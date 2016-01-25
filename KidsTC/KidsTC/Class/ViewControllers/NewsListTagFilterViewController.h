//
//  NewsListTagFilterViewController.h
//  KidsTC
//
//  Created by Altair on 11/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"
#import "NewsTagItemModel.h"

typedef void(^ SelectCompletion)(NewsTagItemModel *itemModel);

@interface NewsListTagFilterViewController : GViewController

@property (nonatomic, strong) SelectCompletion completionBlock;

@property (nonatomic, assign) NSUInteger selectedTagType;

- (instancetype)initWithNewsTagTypeModels:(NSArray<NewsTagTypeModel *> *)models;

@end
