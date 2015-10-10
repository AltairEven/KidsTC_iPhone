//
//  HomeNewsBaseModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeElementBaseModel.h"

@interface HomeNewsBaseModel : HomeElementBaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isHot;

@property (nonatomic, assign) BOOL isRecommend;

@property (nonatomic, assign) NSUInteger viewCount;

@property (nonatomic, assign) NSUInteger commentCount;

@end
