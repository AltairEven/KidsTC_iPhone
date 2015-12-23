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
#import "CommonShareObject.h"
#import "KTCCommentManager.h"

@class ServiceDetailNoticeItem;
@class ServiceDetailPhoneItem;

@interface ServiceDetailModel : NSObject

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, assign) NSUInteger type;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, copy) NSString *serviceDescription;

@property (nonatomic, assign) CGFloat starNumber;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, copy) NSString *priceDescription;

@property (nonatomic, assign) NSUInteger commentsNumber;

@property (nonatomic, assign) NSUInteger saleCount;

@property (nonatomic, assign) NSTimeInterval countdownTime;

@property (nonatomic, assign) CommentRelationType relationType;

@property (nonatomic, assign) BOOL showCountdown;

@property (nonatomic, strong) NSArray *supportedInsurances;

@property (nonatomic, copy) NSString *couponName;

@property (nonatomic, copy) NSString *couponUrlString;

@property (nonatomic, copy) NSArray<ServiceDetailNoticeItem *> *noticeArray;

@property (nonatomic, strong) NSURL *recommenderFaceImageUrl;

@property (nonatomic, copy) NSString *recommenderName;

@property (nonatomic, copy) NSString *recommendString;

@property (nonatomic, assign) BOOL isFavourate;

@property (nonatomic, strong, readonly) NSArray *phoneItems;

@property (nonatomic, copy) NSString *introductionUrlString;

@property (nonatomic, strong) NSArray<StoreListItemModel *> *storeItemsArray;

@property (nonatomic, strong) NSArray<CommentListItemModel *> *commentItemsArray;

@property (nonatomic, assign) NSUInteger commentAllNumber;

@property (nonatomic, assign) NSUInteger commentGoodNumber;

@property (nonatomic, assign) NSUInteger commentNormalNumber;

@property (nonatomic, assign) NSUInteger commentBadNumber;

@property (nonatomic, assign) NSUInteger commentPictureNumber;

@property (nonatomic, assign) NSUInteger stockNumber;

@property (nonatomic, assign) NSUInteger maxLimit;

@property (nonatomic, assign) NSUInteger minLimit;

@property (nonatomic, assign) NSUInteger buyCount;

@property (nonatomic, assign) CGFloat totalPrice;

@property (nonatomic, strong) CommonShareObject *shareObject;

@property (nonatomic, assign) BOOL canBuy;

@property (nonatomic, copy) NSString *buyButtonTitle;

- (void)fillWithRawData:(NSDictionary *)data;

- (CGFloat)topCellHeight;

- (CGFloat)priceCellHeight;

- (CGFloat)insuranceCellHeight;

- (CGFloat)couponCellHeight;

- (CGFloat)noticeTitleCellHeight;

- (CGFloat)noticeCellHeight;

- (CGFloat)recommendCellHeight;

- (BOOL)hasCoupon;

@end

@interface ServiceDetailNoticeItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)itemHeight;

@end

@interface ServiceDetailPhoneItem : NSObject

@property (nonatomic, strong) NSArray *phoneNumbers;

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title andPhoneNumbers:(NSArray *)numbers;

- (instancetype)initWithTitle:(NSString *)title andPhoneNumberString:(NSString *)string;

@end
