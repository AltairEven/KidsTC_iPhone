//
//  HomeActivityService.m
//  KidsTC
//
//  Created by Altair on 1/4/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "HomeActivityService.h"

#define HomeActivityLocalName (@"HomeActivity")

//static NSString *const kAdditionalTabBarItemInfoMD5Key = @"kAdditionalTabBarItemInfoMD5Key";
//static NSString *const kAdditionalTabBarItemInfoExpireTimeKey = @"kAdditionalTabBarItemInfoExpireTimeKey";
//
//NSString *const kAdditionalTabBarItemInfoPageUrlStringKey = @"kAdditionalTabBarItemInfoPageUrlStringKey";
//NSString *const kAdditionalTabBarItemInfoNormalImageKey = @"kAdditionalTabBarItemInfoNormalImageKey";
//NSString *const kAdditionalTabBarItemInfoSelectedImageKey = @"kAdditionalTabBarItemInfoSelectedImageKey";
//
//static NSString *const kAdditionalTabBarItemImageUrlStringsKey = @"kAdditionalTabBarItemImageUrlStringKey";
//static NSString *const kAdditionalTabBarItemImageDownloadStatusKey = @"kAdditionalTabBarItemImageDownloadStatusKey";

static HomeActivityService *_sharedInstance = nil;

@interface HomeActivityService ()

@property (nonatomic, strong) HttpRequestClient *getActivityRequest;

@property (nonatomic, strong) HttpRequestClient *loadImageRequest;

@property (nonatomic, strong) HomeActivity *localActivity;

@property (nonatomic, strong) NSLock *dataLock;

- (HomeActivity *)getHomeActivitySucceed:(NSDictionary *)data;

- (void)getHomeActivityFailed:(NSError *)error;

- (void)downloadImageWithUrlString:(NSString *)urlString;

- (void)downloadUnfinishedImages;

- (void)saveActivity:(HomeActivity *)activity;

@end

@implementation HomeActivityService

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
        _sharedInstance = [[HomeActivityService alloc] init];
    });
    
    return _sharedInstance;
}

- (HomeActivity *)localActivity {
    if (!_localActivity) {
        NSString *configPath = FILE_CACHE_PATH(HomeActivityLocalName);
        _localActivity = [NSKeyedUnarchiver unarchiveObjectWithFile:configPath];;
    }
    return _localActivity;
}

- (HomeActivity *)currentActivity {
    if (self.localActivity.expireTime < [[NSDate date] timeIntervalSince1970]) {
        //已过期
        return nil;
    }
    return self.localActivity;
}

#pragma mark Synchronize-----------------------------------------------------------------

#pragma mark Private methods

- (HomeActivity *)getHomeActivitySucceed:(NSDictionary *)data {
    HomeActivity *activity = [[HomeActivity alloc] initWithRawData:data];
    if (activity) {
        if ([self.localActivity.identifier isEqualToString:activity.identifier]) {
            //与本地活动id相同，则赋值为本地的活动
            if ([[NSDate date] timeIntervalSince1970] > activity.expireTime) {
                //已过期，无效活动
                return nil;
            }
            activity = self.localActivity;
        } else {
            if ([[NSDate date] timeIntervalSince1970] > activity.expireTime) {
                //已过期，无效活动
                return nil;
            }
            //非过期，非无效，则创建本地文件
            [self saveActivity:activity];
        }
        
        
        //下载
        [self downloadImageWithUrlString:activity.thumbImageUrlString];
    } else {
        //服务端没有返回有效数据，则开始下载本地未完成的图片文件
        activity = self.localActivity;
        [self downloadUnfinishedImages];
    }
    return activity;
}

- (void)getHomeActivityFailed:(NSError *)error {
    if (error.code == -2001) {
        [self removeLocalData];
    } else {
        [self downloadUnfinishedImages];
    }
}

