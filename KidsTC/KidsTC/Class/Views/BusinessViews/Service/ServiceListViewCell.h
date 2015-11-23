//
//  ServiceListViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceListItemModel.h"
#import "FiveStarsView.h"
#import "RichPriceView.h"

@interface ServiceListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet RichPriceView *promotionPriceView;
@property (weak, nonatomic) IBOutlet UILabel *saledCountLabel;

- (void)configWithItemModel:(ServiceListItemModel *)model;

+ (CGFloat)cellHeight;

@end
