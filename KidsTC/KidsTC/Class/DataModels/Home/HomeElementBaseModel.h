//
//  HomeElementBaseModel.h
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HomeViewSegueDestinationH5 = 1,
    HomeViewSegueDestinationServiceDetail,
    HomeViewSegueDestinationStoreDetail,
    HomeViewSegueDestinationServiceList,
    HomeViewSegueDestinationStoreList,
    HomeViewSegueDestinationTuanList
}HomeSegueDestination;


extern NSString *const kParameterKeyLinkUrl;
extern NSString *const kParameterKeyServiceId;
extern NSString *const kParameterKeyServiceChannelId;
extern NSString *const kParameterKeyStoreId;
extern NSString *const kParameterKeySearchKeyWord;
extern NSString *const kParameterKeySearchArea;
extern NSString *const kParameterKeySearchAge;
extern NSString *const kParameterKeySearchCategory;
extern NSString *const kParameterKeySearchSort;

@interface HomeElementBaseModel : NSObject

@property (nonatomic, copy) NSString *linkUrlString; //链接地址，在跳转网页时使用

@property (nonatomic, assign) HomeSegueDestination segueDestination; //跳转目的地

@property (nonatomic, copy) NSString *pictureUrlString; //展示图片的链接地址

@property (nonatomic, copy) NSString *paramString;

- (instancetype)initWithHomeData:(NSDictionary *)data;

- (NSDictionary *)parametersFromParamString;

- (void)parseHomeData:(NSDictionary *)data;

@end
