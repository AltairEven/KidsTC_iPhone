//
//  KTCAdvertisementManager.m
//  KidsTC
//
//  Created by Altair on 12/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCAdvertisementManager.h"

#define AdImageLocalDirectory (@"/AdvertisementImage")
#define AdImageShowingFormatPath (@"/AdvertisementImage/AdImageShowingFormat")

static NSString *const kAdImageShowingFormatStatusKey = @"kAdImageShowingFormatStatusKey";
static NSString *const kAdImageShowingFormatMD5Key = @"kAdImageShowingFormatMD5Key";
static NSString *const kAdImageShowingFormatExpireTimeKey = @"kAdImageShowingFormatExpireTimeKey";
static NSString *const kAdImageShowingFormatImagesKey = @"kAdImageShowingFormatImagesKey";

static KTCAdvertisementManager *_sharedInstance = nil;

@interface KTCAdvertisementManager ()

@property (nonatomic, strong) HttpRequestClient *getAdInfoRequest;

@property (nonatomic, strong) NSMutableArray *loadImageRequestsArray;

@property (nonatomic, strong) NSDictionary *localData;

@property (nonatomic, strong) NSLock *dataLock;

- (BOOL)createFileDirectory;

- (void)getAdInfoSucceed:(NSDictionary *)data;

- (void)createShowingFormatWithRawData:(NSDictionary *)data;

- (void)downloadAdImagesWithUrlStrings:(NSArray *)urlStrings;

- (void)downloadUnfinishedImages;

- (NSArray *)filterNeedDownloadImagesWithRemoteUrlStrings:(NSArray *)urlStrings;

- (void)saveImage:(UIImage *)image withName:(NSString *)name;

- (void)setImage:(NSString *)urlString downloaded:(BOOL)hasDownloaded;

- (NSArray *)allLocalImageUrlStringsWithFinishState:(BOOL)finished;

+ (NSString *)imagePathWithName:(NSString *)name;

- (void)synchronizeShowingFormatFile;

@end

@implementation KTCAdvertisementManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataLock = [[NSLock alloc] init];
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
        _sharedInstance = [[KTCAdvertisementManager alloc] init];
    });
    
    return _sharedInstance;
}

- (NSDictionary *)localData {
    if (!_localData) {
        NSString *showingFormatPath = FILE_CACHE_PATH(AdImageShowingFormatPath);
        _localData = [NSDictionary dictionaryWithContentsOfFile:showingFormatPath];
    }
    return _localData;
}

#pragma mark Synchronize-----------------------------------------------------------------

#pragma mark Private methods

- (void)getAdInfoSucceed:(NSDictionary *)data {
    NSDictionary *adInfo = [data objectForKey:@"data"];
    if (adInfo && [adInfo isKindOfClass:[NSDictionary class]]) {
        //由于服务端返回数据，说明远端配置已经更改，故删除本地数据
        [self removeLocalData];
        
        NSTimeInterval expireTime = [[adInfo objectForKey:@"expireTime"] doubleValue];
        if ([[NSDate date] timeIntervalSince1970] > expireTime) {
            //已过期
            return;
        }
        NSArray *images = [adInfo objectForKey:@"imgs"];
        if (!images || ![images isKindOfClass:[NSArray class]]) {
            //无效数据
            return;
        }
        
        //非过期，非无效，则创建本地文件，开始下载
        [self createShowingFormatWithRawData:data];
        NSArray *needDownload = [self filterNeedDownloadImagesWithRemoteUrlStrings:images];
        [self downloadAdImagesWithUrlStrings:needDownload];
    } else {
        //服务端没有返回有效数据，则开始下载本地未完成的图片文件
        [self downloadUnfinishedImages];
    }
}

