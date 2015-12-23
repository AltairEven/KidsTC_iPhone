//
//  RollConfig.m
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-6-13.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import "RollConfig.h"
#import "ASINetworkQueue.h"
#import "WatchDog.h"

static const int kMaxGoldCount = 5;
static const int kRewardCountOfShareSuccess = 2;
//static NSString * const kCacheDicPath = @"plist/home_img_list.plist";
static NSString * const kRollPrizeCacheImagePath = @"roll_prize_img_cache";
static NSString * const kPrizeConfigPath = @"roll_config.plist";
static NSString * const kConfigImgGroupName = @"RollConfigImgGroup";

@interface RollConfig ()
@property (nonatomic, retain) NSDictionary *prizeConfigSnapshotData;    // 当前可用的配置
@property (nonatomic, retain) NSDictionary *prizeConfigLatest;          // 如果非空并且所有图片都下载成功，替换Snapshot
@property (nonatomic) int numOfImgDownSuccess;
@property (nonatomic) int numOfImgDownFailed;
@property (nonatomic) BOOL isAllImageReady;
@property (nonatomic) BOOL isCheckReqOnGoing;
@property (nonatomic, retain) NSLock *lock;

@end

@implementation RollConfig

+ (NSDictionary *)prizeArr2Dic:(NSArray *)prizeArr
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:[prizeArr count]];
    for (NSDictionary *item in prizeArr)
    {
        [tempDic setObject:item forKey:[NSString stringWithFormat:@"%@", [item objectForKey:@"code"]]];
    }
    
    return [NSDictionary dictionaryWithDictionary:tempDic];
}

+ (NSInteger)getMaxGoldCount
{
    return kMaxGoldCount;
}

+ (NSInteger)getRewardCountOfShareSuccess
{
    return kRewardCountOfShareSuccess;
}

+ (NSString *)getPrizeTypeNameWithType:(PrizeType)type
{
    switch (type) {
        case CouponPrizeType:
            return @"优惠劵";
        case QQPrizeType:
            return @"免费道具卡";
        case GoldPrizeType:
            return @"金币";
        default:
            return @"奖品";
    }
}

+ (NSString *)getRandomNotice
{
    static NSString * const noticeArr[] = {
        @"分享中奖后每天可获得2次额外摇奖机会！",
        @"每天都有3次免费摇奖机会哦！"};
    int x = rand()%(sizeof(noticeArr)/sizeof(noticeArr[0]));
    return noticeArr[x];
}

+ (RollConfig *)sharedRollConfig
{
    static RollConfig *_instance = NULL;
    if (_instance == NULL)
    {
        _instance = [[[self class] alloc] init];
    }
    
    return _instance;
}

- (id)init
{
    if (self = [super init])
    {   
        // if the first time after update version, delete the cached image
        self.prizeConfigSnapshotData = [[NSDictionary alloc] initWithContentsOfFile:WG_FOLDER_PATH(kPrizeConfigPath)];
        if (!self.prizeConfigSnapshotData)
        {
            self.prizeConfigSnapshotData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"roll_config" ofType:@"plist"]];
        }
        else
        {
            // check image
            NSDictionary *prizeList = [self.prizeConfigSnapshotData objectForKey:@"list"];
            BOOL isAllImgReady = YES;
            for (id key in prizeList)
            {
                NSDictionary *prizeItem = [prizeList objectForKey:key];
                NSString *imageUrl = [prizeItem objectForKey:@"icon"];
                NSString *localUrl = nil;
                eDownLoadStat stat = [[DownLoadManager sharedDownLoadManager] urlStat:imageUrl withLocalUrl:&localUrl];
                if (!(stat == eDownLoadStatComplete && [localUrl length] > 0))
                {
                    isAllImgReady = NO;
                    break;
                }
            }
            
            if (!isAllImgReady)
            {
                // back to safe config
                self.prizeConfigSnapshotData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"roll_config" ofType:@"plist"]];
            }
        }
    }
    
    return self;
}

- (NSDictionary *)getPrizeConfigData
{
    return [self.prizeConfigSnapshotData objectForKey:@"list"];
}

- (DownloadOption*)downloadOption
{
    HttpRequestMethod httpMethod = [[GConfig sharedConfig] getURLSendDataMethodWithAliasName:@"URL_MB_ROLL_CODE"];
    return httpMethod == HttpRequestMethodGET ? DownloadOptionDefault : DownloadOptionPost;
}

