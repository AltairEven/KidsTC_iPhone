//
//  GCommonFilterOptionSelectorView.h
//  iphone51buy
//
//  Created by CGS on 12-5-23.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCommonFilterOption.h"
#import "GTableViewCell.h"
#import "GCheckBox.h"

@class GCommonFilterOptionSelectorView;
@protocol GCommonFilterOptionSelectorViewDelegate <NSObject>

- (NSArray *)optionsListForGCommonFilterOptionSelectorView: (GCommonFilterOptionSelectorView *)gCommonFilterOptionSelectorView;
- (void)gCommonFilterOptionSelectorView: (GCommonFilterOptionSelectorView *)gCommonFilterOptionSelectorView selectedRow:(NSUInteger)row;

@end

@interface GCommonFilterOptionSelectorViewCell : GTableViewCell

@property (assign, nonatomic) GCommonFilterOptionSelectorView *gTableView;
@property (strong, nonatomic) GCommonFilterOption *optionInfo;
@property (strong, nonatomic) UIImageView *sepLineImg;

- (void)toggleAccessoryType;
@end

@interface GCommonFilterOptionSelectorView : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) id<GCommonFilterOptionSelectorViewDelegate> controllerDelegate;
@end
