//
//  StoreRelatedStrategyModel.h
//  KidsTC
//
//  Created by Altair on 1/20/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreRelatedStrategyModel : NSObject

@property (nonatomic, copy) NSString *strategyId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, assign) BOOL isHot;

@property (nonatomic, assign) BOOL isRecommend;

@property (nonatomic, assign) NSUInteger viewCount;

@property (nonatomic, assign) NSUInteger commentCount;

@property (nonatomic, strong) NSArray *tagNames;

@property (nonatomic, copy) NSString *brief;

@property (nonatomic, assign) CGFloat imageRatio;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)cellHeight;

@end
