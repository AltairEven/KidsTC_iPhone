//
//  ParentingStrategyDetailModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeSegueModel.h"
#import "CommonShareObject.h"
#import "StrategyDetailRelatedStoreItemModel.h"
#import "StoreListItemModel.h"
#import "StrategyDetailServiceItemModel.h"
#import "TextSegueModel.h"

@class ParentingStrategyDetailCellModel;

@interface ParentingStrategyDetailModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, assign) BOOL isFavourite;

@property (nonatomic, strong) NSURL *mainImageUrl;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *authorName;

@property (nonatomic, strong) NSArray *tagNames;

@property (nonatomic, copy) NSString *strategyDescriptionTitle;

@property (nonatomic, copy) NSString *strategyDescription;

@property (nonatomic, assign) CGFloat mainImageRatio;

@property (nonatomic, strong) NSArray<ParentingStrategyDetailCellModel *> *cellModels;

@property (nonatomic, strong) CommonShareObject *shareObject;

@property (nonatomic, strong) NSArray<StrategyDetailRelatedStoreItemModel *> *storeItems;

@property (nonatomic, strong) NSArray<StrategyDetailServiceItemModel *> *relatedServices;

@property (nonatomic, strong) NSArray<TextSegueModel *> *briefSegueModels;

- (BOOL)fillWithRawData:(NSDictionary *)data;

- (CGFloat)mainImageHeight;

- (CGFloat)titleHeight;

- (CGFloat)tagViewHeight;

- (CGFloat)strategyDescriptionViewHeight;

- (NSArray<StoreListItemModel *> *)relatedStoreItems;

@end


@interface ParentingStrategyDetailCellModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *cellContentString;

@property (nonatomic, copy) NSString *timeDescription;

@property (nonatomic, strong) KTCLocation *location;

@property (nonatomic, strong) HomeSegueModel *relatedInfoModel;

@property (nonatomic, copy) NSString *relatedInfoTitle;

@property (nonatomic, assign) NSUInteger commentCount;

@property (nonatomic, assign) CGFloat ratio;

@property (nonatomic, strong) NSArray<TextSegueModel *> *contentSegueModels;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)cellHeight;

@end