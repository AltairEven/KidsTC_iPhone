//
//  ActivityFilterModel.h
//  KidsTC
//
//  Created by 钱烨 on 11/6/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActivityFiltItem;

@interface ActivityFilterModel : NSObject

@property (nonatomic, strong, readonly) NSArray<ActivityFiltItem *> *categoryFiltItems;

@property (nonatomic, strong, readonly) NSArray<ActivityFiltItem *> *areaFiltItems;

@property (nonatomic, strong, readonly) NSDate *lastUpdateDate;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (BOOL)needRefresh;

- (NSArray *)categotyNames;

- (NSArray *)areaNames;

@end



@interface ActivityFiltItem : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end