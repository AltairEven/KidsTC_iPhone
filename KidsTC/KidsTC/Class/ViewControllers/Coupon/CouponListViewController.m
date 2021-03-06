//
//  CouponListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 9/6/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CouponListViewController.h"
#import "KTCWebViewController.h"
#import "CouponUsableServiceViewController.h"

static NSString *const kCouponUseRuleUrlString = @"http://m.kidstc.com/tools/coupon_desc";

@interface CouponListViewController () <CouponListViewDelegate>

@property (weak, nonatomic) IBOutlet CouponListView *listView;

@property (nonatomic, strong) CouponListViewModel *viewModel;

@property (nonatomic, assign) CouponListViewTag firstLoadViewTag;

- (void)didClickedCouponRule;

@end

@implementation CouponListViewController

- (instancetype)initWithCouponListViewTag:(CouponListViewTag)tag {
    self = [super initWithNibName:@"CouponListViewController" bundle:nil];
    if (self) {
        self.firstLoadViewTag = tag;
    }
    return self;
}

- (void)viewDidLoad {
    _navigationTitle = @"优惠券";
    _pageIdentifier = @"pv_coupons";
    // Do any additional setup after loading the view from its nib.
    self.listView.delegate = self;
    self.viewModel = [[CouponListViewModel alloc] initWithView:self.listView];
    [self.listView setViewTag:self.firstLoadViewTag];
    [self.viewModel startUpdateDataWithViewTag:self.firstLoadViewTag];
    [self.listView reloadSegmentHeader];
    [self setupRightBarButton:@"" target:self action:@selector(didClickedCouponRule) frontImage:@"navigation_question" andBackImage:@"navigation_question"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
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

- (void)couponListView:(CouponListView *)listView didSelectedAtIndex:(NSUInteger)index ofViewTag:(CouponListViewTag)tag {
    NSArray *coupons = [self.viewModel resultOfCurrentViewTag];
    if ([coupons count] > index) {
        CouponFullCutModel *model = [coupons objectAtIndex:index];
        if (model.hasRelatedService) {
            CouponUsableServiceViewController *controller = [[CouponUsableServiceViewController alloc] initWithCouponBatchIdentifier:model.batchId];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
            //MTA
            [MTA trackCustomEvent:@"event_skip_coupon_prods" args:nil];
        }
    }
}

#pragma mark Private

- (void)didClickedCouponRule {
    KTCWebViewController *controller = [[KTCWebViewController alloc] init];
    [controller setWebUrlString:kCouponUseRuleUrlString];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
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
