//
//  NewsListViewTagCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/15/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsListViewTagCell.h"

@interface NewsListViewTagCell ()

@property (weak, nonatomic) IBOutlet UIView *tagView;

@end

@implementation NewsListViewTagCell

- (void)awakeFromNib {
    // Initialization code
    [self.tagView setHidden:YES];
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    [self.tagView setBackgroundColor:[AUITheme theme].globalThemeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [self.titleLabel setTextColor:[AUITheme theme].buttonBGColor_Normal];
        [self.tagView setHidden:NO];
    } else {
        [self.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.tagView setHidden:YES];
    }
}

@end
