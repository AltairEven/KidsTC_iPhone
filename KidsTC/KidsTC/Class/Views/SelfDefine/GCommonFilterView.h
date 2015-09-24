//
//  GCommonFilterView.h
//  iphone51buy
//
//  Created by CGS on 12-5-23.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCommonFilterAttr.h"
#import "GTableViewCell.h"

@class GCommonFilterView;
@protocol GCommonFilterViewDelegate <NSObject>

- (NSArray *)filterListForGCommonFilterView: (GCommonFilterView *)gCommonFilterView;
- (void)gCommonFilterView: (GCommonFilterView *)gCommonFilterView selectedRow:(NSUInteger)row;

@end

@interface GCommonFilterViewCell: GTableViewCell

@property (strong, nonatomic, readonly) GLabel *titleLabel;
@property (strong, nonatomic, readonly) GLabel *contentLabel;
@property (strong, nonatomic) GCommonFilterAttr *attrInfo;
@property (strong, nonatomic) UIImageView *sepLineImg;
@property (strong, nonatomic) UIImageView *selArrow;
@property (strong, nonatomic) UIImageView *accessImg;

@end

@interface GCommonFilterView : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) id<GCommonFilterViewDelegate> controllerDelegate;
@end
