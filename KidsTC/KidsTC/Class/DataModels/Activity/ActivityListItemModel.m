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
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"serviceId"]) {
            self.activityId = [NSString stringWithFormat:@"%@", [data objectForKey:@"serviceId"]];
        }
        if ([data objectForKey:@"channelId"]) {
            self.channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelId"]];
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"ImageUrl"]];
        self.title = [data objectForKey:@"serviceName"];
        self.activityContent = [data objectForKey:@"description"];
        self.price = [[data objectForKey:@"price"] floatValue];
        self.percent = [[data objectForKey:@"percentage"] floatValue];
        self.leftNumber = [[data objectForKey:@"leftCount"] integerValue];
        self.ratio = 0.6;
    }
    return self;
}

- (CGFloat)cellHeight {
    CGFloat height = 40; //price
    CGFloat cellWidth = SCREEN_WIDTH;
    height += cellWidth * self.ratio; // image
    height += [GConfig heightForLabelWithWidth:cellWidth - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:14] topGap:10 bottomGap:10 andText:self.activityContent];
    
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
