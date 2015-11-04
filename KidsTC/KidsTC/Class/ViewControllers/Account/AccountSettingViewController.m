//
//  AccountSettingViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "AccountSettingViewModel.h"

@interface AccountSettingViewController () <AccountSettingViewDelegate>

@property (weak, nonatomic) IBOutlet AccountSettingView *settingView;

@property (nonatomic, strong) AccountSettingViewModel *viewModel;

@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"账户设置";
    // Do any additional setup after loading the view from its nib.
    self.settingView.delegate = self;
    self.viewModel = [[AccountSettingViewModel alloc] initWithView:self.settingView];
}

#pragma mark AccountSettingViewDelegate

- (void)accountSettingView:(AccountSettingView *)settingView didClickedWithViewTag:(AccountSettingViewTag)tag {
    
}

- (void)didClickedLogoutButtonOnAccountSettingView:(AccountSettingView *)settingView {
    [[KTCUser currentUser] logoutManually:YES withSuccess:nil failure:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
