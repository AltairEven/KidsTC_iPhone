//
//  ChangeNickNameViewController.m
//  KidsTC
//
//  Created by Altair on 11/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ChangeNickNameViewController.h"

@interface ChangeNickNameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nickNameFiled;

@property (nonatomic, copy) NSString *originName;

@property (nonatomic, strong) HttpRequestClient *changeNickNameRequest;

- (BOOL)validateName;

- (void)confirm;

@end

@implementation ChangeNickNameViewController

- (instancetype)initWithNickName:(NSString *)name {
    self = [super initWithNibName:@"ChangeNickNameViewController" bundle:nil];
    if (self) {
        self.originName = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"修改昵称";
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalBGColor];
    
    [self.nickNameFiled setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)]];
    [self.nickNameFiled setRightView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)]];
    [self.nickNameFiled setLeftViewMode:UITextFieldViewModeAlways];
    [self.nickNameFiled setRightViewMode:UITextFieldViewModeAlways];
    
    self.nickNameFiled.text = self.originName;
    self.nickNameFiled.delegate = self;
    
    [self setupRightBarButton:@"确定" target:self action:@selector(confirm) frontImage:nil andBackImage:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.nickNameFiled becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
    [self.changeNickNameRequest cancel];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self confirm];
    return YES;
}

#pragma mark Private methods

- (BOOL)validateName {
    NSString *name = self.nickNameFiled.text;
    if ([name rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
        [[iToast makeText:@"请勿包含非法字符"] show];
        return NO;
    }
    if ([name length] == 0) {
        [[iToast makeText:@"请输入新的昵称"] show];
        return NO;
    }
    if ([name length] > 50) {
        [[iToast makeText:@"昵称过长"] show];
        return NO;
    }
    
    return YES;
}

- (void)confirm {
    [self.nickNameFiled resignFirstResponder];
    if (![self validateName]) {
        return;
    }
    __weak ChangeNickNameViewController *weakSelf = self;
    if ([self.originName isEqualToString:self.nickNameFiled.text]) {
        if (weakSelf.completeBlock) {
            weakSelf.completeBlock(weakSelf.originName);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (!self.changeNickNameRequest) {
        self.changeNickNameRequest = [HttpRequestClient clientWithUrlAliasName:@"USER_UPDATE_INFO"];
    }
    NSString *nickName = self.nickNameFiled.text;
    NSDictionary *param = [NSDictionary dictionaryWithObject:nickName forKey:@"userName"];
    
    [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view];
    [weakSelf.changeNickNameRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        if (weakSelf.completeBlock) {
            weakSelf.completeBlock(nickName);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [iToast makeText:@"昵称修改失败"];
    }];
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