- (void)checkRollConfigUpdate
{
    if (self.isCheckReqOnGoing || self.isAllImageReady)
    {
        if (self.isAllImageReady)
        {
            [self updateConfigFile];
        }

        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&award_config_v=%@", URL_MB_ROLL_CODE, [self.prizeConfigSnapshotData objectForKey:@"version"]];
//    NSString *url = [NSString stringWithFormat:@"%@&award_config_v=%@&act_id=11073", URL_MB_ROLL_CODE, [self.prizeConfigSnapshotData objectForKey:@"version"]];
    self.isCheckReqOnGoing = YES;

    [self nocacheRequestWithURL:url completion:^(NSDictionary *dict) {
        [self.lock lock];
        self.numOfImgDownFailed = self.numOfImgDownSuccess = 0;
        NSDictionary *prizeDicList = [RollConfig prizeArr2Dic:[dict objectForKey:@"list"]];
        self.prizeConfigLatest = @{@"version":[dict objectForKey:@"version"], @"list":prizeDicList};
        // start image download
        [self startDownloadImages];
        [self.lock unlock];
    } fail:^(NSError *error) {
        self.prizeConfigLatest = nil;
        self.isCheckReqOnGoing = NO;
    } withName:@"URL_MB_ROLL_CODE"];
}

- (void)setNumOfImgDownSuccess:(int)numOfImgDownSuccess
{
    _numOfImgDownSuccess = numOfImgDownSuccess;
    NSInteger imageCount = [[self.prizeConfigLatest objectForKey:@"list"] count];
    if (self.numOfImgDownFailed + self.numOfImgDownSuccess == imageCount && imageCount > 0)
    {
        self.isCheckReqOnGoing = NO;
    }
    
    if (self.numOfImgDownSuccess == imageCount && imageCount > 0)
    {
        self.isAllImageReady = YES;
        [self updateConfigFile];
    }
}

- (void)setNumOfImgDownFailed:(int)numOfImgDownFailed
{
    _numOfImgDownFailed = numOfImgDownFailed;
    NSInteger imageCount = [[self.prizeConfigLatest objectForKey:@"list"] count];
    if (self.numOfImgDownFailed + self.numOfImgDownSuccess == imageCount && imageCount > 0)
    {
        self.isCheckReqOnGoing = NO;
    }
}

- (void)startDownloadImages
{
    static const int kNonPrizeId = 1;
    NSDictionary *prizeConfigList = [self.prizeConfigLatest objectForKey:@"list"];
    for (id key in prizeConfigList)
    {
        NSDictionary *prizeItem = [prizeConfigList objectForKey:key];
        NSString *imageUrl = [prizeItem objectForKey:@"icon"];
        if ([[prizeItem objectForKey:@"code"] intValue] == kNonPrizeId)
        {
            self.numOfImgDownSuccess++;
            continue;
        }
        else if ([imageUrl length] == 0)
        {
            self.numOfImgDownFailed++;
            continue;
        }

        [[DownLoadManager sharedDownLoadManager] downloadWithUrl:imageUrl group:kConfigImgGroupName successBlock:^(NSData *data) {
            UIImage *image = [UIImage imageWithData:data];
            if (!image)
            {
                [[DownLoadManager sharedDownLoadManager] removeByUrl:imageUrl];
                self.numOfImgDownFailed++;
//                int imageCount = [[_bself.prizeConfigLatest objectForKey:@"list"] count];
//                if (_bself.numOfImgDownFailed + _bself.numOfImgDownSuccess == imageCount)
//                {
//                    _bself.isCheckReqOnGoing = NO;
//                }
            }
            else
            {
                self.numOfImgDownSuccess++;
//                int imageCount = [[_bself.prizeConfigLatest objectForKey:@"list"] count];
//                if (_bself.numOfImgDownFailed + _bself.numOfImgDownSuccess == imageCount)
//                {
//                    _bself.isCheckReqOnGoing = NO;
//                }
//                
//                if (_bself.numOfImgDownSuccess == imageCount)
//                {
//                    _bself.isAllImageReady = YES;
//                    [_bself updateConfigFile];
//                }
            }
        } failureBlock:^(NSError *error){
            self.numOfImgDownFailed++;
//            int imageCount = [[_bself.prizeConfigLatest objectForKey:@"list"] count];
//            if (_bself.numOfImgDownFailed + _bself.numOfImgDownSuccess == imageCount)
//            {
//                _bself.isCheckReqOnGoing = NO;
//            }
        }];
    }
}

- (void)updateConfigFile
{
    if (self.isAllImageReady && [self.prizeConfigLatest count] > 0)
    {
        BOOL finished = [self.prizeConfigLatest writeToFile:WG_FOLDER_PATH(kPrizeConfigPath) atomically:YES];
        if (finished)
        {
            self.prizeConfigSnapshotData = self.prizeConfigLatest;
            self.prizeConfigLatest = NULL;
            self.numOfImgDownSuccess = self.numOfImgDownFailed = 0;
            self.isAllImageReady = NO;
        }
    }
}

- (UIImage *)getPrizeImgFromCacheWithPrizeId:(int)prizeId
{
    // xingyao说以后的版本永远只会有会员体验卡这一种奖项
    NSString *imageName = [NSString stringWithFormat:@"prize_%d.png", 7];
    return [UIImage imageNamed:imageName];
    
    if ([[self.prizeConfigSnapshotData objectForKey:@"bundle"] boolValue] == YES)
    {
        NSString *imageName = [NSString stringWithFormat:@"prize_%d.png", prizeId];
        return [UIImage imageNamed:imageName];
    }
    else
    {
        NSString *imageUrl = [[[self.prizeConfigSnapshotData objectForKey:@"list"] objectForKey:INT2STRING(prizeId)] objectForKey:@"icon"];
        NSString *localUrl = nil;
        eDownLoadStat stat = [[DownLoadManager sharedDownLoadManager] urlStat:imageUrl withLocalUrl:&localUrl];
        if (stat == eDownLoadStatComplete && [localUrl length] > 0)
        {
            return [UIImage imageWithContentsOfFile:localUrl];
        }
        else
        {
            return nil;
        }
    }
}

- (PrizeType)getPrizeTypeWithPrizeId:(int)prizeId
{
    NSDictionary *prizeItemConfig = [[self.prizeConfigSnapshotData objectForKey:@"list"] objectForKey:INT2STRING(prizeId)];
    PrizeType prizeType = [[prizeItemConfig objectForKey:@"type"] intValue];
    return prizeType;
}

- (NSString *)getPrizeTypeNameWithPrizeId:(int)prizeId
{
    PrizeType prizeType = [self getPrizeTypeWithPrizeId:prizeId];
    return [RollConfig getPrizeTypeNameWithType:prizeType];
}

+ (UIImageView *)constructImageWithPrizeType:(PrizeType)prizeType andDesc:(NSString *)desc
{
    return nil;
}

@end
