//
//  FlashDetailModel.h
//  KidsTC
//
//  Created by Altair on 2/29/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceDetailModel.h"
#import "StoreListItemModel.h"
#import "CommentListItemModel.h"
#import "Insurance.h"
#import "CommonShareObject.h"
#import "KTCCommentManager.h"
#import "TextSegueModel.h"
#import "ServiceMoreDetailHotSalesItemModel.h"
#import "FlashStageModel.h"

@class ServiceDetailNoticeItem;
@class ServiceDetailPhoneItem;
@class ServicePromotionSegueModel;

@interface FlashDetailModel : NSObject

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, assign) NSUInteger type;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, assign) CGFloat imageRatio;

@property (nonatomic, strong) NSArray *narrowImageUrls;

@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, copy) NSString *serviceBriefName;

@property (nonatomic, copy) NSString *serviceDescription;

@property (nonatomic, strong) NSArray<TextSegueModel *> *promotionSegueModels;

@property (nonatomic, strong) NSArray<FlashStageModel *> *flashStages;

@property (nonatomic, assign) CGFloat starNumber;

@property (nonatomic, assign) CGFloat originalPrice;

@property (nonatomic, assign) CGFloat currentPrice;

@property (nonatomic, copy) NSString *priceDescription;

@property (nonatomic, assign) NSUInteger commentsNumber;

@property (nonatomic, assign) NSUInteger saleCount;

@property (nonatomic, assign) NSTimeInterval countdownTime;

@property (nonatomic, assign) CommentRelationType relationType;

@property (nonatomic, assign) BOOL showCountdown;

@property (nonatomic, copy) NSString *serviceContent;

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

- (BOOL)fillWithRawData:(NSDictionary *)data;

- (CGFloat)topCellHeight;

- (CGFloat)priceCellHeight;

- (CGFloat)contentCellHeight;

- (CGFloat)noticeTitleCellHeight;

- (CGFloat)noticeCellHeight;

- (CGFloat)recommendCellHeight;

@end
