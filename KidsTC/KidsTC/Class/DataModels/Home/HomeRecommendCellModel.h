//
//  HomeRecommendCellModel.h
//  KidsTC
//
//  Created by Altair on 12/31/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@class HomeRecommendElement;

@interface HomeRecommendCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray<HomeRecommendElement *> *recommendElementsArray;

@end


@interface HomeRecommendElement : HomeElementBaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) CGFloat promotionPrice;

@property (nonatomic, assign) CGFloat originalPrice;

@property (nonatomic, assign) NSUInteger saledCount;

@property (nonatomic, assign) CGFloat imageRatio;

@property (nonatomic, readonly) CGFloat cellHeight;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
