//
//  KTCSearchResultFilterLevel2Cell.m
//  KidsTC
//
//  Created by 钱烨 on 7/31/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchResultFilterLevel2Cell.h"

@interface KTCSearchResultFilterLevel2Cell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation KTCSearchResultFilterLevel2Cell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [self.selectImageView setImage:[UIImage imageNamed:@"selected"]];
    } else {
        [self.selectImageView setImage:[UIImage imageNamed:@"unselected"]];
    }
}

@end
