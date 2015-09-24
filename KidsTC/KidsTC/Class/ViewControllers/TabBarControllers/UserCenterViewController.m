//
//  UserCenterViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterViewModel.h"
#import "OrderListViewController.h"
#import "CouponListViewController.h"
#import "FavourateViewController.h"
#import "AccountSettingViewController.h"
#import "LoginViewController.h"
#import "AppointmentOrderListViewController.h"

@interface UserCenterViewController () <UserCenterViewDelegate>

@property (weak, nonatomic) IBOutlet UserCenterView *userCenterView;

@property (nonatomic, strong) UserCenterViewModel *viewModel;

@end

@implementation UserCenterViewController

#pragma mark Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navigationTitle = @"个人中心";
    self.userCenterView.delegate = self;
    
    self.viewModel = [[UserCenterViewModel alloc] initWithView:self.userCenterView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[KTCUser currentUser] hasLogin]) {
        [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [self.viewModel stopUpdateData];
}


#pragma mark UserCenterViewDelegate

- (void)userCenterView:(UserCenterView *)view didClickedWithTag:(UserCenterTag)tag {
    if (tag == UserCenterTagFace && ![[KTCUser currentUser] hasLogin]) {
        [GToolUtil checkLogin:^(NSString *uid) {
            [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
        } target:self];
        return;
    }
    [GToolUtil checkLogin:^(NSString *uid) {
        [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
        switch (tag) {
            case UserCenterTagFace:
            {
                AccountSettingViewController *controller = [[AccountSettingViewController alloc] initWithNibName:@"AccountSettingViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case UserCenterTagMyAppointment:
            {
                AppointmentOrderListViewController *controller = [[AppointmentOrderListViewController alloc] initWithNibName:@"AppointmentOrderListViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case UserCenterTagWaitingPay:
            {
                OrderListViewController *controller = [[OrderListViewController alloc] initWithOrderListType:OrderListTypeWaitingPayment];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case UserCenterTagWaitingComment:
            {
                OrderListViewController *controller = [[OrderListViewController alloc] initWithOrderListType:OrderListTypeWaitingComment];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case UserCenterTagAllOrder:
            {
                OrderListViewController *controller = [[OrderListViewController alloc] initWithOrderListType:OrderListTypeAll];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case UserCenterTagCoupon:
            {
                CouponListViewController *controller = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case UserCenterTagMyFavourate:
            {
                FavourateViewController *controller = [[FavourateViewController alloc] initWithNibName:@"FavourateViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case UserCenterTagSetting:
            {
                AccountSettingViewController *controller = [[AccountSettingViewController alloc] initWithNibName:@"AccountSettingViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            default:
                break;
        }
    } target:self];
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
