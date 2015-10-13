//
//  ActivityListItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ActivityListItemModel.h"

@implementation ActivityListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
//    if (!data || ![data isMemberOfClass:[NSDictionary class]]) {
//        return nil;
//    }
    self = [super init];
    if (self) {
//        if ([data objectForKey:@"id"]) {
//            self.activityId = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
//        }
//        if ([data objectForKey:@"channelId"]) {
//            self.channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelId"]];
//        }
//        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
//        self.title = [data objectForKey:@"title"];
//        self.activityContent = [data objectForKey:@"content"];
//        self.price = [[data objectForKey:@"price"] floatValue];
//        self.leftNumber = [[data objectForKey:@"number"] integerValue];
        
        self.imageUrl = [NSURL URLWithString:@"http://img.sqkids.com:7500/v1/img/T1KtETBjVT1RCvBVdK.jpg"];
        self.title = @"热门大活动";
        self.activityContent = @"亲子游乐热门大活动热门大活动热门大活动热门大活动热门大活动热门大活动热门大活动热门大活动热门大活动热门大活动热门大活动热门大活动";
        self.price = 888.99;
        self.percent = 66;
        self.leftNumber = 12;
        self.ratio = 0.6;
    }
    return self;
}

- (CGFloat)cellHeight {
    CGFloat height = 50; //price
    CGFloat cellWidth = SCREEN_WIDTH;
    height += cellWidth * self.ratio; // image
    height += [GConfig heightForLabelWithWidth:cellWidth LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:15] topGap:10 bottomGap:10 andText:self.activityContent];
    
    return height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
