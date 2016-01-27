//
//  AdditionalTabBarItemManager.m
//  KidsTC
//
//  Created by Altair on 1/3/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "AdditionalTabBarItemManager.h"

#define AdditionalTabBarItemLocalDirectory (@"/AdditionalTabBarItem")
#define AdditionalTabBarItemConfigPath (@"/AdditionalTabBarItem/config")

#define AdditionalTabBarItemNormalImage (@"normalImage")
#define AdditionalTabBarItemSelectedImage (@"selectedImage")

static NSString *const kAdditionalTabBarItemInfoMD5Key = @"kAdditionalTabBarItemInfoMD5Key";
static NSString *const kAdditionalTabBarItemInfoExpireTimeKey = @"kAdditionalTabBarItemInfoExpireTimeKey";

NSString *const kAdditionalTabBarItemInfoPageUrlStringKey = @"kAdditionalTabBarItemInfoPageUrlStringKey";
NSString *const kAdditionalTabBarItemInfoNormalImageKey = @"kAdditionalTabBarItemInfoNormalImageKey";
NSString *const kAdditionalTabBarItemInfoSelectedImageKey = @"kAdditionalTabBarItemInfoSelectedImageKey";

static NSString *const kAdditionalTabBarItemImageUrlStringsKey = @"kAdditionalTabBarItemImageUrlStringKey";
static NSString *const kAdditionalTabBarItemImageDownloadStatusKey = @"kAdditionalTabBarItemImageDownloadStatusKey";

static AdditionalTabBarItemManager *_sharedInstance = nil;

@interface AdditionalTabBarItemManager ()

@property (nonatomic, strong) HttpRequestClient *getTabBarItemInfoRequest;

@property (nonatomic, strong) NSMutableArray *loadImageRequestsArray;

@property (nonatomic, strong) NSDictionary *localData;

@property (nonatomic, strong) NSLock *dataLock;

- (BOOL)createFileDirectory;

- (void)getAdInfoSucceed:(NSDictionary *)data;

- (void)getAdInfoFailed:(NSError *)error;

- (void)createConfigWithRawData:(NSDictionary *)data;

- (void)downloadAdImagesWithUrlStrings:(NSArray *)urlStrings;

- (void)downloadUnfinishedImages;

- (void)saveImage:(UIImage *)image withDownloadUrlString:(NSString *)urlString;

- (void)setImage:(NSString *)urlString downloaded:(BOOL)hasDownloaded;

- (NSArray *)allLocalImageUrlStringsWithFinishState:(BOOL)finished;

- (NSString *)imagePathWithDownloadUrlString:(NSString *)urlString;

- (void)synchronizeConfigFile;

@end

@implementation AdditionalTabBarItemManager

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
        _sharedInstance = [[AdditionalTabBarItemManager alloc] init];
    });
    
    return _sharedInstance;
}

- (NSDictionary *)localData {
    if (!_localData) {
        NSString *configPath = FILE_CACHE_PATH(AdditionalTabBarItemConfigPath);
        _localData = [NSDictionary dictionaryWithContentsOfFile:configPath];
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
        
        //非过期，非无效，则创建本地文件，开始下载
        [self createConfigWithRawData:data];
        
        //获取将要下载的图片链接
        NSArray *urlStrings = [self allLocalImageUrlStringsWithFinishState:NO];
        //下载
        [self downloadAdImagesWithUrlStrings:urlStrings];
    } else {
        //服务端没有返回有效数据，则开始下载本地未完成的图片文件
        [self downloadUnfinishedImages];
    }
}

- (void)getAdInfoFailed:(NSError *)error {
    if (error.code == -2001) {
        [self removeLocalData];
    } else {
        [self downloadUnfinishedImages];
    }
}

