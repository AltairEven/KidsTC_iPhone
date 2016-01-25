//
//  StrategyDetailBottomView.m
//  KidsTC
//
//  Created by Altair on 1/22/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "StrategyDetailBottomView.h"

@interface StrategyDetailBottomView ()

@property (weak, nonatomic) IBOutlet UIView *leftBGView;
@property (weak, nonatomic) IBOutlet UIView *gapView;
@property (weak, nonatomic) IBOutlet UIView *rightBGView;

- (void)didClickedLeft;
- (void)didClickedRight;

@end

@implementation StrategyDetailBottomView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        StrategyDetailBottomView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedLeft)];
    [self.leftBGView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedRight)];
    [self.rightBGView addGestureRecognizer:tap2];
}


- (void)didClickedLeft {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedLeftButtonOnStrategyDetailBottomView:)]) {
        [self.delegate didClickedLeftButtonOnStrategyDetailBottomView:self];
    }
}


- (void)didClickedRight {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedRightButtonOnStrategyDetailBottomView:)]) {
        [self.delegate didClickedRightButtonOnStrategyDetailBottomView:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end