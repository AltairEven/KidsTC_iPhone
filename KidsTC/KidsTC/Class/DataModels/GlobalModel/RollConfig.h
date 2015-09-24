//
//  RollConfig.h
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-6-13.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonParser.h"

typedef enum {
    ProductPrize = 4,       // 商品专享价
    CouponPrizeType = 1,    // 优惠劵
    QQPrizeType = 2,        // 免费道具卡
    GoldPrizeType = 3,      // 金币
    UnKnownPrizeType = 0,   // 未知奖项
    NonPrize = -1,
} PrizeType;

typedef enum {
    PrizeImgSizeSmall = 0,
    PrizeImgSizeMid = 1,
    PrizeImgSizeLarge = 2,
} PrizeImgSize;

@interface RollConfig : CommonParser

+ (RollConfig *)sharedRollConfig;
+ (NSInteger)getMaxGoldCount;
+ (NSInteger)getRewardCountOfShareSuccess;
+ (NSString *)getRandomNotice;

- (NSDictionary *)getPrizeConfigData;
- (UIImage *)getPrizeImgFromCacheWithPrizeId:(int)prizeId;
- (PrizeType)getPrizeTypeWithPrizeId:(int)prizeId;
- (NSString *)getPrizeTypeNameWithPrizeId:(int)prizeId;
- (void)checkRollConfigUpdate;
- (void)updateConfigFile;

// new method for roll stage 3
+ (UIImageView *)constructImageWithPrizeType:(PrizeType)prizeType andDesc:(NSString *)desc;

@end