- (void)createConfigWithRawData:(NSDictionary *)data {
    if (!data || ! [data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    
    NSString *md5 = [data objectForKey:@"md5"];
    if (!md5 || ![md5 isKindOfClass:[NSString class]]) {
        //无效的MD5串
        return;
    }
    [tempDic setObject:md5 forKey:kAdditionalTabBarItemInfoMD5Key];
    
    NSDictionary *adInfo = [data objectForKey:@"data"];
    if (adInfo && [adInfo isKindOfClass:[NSDictionary class]]) {
        //过期时间
        NSTimeInterval expireTime = [[adInfo objectForKey:@"expireTime"] doubleValue];
        if (expireTime <= [[NSDate date] timeIntervalSince1970]) {
            //已过期
            return;
        }
        [tempDic setObject:[NSNumber numberWithDouble:expireTime] forKey:kAdditionalTabBarItemInfoExpireTimeKey];
        //页面地址
        NSString *pageUrlString = [adInfo objectForKey:@"url"];
        if (!pageUrlString || ![pageUrlString isKindOfClass:[NSString class]] || [pageUrlString length] == 0) {
            //无效的页面地址
            return;
        }
        [tempDic setObject:pageUrlString forKey:kAdditionalTabBarItemInfoPageUrlStringKey];
        //图片
        NSString *normalImageUrlString = [adInfo objectForKey:@"fImg"];
        if (!normalImageUrlString || ![normalImageUrlString isKindOfClass:[NSString class]] || [normalImageUrlString length] == 0) {
            //无效的数据
            return;
        }
        NSDictionary *normalImageDic = [NSDictionary dictionaryWithObjectsAndKeys:normalImageUrlString, kAdditionalTabBarItemImageUrlStringsKey, [NSNumber numberWithBool:NO], kAdditionalTabBarItemImageDownloadStatusKey, nil];
        
        NSString *selectedImageUrlString = [adInfo objectForKey:@"sImg"];
        if (!selectedImageUrlString || ![selectedImageUrlString isKindOfClass:[NSString class]] || [selectedImageUrlString length] == 0) {
            //无效的数据
            return;
        }
        NSDictionary *selectedImageDic = [NSDictionary dictionaryWithObjectsAndKeys:selectedImageUrlString, kAdditionalTabBarItemImageUrlStringsKey, [NSNumber numberWithBool:NO], kAdditionalTabBarItemImageDownloadStatusKey, nil];
        
        [tempDic setObject:normalImageDic forKey:kAdditionalTabBarItemInfoNormalImageKey];
        [tempDic setObject:selectedImageDic forKey:kAdditionalTabBarItemInfoSelectedImageKey];
    }
    //先创建目录
    if ([self createFileDirectory]) {
        //再写入文件
        NSString *filePath = FILE_CACHE_PATH(AdditionalTabBarItemConfigPath);
        [tempDic writeToFile:filePath atomically:NO];
    }
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
    
    __weak AdditionalTabBarItemManager *weakSelf = self;
    
    for (NSString *string in urlStrings) {
        //约定最多3张图片，所以可以同时发起请求
        HttpRequestClient *client = [HttpRequestClient clientWithUrlString:string];
        if (client) {
            [self.loadImageRequestsArray addObject:client];
            [client downloadImageWithSuccess:^(HttpRequestClient *client, UIImage *image) {
                [weakSelf saveImage:image withDownloadUrlString:string];
            } failure:nil];
        }
    }
}

- (void)downloadUnfinishedImages {
    NSArray *imageUrlStrings = [self allLocalImageUrlStringsWithFinishState:NO];
    [self downloadAdImagesWithUrlStrings:imageUrlStrings];
}

#pragma mark Public methods

- (void)synchronizeAdditionalTabBarItem {
    if (!self.getTabBarItemInfoRequest) {
        self.getTabBarItemInfoRequest = [HttpRequestClient clientWithUrlAliasName:@"GET_HOME_TAB"];
    }
    
    NSDictionary *param = nil;
    if (self.localData) {
        NSString *md5 = [self.localData objectForKey:kAdditionalTabBarItemInfoMD5Key];
        if (md5) {
            param = [NSDictionary dictionaryWithObject:md5 forKey:@"key"];
        }
    }
    
    __weak AdditionalTabBarItemManager *weakSelf = self;
    [weakSelf.getTabBarItemInfoRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf getAdInfoSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf getAdInfoFailed:error];
    }];
}

- (void)removeLocalData {
    NSString *fileDirectory = FILE_CACHE_PATH(AdditionalTabBarItemLocalDirectory);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fileDirectory error:nil];
    self.localData = nil;
}

#pragma mark Get TabBarItem Info------------------------------------------------------------

#pragma mark Private methods

#pragma mark Public methods

