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
//        self.name = [data objectForKey:@"title"];
//        self.hospitalDescription = [data objectForKey:@"content"];
//        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
//        self.phoneNumber = [data objectForKey:@"phone"];
//        self.distanceDescription = [data objectForKey:@"distance"];
//        self.coordinate = [GToolUtil coordinateFromString:[data objectForKey:@"mapAddr"]];
        
        self.name = @"XX医院";
        self.hospitalDescription = @"XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院XX医院";
        self.imageUrl = [NSURL URLWithString:@"http://img.sqkids.com:7500/v1/img/T1KtETBjVT1RCvBVdK.jpg"];
        self.phoneNumber = @"15000168321";
        self.distanceDescription = @"<500米";
        self.coordinate = [GToolUtil coordinateFromString:@"34.50000,121.43333"];
    }
    return self;
}

- (CGFloat)cellHeight {
    CGFloat height = 120;
    height += [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 andText:self.hospitalDescription];
    return height;
}

@end
