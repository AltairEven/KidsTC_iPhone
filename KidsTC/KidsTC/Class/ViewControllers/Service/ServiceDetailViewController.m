//
//  ServiceDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/15/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "ServiceDetailViewModel.h"
#import "ServiceDetailBottomView.h"
#import "AppDelegate.h"
#import "Insurance.h"
#import "AUIPickerView.h"
#import "SettlementViewController.h"
#import "CommentListViewController.h"
#import "ServiceDetailConfirmView.h"
#import "KTCWebViewController.h"
#import "KTCActionView.h"
#import "CommonShareViewController.h"
#import "KTCSearchViewController.h"
#import "StoreDetailViewController.h"


@interface ServiceDetailViewController () <ServiceDetailViewDelegate, ServiceDetailBottomViewDelegate, ServiceDetailConfirmViewDelegate, KTCActionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailBGView;
@property (weak, nonatomic) IBOutlet ServiceDetailView *detailView;

@property (weak, nonatomic) IBOutlet ServiceDetailBottomView *bottomView;
@property (nonatomic, strong) AUIPickerView *pickerView;
@property (nonatomic, strong) ServiceDetailConfirmView *confirmView;

@property (nonatomic, copy) NSString *serviceId;
@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, strong) ServiceDetailViewModel *viewModel;

- (void)loadConfirmView;
- (void)setupBottomView;

- (void)goSettlement;

- (void)showActionView;

@end

@implementation ServiceDetailViewController

- (instancetype)initWithServiceId:(NSString *)serviceId channelId:(NSString *)channelId {
    self = [super initWithNibName:@"ServiceDetailViewController" bundle:nil];
    if (self) {
        self.serviceId = serviceId;
        self.channelId = channelId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navigationTitle = @"服务详情";
    
    self.detailView.delegate = self;
    
    self.bottomView.delegate = self;
    
    self.confirmView = [[ServiceDetailConfirmView alloc] init];
    self.confirmView.delegate = self;
    
    self.viewModel = [[ServiceDetailViewModel alloc] initWithView:self.detailView];
    __weak ServiceDetailViewController *weakSelf = self;
    [self.viewModel setNetErrorBlock:^(NSError *error) {
        [weakSelf showConnectError:YES];
    }];
    
    [self setupRightBarButton:nil target:self action:@selector(showActionView) frontImage:@"navigation_more" andBackImage:@"navigation_more"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (showFirstTime) {
        [self reloadNetworkData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
    [self.viewModel stopUpdateData];
    [[KTCActionView actionView] hide];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark ServiceDetailViewDelegate

- (void)didClickedCouponButtonOnServiceDetailView:(ServiceDetailView *)detailView {
    KTCWebViewController * controller = [[KTCWebViewController alloc] init];
    [controller setHidesBottomBarWhenPushed:YES];
    [controller setWebUrlString:self.viewModel.detailModel.couponUrlString];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)serviceDetailView:(ServiceDetailView *)detailView didChangedMoreInfoViewTag:(ServiceDetailMoreInfoViewTag)viewTag {
    [self.viewModel resetMoreInfoViewWithViewTag:viewTag];
}

- (void)serviceDetailView:(ServiceDetailView *)detailView didClickedStoreCellAtIndex:(NSUInteger)index {
    StoreListItemModel *model = [self.viewModel.detailModel.storeItemsArray objectAtIndex:index];
    StoreDetailViewController *controller = [[StoreDetailViewController alloc] initWithStoreId:model.identifier];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)serviceDetailView:(ServiceDetailView *)detailView didClickedCommentCellAtIndex:(NSUInteger)index {
    NSDictionary *commentNumberDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentAllNumber], CommentListTabNumberKeyAll,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentGoodNumber], CommentListTabNumberKeyGood,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentNormalNumber], CommentListTabNumberKeyNormal,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentBadNumber], CommentListTabNumberKeyBad,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentPictureNumber], CommentListTabNumberKeyPicture, nil];
    
    CommentListViewController *controller = [[CommentListViewController alloc] initWithIdentifier:self.serviceId relationType:(CommentRelationType)self.viewModel.detailModel.type commentNumberDic:commentNumberDic];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark ServiceDetailBottomViewDelegate

- (void)didClickedFavourateButtonOnServiceDetailBottomView:(ServiceDetailBottomView *)bottomView {
    [GToolUtil checkLogin:^(NSString *uid) {
        __weak ServiceDetailViewController *weakSelf = self;
        [weakSelf.viewModel addOrRemoveFavouriteWithSucceed:^(NSDictionary *data) {
            [bottomView setFavourite:weakSelf.viewModel.detailModel.isFavourate];
        } failure:^(NSError *error) {
            if ([[error userInfo] count] > 0) {
                [[iToast makeText:[[error userInfo] objectForKey:@"data"]] show];
            }
        }];
    } target:self];
}

