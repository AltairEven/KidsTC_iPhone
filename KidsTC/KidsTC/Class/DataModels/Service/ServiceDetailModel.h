//
//  ServiceDetailModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreListItemModel.h"
#import "CommentListItemModel.h"
#import "Insurance.h"

@interface ServiceDetailModel : NSObject

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, copy) NSString *serviceDescription;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, copy) NSString *priceDescription;

@property (nonatomic, assign) NSUInteger commentsNumber;

@property (nonatomic, assign) NSUInteger saleCount;

@property (nonatomic, assign) NSTimeInterval countdownTime;

@property (nonatomic, assign) BOOL showCountdown;

@property (nonatomic, assign) NSArray *supportedInsurances;

@property (nonatomic, assign) BOOL hasCoupon;

@property (nonatomic, copy) NSString *notice;

@property (nonatomic, strong) NSURL *recommenderFaceImageUrl;

@property (nonatomic, copy) NSString *recommenderName;

@property (nonatomic, copy) NSString *recommendString;

@property (nonatomic, assign) BOOL isFavourate;

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, copy) NSString *introductionHtmlString;

@property (nonatomic, strong) NSArray *storeItemsArray;

@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, assign) NSUInteger stockNumber;

@property (nonatomic, assign) NSUInteger maxLimit;

@property (nonatomic, assign) NSUInteger minLimit;

@property (nonatomic, assign) NSUInteger buyCount;

@property (nonatomic, assign) CGFloat totalPrice;

- (void)fillWithRawData:(NSDictionary *)data;

- (CGFloat)topCellHeight;

- (CGFloat)priceCellHeight;

- (CGFloat)insuranceCellHeight;

- (CGFloat)couponCellHeight;

- (CGFloat)noticeTitleCellHeight;

- (CGFloat)noticeCellHeight;

- (CGFloat)recommendCellHeight;

@end