- (void)downloadImageWithUrlString:(NSString *)urlString {
    if (!urlString || ![urlString isKindOfClass:[NSString class]] || [urlString length] == 0) {
        return;
    }
    
    __weak HomeActivityService *weakSelf = self;
    self.loadImageRequest = [HttpRequestClient clientWithUrlString:urlString];
    if (self.loadImageRequest) {
        [weakSelf.loadImageRequest downloadImageWithSuccess:^(HttpRequestClient *client, UIImage *image) {
            [weakSelf.localActivity setThumbImage:image];
            [weakSelf saveActivity:weakSelf.localActivity];
        } failure:nil];
    }
}

- (void)downloadUnfinishedImages {
    if (!self.localActivity.thumbImage) {
        [self downloadImageWithUrlString:self.localActivity.thumbImageUrlString];
    }
}

- (void)saveActivity:(HomeActivity *)activity {
    if (!activity) {
        return;
    }
    NSString *filePath = FILE_CACHE_PATH(HomeActivityLocalName);
    BOOL bWrite = [NSKeyedArchiver archiveRootObject:activity toFile:filePath];
    if (!bWrite) {
        NSLog(@"Synchronize config file failed.");
    }
}

#pragma mark Public methods

- (void)synchronizeActivitySuccess:(void (^)(HomeActivity *))success failure:(void (^)(NSError *))failure {
    if (!self.getActivityRequest) {
        self.getActivityRequest = [HttpRequestClient clientWithUrlAliasName:@"GET_HOME_PAGE_ACTIVITY"];
    }
    
    __weak HomeActivityService *weakSelf = self;
    [weakSelf.getActivityRequest startHttpRequestWithParameter:nil success:^(HttpRequestClient *client, NSDictionary *responseData) {
        HomeActivity *activity = [weakSelf getHomeActivitySucceed:[responseData objectForKey:@"data"]];
        if (activity) {
            if (success) {
                success(activity);
            }
        } else if (failure) {
            NSError *error = [NSError errorWithDomain:@"Home activity service" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"无效的返回数据" forKey:kErrMsgKey]];
            failure(error);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf getHomeActivityFailed:error];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)removeLocalData {
    NSString *filePath = FILE_CACHE_PATH(HomeActivityLocalName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    self.localActivity = nil;
}

- (void)setHasDisplayedWebPage {
    [self.currentActivity setHasDisplayedWebPage:YES];
    [self saveActivity:self.currentActivity];
}

@end


@implementation HomeActivity

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"id"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
        self.pageUrlString = [data objectForKey:@"pageUrl"];
        self.linkUrlString = [data objectForKey:@"linkUrl"];
        self.thumbImageUrlString = [data objectForKey:@"thumbImg"];
        self.startTime = [[data objectForKey:@"startTime"] doubleValue];
        self.expireTime = [[data objectForKey:@"endTime"] doubleValue];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.pageUrlString = [aDecoder decodeObjectForKey:@"pageUrlString"];
        self.linkUrlString = [aDecoder decodeObjectForKey:@"linkUrlString"];
        self.thumbImageUrlString = [aDecoder decodeObjectForKey:@"thumbImageUrlString"];
        self.thumbImage = [aDecoder decodeObjectForKey:@"thumbImage"];
        self.startTime = [aDecoder decodeDoubleForKey:@"startTime"];
        self.expireTime = [aDecoder decodeDoubleForKey:@"expireTime"];
        self.hasDisplayedWebPage = [aDecoder decodeBoolForKey:@"hasDisplayedWebPage"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.pageUrlString forKey:@"pageUrlString"];
    [aCoder encodeObject:self.linkUrlString forKey:@"linkUrlString"];
    [aCoder encodeObject:self.thumbImageUrlString forKey:@"thumbImageUrlString"];
    [aCoder encodeObject:self.thumbImage forKey:@"thumbImage"];
    [aCoder encodeDouble:self.startTime forKey:@"startTime"];
    [aCoder encodeDouble:self.expireTime forKey:@"expireTime"];
    [aCoder encodeBool:self.hasDisplayedWebPage forKey:@"hasDisplayedWebPage"];
}

@end
