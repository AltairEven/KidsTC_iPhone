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
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"image"]];
        self.title = [data objectForKey:@"title"];
        self.editorFaceImageUrl = [NSURL URLWithString:[data objectForKey:@"authorImgUrl"]];
        self.editorName = [data objectForKey:@"authorName"];
        self.viewCount = [[data objectForKey:@"viewCount"] integerValue];
        self.commentCount = [[data objectForKey:@"commentCount"] integerValue];
        self.likeCount = [[data objectForKey:@"praiseCount"] integerValue];
        self.brief = [data objectForKey:@"simply"];
        BOOL isRecommend = [[data objectForKey:@"isRecommend"] boolValue];
        BOOL isHot = [[data objectForKey:@"isHot"] boolValue];
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
