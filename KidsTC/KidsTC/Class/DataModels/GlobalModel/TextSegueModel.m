//
//  TextSegueModel.m
//  KidsTC
//
//  Created by Altair on 1/16/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "TextSegueModel.h"

@implementation TextSegueModel

- (instancetype)initWithLinkParam:(NSDictionary *)param promotionWords:(NSString *)words {
    if (!param || ![param isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if (![words isKindOfClass:[NSString class]] || [words length] == 0) {
        return nil;
    }
    self = [super init];
    if (self) {
        _promotionWords = words;
        _linkWords = [param objectForKey:@"linkKey"];
        if ([_linkWords length] > 0) {
            _linkRange = [_promotionWords rangeOfString:self.linkWords];
        }
        HomeSegueDestination destination = (HomeSegueDestination)[[param objectForKey:@"linkType"] integerValue];
        if (destination != HomeSegueDestinationNone) {
            _segueModel = [[HomeSegueModel alloc] initWithDestination:destination paramRawData:[param objectForKey:@"params"]];
        }
    }
    return self;
}

@end
