//
//  OrderCommentModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
#import "AppointmentOrderModel.h"
#import "StoreDetailModel.h"
#import "KTCCommentManager.h"

typedef enum {
    OrderTypeServiceOrder,
    OrderTypeStoreAppointmentOrder
}OrderType;

@interface OrderCommentModel : NSObject

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *relationSysNo;

@property (nonatomic, assign) CommentRelationType relationType;

@property (nonatomic, assign) OrderType type;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, copy) NSString *objectName;

@property (nonatomic, copy) NSString *commentText;

@property (nonatomic, strong) NSArray *uploadPhotoLocationStrings;

@property (nonatomic, assign) NSUInteger environmentStarNumber;

@property (nonatomic, assign) NSUInteger serviceStarNumber;

@property (nonatomic, assign) NSUInteger qualityStarNumber;

//@property (nonatomic, assign) NSUInteger totalStarNumber;

@property (nonatomic, assign) BOOL needHideName;

+ (instancetype)modelFromServiceOrderModel:(OrderModel *)orderModel;

+ (instancetype)modelFromStoreAppointmentModel:(AppointmentOrderModel *)orderModel;

+ (instancetype)modelFromStore:(StoreDetailModel *)detailModel;

@end
