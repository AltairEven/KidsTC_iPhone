//
//  StoreDetailViewActiveCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLogoItem.h"

@interface StoreDetailViewActiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activeImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void)configWithModel:(ActivityLogoItem *)model;

@end
