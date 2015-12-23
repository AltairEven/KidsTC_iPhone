//
//  LoveHouseListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "LoveHouseListViewController.h"
#import "LoveHouseListViewModel.h"
#import "KTCMapViewController.h"
#import "KTCSegueMaster.h"

@interface LoveHouseListViewController () <LoveHouseListViewDelegate>

@property (weak, nonatomic) IBOutlet LoveHouseListView *listView;

@property (nonatomic, strong) LoveHouseListViewModel *viewModel;

@end

@implementation LoveHouseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"爱心妈咪小屋";
    _pageIdentifier = @"pv_baby_rooms";
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
    LoveHouseListItemModel *model = [[self.viewModel resutlItemModels] objectAtIndex:index];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:model.coordinate.latitude longitude:model.coordinate.longitude];
    KTCLocation *destination = [[KTCLocation alloc] initWithLocation:location locationDescription:model.name];
    if (destination) {
        KTCMapViewController *controller = [[KTCMapViewController alloc] initWithMapType:KTCMapTypeStoreGuide destination:destination];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)loveHouseListView:(LoveHouseListView *)listView didClickedNearbyButtonAtIndex:(NSUInteger)index {
    LoveHouseListItemModel *model = [[self.viewModel resutlItemModels] objectAtIndex:index];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:0], @"a",
                           [NSNumber numberWithInteger:0], @"c",
                           @"", @"k",
                           [NSNumber numberWithInteger:0], @"s",
                           [NSNumber numberWithInteger:KTCSearchResultStoreSortTypeDistance], @"st",
                           [GToolUtil stringFromCoordinate:model.coordinate], @"mapaddr", nil];
    HomeSegueModel *segueModel = [[HomeSegueModel alloc] initWithDestination:HomeSegueDestinationStoreList paramRawData:param];
    [KTCSegueMaster makeSegueWithModel:segueModel fromController:self];
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
