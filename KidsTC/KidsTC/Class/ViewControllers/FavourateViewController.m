//
//  FavourateViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "FavourateViewController.h"
#import "FavourateViewModel.h"
#import "ServiceDetailViewController.h"
#import "StoreDetailViewController.h"
#import "ParentingStrategyDetailViewController.h"
#import "KTCWebViewController.h"

@interface FavourateViewController () <FavourateViewDelegate>

@property (weak, nonatomic) IBOutlet FavourateView *favourateView;

@property (nonatomic, strong) FavourateViewModel *viewModel;

@end

@implementation FavourateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationTitle = @"我的收藏";
    _pageIdentifier = @"pv_acct_favors";
    // Do any additional setup after loading the view from its nib.
    self.hidesBottomBarWhenPushed = YES;
    self.favourateView.delegate = self;
    
    self.viewModel = [[FavourateViewModel alloc] initWithView:self.favourateView];
    [self.favourateView startRefreshWithTag:FavourateViewSegmentTagService];
//    [self.viewModel startUpdateDataWithFavouratedTag:FavourateViewSegmentTagService];
}

#pragma mark FavourateViewDelegate

- (void)favourateView:(FavourateView *)favourateView didChangedSegmentSelectedIndexWithTag:(FavourateViewSegmentTag)tag {
    [self.viewModel resetResultWithFavouratedTag:tag];
}

- (void)favourateView:(FavourateView *)favourateView didSelectedAtIndex:(NSUInteger)index ofTag:(FavourateViewSegmentTag)tag {
    NSArray *array = [self.viewModel resultWithFavouratedTag:tag];
    switch (tag) {
        case FavourateViewSegmentTagService:
        {
            FavouriteServiceItemModel *model = [array objectAtIndex:index];
            ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:model.identifier channelId:model.channelId];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case FavourateViewSegmentTagStore:
        {
            FavouriteStoreItemModel *model = [array objectAtIndex:index];
            StoreDetailViewController *controller = [[StoreDetailViewController alloc] initWithStoreId:model.identifier];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case FavourateViewSegmentTagStrategy:
        {
            FavouriteStrategyItemModel *model = [array objectAtIndex:index];
            ParentingStrategyDetailViewController *controller = [[ParentingStrategyDetailViewController alloc] initWithStrategyIdentifier:model.identifier];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case FavourateViewSegmentTagNews:
        {
            FavouriteNewsItemModel *model = [array objectAtIndex:index];
            KTCWebViewController *controller = [[KTCWebViewController alloc] init];
            [controller setWebUrlString:model.linkUrlString];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)favourateView:(FavourateView *)favourateView needUpdateDataForTag:(FavourateViewSegmentTag)tag {
    [self.viewModel startUpdateDataWithFavouratedTag:tag];
}

- (void)favourateView:(FavourateView *)favourateView needLoadMoreDataForTag:(FavourateViewSegmentTag)tag {
    [self.viewModel getMoreDataWithFavouratedTag:tag];
}

- (void)favourateView:(FavourateView *)favourateView didDeleteIndex:(NSUInteger)index ofTag:(FavourateViewSegmentTag)tag {
    [self.viewModel deleteFavourateDataForTag:tag atInde:index];
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
