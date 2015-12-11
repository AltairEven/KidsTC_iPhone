//
//  SoftwareSettingViewController.m
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "SoftwareSettingViewController.h"
#import "SoftwareSettingViewModel.h"
#import "VersionManager.h"
#import "KTCWebViewController.h"

static NSString *const kAboutUsUrlString = @"http://m.kidstc.com/tools/about_us";

@interface SoftwareSettingViewController () <SoftwareSettingViewDelegate>

@property (weak, nonatomic) IBOutlet SoftwareSettingView *settingView;

@property (nonatomic, strong) SoftwareSettingViewModel *viewModel;

@end

@implementation SoftwareSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"设置";
    // Do any additional setup after loading the view from its nib.
    self.settingView.delegate = self;
    self.viewModel = [[SoftwareSettingViewModel alloc] initWithView:self.settingView];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark SoftwareSettingViewDelegate

- (void)softwareSettingView:(SoftwareSettingView *)view didClickedWithViewTag:(SoftwareSettingViewTag)tag {
    switch (tag) {
        case SoftwareSettingViewTagCache:
        {
            [UIImageView clearCache];
            [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
        }
            break;
        case SoftwareSettingViewTagVersion:
        {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate checkVersion];
        }
            break;
        case SoftwareSettingViewTagAbout:
        {
            KTCWebViewController *controller = [[KTCWebViewController alloc] init];
            [controller setWebUrlString:kAboutUsUrlString];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case SoftwareSettingViewTagFeedback:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", kCustomerServicePhoneNumber]]];
        }
            break;
        default:
            break;
    }
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
