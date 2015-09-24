//
//  ServiceDetailModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceOwnerStoreModel.h"

typedef enum {
    ServicePriceTypeNormal,
    ServicePriceTypeMobileOnly,
    ServiceDetailModelTuan,
    ServiceDetailModelQiang,
    ServiceDetailModelMiao
}ServicePriceType;

@interface ServiceDetailModel : NSObject

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, assign) NSUInteger starNumber;

@property (nonatomic, assign) NSUInteger commentsNumber;

@property (nonatomic, assign) NSUInteger saleCount;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) ServicePriceType priceType;

@property (nonatomic, copy) NSString *priceDescription;

@property (nonatomic, assign) NSTimeInterval countdownTime;

@property (nonatomic, assign) BOOL showCountdown;

@property (nonatomic, assign) NSArray *supportedInsurances;

@property (nonatomic, copy) NSString *promotionDescription;

@property (nonatomic, copy) NSString *ageDescription;

@property (nonatomic, copy) NSString *timeDescription;

@property (nonatomic, strong) NSArray *storeItemsArray;

@property (nonatomic, strong) ServiceOwnerStoreModel *currentStoreModel;

@property (nonatomic, assign) NSUInteger stockNumber;

@property (nonatomic, assign) BOOL isFavourate;

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, assign) NSUInteger maxLimit;

@property (nonatomic, assign) NSUInteger minLimit;

@property (nonatomic, assign) NSUInteger buyCount;

@property (nonatomic, assign) CGFloat totalPrice;

- (void)fillWithRawData:(NSDictionary *)data;

@end
