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
    HomeSegueDestinationNewsRecommend = 2, //资讯推荐列表
    HomeSegueDestinationNewsList = 3, //资讯列表
    HomeSegueDestinationActivity = 4, //活动页面
    HomeSegueDestinationLoveHouse = 5, //爱心小屋
    HomeSegueDestinationHospital = 6, //医院
    HomeSegueDestinationStrategyList = 7, //攻略列表
    HomeSegueDestinationServiceList = 8, //服务列表
    HomeSegueDestinationStoreList = 9, //门店列表
    HomeSegueDestinationServiceDetail = 10, //服务详情
    HomeSegueDestinationStoreDetail = 11, //门店详情
    HomeSegueDestinationStrategyDetail = 12, //攻略详情
    HomeSegueDestinationCouponList = 13, //优惠券列表
    HomeSegueDestinationOrderDetail = 14, //订单详情
    HomeSegueDestinationOrderList = 15 //订单列表
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

- (instancetype)initWithDestination:(HomeSegueDestination)destination;

- (instancetype)initWithDestination:(HomeSegueDestination)destination paramRawData:(NSDictionary *)data;

@end
