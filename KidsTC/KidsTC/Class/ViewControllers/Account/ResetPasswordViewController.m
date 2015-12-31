//
//  ResetPasswordViewController.m
//  KidsTC
//
//  Created by Altair on 11/30/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "GValidator.h"

@interface ResetPasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIView *gapLine1;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIView *gapLine2;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) UIButton *getCodeButton;
@property (nonatomic, strong) UIButton *showPasswordButton;

@property (nonatomic, strong) HttpRequestClient *getCodeRequest;

@property (nonatomic, strong) HttpRequestClient *resetPasswordRequest;

@property (nonatomic, strong) ATCountDown *localCountDown;


- (void)buildSubviews;

- (void)didClickedGetCodeButton;
- (void)didClickedShowPasswordButton;
- (IBAction)didClickedConfirmButton:(id)sender;

- (BOOL)isValidPhoneNumber;

- (void)autoResetCodeButtonIfStartNewCountDown:(BOOL)needStartNew;

- (void)setGetCodeButtonEnableState:(BOOL)enabled;

- (void)resetPasswordSucceedWithRespData:(NSDictionary *)data;

- (void)resetPasswordFailedWithError:(NSError *)error;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    self.bTapToEndEditing = YES;
    [super viewDidLoad];
    _navigationTitle = @"重置密码";
    _pageIdentifier = @"pv_resetpwd";
    // Do any additional setup after loading the view from its nib.
    [self buildSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self autoResetCodeButtonIfStartNewCountDown:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self.localCountDown stopCountDown];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.passwordField) {
        [self.showPasswordButton setHidden:NO];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.passwordField) {
        [self.showPasswordButton setHidden:YES];
    }
}

#pragma mark Private methods

- (void)buildSubviews {
    self.phoneField.delegate = self;
    self.passwordField.delegate = self;
    [self.bgView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    
    [GConfig resetLineView:self.gapLine1 withLayoutAttribute:NSLayoutAttributeHeight];
    [GConfig resetLineView:self.gapLine2 withLayoutAttribute:NSLayoutAttributeHeight];
    
    //phone
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setFont:[UIFont systemFontOfSize:15]];
    [phoneLabel setTextColor:[UIColor darkGrayColor]];
    [phoneLabel setText:@"手机号"];
    [self.phoneField setLeftView:phoneLabel];
    [self.phoneField setLeftViewMode:UITextFieldViewModeAlways];
    
    //code
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [codeLabel setBackgroundColor:[UIColor clearColor]];
    [codeLabel setFont:[UIFont systemFontOfSize:15]];
    [codeLabel setTextColor:[UIColor darkGrayColor]];
    [codeLabel setText:@"验证码"];
    [self.codeField setLeftView:codeLabel];
    [self.codeField setLeftViewMode:UITextFieldViewModeAlways];
    
    self.getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getCodeButton setFrame:CGRectMake(0, 0, 100, 30)];
    self.getCodeButton.layer.borderColor = [[KTCThemeManager manager] defaultTheme].globalThemeColor.CGColor;
    self.getCodeButton.layer.borderWidth = BORDER_WIDTH;
    self.getCodeButton.layer.cornerRadius = 5;
    self.getCodeButton.layer.masksToBounds = YES;
    [self.getCodeButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCodeButton setTitleColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor forState:UIControlStateNormal];
    [self.getCodeButton setTitleColor:[[KTCThemeManager manager] defaultTheme].lightTextColor forState:UIControlStateDisabled];
    [self.getCodeButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.getCodeButton setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1] forState:UIControlStateDisabled];
    [self.getCodeButton addTarget:self action:@selector(didClickedGetCodeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.codeField setRightView:self.getCodeButton];
    [self.codeField setRightViewMode:UITextFieldViewModeAlways];
    
    //password
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [passwordLabel setBackgroundColor:[UIColor clearColor]];
    [passwordLabel setFont:[UIFont systemFontOfSize:15]];
    [passwordLabel setTextColor:[UIColor darkGrayColor]];
    [passwordLabel setText:@"密码"];
    [self.passwordField setLeftView:passwordLabel];
    [self.passwordField setLeftViewMode:UITextFieldViewModeAlways];
    
    
    self.showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showPasswordButton setFrame:CGRectMake(SCREEN_WIDTH - 50, 5, 30, 30)];
    [self.showPasswordButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.showPasswordButton setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1] forState:UIControlStateDisabled];
    [self.showPasswordButton setBackgroundImage:[UIImage imageNamed:@"showpassword_normal"] forState:UIControlStateNormal];
    [self.showPasswordButton setBackgroundImage:[UIImage imageNamed:@"showpassword_highlight"] forState:UIControlStateSelected];
    [self.showPasswordButton addTarget:self action:@selector(didClickedShowPasswordButton) forControlEvents:UIControlEventTouchUpInside];
    [self.passwordField.superview addSubview:self.showPasswordButton];
    [self.showPasswordButton setHidden:YES];
    
    
    [self.confirmButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.confirmButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
}

