//
//  OrderCommentBottomView.m
//  KidsTC
//
//  Created by 钱烨 on 7/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderCommentBottomView.h"

@interface OrderCommentBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *hideNameButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)didClickedHideNameButton:(id)sender;
- (IBAction)didClickedSubmitButton:(id)sender;

@end

@implementation OrderCommentBottomView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        OrderCommentBottomView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.hideNameButton.selected = NO;
    [self.hideNameButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor forState:UIControlStateNormal];
    
    [self.submitButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)needHideName {
    return [self.hideNameButton isSelected];
}

- (IBAction)didClickedHideNameButton:(id)sender {
    self.hideNameButton.selected = ![self.hideNameButton isSelected];
}

- (IBAction)didClickedSubmitButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSubmitButtonOnOrderCommentBottomView:)]) {
        [self.delegate didClickedSubmitButtonOnOrderCommentBottomView:self];
    }
}

@end
