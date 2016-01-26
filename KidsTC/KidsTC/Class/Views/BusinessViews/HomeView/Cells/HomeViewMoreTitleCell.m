//
//  HomeViewMoreTitleCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewMoreTitleCell.h"

@interface HomeViewMoreTitleCell ()

@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation HomeViewMoreTitleCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.tagView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    
    [self.mainTitleLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeMoreTitleCellModel *)model {
    if (model) {
        [self setMainTitle:model.mainTitle subTitle:model.subTitle];
    }
}

- (void)setMainTitle:(NSString *)main subTitle:(NSString *)sub {
    [self.mainTitleLabel setText:main];
    if ([sub length] > 0) {
        [self.subTitleLabel setText:sub];
        [self.subTitleLabel setHidden:NO];
    } else {
        [self.subTitleLabel setHidden:YES];
    }
}

@end
