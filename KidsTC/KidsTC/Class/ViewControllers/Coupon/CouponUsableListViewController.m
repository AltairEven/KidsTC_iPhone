//
//  CouponUsableListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 9/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CouponUsableListViewController.h"
#import "KTCWebViewController.h"


static NSString *const kCouponUseRuleUrlString = @"http://m.kidstc.com/tools/coupon_desc";

@interface CouponUsableListViewController () <CouponUsableListViewDataSource, CouponUsableListViewDelegate>

@property (weak, nonatomic) IBOutlet CouponUsableListView *listView;

@property (nonatomic, strong) HttpRequestClient *checkUsableCouponRequest;

@property (nonatomic, strong) NSArray *couponModelsArray;

@property (nonatomic, assign) CouponBaseModel *selectedCoupon;

@end

@implementation CouponUsableListViewController

- (instancetype)initWithCouponModels:(NSArray *)modelsArray selectedCoupon:(CouponBaseModel *)coupon {
    self = [super initWithNibName:@"CouponUsableListViewController" bundle:nil];
    if (self) {
        self.couponModelsArray = [modelsArray copy];
        self.checkUsableCouponRequest = [HttpRequestClient clientWithUrlAliasName:@"COUPON_CHECK"];
        self.selectedCoupon = coupon;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"可用优惠券";
    // Do any additional setup after loading the view from its nib.
    self.listView.dataSource = self;
    self.listView.delegate = self;
    [self.listView reloadData];
    if (self.selectedCoupon) {
        NSInteger selectedIndex = -1;
        for (NSUInteger index = 0; index < [self.couponModelsArray count]; index ++) {
            CouponFullCutModel *model = [self.couponModelsArray objectAtIndex:index];
            if ([model.couponId isEqualToString:self.selectedCoupon.couponId]) {
                selectedIndex = index;
                break;
            }
        }
        if (selectedIndex >= 0) {
            [self.listView setIndex:selectedIndex selected:YES];
        }
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self setupRightBarButton:@"" target:self action:@selector(didClickedCouponRule) frontImage:@"phone1" andBackImage:@"phone2"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    __weak CouponUsableListViewController *weakSelf = self;
    if (self.dismissBlock) {
        weakSelf.dismissBlock(weakSelf.selectedCoupon);
    }
}

#pragma mark CouponUsableListViewDataSource & CouponUsableListViewDelegate

- (NSArray *)couponModelsOfCouponUsableListView:(CouponUsableListView *)listView {
    return self.couponModelsArray;
}

- (void)couponUsableListView:(CouponUsableListView *)listView didSelectedCouponAtIndex:(NSUInteger)index {
    CouponFullCutModel *model = [self.couponModelsArray objectAtIndex:index];
    NSDictionary *param = [NSDictionary dictionaryWithObject:model.couponId forKey:@"couponcode"];
    
    __weak CouponUsableListViewController *weakSelf = self;
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [weakSelf.checkUsableCouponRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        weakSelf.selectedCoupon = [weakSelf.couponModelsArray objectAtIndex:index];
        [weakSelf goBackController:nil];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        NSString *errMsg = @"该优惠券不可使用";
        if (error.userInfo) {
            NSString *tempErrMsg = [error.userInfo objectForKey:@"data"];
            if ([tempErrMsg isKindOfClass:[NSString class]] && [tempErrMsg length] > 0) {
                errMsg = tempErrMsg;
            }
        }
        [[iToast makeText:errMsg] show];
        [weakSelf.listView setIndex:index selected:NO];
    }];
}

- (void)couponUsableListView:(CouponUsableListView *)listView didDeselectedCouponAtIndex:(NSUInteger)index {
    self.selectedCoupon = nil;
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
