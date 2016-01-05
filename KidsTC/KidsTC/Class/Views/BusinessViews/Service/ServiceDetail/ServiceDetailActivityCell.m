//
//  ServiceDetailActivityCell.m
//  KidsTC
//
//  Created by Altair on 1/5/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "ServiceDetailActivityCell.h"

@implementation ServiceDetailActivityCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.descriptionLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(ActivityLogoItem *)model {
    [self.activeImageView setImage:model.image];
    [self.descriptionLabel setText:model.itemDescription];
}

@end