- (void)didClickedGetCodeButton {
    [self setGetCodeButtonEnableState:NO];
    if ([self isValidPhoneNumber]) {
        
    } else {
        [[iToast makeText:@"请输入正确的手机号"] show];
        [self setGetCodeButtonEnableState:YES];
        return;
    }
    
    if (!self.getCodeRequest) {
        self.getCodeRequest = [HttpRequestClient clientWithUrlAliasName:@"TOOL_SEND_REGISTER_SMS"];
    }
    
    NSString *codeKey = [GConfig generateSMSCodeKey];
    [[GConfig sharedConfig] setCurrentSMSCodeKey:codeKey];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           codeKey, @"codeKey",
                           self.phoneField.text, @"mobile",
                           @"0", @"smsType",
                           [NSNumber numberWithInteger:SMSValidateTypeFindPassword], @"validateType", nil];
    
    __weak ResetPasswordViewController *weakSelf = self;
    [weakSelf.getCodeRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf autoResetCodeButtonIfStartNewCountDown:YES];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf setGetCodeButtonEnableState:YES];
        if (error.userInfo) {
            NSString *errMsg = [error.userInfo objectForKey:@"data"];
            if ([errMsg length] == 0) {
                errMsg = @"获取验证码失败";
            }
            [[iToast makeText:errMsg] show];
        }
    }];
}

- (void)didClickedShowPasswordButton {
    [self.showPasswordButton setSelected:![self.showPasswordButton isSelected]];
    [self.passwordField setSecureTextEntry:![self.showPasswordButton isSelected]];
}

- (IBAction)didClickedConfirmButton:(id)sender {
    if (![self isValidPhoneNumber]) {
        [[iToast makeText:@"请输入正确的手机号"] show];
        return;
    }
    if ([self.codeField.text length] == 0) {
        [[iToast makeText:@"请输入验证码"] show];
        return;
    }
    if ([self.passwordField.text length] < 6 || [self.passwordField.text length] > 20) {
        [[iToast makeText:@"请输入6-20位的新密码"] show];
        return;
    }
    
    if (!self.resetPasswordRequest) {
        self.resetPasswordRequest = [HttpRequestClient clientWithUrlAliasName:@"USER_FIND_PASSWORD"];
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.phoneField.text, @"mobile",
                           self.codeField.text, @"code",
                           [[GConfig sharedConfig] currentSMSCodeKey], @"codeKey",
                           self.passwordField.text, @"passWord", nil];
    
    __weak ResetPasswordViewController *weakSelf = self;
    [weakSelf.resetPasswordRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf resetPasswordSucceedWithRespData:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf resetPasswordFailedWithError:error];
    }];
}

- (BOOL)isValidPhoneNumber {
    NSString *phoneNumber = self.phoneField.text;
    if ([phoneNumber length] == 0) {
        return NO;
    }
    if (![GValidator checkMobilePhone:phoneNumber]) {
        return NO;
    }
    return YES;
}

- (void)autoResetCodeButtonIfStartNewCountDown:(BOOL)needStartNew {
    NSTimeInterval leftTime = [GConfig sharedConfig].smsCodeCountDown.leftTime;
    if (leftTime > 0) {
        if (!self.localCountDown) {
            self.localCountDown = [[ATCountDown alloc] initWithLeftTimeInterval:leftTime];
        }
        [self.localCountDown startCountDownWithCurrentTimeLeft:^(NSTimeInterval currentTimeLeft) {
            [self setGetCodeButtonEnableState:NO];
            NSString *title = [NSString stringWithFormat:@"重新获取(%.f)", currentTimeLeft];
            [self.getCodeButton setTitle:title forState:UIControlStateDisabled];
        } completion:^{
            [self setGetCodeButtonEnableState:YES];
            [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.getCodeButton setEnabled:YES];
        }];
    } else if (needStartNew) {
        [[GConfig sharedConfig] startSMSCodeCountDownWithLeftTime:^(NSTimeInterval currentTimeLeft) {
            NSString *title = [NSString stringWithFormat:@"重新获取(%.f)", currentTimeLeft];
            [self.getCodeButton setTitle:title forState:UIControlStateDisabled];
            [self setGetCodeButtonEnableState:NO];
        } completion:^{
            [self setGetCodeButtonEnableState:YES];
        }];
    }
}

- (void)setGetCodeButtonEnableState:(BOOL)enabled {
    [self.getCodeButton setEnabled:enabled];
    if (enabled) {
        self.getCodeButton.layer.borderColor = [[KTCThemeManager manager] defaultTheme].globalThemeColor.CGColor;
    } else {
        self.getCodeButton.layer.borderColor = [[KTCThemeManager manager] defaultTheme].lightTextColor.CGColor;
    }
}

- (void)resetPasswordSucceedWithRespData:(NSDictionary *)data {
    [[KTCUser currentUser] logoutManually:YES withSuccess:nil failure:nil];
    [self goBackController:nil];
}

- (void)resetPasswordFailedWithError:(NSError *)error {
    NSString *errMsg = @"";
    if (error.userInfo) {
        errMsg = [error.userInfo objectForKey:@"data"];
    }
    if (![errMsg isKindOfClass:[NSString class]] || [errMsg length] == 0) {
        errMsg = @"重置密码失败";
    }
    
    [[iToast makeText:errMsg] show];
}

#pragma mark Super methods

- (void)goBackController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
