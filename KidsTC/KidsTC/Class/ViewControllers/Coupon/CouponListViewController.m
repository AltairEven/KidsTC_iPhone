//
//  CouponListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 9/6/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponListViewModel.h"

@interface CouponListViewController () <CouponListViewDelegate>

@property (weak, nonatomic) IBOutlet CouponListView *listView;

@property (nonatomic, strong) CouponListViewModel *viewModel;

@end

@implementation CouponListViewController

- (void)viewDidLoad {
    _navigationTitle = @"优惠券";
    // Do any additional setup after loading the view from its nib.
    self.listView.delegate = self;
    self.viewModel = [[CouponListViewModel alloc] initWithView:self.listView];
    [self.viewModel startUpdateDataWithViewTag:CouponListViewTagUnused];
    [self.listView reloadSegmentHeader];
}

#pragma mark CouponListViewDelegate

- (void)couponListView:(CouponListView *)listView willShowWithTag:(CouponListViewTag)tag {
    [self.viewModel resetResultWithViewTag:tag];
}

- (void)couponListView:(CouponListView *)listView DidPullDownToRefreshforViewTag:(CouponListViewTag)tag {
    [self.viewModel startUpdateDataWithViewTag:tag];
}

- (void)couponListView:(CouponListView *)listView DidPullUpToLoadMoreforViewTag:(CouponListViewTag)tag {
    [self.viewModel getMoreDataWithViewTag:tag];
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
