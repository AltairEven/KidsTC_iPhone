//
//  NewsRecommendCellViewBigImageView.m
//  KidsTC
//
//  Created by 钱烨 on 10/15/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsRecommendCellViewBigImageView.h"

@implementation NewsRecommendCellViewBigImageView

- (void)awakeFromNib {
    [self setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (CGFloat)viewHeight {
    return (SCREEN_WIDTH - 40) * 0.6;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
