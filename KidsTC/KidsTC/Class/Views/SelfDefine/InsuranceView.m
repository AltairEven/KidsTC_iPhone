//
//  InsuranceView.m
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "InsuranceView.h"
#import "Insurance.h"

@interface InsuranceView ()

- (void)resetSubviews;

@end

@implementation InsuranceView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    self.viewGap = 5;
    return self;
}

- (void)setSupportedInsurance:(NSArray *)supportedInsurance {
    _supportedInsurance = supportedInsurance;
    if (!supportedInsurance) {
        [self setSubViews:nil];
        return;
    } else {
        [self resetSubviews];
    }
}


- (void)setFontSize:(CGFloat)fontSize {
    CGFloat lastSize = _fontSize;
    _fontSize = fontSize;
    if (fontSize != lastSize) {
        [self resetSubviews];
    }
}

- (void)resetSubviews {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (Insurance *ins in self.supportedInsurance) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, self.fontSize)];
        
        UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.fontSize, self.fontSize)];
        [checkImageView setImage:[UIImage imageNamed:@"insurance_checked"]];
        [bgView addSubview:checkImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(checkImageView.frame.size.width + 1, 0, SCREEN_WIDTH, self.fontSize)];
        [label setTextColor:RGBA(89, 209, 160, 1)];
        [label setFont:[UIFont systemFontOfSize:self.fontSize]];
        [label setText:ins.InsuranceDescription];
        [label sizeToFitWithMaximumNumberOfLines:1];
        [label setCenter:CGPointMake(label.center.x, checkImageView.center.y)];
        [bgView addSubview:label];
        
        [bgView setFrame:CGRectMake(0, 0, checkImageView.frame.size.width + label.frame.size.width, bgView.frame.size.height)];
        [tempArray addObject:bgView];
    }
    [self setSubViews:[NSArray arrayWithArray:tempArray]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