- (NSDictionary *)AdditionalTabBarItemInfo {
    if (!self.localData) {
        return nil;
    }
    //获取本地未过期数据
    NSTimeInterval expireTime = [[self.localData objectForKey:kAdditionalTabBarItemInfoExpireTimeKey] doubleValue];
    if (expireTime < [[NSDate date] timeIntervalSince1970]) {
        //已过期
        [self removeLocalData];
        return nil;
    }
    NSDictionary *normalImageDic = [self.localData objectForKey:kAdditionalTabBarItemInfoNormalImageKey];
    NSDictionary *selectedImageDic = [self.localData objectForKey:kAdditionalTabBarItemInfoSelectedImageKey];
    
    if (![[normalImageDic objectForKey:kAdditionalTabBarItemImageDownloadStatusKey] boolValue] || ![[selectedImageDic objectForKey:kAdditionalTabBarItemImageDownloadStatusKey] boolValue]) {
        //有未下载完成的图片
        return nil;
    }
    NSString *directory = FILE_CACHE_PATH(AdditionalTabBarItemLocalDirectory);
    NSString *normalImagePath = [NSString stringWithFormat:@"%@/%@", directory, AdditionalTabBarItemNormalImage];
    NSString *selectedImagePath = [NSString stringWithFormat:@"%@/%@", directory, AdditionalTabBarItemSelectedImage];
    UIImage *normalImage = [UIImage imageWithContentsOfFile:normalImagePath];
    if (!normalImage) {
        //读取图片失败
        return nil;
    }
    UIImage *selectedImage = [UIImage imageWithContentsOfFile:selectedImagePath];
    if (!selectedImage) {
        //读取图片失败
        return nil;
    }
    //替换掉图片字段
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.localData];
    [tempDic setObject:normalImage forKey:kAdditionalTabBarItemInfoNormalImageKey];
    [tempDic setObject:selectedImage forKey:kAdditionalTabBarItemInfoSelectedImageKey];
    
    return [NSDictionary dictionaryWithDictionary:tempDic];
}


- (AUITheme *)themeWithAdditionalTabBarItemInfo:(AUITheme *)originalTheme {
    NSDictionary *additionalInfo = [self AdditionalTabBarItemInfo];
    if (!additionalInfo) {
        //没有附加tab
        return originalTheme;
    }
    //创建主题元素
    AUITabbarItemElement *element = [[AUITabbarItemElement alloc] init];
    element.type = AUITabbarItemTypeAdditional;
    
    UIImage *normalImage = [additionalInfo objectForKey:kAdditionalTabBarItemInfoNormalImageKey] ;
    CGFloat width = SCREEN_WIDTH / 5;
    CGFloat height = normalImage.size.height / normalImage.size.width * width;
    element.tabbarItemImage_Normal = [normalImage imageByScalingToSize:CGSizeMake(width, height)];
    
    UIImage *selectedImage = [additionalInfo objectForKey:kAdditionalTabBarItemInfoSelectedImageKey];
    height = selectedImage.size.height / selectedImage.size.width * width;
    element.tabbarItemImage_Highlight = [selectedImage imageByScalingToSize:CGSizeMake(width, height)];
    
    element.userInfo = [NSDictionary dictionaryWithObject:[additionalInfo objectForKey:kAdditionalTabBarItemInfoPageUrlStringKey] forKey:kAdditionalTabBarItemInfoPageUrlStringKey];
    //插入主题元素
    AUITheme *infoTheme = [originalTheme copy];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[infoTheme tabbarItemElements]];
    if (element && [tempArray count] > 2) {
        [tempArray insertObject:element atIndex:2];
    }
    infoTheme.tabbarItemElements = [NSArray arrayWithArray:tempArray];
    
    return infoTheme;
}

#pragma mark General methods---------------------------------------------------------------

#pragma mark Private methods

