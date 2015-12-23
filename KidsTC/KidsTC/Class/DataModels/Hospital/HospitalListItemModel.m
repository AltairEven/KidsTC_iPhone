//
//  HospitalListItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HospitalListItemModel.h"

@implementation HospitalListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"id"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
        self.name = [data objectForKey:@"title"];
        self.hospitalDescription = [data objectForKey:@"desc"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"picUrl"]];
        self.distanceDescription = [data objectForKey:@"distance"];
        self.coordinate = [GToolUtil coordinateFromString:[data objectForKey:@"coordinate"]];
        self.phoneNumber = [data objectForKey:@"mobile"];
    }
    return self;
}

- (CGFloat)cellHeight {
    CGFloat height = 120;
    height += [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 andText:self.hospitalDescription];
    return height;
}

@end