- (void)createShowingFormatWithRawData:(NSDictionary *)data {
    if (!data || ! [data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    
    NSString *md5 = [data objectForKey:@"md5"];
    if (!md5 || ![md5 isKindOfClass:[NSString class]]) {
        //无效的MD5串
        return;
    }
    [tempDic setObject:md5 forKey:kAdImageShowingFormatMD5Key];
    
    NSDictionary *adInfo = [data objectForKey:@"data"];
    if (adInfo && [adInfo isKindOfClass:[NSDictionary class]]) {
        //过期时间
        NSTimeInterval expireTime = [[adInfo objectForKey:@"expireTime"] doubleValue];
        [tempDic setObject:[NSNumber numberWithDouble:expireTime] forKey:kAdImageShowingFormatExpireTimeKey];
        //图片
        NSArray *images = [adInfo objectForKey:@"imgs"];
        if (!images || ![images isKindOfClass:[NSArray class]]) {
            return;
        }
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSString *imageUrlString in images) {
            NSDictionary *imageDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:imageUrlString];
            [tempArray addObject:imageDic];
        }
        [tempDic setObject:[NSArray arrayWithArray:tempArray] forKey:kAdImageShowingFormatImagesKey];
    }
    //先创建目录
    if ([self createFileDirectory]) {
        //再写入文件
        NSString *filePath = FILE_CACHE_PATH(AdImageShowingFormatPath);
        [tempDic writeToFile:filePath atomically:NO];
    }
}

- (NSArray *)filterNeedDownloadImagesWithRemoteUrlStrings:(NSArray *)urlStrings {
    NSArray *localImages = [self allLocalImageUrlStringsWithFinishState:YES];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSString *localString in localImages) {
        for (NSString *remoteString in urlStrings) {
            if ([localString isEqualToString:remoteString]) {
                //相同的不下载，将重复的加到临时数组
                [tempArray addObject:localString];
                [self setImage:localString downloaded:YES];
            }
        }
    }
    //删除重复的
    NSMutableArray *tempRemote = [NSMutableArray arrayWithArray:urlStrings];
    [tempRemote removeObjectsInArray:tempArray];
    //数组内部去重
    NSDictionary *tempDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithArray:tempRemote] forKeys:[NSArray arrayWithArray:tempRemote]];
    
    return [NSArray arrayWithArray:[tempDic allKeys]];
}

- (void)downloadAdImagesWithUrlStrings:(NSArray *)urlStrings {
    if (!urlStrings || [urlStrings count] == 0) {
        return;
    }
    if (!self.loadImageRequestsArray) {
        self.loadImageRequestsArray = [[NSMutableArray alloc] init];
    } else {
        [self.loadImageRequestsArray removeAllObjects];
    }
    
    __weak KTCAdvertisementManager *weakSelf = self;
    
    for (NSString *string in urlStrings) {
        //约定最多3张图片，所以可以同时发起请求
        HttpRequestClient *client = [HttpRequestClient clientWithUrlString:string];
        if (client) {
            [self.loadImageRequestsArray addObject:client];
            [client downloadImageWithSuccess:^(HttpRequestClient *client, UIImage *image) {
                [weakSelf saveImage:image withName:string];
            } failure:nil];
        }
    }
}

- (void)downloadUnfinishedImages {
    NSArray *imageUrlStrings = [self allLocalImageUrlStringsWithFinishState:NO];
    [self downloadAdImagesWithUrlStrings:imageUrlStrings];
}

#pragma mark Public methods

- (void)synchronizeAdvertisement {
    if (!self.getAdInfoRequest) {
        self.getAdInfoRequest = [HttpRequestClient clientWithUrlAliasName:@"GET_LAUNCH"];
    }
    
    NSDictionary *param = nil;
    if (self.localData) {
        NSString *md5 = [self.localData objectForKey:kAdImageShowingFormatMD5Key];
        if (md5) {
            param = [NSDictionary dictionaryWithObject:md5 forKey:@"key"];
        }
    }
    
    __weak KTCAdvertisementManager *weakSelf = self;
    [weakSelf.getAdInfoRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf getAdInfoSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf downloadUnfinishedImages];
    }];
}

- (void)removeLocalData {
    NSString *fileDirectory = FILE_CACHE_PATH(AdImageLocalDirectory);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fileDirectory error:nil];
    self.localData = nil;
}

- (void)removeOverTimeImages {
    if (!self.localData) {
        return;
    }
    NSTimeInterval expTimeInterval = [[self.localData objectForKey:kAdImageShowingFormatExpireTimeKey] doubleValue];
    if (expTimeInterval < [[NSDate date] timeIntervalSince1970]) {
        //已过期
        [self removeLocalData];
    }
}

#pragma mark Get showing images------------------------------------------------------------

#pragma mark Private methods

#pragma mark Public methods

