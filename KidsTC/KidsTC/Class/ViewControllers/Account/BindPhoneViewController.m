//
//  BindPhoneViewController.m
//  KidsTC
//
//  Created by Altair on 11/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "GValidator.h"
#import "ThirdPartyLoginService.h"

@interface BindPhoneViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *verifyField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (weak, nonatomic) IBOutlet UIButton *bindButton;

@property (nonatomic, strong) HttpRequestClient *getCodeRequest;

@property (nonatomic, strong) HttpRequestClient *bindPhoneRequest;

@property (nonatomic, strong) ATCountDown *localCountDown;

- (void)setupSubviews;

- (IBAction)didClickedCodeButton:(id)sender;

- (IBAction)didClickedBindButton:(id)sender;

- (BOOL)isValidPhoneNumber;

- (void)autoResetCodeButtonIfStartNewCountDown:(BOOL)needStartNew;

- (void)setCodeButtonEnableState:(BOOL)enabled;

- (void)bindPhoneSucceedWithRespData:(NSDictionary *)data;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"请先绑定手机";
    self.bTapToEndEditing = YES;
    // Do any additional setup after loading the view from its nib.
    [self setupSubviews];
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

#pragma mark Private methods

- (void)setupSubviews {
    [self.view setBackgroundColor:[AUITheme theme].globalBGColor];
    
    [self.phoneLabel setTextColor:[AUITheme theme].globalThemeColor];
    
    self.phoneField.layer.borderColor = [AUITheme theme].globalThemeColor.CGColor;
    self.phoneField.layer.borderWidth = BORDER_WIDTH;
    self.phoneField.layer.cornerRadius = 5;
    self.phoneField.layer.masksToBounds = YES;
    [self.phoneField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
    [self.phoneField setRightView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
    [self.phoneField setLeftViewMode:UITextFieldViewModeAlways];
    [self.phoneField setRightViewMode:UITextFieldViewModeAlways];
    
    [self.codeLabel setTextColor:[AUITheme theme].globalThemeColor];
    
    self.verifyField.layer.borderColor = [AUITheme theme].globalThemeColor.CGColor;
    self.verifyField.layer.borderWidth = BORDER_WIDTH;
    self.verifyField.layer.cornerRadius = 5;
    self.verifyField.layer.masksToBounds = YES;
    [self.verifyField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
    [self.verifyField setRightView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]];
    [self.verifyField setLeftViewMode:UITextFieldViewModeAlways];
    [self.verifyField setRightViewMode:UITextFieldViewModeAlways];
    
    self.codeButton.layer.borderColor = [AUITheme theme].globalThemeColor.CGColor;
    self.codeButton.layer.borderWidth = BORDER_WIDTH;
    self.codeButton.layer.cornerRadius = 5;
    self.codeButton.layer.masksToBounds = YES;
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[AUITheme theme].globalThemeColor forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[AUITheme theme].lightTextColor forState:UIControlStateNormal];
    [self.codeButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.codeButton setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1] forState:UIControlStateDisabled];
    
    [self.bindButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.bindButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    self.bindButton.layer.cornerRadius = 5;
    self.bindButton.layer.masksToBounds = YES;
}

- (IBAction)didClickedCodeButton:(id)sender {
    [self setCodeButtonEnableState:NO];
    if ([self isValidPhoneNumber]) {
        
    } else {
        [[iToast makeText:@"请输入正确的手机号"] show];
        [self setCodeButtonEnableState:YES];
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
                           @"1", @"validateType", nil];
    
    __weak BindPhoneViewController *weakSelf = self;
    [weakSelf.getCodeRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf autoResetCodeButtonIfStartNewCountDown:YES];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf setCodeButtonEnableState:YES];
        if (error.userInfo) {
            NSString *errMsg = [error.userInfo objectForKey:@"data"];
            if ([errMsg length] == 0) {
                errMsg = @"获取验证码失败";
            }
            [[iToast makeText:errMsg] show];
        }
    }];
}

- (IBAction)didClickedBindButton:(id)sender {
    if (![self isValidPhoneNumber]) {
        [[iToast makeText:@"请输入正确的手机号"] show];
        return;
    }
    if ([self.verifyField.text length] == 0) {
        [[iToast makeText:@"请输入验证码"] show];
        return;
    }
    
    if (!self.bindPhoneRequest) {
        self.bindPhoneRequest = [HttpRequestClient clientWithUrlAliasName:@"THIRD_USER_PHONE_REGISTER"];
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:[[ThirdPartyLoginService sharedService] currentLoginType]], @"thirdType",
                           self.phoneField.text, @"mobile",
                           self.verifyField.text, @"code",
                           [[GConfig sharedConfig] currentSMSCodeKey], @"codeKey",
                           [[ThirdPartyLoginService sharedService] currentOpenId], @"openId",
                           [[ThirdPartyLoginService sharedService] currentAccessToken], @"accessToken", nil];
    
    __weak BindPhoneViewController *weakSelf = self;
    [weakSelf.bindPhoneRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf bindPhoneSucceedWithRespData:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        NSString *errMsg = [error.userInfo objectForKey:kErrMsgKey];
        if ([errMsg length] == 0) {
            errMsg = @"绑定失败";
        }
        [[iToast makeText:errMsg] show];
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
            [self setCodeButtonEnableState:NO];
            NSString *title = [NSString stringWithFormat:@"重新获取(%.f)", currentTimeLeft];
            [self.codeButton setTitle:title forState:UIControlStateDisabled];
        } completion:^{
            [self setCodeButtonEnableState:YES];
            [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.codeButton setEnabled:YES];
        }];
    } else if (needStartNew) {
        [[GConfig sharedConfig] startSMSCodeCountDownWithLeftTime:^(NSTimeInterval currentTimeLeft) {
            NSString *title = [NSString stringWithFormat:@"重新获取(%.f)", currentTimeLeft];
            [self.codeButton setTitle:title forState:UIControlStateDisabled];
            [self setCodeButtonEnableState:NO];
        } completion:^{
            [self setCodeButtonEnableState:YES];
        }];
    }
}

- (void)setCodeButtonEnableState:(BOOL)enabled {
    [self.codeButton setEnabled:enabled];
    if (enabled) {
        self.codeButton.layer.borderColor = [AUITheme theme].globalThemeColor.CGColor;
    } else {
        self.codeButton.layer.borderColor = [AUITheme theme].lightTextColor.CGColor;
    }
}

- (void)bindPhoneSucceedWithRespData:(NSDictionary *)data {
    NSDictionary *userData = [data objectForKey:@"data"];
    if (userData && [userData isKindOfClass:[NSDictionary class]]) {
        NSString *uid = [NSString stringWithFormat:@"%@", [userData objectForKey:@"uid"]];
        NSString *skey = [userData objectForKey:@"skey"];
        [[KTCUser currentUser] updateUid:uid skey:skey];
    } else {
        [[iToast makeText:@"获取用户信息失败, 请重新登录"] show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Super methods

- (void)goBackController:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"不绑定手机将无法正常登陆" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelBind = [UIAlertAction actionWithTitle:@"暂不绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *continueBind = [UIAlertAction actionWithTitle:@"继续绑定" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:cancelBind];
    [controller addAction:continueBind];
    
    [self presentViewController:controller animated:YES completion:nil];
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
