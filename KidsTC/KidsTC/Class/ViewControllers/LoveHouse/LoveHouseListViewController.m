//
//  LoveHouseListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "LoveHouseListViewController.h"
#import "LoveHouseListViewModel.h"

@interface LoveHouseListViewController () <LoveHouseListViewDelegate>

@property (weak, nonatomic) IBOutlet LoveHouseListView *listView;

@property (nonatomic, strong) LoveHouseListViewModel *viewModel;

@end

@implementation LoveHouseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"爱心妈咪小屋";
    // Do any additional setup after loading the view from its nib.
    self.listView.delegate = self;
    
    self.viewModel = [[LoveHouseListViewModel alloc] initWithView:self.listView];
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [self.viewModel startUpdateDataWithSucceed:^(NSDictionary *data) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

#pragma mark LoveHouseListViewDelegate

- (void)didPullUpToLoadMoreForLoveHouseListView:(LoveHouseListView *)listView {
    [self.viewModel getMoreHouses];
}

- (void)loveHouseListView:(LoveHouseListView *)listView didClickedGotoButtonAtIndex:(NSUInteger)index {
    
}

- (void)loveHouseListView:(LoveHouseListView *)listView didClickedNearbyButtonAtIndex:(NSUInteger)index {
    
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
