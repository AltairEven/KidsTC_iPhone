//
//  NotificationCenterViewController.m
//  KidsTC
//
//  Created by Altair on 11/30/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NotificationCenterViewController.h"
#import "NotificationCenterViewModel.h"
#import "KTCSegueMaster.h"

@interface NotificationCenterViewController () <NotificationCenterViewDelegate>

@property (weak, nonatomic) IBOutlet NotificationCenterView *listView;

@property (nonatomic, strong) NotificationCenterViewModel *viewModel;

@end

@implementation NotificationCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"消息中心";
    // Do any additional setup after loading the view from its nib.
    self.listView.delegate = self;
    
    self.viewModel = [[NotificationCenterViewModel alloc] initWithView:self.listView];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.viewModel stopUpdateData];
}

#pragma mark NotificationCenterViewDelegate

- (void)didPullDownToRefreshForNotificationCenterView:(NotificationCenterView *)view {
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

- (void)didPullUpToLoadMoreForNotificationCenterView:(NotificationCenterView *)view {
    [self.viewModel getMoreDataWithSucceed:nil failure:nil];
}

- (void)notificationCenterView:(NotificationCenterView *)view didClickedAtIndex:(NSUInteger)index {
    PushNotificationModel *model = [[self.viewModel resultArray] objectAtIndex:index];
    [KTCSegueMaster makeSegueWithModel:model.segueModel fromController:self];
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
