//
//  NewsRecommendCellViewSmallImageCell.m
//  KidsTC
//
//  Created by Qian Ye on 15/10/2.
//  Copyright © 2015年 KidsTC. All rights reserved.
//

#import "NewsRecommendCellViewSmallImageCell.h"

@interface NewsRecommendCellViewSmallImageCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation NewsRecommendCellViewSmallImageCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 60;
}

@end
