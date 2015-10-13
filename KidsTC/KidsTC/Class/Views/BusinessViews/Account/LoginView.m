//
//  LoginView.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "LoginView.h"
#import "AUIStackView.h"

@interface LoginView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *findPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet AUIStackView *thirdPartyLoginView;

- (void)resetThirdPartyLoginView;

- (IBAction)didClickedLoginButton:(id)sender;
- (IBAction)didClickedFindPasswordButton:(id)sender;
- (IBAction)didClickedRegisterButton:(id)sender;

- (void)didTapOnView;

@end

@implementation LoginView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        LoginView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.userNameField.delegate = self;
    self.passwordField.delegate = self;

    [self.loginButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    
    [self.thirdPartyLoginView setViewGap:20];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView)];
    [self addGestureRecognizer:tap];
}

- (void)setSupportedLoginItemModels:(NSArray *)supportedLoginItemModels {
    _supportedLoginItemModels = [NSArray arrayWithArray:supportedLoginItemModels];
    [self resetThirdPartyLoginView];
}

#pragma mark UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.userNameField isEditing]) {
        [self.passwordField becomeFirstResponder];
    } else {
        [self didClickedLoginButton:nil];
    }
    return NO;
}

#pragma mark Private methods

- (void)resetThirdPartyLoginView {
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    for (LoginItemModel *model in self.supportedLoginItemModels) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (model.type == LoginTypeAli) {
            [button setFrame:CGRectMake(0, 0, 28, 28)];
        } else {
            [button setFrame:CGRectMake(0, 0, 30, 30)];
        }
        [button setBackgroundImage:model.logo forState:UIControlStateNormal];
        [viewArray addObject:button];
    }
    [self.thirdPartyLoginView setSubViews:viewArray];
}

- (IBAction)didClickedLoginButton:(id)sender {
    [self endEditing:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginView:didClickedLoginButtonWithAccount:password:)]) {
        [self.delegate loginView:self didClickedLoginButtonWithAccount:self.userNameField.text password:self.passwordField.text];
    }
}

- (IBAction)didClickedFindPasswordButton:(id)sender {
    [self endEditing:YES];
}

- (IBAction)didClickedRegisterButton:(id)sender {
    [self endEditing:YES];
}

- (void)didTapOnView {
    [self endEditing:YES];
}

#pragma mark Public methods

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
