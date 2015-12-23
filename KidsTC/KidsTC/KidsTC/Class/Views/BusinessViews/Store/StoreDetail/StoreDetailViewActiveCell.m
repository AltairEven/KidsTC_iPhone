//
//  StoreDetailViewActiveCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreDetailViewActiveCell.h"

@implementation StoreDetailViewActiveCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(ActivityLogoItem *)model {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.activeImageView setImage:model.image];
    [self.descriptionLabel setText:model.itemDescription];
}
@end
