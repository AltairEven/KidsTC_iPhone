//
//  NewsRecommendCellViewSmallImageView.m
//  KidsTC
//
//  Created by 钱烨 on 10/15/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsRecommendCellViewSmallImageView.h"

@implementation NewsRecommendCellViewSmallImageView

- (void)awakeFromNib {
    [self setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor];
}

- (CGFloat)viewHeight {
    return 60;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
