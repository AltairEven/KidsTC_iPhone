//
//  ServiceDetailActivityCell.h
//  KidsTC
//
//  Created by Altair on 1/5/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLogoItem.h"

@interface ServiceDetailActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activeImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void)configWithModel:(ActivityLogoItem *)model;

@end
