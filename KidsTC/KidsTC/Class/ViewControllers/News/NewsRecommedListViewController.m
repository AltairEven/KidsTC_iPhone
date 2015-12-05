//
//  NewsRecommedListViewController.m
//  KidsTC
//
//  Created by Altair on 12/5/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsRecommedListViewController.h"
#import "NewsRecommendListViewModel.h"
#import "KTCWebViewController.h"

@interface NewsRecommedListViewController () <NewsRecommendListViewDelegate>

@property (weak, nonatomic) IBOutlet NewsRecommendListView *listView;

@property (nonatomic, strong) NewsRecommendListViewModel *viewModel;

@end

@implementation NewsRecommedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"推荐";
    // Do any additional setup after loading the view from its nib.
    self.listView.delegate = self;
    self.viewModel = [[NewsRecommendListViewModel alloc] initWithView:self.listView];
    [self.viewModel startUpdateDataWithSucceed:nil failure:nil];
}

#pragma mark NewsRecommendListViewDelegate

- (void)newsRecommendListView:(NewsRecommendListView *)listView didSelectedCellItem:(NewsListItemModel *)item {
    KTCWebViewController *controller = [[KTCWebViewController alloc] init];
    [controller setWebUrlString:item.linkUrl];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)newsRecommendListViewDidPulledToloadMore:(NewsRecommendListView *)listView {
    [self.viewModel getMoreRecommendNewsWithSucceed:nil failure:nil];
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
