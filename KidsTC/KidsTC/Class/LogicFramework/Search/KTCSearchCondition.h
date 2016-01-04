//
//  KTCSearchCondition.h
//  KidsTC
//
//  Created by 钱烨 on 8/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KTCSearchResultServiceSortTypeSmart = 1, //智能排序
    KTCSearchResultServiceSortTypeTimeDescending, //更新时间（降序）
    KTCSearchResultServiceSortTypeTimeAscending, //更新时间（升序）
    KTCSearchResultServiceSortTypePriceAscending, //价格（升序）
    KTCSearchResultServiceSortTypePriceDescending, //价格（降序）
    KTCSearchResultServiceSortTypeCommentCount, //总评价数量（降序）
    KTCSearchResultServiceSortTypeGoodRate, //好评率（降序）
    KTCSearchResultServiceSortTypeSaleCount, //销量（降序）
}KTCSearchResultServiceSortType;

typedef enum {
    KTCSearchResultStoreSortTypeSmart = 1, //智能排序
    KTCSearchResultStoreSortTypeTimeDescending, //更新时间（降序）
    KTCSearchResultStoreSortTypeTimeAscending, //更新时间（升序）
    KTCSearchResultStoreSortTypeCommentCount, //总评价数量（降序）
    KTCSearchResultStoreSortTypeGoodRate, //好评率（降序）
    KTCSearchResultStoreSortTypeDistance //距离（升序）
}KTCSearchResultStoreSortType;

@class IcsonBaseCategory;
@class KTCSearchStoreCondition;

@interface KTCSearchCondition : NSObject

@property (nonatomic, copy) NSString *keyWord;

@property (nonatomic, strong) KTCAreaItem *area;

@property (nonatomic, strong) KTCAgeItem *age;

@property (nonatomic, copy) NSString *categoryIdentifier;

@property (nonatomic, assign) UserRole userRole;

+ (instancetype)conditionFromCategory:(IcsonBaseCategory *)category;

+ (instancetype)conditionFromRawData:(NSDictionary *)data;

@end


@interface KTCSearchServiceCondition : KTCSearchCondition

@property (nonatomic, assign) KTCSearchResultServiceSortType sortType;

+ (KTCSearchServiceCondition *)conditionFromStoreCondition:(KTCSearchStoreCondition *)condition;

@end

@interface KTCSearchStoreCondition : KTCSearchCondition

@property (nonatomic, assign) KTCSearchResultStoreSortType sortType;

@property (nonatomic, copy) NSString *coordinateString;

+ (KTCSearchStoreCondition *)conditionFromServiceCondition:(KTCSearchServiceCondition *)condition;

@end

@interface KTCSearchNewsCondition : KTCSearchCondition

@end