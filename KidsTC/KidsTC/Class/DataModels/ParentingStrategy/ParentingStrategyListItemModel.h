//
//  ParentingStrategyListItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParentingStrategyListItemModel : NSObject

@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *editorWord;
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, copy) NSString *linkUrlString;

@property (nonatomic, assign) CGFloat imageRatio;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)cellHeight;

@end
