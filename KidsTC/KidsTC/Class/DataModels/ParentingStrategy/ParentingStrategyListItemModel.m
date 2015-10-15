//
//  ParentingStrategyListItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyListItemModel.h"


@implementation ParentingStrategyListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"id"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
//        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
//        self.title = [data objectForKey:@"title"];
//        self.editorName = [data objectForKey:@"author"];
//        self.viewCount = [[data objectForKey:@"viewCount"] integerValue];
//        self.commentCount = [[data objectForKey:@"commentCount"] integerValue];
//        BOOL isRecommend = [[data objectForKey:@"isRecommend"] boolValue];
//        BOOL isHot = [[data objectForKey:@"isHot"] boolValue];
//        if (isRecommend && isHot) {
//            self.listTag = ParentingStrategyListTagRNH;
//        } else if (isRecommend) {
//            self.listTag = ParentingStrategyListTagRecommend;
//        } else if (isHot) {
//            self.listTag = ParentingStrategyListTagHot;
//        } else {
//            self.listTag = ParentingStrategyListTagNone;
//        }
        
        self.imageUrl = [NSURL URLWithString:@"http://img.sqkids.com:7500/v1/img/T1KtETBjVT1RCvBVdK.jpg"];
        self.title = @"亲子攻略";
        self.editorName = @"不晶匀";
        self.viewCount = 10086;
        self.commentCount = 10086;
        BOOL isRecommend = YES;
        BOOL isHot = NO;
        if (isRecommend && isHot) {
            self.listTag = ParentingStrategyListTagRNH;
        } else if (isRecommend) {
            self.listTag = ParentingStrategyListTagRecommend;
        } else if (isHot) {
            self.listTag = ParentingStrategyListTagHot;
        } else {
            self.listTag = ParentingStrategyListTagNone;
        }
        
        self.imageRatio = 0.6;
    }
    return self;
}


- (CGFloat)cellHeight {
    return self.imageRatio * SCREEN_WIDTH;
}

@end