- (void)didClickedCustomerServiceButtonOnServiceDetailBottomView:(ServiceDetailBottomView *)bottomView {
    if ([self.viewModel.detailModel.phoneNumber length] > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.viewModel.detailModel.phoneNumber]]];
    } else {
        [[iToast makeText:[NSString stringWithFormat:@"服务电话信息有误，如有疑问，请联系客服:%@", kCustomerServicePhoneNumber]] show];
    }
}

- (void)didClickedBuyButtonOnServiceDetailBottomView:(ServiceDetailBottomView *)bottomView {
    [self.confirmView show];
}

#pragma mark ServiceDetailConfirmViewDelegate

- (void)didClickedSubmitButtonWithBuyNumber:(NSUInteger)number selectedStore:(StoreListItemModel *)store {
    [GToolUtil checkLogin:^(NSString *uid) {
        __weak ServiceDetailViewController *weakSelf = self;
        [[GAlertLoadingView sharedAlertLoadingView] show];
        [weakSelf.viewModel addToSettlementWithBuyCount:number storeId:store.identifier succeed:^(NSDictionary *data) {
            [[GAlertLoadingView sharedAlertLoadingView] hide];
            [weakSelf goSettlement];
        } failure:^(NSError *error) {
            [[GAlertLoadingView sharedAlertLoadingView] hide];
            if ([[error userInfo] count] > 0) {
                [[iToast makeText:[[error userInfo] objectForKey:@"data"]] show];
            }
        }];
    } target:self];
}

#pragma mark KTCActionViewDelegate

- (void)actionViewDidClickedWithTag:(KTCActionViewTag)tag {
    [[KTCActionView actionView] hide];
    switch (tag) {
        case KTCActionViewTagHome:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[KTCTabBarController shareTabBarController] setSelectedIndex:KTCTabHome];
        }
            break;
        case KTCActionViewTagSearch:
        {
            KTCSearchViewController *controller = [[KTCSearchViewController alloc] initWithSearchType:KTCSearchTypeService];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case KTCActionViewTagShare:
        {
            CommonShareObject *shareObject = [CommonShareObject shareObjectWithTitle:self.viewModel.detailModel.serviceName description:[NSString stringWithFormat:@"【童成网】推荐：%@", self.viewModel.detailModel.serviceName] thumbImage:[UIImage imageNamed:@"userCenter_defaultFace_boy"] urlString:@"www.kidstc.com"];
            shareObject.identifier = self.serviceId;
            shareObject.followingContent = @"【童成网】";
            CommonShareViewController *controller = [CommonShareViewController instanceWithShareObject:shareObject];
            
            [self presentViewController:controller animated:YES completion:nil] ;
        }
            break;
        default:
            break;
    }
}

#pragma mark Private methods

- (void)loadConfirmView {
    [self.confirmView setStockNumber:self.viewModel.detailModel.stockNumber];
    [self.confirmView setUnitPrice:self.viewModel.detailModel.price];
    [self.confirmView setMinBuyCount:self.viewModel.detailModel.minLimit maxBuyCount:self.viewModel.detailModel.maxLimit];
    [self.confirmView setStoreItemsArray:self.viewModel.detailModel.storeItemsArray];
}

- (void)setupBottomView {
    if ([[KTCUser currentUser] hasLogin]) {
        [self.bottomView setFavourite:self.viewModel.detailModel.isFavourate];
    }
    if (self.viewModel.detailModel.stockNumber == 0) {
        [self.bottomView.buyButton setEnabled:NO];
    } else {
        [self.bottomView.buyButton setEnabled:YES];
    }
}


- (void)goSettlement {
    [GToolUtil checkLogin:^(NSString *uid) {
        SettlementViewController *controller = [[SettlementViewController alloc] initWithNibName:@"SettlementViewController" bundle:nil];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    } target:self];
}

- (void)showActionView {
    if ([[KTCActionView actionView] isShowing]) {
        [[KTCActionView actionView] hide];
        [[KTCActionView actionView] setDelegate:nil];
    } else {
        [[KTCActionView actionView] showInViewController:self];
        [[KTCActionView actionView] setDelegate:self];
    }
}

#pragma mark Super method

- (void)reloadNetworkData {
    [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view];
    __weak ServiceDetailViewController *weakSelf = self;
    [self.viewModel startUpdateDataWithServiceId:self.serviceId channelId:self.channelId Succeed:^(NSDictionary *data) {
        [weakSelf.detailView reloadData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf loadConfirmView];
        [weakSelf setupBottomView];
    } failure:^(NSError *error) {
        [weakSelf.detailView reloadData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

- (void)dealloc {
    
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
