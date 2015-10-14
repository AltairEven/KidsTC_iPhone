//
//  HomeSegueModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeSegueModel.h"

//H5
NSString *const kHomeSegueParameterKeyLinkUrl = @"kHomeSegueParameterKeyLinkUrl";
//资讯列表
NSString *const kHomeSegueParameterKeyNewsKind = @"kHomeSegueParameterKeyNewsKind";
NSString *const kHomeSegueParameterKeyNewsTag = @"kHomeSegueParameterKeyNewsTag";
NSString *const kHomeSegueParameterKeyNewsType = @"kHomeSegueParameterKeyNewsType";
//搜索
NSString *const kHomeSegueParameterKeySearchKeyWord = @"kHomeSegueParameterKeySearchKeyWord";
NSString *const kHomeSegueParameterKeySearchArea = @"kHomeSegueParameterKeySearchArea";
NSString *const kHomeSegueParameterKeySearchAge = @"kHomeSegueParameterKeySearchAge";
NSString *const kHomeSegueParameterKeySearchCategory = @"kHomeSegueParameterKeySearchCategory";
NSString *const kHomeSegueParameterKeySearchSort = @"kHomeSegueParameterKeySearchSort";

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
            if ([data isKindOfClass:[NSDictionary class]]) {
                _segueParam = [NSDictionary dictionaryWithObject:[data objectForKey:@"linkurl"] forKey:kHomeSegueParameterKeyLinkUrl];
            } else {
                _destination = HomeSegueDestinationNone;
            }
        }
            break;
        case HomeSegueDestinationNone:
        case HomeSegueDestinationNewsRecommend:
        case HomeSegueDestinationActivity:
        case HomeSegueDestinationLoveHouse:
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
