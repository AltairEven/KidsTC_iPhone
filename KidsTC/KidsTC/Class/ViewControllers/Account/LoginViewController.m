//
//  LoginViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "LoginService.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "KTCUser.h"

@interface LoginViewController () <LoginViewDelegate>

@property (weak, nonatomic) IBOutlet LoginView *loginView;

- (NSArray *)supportedLoginTypes;

- (BOOL)validAccount:(NSString *)account andPassword:(NSString *)password;

- (void)handleKTCLoginSuccessWithUid:(NSString *)uid skey:(NSString *)skey;

- (void)handleKTCLoginFailedWithError:(NSError *)error;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"登陆";
    self.isNavShowType = NO;
    // Do any additional setup after loading the view from its nib.
    self.loginView.delegate = self;
    [self.loginView setSupportedLoginItemModels:[self supportedLoginTypes]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupLeftBarButtonWithFrontImage:@"navigation_close" andBackImage:@"navigation_close"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.loginView endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)goBackController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark LoginViewDelegate

- (void)loginView:(LoginView *)loginView didClickedLoginButtonWithAccount:(NSString *)account password:(NSString *)password {
    account = @"18018844388";
    password = @"123456";
    if ([self validAccount:account andPassword:password]) {
        [[LoginService sharedService] KTCLoginWithAccount:account password:password success:^(NSString *uid, NSString *sky) {
            [self handleKTCLoginSuccessWithUid:uid skey:sky];
        } failure:^(NSError *error) {
            [self handleKTCLoginFailedWithError:error];
        }];
    }
}

#pragma mark Private methods

- (NSArray *)supportedLoginTypes {
    NSMutableArray * loginArr = [[NSMutableArray alloc] init];
    //qq登录按钮
    if ([TencentOAuth iphoneQQInstalled]) {
        LoginItemModel *model = [[LoginItemModel alloc] init];
        model.type = LoginTypeQQ;
        model.logo = [UIImage imageNamed:@"logo_qq"];
        [loginArr addObject:model];
    }
    //微信按钮
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        LoginItemModel *model = [[LoginItemModel alloc] init];
        model.type = LoginTypeWechat;
        model.logo = [UIImage imageNamed:@"logo_wechat"];
        [loginArr addObject:model];
    }
    
    //支付宝按钮-目前支付宝是必然要添加的
    if(true)
    {
        LoginItemModel *model = [[LoginItemModel alloc] init];
        model.type = LoginTypeAli;
        model.logo = [UIImage imageNamed:@"logo_ali"];
        [loginArr addObject:model];
    }
    return [NSArray arrayWithArray:loginArr];
}

#pragma mark KTC login

- (BOOL)validAccount:(NSString *)account andPassword:(NSString *)password {
    if ([account length] == 0) {
        [[iToast makeText:@"用户名不能为空"] show];
        return NO;
    }
    if ([password length] == 0) {
        [[iToast makeText:@"密码不能为空"] show];
        return NO;
    }
    return YES;
}

- (void)handleKTCLoginSuccessWithUid:(NSString *)uid skey:(NSString *)skey {
    [[KTCUser currentUser] updateUid:uid skey:skey];
    if (self.block) {
        self.block(uid, nil);
    }
    [self goBackController:nil];
}

- (void)handleKTCLoginFailedWithError:(NSError *)error {
    
}

#pragma mark Super methods

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