- (NSArray *)advertisementImages {
    if (!self.localData) {
        return nil;
    }
    BOOL hasDisplayed = [[self.localData objectForKey:kAdImageShowingFormatStatusKey] boolValue];
    if (hasDisplayed) {
        return nil;
    }
    //获取本地未过期数据
    NSArray *localImageFileNames = [self allLocalImageUrlStringsWithFinishState:YES];
    if (!localImageFileNames) {
        //没有本地数据，直接返回
        return nil;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSString *fileName in localImageFileNames) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", FILE_CACHE_PATH(AdImageLocalDirectory), [GToolUtil hashString:fileName]];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if (image) {
            [tempArray addObject:image];
        }
    }
    
    return [NSArray arrayWithArray:tempArray];
}

#pragma mark General methods---------------------------------------------------------------

#pragma mark Private methods

- (BOOL)createFileDirectory {
    NSString *fileDirectory = FILE_CACHE_PATH(AdImageLocalDirectory);
    //创建目录
    NSError *error;
    BOOL bRet = [[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    if (!bRet || error) {
        return NO;
    }
    return YES;
}

- (NSArray *)allLocalImageUrlStringsWithFinishState:(BOOL)finished {
    if (!self.localData) {
        //没有显示数据
        return nil;
    }
    
    NSArray *imagesArray = [self.localData objectForKey:kAdImageShowingFormatImagesKey];
    if (!imagesArray || ![imagesArray isKindOfClass:[NSArray class]]) {
        //没有图片数据
        return nil;
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *imageDic in imagesArray) {
        BOOL hasDownloaded = [[[imageDic allValues] firstObject] boolValue];
        if (hasDownloaded == finished) {
            //已下载的图片url string
            NSString *urlString = [[imageDic allKeys] firstObject];
            [tempArray addObject:urlString];
        }
    }
    
    return [NSArray arrayWithArray:tempArray];
}

- (void)saveImage:(UIImage *)image withName:(NSString *)name {
    NSData *data = UIImagePNGRepresentation(image);
    NSString *filePath = [KTCAdvertisementManager imagePathWithName:[GToolUtil hashString:name]];
    BOOL bWrite = [data writeToFile:filePath atomically:NO];
    if (bWrite) {
        [self setImage:name downloaded:YES];
    }
}

- (void)setImage:(NSString *)urlString downloaded:(BOOL)hasDownloaded {
    if (!self.localData) {
        return;
    }
    //加锁
    [self.dataLock lock];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.localData];
    NSArray *imagesArray = [tempDic objectForKey:kAdImageShowingFormatImagesKey];
    if (!imagesArray || ![imagesArray isKindOfClass:[NSArray class]]) {
        //没有图片数据
        //解锁
        [self.dataLock unlock];
        return;
    }
    NSMutableArray *tempImages = [[NSMutableArray alloc] init];
    for (NSDictionary *imageDic in imagesArray) {
        if ([imageDic objectForKey:urlString]) {
            //url string 相同，则设置hasDownloaded
            [tempImages addObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:hasDownloaded] forKey:urlString]];
        } else {
            //url string 不同，则继续遍历
            [tempImages addObject:imageDic];
        }
    }
    [tempDic setObject:[NSArray arrayWithArray:tempImages] forKey:kAdImageShowingFormatImagesKey];
    self.localData = [NSDictionary dictionaryWithDictionary:tempDic];
    //同步本地文件
    [self synchronizeShowingFormatFile];
    //解锁
    [self.dataLock unlock];
}

- (void)synchronizeShowingFormatFile {
    if (!self.localData) {
        return;
    }
    NSString *filePath = FILE_CACHE_PATH(AdImageShowingFormatPath);
    BOOL bWrite = [self.localData writeToFile:filePath atomically:NO];
    if (!bWrite) {
        NSLog(@"Synchronize showing format file failed.");
    }
}

#pragma mark Public methods

+ (NSString *)imagePathWithName:(NSString *)name {
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", FILE_CACHE_PATH(AdImageLocalDirectory), name];
    return filePath;
}

- (void)setAlreadyShowed {
    if (!self.localData) {
        return;
    }
    [self.dataLock lock];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.localData];
    [tempDic setObject:[NSNumber numberWithBool:YES] forKey:kAdImageShowingFormatStatusKey];
    
    self.localData = [NSDictionary dictionaryWithDictionary:tempDic];
    //同步本地文件
    [self synchronizeShowingFormatFile];
    [self.dataLock unlock];
}

@end
