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
#import "KTCBrowseHistoryView.h"
#import "KTCBrowseHistoryManager.h"


@interface ServiceDetailViewController () <ServiceDetailViewDelegate, ServiceDetailBottomViewDelegate, ServiceDetailConfirmViewDelegate, KTCActionViewDelegate, KTCBrowseHistoryViewDataSource, KTCBrowseHistoryViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailBGView;
@property (weak, nonatomic) IBOutlet ServiceDetailView *detailView;

@property (weak, nonatomic) IBOutlet ServiceDetailBottomView *bottomView;
@property (nonatomic, strong) AUIPickerView *pickerView;
@property (nonatomic, strong) ServiceDetailConfirmView *confirmView;

@property (nonatomic, copy) NSString *serviceId;
@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, strong) ServiceDetailViewModel *viewModel;

- (void)buildRightBarButtons;

- (void)loadConfirmView;
- (void)setupBottomView;

- (void)goSettlement;

- (void)getHistoryDataForTag:(KTCBrowseHistoryViewTag)tag needMore:(BOOL)need;
- (void)showHistoryView;
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
    
    [self buildRightBarButtons];
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
    [[KTCBrowseHistoryView historyView] hide];
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

#pragma mark KTCBrowseHistoryViewDataSource & KTCBrowseHistoryViewDelegate

- (NSString *)titleForBrowseHistoryView:(KTCBrowseHistoryView *)view withTag:(KTCBrowseHistoryViewTag)tag {
    NSString *title = @"浏览足迹";
    if (![[KTCUser currentUser] hasLogin]) {
        title = @"尚未登录";
    }
    return title;
}

- (NSArray *)itemModelsForBrowseHistoryView:(KTCBrowseHistoryView *)view withTag:(KTCBrowseHistoryViewTag)tag {
    KTCBrowseHistoryType type = [KTCBrowseHistoryView typeOfViewTag:tag];
    NSArray *array = [[KTCBrowseHistoryManager sharedManager] resultForType:type];
    return [NSArray arrayWithArray:array];
}

- (void)browseHistoryView:(KTCBrowseHistoryView *)view didChangedTag:(KTCBrowseHistoryViewTag)tag {
    [self getHistoryDataForTag:tag needMore:NO];
}

- (void)browseHistoryView:(KTCBrowseHistoryView *)view didPulledUpToloadMoreForTag:(KTCBrowseHistoryViewTag)tag {
    [self getHistoryDataForTag:tag needMore:YES];
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

- (void)buildRightBarButtons {
    CGFloat buttonWidth = 28;
    CGFloat buttonHeight = 28;
    CGFloat buttonGap = 15;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth * 2 + buttonGap, buttonHeight)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat xPosition = 0;
    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyButton setFrame:CGRectMake(xPosition, 0, buttonWidth, buttonHeight)];
    [historyButton setBackgroundColor:[UIColor clearColor]];
    [historyButton setImage:[UIImage imageNamed:@"navigation_sort"] forState:UIControlStateNormal];
    [historyButton setImage:[UIImage imageNamed:@"navigation_sort"] forState:UIControlStateHighlighted];
    [historyButton addTarget:self action:@selector(showHistoryView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:historyButton];
    
    xPosition += buttonWidth + buttonGap;
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(xPosition, 0, buttonWidth, buttonHeight)];
    [shareButton setBackgroundColor:[UIColor clearColor]];
    [shareButton setImage:[UIImage imageNamed:@"navigation_more"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(showActionView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:shareButton];
    
    UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    self.navigationItem.rightBarButtonItem = rItem;
}

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

- (void)getHistoryDataForTag:(KTCBrowseHistoryViewTag)tag needMore:(BOOL)need {
    KTCBrowseHistoryType type = [KTCBrowseHistoryView typeOfViewTag:tag];
    NSArray *array = [[KTCBrowseHistoryManager sharedManager] resultForType:type];
    if ([array count] == 0) {
        [[KTCBrowseHistoryManager sharedManager] getUserBrowseHistoryWithType:type needMore:NO succeed:^(NSArray *modelsArray) {
            [[KTCBrowseHistoryView historyView] reloadDataForTag:tag];
            [[KTCBrowseHistoryView historyView] startLoadingAnimation:NO];
        } failure:^(NSError *error) {
            [[KTCBrowseHistoryView historyView] reloadDataForTag:tag];
            [[KTCBrowseHistoryView historyView] startLoadingAnimation:NO];
        }];
    } else if (need){
        [[KTCBrowseHistoryManager sharedManager] getUserBrowseHistoryWithType:type needMore:YES succeed:^(NSArray *modelsArray) {
            [[KTCBrowseHistoryView historyView] reloadDataForTag:tag];
            [[KTCBrowseHistoryView historyView] startLoadingAnimation:NO];
        } failure:^(NSError *error) {
            [[KTCBrowseHistoryView historyView] reloadDataForTag:tag];
            [[KTCBrowseHistoryView historyView] startLoadingAnimation:NO];
        }];
    } else {
        [[KTCBrowseHistoryView historyView] reloadDataForTag:tag];
        [[KTCBrowseHistoryView historyView] startLoadingAnimation:NO];
    }
}

- (void)showHistoryView {
    if ([[KTCBrowseHistoryView historyView] isShowing]) {
        [[KTCBrowseHistoryView historyView] startLoadingAnimation:NO];
        [[KTCBrowseHistoryView historyView] setDelegate:nil];
        [[KTCBrowseHistoryView historyView] setDataSource:nil];
        [[KTCBrowseHistoryView historyView] hide];
    } else {
        [[KTCBrowseHistoryView historyView] startLoadingAnimation:YES];
        [[KTCBrowseHistoryView historyView] setDelegate:self];
        [[KTCBrowseHistoryView historyView] setDataSource:self];
        [[KTCBrowseHistoryView historyView] showInViewController:self];
        [self getHistoryDataForTag:KTCBrowseHistoryViewTagService needMore:NO];
    }
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
