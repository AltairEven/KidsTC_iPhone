//
//  HomeTopView.m
//  ICSON
//
//  Created by 钱烨 on 4/14/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeTopView.h"

@interface HomeTopView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIView *redDot;

- (IBAction)didClickedCategoryButton:(id)sender;
- (IBAction)didClickedMessageButton:(id)sender;

@end

@implementation HomeTopView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        HomeTopView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.inputField.delegate = self;
    
    self.backgroundColor = [AUITheme theme].navibarBGColor;
}

- (IBAction)didClickedCategoryButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchedCategoryButtonOnHomeTopView:)]) {
        [self.delegate didTouchedCategoryButtonOnHomeTopView:self];
    }
}

- (IBAction)didClickedMessageButton:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchedMessageButtonOnHomeTopView:)]) {
        [self.delegate didTouchedMessageButtonOnHomeTopView:self];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchedInputFieldOnHomeTopView:)]) {
        [self.delegate didTouchedInputFieldOnHomeTopView:self];
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
