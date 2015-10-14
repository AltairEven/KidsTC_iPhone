//
//  HomeSegueModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HomeSegueDestinationNone = 0, //无跳转
    HomeSegueDestinationH5 = 1, //H5
    HomeSegueDestinationNewsRecommend, //资讯推荐列表
    HomeSegueDestinationNewsList, //资讯列表
    HomeSegueDestinationActivity, //活动页面
    HomeSegueDestinationLoveHouse, //爱心小屋
    HomeSegueDestinationHospital, //医院
    HomeSegueDestinationStrategyList, //攻略列表
    HomeSegueDestinationServiceList, //服务列表
    HomeSegueDestinationStoreList //门店列表
}HomeSegueDestination;

//H5
extern NSString *const kHomeSegueParameterKeyLinkUrl;
//资讯列表
extern NSString *const kHomeSegueParameterKeyNewsKind;
extern NSString *const kHomeSegueParameterKeyNewsTag;
extern NSString *const kHomeSegueParameterKeyNewsType;
//搜索
extern NSString *const kHomeSegueParameterKeySearchKeyWord;
extern NSString *const kHomeSegueParameterKeySearchArea;
extern NSString *const kHomeSegueParameterKeySearchAge;
extern NSString *const kHomeSegueParameterKeySearchCategory;
extern NSString *const kHomeSegueParameterKeySearchSort;

@interface HomeSegueModel : NSObject

@property (nonatomic, readonly) HomeSegueDestination destination;

@property (nonatomic, strong, readonly) NSDictionary *segueParam;

- (instancetype)initWithDestination:(HomeSegueDestination)destinaton paramRawData:(NSDictionary *)data;

@end
