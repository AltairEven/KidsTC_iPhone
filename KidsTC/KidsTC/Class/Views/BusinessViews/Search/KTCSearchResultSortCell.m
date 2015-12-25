//
//  KTCSearchResultSortCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/31/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchResultSortCell.h"

@interface KTCSearchResultSortCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UIView *dot;

@end

@implementation KTCSearchResultSortCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor];
    [self.tagView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalThemeColor];
    [self.dot setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalThemeColor];
    
    self.dot.layer.cornerRadius = 2.5;
    self.dot.layer.masksToBounds = YES;
    [self.dot setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.tagView setHidden:!selected];
}

- (void)hideDot:(BOOL)hidden {
    [self.dot setHidden:hidden];
}

@end
