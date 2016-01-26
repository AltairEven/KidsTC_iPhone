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
@property (weak, nonatomic) IBOutlet UIButton *roleButton;

- (IBAction)didClickedCategoryButton:(id)sender;
- (IBAction)didClickedRoleButton:(id)sender;

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
    
    [self.roleButton setTitleColor:[[KTCThemeManager manager] defaultTheme].navibarTitleColor_Normal forState:UIControlStateNormal];
    [self.roleButton setTitleColor:[[KTCThemeManager manager] defaultTheme].navibarTitleColor_Highlight forState:UIControlStateHighlighted];
    
//    self.roleButton.layer.cornerRadius = 14;
//    self.roleButton.layer.masksToBounds = YES;
//    self.roleButton.layer.borderColor = [[KTCThemeManager manager] defaultTheme].navibarTitleColor_Normal.CGColor;
//    self.roleButton.layer.borderWidth = 1;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchedInputFieldOnHomeTopView:)]) {
        [self.delegate didTouchedInputFieldOnHomeTopView:self];
    }
    return NO;
}

#pragma mark Private methods

- (IBAction)didClickedCategoryButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchedCategoryButtonOnHomeTopView:)]) {
        [self.delegate didTouchedCategoryButtonOnHomeTopView:self];
    }
}

- (IBAction)didClickedRoleButton:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchedRoleButtonOnHomeTopView:)]) {
        [self.delegate didTouchedRoleButtonOnHomeTopView:self];
    }
}


#pragma mark Public methods

- (void)setRoleWithImage:(UIImage *)image {
    [self.roleButton setImage:image forState:UIControlStateNormal];
}

- (void)setRoleWithTitle:(NSString *)title {
    [self.roleButton setTitle:title forState:UIControlStateNormal];
}

- (void)resetInputFieldContent:(NSString *)content isPlaceHolder:(BOOL)isPlaceHolder {
    if (isPlaceHolder) {
        [self.inputField setPlaceholder:content];
    } else {
        [self.inputField setText:content];
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