- (BOOL)createFileDirectory {
    NSString *fileDirectory = FILE_CACHE_PATH(AdditionalTabBarItemLocalDirectory);
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
    
    NSDictionary *normalImageDic = [self.localData objectForKey:kAdditionalTabBarItemInfoNormalImageKey];
    NSDictionary *selectedImageDic = [self.localData objectForKey:kAdditionalTabBarItemInfoSelectedImageKey];
    if (!normalImageDic || !selectedImageDic) {
        //没有合适的图片数据
        return nil;
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    //normal
    BOOL hasDownloaded = [[normalImageDic objectForKey:kAdditionalTabBarItemImageDownloadStatusKey] boolValue];
    if (hasDownloaded == finished) {
        //对应下载状态的图片url string
        NSString *urlString = [normalImageDic objectForKey:kAdditionalTabBarItemImageUrlStringsKey];
        [tempArray addObject:urlString];
    }
    //seleted
    hasDownloaded = [[selectedImageDic objectForKey:kAdditionalTabBarItemImageDownloadStatusKey] boolValue];
    if (hasDownloaded == finished) {
        //对应下载状态的图片url string
        NSString *urlString = [selectedImageDic objectForKey:kAdditionalTabBarItemImageUrlStringsKey];
        [tempArray addObject:urlString];
    }
    
    return [NSArray arrayWithArray:tempArray];
}

- (void)saveImage:(UIImage *)image withDownloadUrlString:(NSString *)urlString {
    NSData *data = UIImagePNGRepresentation(image);
    NSString *filePath = [self imagePathWithDownloadUrlString:urlString];
    BOOL bWrite = [data writeToFile:filePath atomically:NO];
    if (bWrite) {
        [self setImage:urlString downloaded:YES];
    }
}

- (void)setImage:(NSString *)urlString downloaded:(BOOL)hasDownloaded {
    if (!self.localData) {
        return;
    }
    //加锁
    [self.dataLock lock];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.localData];
    
    NSDictionary *normalImageDic = [self.localData objectForKey:kAdditionalTabBarItemInfoNormalImageKey];
    NSDictionary *selectedImageDic = [self.localData objectForKey:kAdditionalTabBarItemInfoSelectedImageKey];
    if (!normalImageDic || !selectedImageDic) {
        //没有合适的图片数据
        return;
    }
    if ([[normalImageDic objectForKey:kAdditionalTabBarItemImageUrlStringsKey] isEqualToString:urlString]) {
        //normal
        NSMutableDictionary *tempImageDic = [NSMutableDictionary dictionaryWithDictionary:normalImageDic];
        [tempImageDic setObject:[NSNumber numberWithBool:hasDownloaded] forKey:kAdditionalTabBarItemImageDownloadStatusKey];
        [tempDic setObject:[NSDictionary dictionaryWithDictionary:tempImageDic] forKey:kAdditionalTabBarItemInfoNormalImageKey];
    } else if ([[selectedImageDic objectForKey:kAdditionalTabBarItemImageUrlStringsKey] isEqualToString:urlString]) {
        //selected
        NSMutableDictionary *tempImageDic = [NSMutableDictionary dictionaryWithDictionary:selectedImageDic];
        [tempImageDic setObject:[NSNumber numberWithBool:hasDownloaded] forKey:kAdditionalTabBarItemImageDownloadStatusKey];
        [tempDic setObject:[NSDictionary dictionaryWithDictionary:tempImageDic] forKey:kAdditionalTabBarItemInfoSelectedImageKey];
    }
    self.localData = [NSDictionary dictionaryWithDictionary:tempDic];
    //同步本地文件
    [self synchronizeConfigFile];
    //解锁
    [self.dataLock unlock];
}

- (void)synchronizeConfigFile {
    if (!self.localData) {
        return;
    }
    NSString *filePath = FILE_CACHE_PATH(AdditionalTabBarItemConfigPath);
    BOOL bWrite = [self.localData writeToFile:filePath atomically:NO];
    if (!bWrite) {
        NSLog(@"Synchronize config file failed.");
    }
}

#pragma mark Public methods

- (NSString *)imagePathWithDownloadUrlString:(NSString *)urlString {
    if (!self.localData) {
        return nil;
    }
    NSDictionary *normalImageDic = [self.localData objectForKey:kAdditionalTabBarItemInfoNormalImageKey];
    NSDictionary *selectedImageDic = [self.localData objectForKey:kAdditionalTabBarItemInfoSelectedImageKey];
    
    NSString *name = nil;
    if ([[normalImageDic objectForKey:kAdditionalTabBarItemImageUrlStringsKey] isEqualToString:urlString]) {
        //normal
        name = AdditionalTabBarItemNormalImage;
    } else if ([[selectedImageDic objectForKey:kAdditionalTabBarItemImageUrlStringsKey] isEqualToString:urlString]) {
        //selected
        name = AdditionalTabBarItemSelectedImage;
    }
    if (!name) {
        return nil;
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", FILE_CACHE_PATH(AdditionalTabBarItemLocalDirectory), name];
    return filePath;
}

@end
