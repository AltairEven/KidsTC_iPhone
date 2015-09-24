//
//  NewsRecommendListModel.h
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsListItemModel.h"

@class NewsListItemModel;

@interface NewsRecommendListModel : NSObject

@property (nonatomic, copy) NSString *timeDescription;

@property (nonatomic, strong) NSArray<NewsListItemModel *> *cellModelsArray;

- (CGFloat)cellHeight;

@end
