//
//  HomeSegueModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeSegueModel.h"

//H5
NSString *const kParameterKeyLinkUrl = @"kParameterKeyLinkUrl";
//资讯列表
NSString *const kParameterKeyNewsKind = @"kParameterKeyNewsKind";
NSString *const kParameterKeyNewsTag = @"kParameterKeyNewsTag";
NSString *const kParameterKeyNewsType = @"kParameterKeyNewsType";
//搜索
NSString *const kParameterKeySearchKeyWord = @"kParameterKeySearchKeyWord";
NSString *const kParameterKeySearchArea = @"kParameterKeySearchArea";
NSString *const kParameterKeySearchAge = @"kParameterKeySearchAge";
NSString *const kParameterKeySearchCategory = @"kParameterKeySearchCategory";
NSString *const kParameterKeySearchSort = @"kParameterKeySearchSort";

@interface HomeSegueModel ()

- (void)fillSegueParamWithData:(NSDictionary *)data;

@end

@implementation HomeSegueModel

- (instancetype)initWithDestination:(HomeSegueDestination)destinaton paramRawData:(NSDictionary *)data {
    if (!data) {
        return nil;
    }
    self = [super init];
    if (self) {
        _destination = destinaton;
        [self fillSegueParamWithData:data];
    }
    return self;
}


- (void)fillSegueParamWithData:(NSDictionary *)data {
    switch (self.destination) {
        case HomeSegueDestinationH5:
        {
            if ([data isKindOfClass:[NSString class]]) {
                _segueParam = [NSDictionary dictionaryWithObject:data forKey:kParameterKeyLinkUrl];
            } else {
                _destination = HomeSegueDestinationNone;
            }
        }
            break;
        case HomeSegueDestinationNone:
        case HomeSegueDestinationNewsRecommend:
        case HomeSegueDestinationActivity:
        case HomeSegueDestinationBabyHouse:
        case HomeSegueDestinationHospital:
        case HomeSegueDestinationStrategyList:
            break;
        case HomeSegueDestinationNewsList:
        case HomeSegueDestinationServiceList:
        case HomeSegueDestinationStoreList:
        {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _segueParam = [NSDictionary dictionaryWithDictionary:data];
            } else {
                _destination = HomeSegueDestinationNone;
            }
        }
        default:
            break;
    }
}

@end
