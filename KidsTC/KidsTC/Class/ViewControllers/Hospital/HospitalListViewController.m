//
//  HospitalListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HospitalListViewController.h"
#import "HospitalListViewModel.h"

@interface HospitalListViewController () <HospitalListViewDelegate>

@property (weak, nonatomic) IBOutlet HospitalListView *listView;

@property (nonatomic, strong) HospitalListViewModel *viewModel;

@end

@implementation HospitalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"医院";
    // Do any additional setup after loading the view from its nib.
    self.listView.delegate = self;
    
    self.viewModel = [[HospitalListViewModel alloc] initWithView:self.listView];
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [self.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

#pragma mark HospitalListViewDelegate

- (void)didPullUpToLoadMoreForHospitalListView:(HospitalListView *)listView {
    [self.viewModel getMoreHouses];
}

- (void)hospitalListView:(HospitalListView *)listView didClickedPhoneButtonAtIndex:(NSUInteger)index {
    
}

- (void)hospitalListView:(HospitalListView *)listView didClickedGotoButtonAtIndex:(NSUInteger)index {
    
}

- (void)hospitalListView:(HospitalListView *)listView didClickedNearbyButtonAtIndex:(NSUInteger)index {
    
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
