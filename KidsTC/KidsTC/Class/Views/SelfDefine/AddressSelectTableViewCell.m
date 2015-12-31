//
//  AddressSelectTableViewCell.m
//  ICSON
//
//  Created by 钱烨 on 3/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "AddressSelectTableViewCell.h"

@interface AddressSelectTableViewCell ()

@end


@implementation AddressSelectTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
