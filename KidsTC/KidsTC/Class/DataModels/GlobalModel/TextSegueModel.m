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
        _linkColor = [GToolUtil colorWithString:[param objectForKey:@"color"]];
        if (!_linkColor) {
            _linkColor = [UIColor blueColor];
        }
        _promotionWords = words;
        _linkWords = [param objectForKey:@"linkKey"];
        _linkRangeStrings = [GToolUtil rangeStringsOfSubString:self.linkWords inString:self.promotionWords];
        HomeSegueDestination destination = (HomeSegueDestination)[[param objectForKey:@"linkType"] integerValue];
        if (destination != HomeSegueDestinationNone) {
            _segueModel = [[HomeSegueModel alloc] initWithDestination:destination paramRawData:[param objectForKey:@"params"]];
        }
    }
    return self;
}

@end
