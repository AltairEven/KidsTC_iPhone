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

@interface StoreDetailModel : NSObject

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, assign) CGFloat bannerRatio;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *couponName;

@property (nonatomic, copy) NSString *couponUrlString;

@property (nonatomic, assign) NSUInteger starNumber;

@property (nonatomic, assign) NSUInteger appointmentNumber;

@property (nonatomic, assign) NSUInteger commentNumber;

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, assign) CLLocationCoordinate2D storeCoordinate;

@property (nonatomic, copy) NSString *storeAddress;

@property (nonatomic, strong) NSArray<ActivityLogoItem *> *activeModelsArray;

@property (nonatomic, strong) NSArray *hotRecommendServiceArray;

@property (nonatomic, strong) NSURL *recommenderFaceImageUrl;

@property (nonatomic, copy) NSString *recommenderName;

@property (nonatomic, copy) NSString *recommendString;

@property (nonatomic, copy) NSString *storeBrief;

@property (nonatomic, copy) NSString *detailUrlString;

@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, strong) NSArray *nearbyFacilities;

@property (nonatomic, strong) NSArray *brotherStores;

@property (nonatomic, strong) NSArray *serviceModelsArray;

@property (nonatomic, assign) NSUInteger commentAllNumber;

@property (nonatomic, assign) NSUInteger commentGoodNumber;

@property (nonatomic, assign) NSUInteger commentNormalNumber;

@property (nonatomic, assign) NSUInteger commentBadNumber;

@property (nonatomic, assign) NSUInteger commentPictureNumber;

@property (nonatomic, assign) BOOL isFavourate;

@property (nonatomic, strong) NSDate *appointmentStartDate;

@property (nonatomic, strong) NSDate *appointmentEndDate;

@property (nonatomic, strong) NSArray *appointmentTimes;

- (void)fillWithRawData:(NSDictionary *)data;

- (CGFloat)topCellHeight;

- (CGFloat)recommendCellHeight;

- (CGFloat)briefCellHeight;

- (CGFloat)nearbyCellHeight;

- (BOOL)hasCoupon;

- (NSArray<NSString *> *)phoneNumbersArray;

- (CGFloat)couponCellHeight;

- (CGFloat)activityCellHeightAtIndex:(NSUInteger)index;

@end
