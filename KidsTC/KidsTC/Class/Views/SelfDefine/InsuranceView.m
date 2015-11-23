//
//  InsuranceView.m
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "InsuranceView.h"
#import "Insurance.h"

#define InsuranceVIEW_WIDTH (102)
#define InsuranceVIEW_HEIGHT (15)

@interface InsuranceView ()

@property (weak, nonatomic) IBOutlet UIView *gapView;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

- (void)resetSubViews;

@end

@implementation InsuranceView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        InsuranceView *view = [GConfig getObjectFromNibWithView:self];
        [self buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}


- (void)buildSubviews {
    [GConfig resetLineView:self.gapView withLayoutAttribute:NSLayoutAttributeWidth];
    [self bringSubviewToFront:self.gapView];
}

- (void)setSupportedInsurance:(NSArray *)supportedInsurance {
    if (!supportedInsurance) {
        _supportedInsurance = nil;
        [self setHidden:YES];
        return;
    }
    [self setHidden:NO];
    _supportedInsurance = [NSArray arrayWithArray:supportedInsurance];
    [self resetSubViews];
}


- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self.firstButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self.secondButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
}

- (void)resetSubViews {
    //clear
    [self.firstButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.firstButton setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    [self.secondButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.secondButton setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    
    //reset
    for (Insurance *ens in self.supportedInsurance) {
        if (ens.type == InsuranceTypeRefundAnyTime) {
            [self.firstButton setTitleColor:RGBA(129, 25, 31, 1) forState:UIControlStateNormal];
            [self.firstButton setImage:[UIImage imageNamed:@"yes"] forState:UIControlStateNormal];
        }
        if (ens.type == InsuranceTypeRefundOutOfDate) {
            [self.secondButton setTitleColor:RGBA(129, 25, 31, 1) forState:UIControlStateNormal];
            [self.secondButton setImage:[UIImage imageNamed:@"yes"] forState:UIControlStateNormal];
        }
    }
    [self bringSubviewToFront:self.gapView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
