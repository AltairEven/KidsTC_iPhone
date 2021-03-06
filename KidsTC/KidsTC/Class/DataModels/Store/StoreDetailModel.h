//
//  StoreDetailModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityLogoItem.h"
#import "PromotionLogoItem.h"
#import "StoreDetailHotRecommendModel.h"
#import "StoreOwnedServiceModel.h"
#import "StoreListItemModel.h"
#import "CommentListItemModel.h"
#import "StoreDetailNearbyModel.h"
#import "CommonShareObject.h"
#import "TextSegueModel.h"
#import "StoreRelatedStrategyModel.h"

@interface StoreDetailModel : NSObject

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, assign) CGFloat imageRatio;

@property (nonatomic, strong) NSArray *narrowImageUrls;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *storeShortName;

@property (nonatomic, copy) NSString *storeBrief;

@property (nonatomic, strong) NSArray<TextSegueModel *> *promotionSegueModels;

@property (nonatomic, copy) NSString *couponName;

@property (nonatomic, copy) NSString *couponUrlString;

@property (nonatomic, assign) NSUInteger couponProvideCount;

@property (nonatomic, assign) NSUInteger starNumber;

@property (nonatomic, assign) NSUInteger appointmentNumber;

@property (nonatomic, assign) NSUInteger commentNumber;

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, assign) CLLocationCoordinate2D storeCoordinate;

@property (nonatomic, copy) NSString *storeAddress;

@property (nonatomic, strong) NSArray<ActivityLogoItem *> *activeModelsArray;

@property (nonatomic, copy) NSString *hotRecommendTitle;

@property (nonatomic, strong) StoreDetailHotRecommendModel *hotRecommedService;

@property (nonatomic, strong) NSURL *recommenderFaceImageUrl;

@property (nonatomic, copy) NSString *recommenderName;

@property (nonatomic, copy) NSString *recommendString;

@property (nonatomic, copy) NSString *detailUrlString;

@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, strong) NSArray *nearbyFacilities;

@property (nonatomic, strong) NSArray<StoreListItemModel *> *brotherStores;

@property (nonatomic, strong) NSArray<StoreOwnedServiceModel *> *serviceModelsArray;

@property (nonatomic, strong) NSArray<StoreRelatedStrategyModel *> *strategyModelsArray;

@property (nonatomic, assign) NSUInteger commentAllNumber;

@property (nonatomic, assign) NSUInteger commentGoodNumber;

@property (nonatomic, assign) NSUInteger commentNormalNumber;

@property (nonatomic, assign) NSUInteger commentBadNumber;

@property (nonatomic, assign) NSUInteger commentPictureNumber;

@property (nonatomic, assign) BOOL isFavourate;

@property (nonatomic, strong) NSDate *appointmentStartDate;

@property (nonatomic, strong) NSDate *appointmentEndDate;

@property (nonatomic, copy) NSString *appointmentTimeDes;

@property (nonatomic, strong) CommonShareObject *shareObject;

@property (nonatomic, assign) BOOL canAppoint;

@property (nonatomic, copy) NSString *appointButtonTitle;

- (BOOL)fillWithRawData:(NSDictionary *)data;

- (CGFloat)topCellHeight;

- (CGFloat)recommendCellHeight;

- (CGFloat)briefCellHeight;

- (CGFloat)nearbyCellHeight;

- (BOOL)hasCoupon;

- (NSArray<NSString *> *)phoneNumbersArray;

- (CGFloat)couponCellHeight;

- (CGFloat)activityCellHeightAtIndex:(NSUInteger)index;

@end
