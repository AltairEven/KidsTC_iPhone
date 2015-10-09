//
//  ParentingStrategyDetailView.h
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentingStrategyDetailModel.h"

@class ParentingStrategyDetailView;

@protocol ParentingStrategyDetailViewDataSource <NSObject>

- (ParentingStrategyDetailModel *)detailModelForParentingStrategyDetailView:(ParentingStrategyDetailView *)detailView;

@end

@interface ParentingStrategyDetailView : UIView

@property (nonatomic, assign) id<ParentingStrategyDetailViewDataSource> dataSource;

@end
