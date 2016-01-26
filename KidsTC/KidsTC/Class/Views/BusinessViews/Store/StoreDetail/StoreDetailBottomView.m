//
//  StoreDetailBottomView.m
//  KidsTC
//
//  Created by 钱烨 on 7/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreDetailBottomView.h"

#define StandardButtonWidth (60)

@interface StoreDetailBottomView ()

- (IBAction)didClickedButton:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneButtonWidth;

@end

@implementation StoreDetailBottomView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        StoreDetailBottomView *view = [GConfig getObjectFromNibWithView:self];
        [self buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}


- (void)buildSubviews {
    [self.favourateButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor forState:UIControlStateNormal];
    [self.commentButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor forState:UIControlStateNormal];
    [self.appointmentButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.appointmentButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.appointmentButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Disable forState:UIControlStateDisabled];
    
    [self hidePhone:YES];
}

- (void)setFavourite:(BOOL)isFavourite {
    if (isFavourite) {
        [self.favourateButton setImage:[UIImage imageNamed:@"favourate_h"] forState:UIControlStateNormal];
    } else {
        [self.favourateButton setImage:[UIImage imageNamed:@"favourate_n"] forState:UIControlStateNormal];
    }
}

- (void)hidePhone:(BOOL)bHidden {
    [self.phoneButton setHidden:bHidden];
    if (bHidden) {
        self.phoneButtonWidth.constant = 0;
    } else {
        self.phoneButtonWidth.constant = StandardButtonWidth;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didClickedButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeDetailBottomView:didClickedButtonWithTag:)]) {
        [self.delegate storeDetailBottomView:self didClickedButtonWithTag:(StoreDetailBottomSubviewTag)((UIButton *)sender).tag];
    }
}

@end
