//
//  NewsRecommendCellViewBigImageCell.m
//  KidsTC
//
//  Created by Qian Ye on 15/10/2.
//  Copyright © 2015年 KidsTC. All rights reserved.
//

#import "NewsRecommendCellViewBigImageCell.h"

@implementation NewsRecommendCellViewBigImageCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    
    [GConfig resetLineView:self.separator withLayoutAttribute:NSLayoutAttributeHeight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return (SCREEN_WIDTH - 40) * 0.6;
}

@end
