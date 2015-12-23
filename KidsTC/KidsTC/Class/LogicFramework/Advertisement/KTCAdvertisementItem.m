//
//  KTCAdvertisementItem.m
//  KidsTC
//
//  Created by Altair on 12/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCAdvertisementItem.h"

@implementation KTCAdvertisementItem

- (instancetype)initWithImage:(UIImage *)image segueRawData:(NSDictionary *)data {
    if (!image || ![image isKindOfClass:[UIImage class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.image = image;
        HomeSegueDestination dest = (HomeSegueDestination)[[data objectForKey:@"linkType"] integerValue];
        if (dest != HomeSegueDestinationNone) {
            NSDictionary *paramData = [data objectForKey:@"params"];
//            NSString *paramString = [data objectForKey:@"params"];
//            NSData *paramData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:paramData options:NSJSONReadingAllowFragments error:nil];
            self.segueModel = [[HomeSegueModel alloc] initWithDestination:dest paramRawData:paramData];
        }
    }
    return self;
}

@end
