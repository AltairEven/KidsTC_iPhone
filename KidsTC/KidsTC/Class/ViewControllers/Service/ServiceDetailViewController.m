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
#import "CommentDetailViewController.h"
#import "ServiceDetailConfirmView.h"
#import "KTCWebViewController.h"
#import "KTCActionView.h"
#import "CommonShareViewController.h"
#import "KTCSearchViewController.h"
#import "StoreDetailViewController.h"
#import "KTCBrowseHistoryView.h"
#import "KTCBrowseHistoryManager.h"
#import "OnlineCustomerService.h"
#import "KTCSegueMaster.h"
#import "KTCStoreMapViewController.h"
#import "ServiceDetailRelatedServiceListViewController.h"


@interface ServiceDetailViewController () <ServiceDetailViewDelegate, ServiceDetailBottomViewDelegate, ServiceDetailConfirmViewDelegate, KTCActionViewDelegate, KTCBrowseHistoryViewDataSource, KTCBrowseHistoryViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailBGView;
@property (weak, nonatomic) IBOutlet ServiceDetailView *detailView;

@property (weak, nonatomic) IBOutlet ServiceDetailBottomView *bottomView;
@property (nonatomic, strong) AUIPickerView *pickerView;
@property (nonatomic, strong) ServiceDetailConfirmView *confirmView;

@property (nonatomic, copy) NSString *serviceId;
@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, strong) ServiceDetailViewModel *viewModel;

@property (nonatomic, strong) ATCountDown *countdownTimer;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UIView *countdownBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countdownBGHeight;
@property (weak, nonatomic) IBOutlet UIView *gapView;

- (void)buildRightBarButtons;
- (void)resetTitle;

- (void)loadConfirmView;
- (void)setupBottomView;

- (void)goSettlement;

- (void)getHistoryDataForTag:(KTCBrowseHistoryViewTag)tag needMore:(BOOL)need;
- (void)showHistoryView;
- (void)showActionView;

- (void)buildCountDownView;
- (void)startCountDown;
- (void)stopCountDown;
- (void)hideCountdown:(BOOL)hide;

//cs

- (void)makePhoneCallWithNumbers:(NSArray *)numbers;

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
    _pageIdentifier = @"pv_server_dtl";
    
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
    [self buildCountDownView];
    
    [self.bottomView setHidden:YES];
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

- (void)dealloc {
    [self stopCountDown];
}

#pragma mark ServiceDetailViewDelegate

- (void)didClickedCouponOnServiceDetailView:(ServiceDetailView *)detailView {
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
    //MTA
    [MTA trackCustomEvent:@"event_skip_server_stores_dtl" args:nil];
}

- (void)serviceDetailView:(ServiceDetailView *)detailView didClickedCommentCellAtIndex:(NSUInteger)index {
    CommentListItemModel *model = [self.viewModel.detailModel.commentItemsArray objectAtIndex:index];
    model.relationIdentifier = self.serviceId;
    CommentDetailViewController *controller = [[CommentDetailViewController alloc] initWithSource:CommentDetailViewSourceServiceOrStore relationType:self.viewModel.detailModel.relationType headerModel:model];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didClickedMoreCommentOnServiceDetailView:(ServiceDetailView *)detailView {
    NSDictionary *commentNumberDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentAllNumber], CommentListTabNumberKeyAll,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentGoodNumber], CommentListTabNumberKeyGood,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentNormalNumber], CommentListTabNumberKeyNormal,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentBadNumber], CommentListTabNumberKeyBad,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentPictureNumber], CommentListTabNumberKeyPicture, nil];
    
    CommentListViewController *controller = [[CommentListViewController alloc] initWithIdentifier:self.serviceId relationType:self.viewModel.detailModel.relationType commentNumberDic:commentNumberDic];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)serviceDetailView:(ServiceDetailView *)detailView didScrolledAtOffset:(CGPoint)offset {
}


- (void)serviceDetailView:(ServiceDetailView *)detailView didSelectedLinkWithSegueModel:(HomeSegueModel *)model {
    [KTCSegueMaster makeSegueWithModel:model fromController:self];
}

- (void)didClickedStoreBriefOnServiceDetailView:(ServiceDetailView *)detailView {
    KTCStoreMapViewController *controller = [[KTCStoreMapViewController alloc] initWithStoreItems:self.viewModel.detailModel.storeItemsArray];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedAllRelatedServiceOnServiceDetailView:(ServiceDetailView *)detailView {
    ServiceDetailRelatedServiceListViewController *controller = [[ServiceDetailRelatedServiceListViewController alloc] initWithListItemModels:self.viewModel.detailModel.moreServiceItems];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)serviceDetailView:(ServiceDetailView *)detailView didSelectedRelatedServiceAtIndex:(NSUInteger)index {
    ServiceMoreDetailHotSalesItemModel *model = [self.viewModel.detailModel.moreServiceItems objectAtIndex:index];
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:model.serviceId channelId:model.channelId];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark ServiceDetailBottomViewDelegate

- (void)didClickedCustomerServiceButtonOnServiceDetailBottomView:(ServiceDetailBottomView *)bottomView {
    KTCWebViewController *controller = [[KTCWebViewController alloc] init];
    [controller setHideShare:YES];
    [controller setWebUrlString:[OnlineCustomerService onlineCustomerServiceLinkUrlString]];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedPhoneButtonOnServiceDetailBottomView:(ServiceDetailBottomView *)bottomView {
    if ([[self.viewModel.detailModel phoneItems] count] > 0) {
        //telprompt
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择门店" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        for (ServiceDetailPhoneItem *item in self.viewModel.detailModel.phoneItems) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:item.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self makePhoneCallWithNumbers:item.phoneNumbers];
            }];
            [controller addAction:action];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:cancelAction];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

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
            //MTA
            NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"result", nil];
            [MTA trackCustomKeyValueEvent:@"event_result_server_addtocart" props:trackParam];
        } failure:^(NSError *error) {
            [[GAlertLoadingView sharedAlertLoadingView] hide];
            if ([[error userInfo] count] > 0) {
                [[iToast makeText:[[error userInfo] objectForKey:@"data"]] show];
            }
            //MTA
            NSDictionary *trackParam = [NSDictionary dictionaryWithObjectsAndKeys:@"false", @"result", nil];
            [MTA trackCustomKeyValueEvent:@"event_result_server_addtocart" props:trackParam];
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
    if ([[KTCUser currentUser] hasLogin]) {
        KTCBrowseHistoryType type = [KTCBrowseHistoryView typeOfViewTag:tag];
        NSArray *array = [[KTCBrowseHistoryManager sharedManager] resultForType:type];
        return [NSArray arrayWithArray:array];
    }
    return nil;
}

- (void)browseHistoryView:(KTCBrowseHistoryView *)view didSelectedItemAtIndex:(NSUInteger)index {
    KTCBrowseHistoryType type = [KTCBrowseHistoryView typeOfViewTag:view.currentTag];
    NSArray *array = [[KTCBrowseHistoryManager sharedManager] resultForType:type];
    switch (type) {
        case KTCBrowseHistoryTypeService:
        {
            BrowseHistoryServiceListItemModel *model = [array objectAtIndex:index];
            ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:model.identifier channelId:model.channelId];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
            //MTA
            [MTA trackCustomEvent:@"event_skip_historys_dtl_service" args:nil];
        }
            break;
        case KTCBrowseHistoryTypeStore:
        {
            BrowseHistoryStoreListItemModel *model = [array objectAtIndex:index];
            StoreDetailViewController *controller = [[StoreDetailViewController alloc] initWithStoreId:model.identifier];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
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
            [[KTCTabBarController shareTabBarController] setSelectedIndex:0];
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
            CommonShareViewController *controller = [CommonShareViewController instanceWithShareObject:self.viewModel.detailModel.shareObject sourceType:KTCShareServiceTypeService];
            
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
    [historyButton setImage:[UIImage imageNamed:@"navigation_time"] forState:UIControlStateNormal];
    [historyButton setImage:[UIImage imageNamed:@"navigation_time"] forState:UIControlStateHighlighted];
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

- (void)resetTitle {
    _navigationTitle = self.viewModel.detailModel.serviceBriefName;
    self.navigationItem.title = _navigationTitle;
}

- (void)loadConfirmView {
    [self.confirmView setStockNumber:self.viewModel.detailModel.stockNumber];
    [self.confirmView setUnitPrice:self.viewModel.detailModel.currentPrice];
    [self.confirmView setMinBuyCount:self.viewModel.detailModel.minLimit maxBuyCount:self.viewModel.detailModel.maxLimit];
    [self.confirmView setStoreItemsArray:self.viewModel.detailModel.storeItemsArray];
}

- (void)setupBottomView {
    if (self.viewModel.detailModel) {
        [self.bottomView setHidden:NO];
    } else {
        [self.bottomView setHidden:YES];
    }
    
    if ([[KTCUser currentUser] hasLogin]) {
        [self.bottomView setFavourite:self.viewModel.detailModel.isFavourate];
    }
    [self.bottomView.buyButton setEnabled:self.viewModel.detailModel.canBuy];
    NSString *title = self.viewModel.detailModel.buyButtonTitle;
    if ([title length] == 0) {
        if (self.viewModel.detailModel.canBuy) {
            title = @"立即购买";
        } else {
            title = @"暂不销售";
        }
    }
    [self.bottomView.buyButton setTitle:title forState:UIControlStateNormal];
    [self.bottomView.buyButton setTitle:title forState:UIControlStateHighlighted];
    [self.bottomView.buyButton setTitle:title forState:UIControlStateDisabled];
    if ([self.viewModel.detailModel showCountdown]) {
        [self hideCountdown:NO];
        [self startCountDown];
    } else {
        [self stopCountDown];
        [self hideCountdown:YES];
    }
    
    [self.bottomView setCustomerServiceButtonHidden:![OnlineCustomerService serviceIsOnline]];
    [self.bottomView setPhoneButtonHidden:!([self.viewModel.detailModel.phoneItems count] > 0)];
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
    [[KTCBrowseHistoryView historyView] endLoadMore];
    NSArray *array = [[KTCBrowseHistoryManager sharedManager] resultForType:type];
    if ([array count] == 0) {
        [[KTCBrowseHistoryManager sharedManager] getUserBrowseHistoryWithType:type needMore:NO succeed:^(NSArray *modelsArray) {
            [[KTCBrowseHistoryView historyView] reloadDataForTag:tag];
            [[KTCBrowseHistoryView historyView] startLoadingAnimation:NO];
            [[KTCBrowseHistoryView historyView] noMoreData:NO forTag:tag];
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
            [[KTCBrowseHistoryView historyView] noMoreData:YES forTag:tag];
        }];
    } else {
        [[KTCBrowseHistoryView historyView] reloadDataForTag:tag];
        [[KTCBrowseHistoryView historyView] startLoadingAnimation:NO];
    }
}

- (void)showHistoryView {
    [[KTCActionView actionView] hide];
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
    [[KTCBrowseHistoryView historyView] hide];
    if ([[KTCActionView actionView] isShowing]) {
        [[KTCActionView actionView] hide];
        [[KTCActionView actionView] setDelegate:nil];
    } else {
        [[KTCActionView actionView] showInViewController:self];
        [[KTCActionView actionView] setDelegate:self];
    }
}

- (void)buildCountDownView {
    [self.label1 setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [self.gapView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [GConfig resetLineView:self.gapView withLayoutAttribute:NSLayoutAttributeWidth];
    [self.countdownLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [self hideCountdown:YES];
}

- (void)startCountDown {
    if (!self.countdownTimer) {
        self.countdownTimer = [[ATCountDown alloc] initWithLeftTimeInterval:self.viewModel.detailModel.countdownTime];
    }
    __weak ServiceDetailViewController *weakSelf = self;
    [weakSelf.countdownTimer startCountDownWithCurrentTimeLeft:^(NSTimeInterval currentTimeLeft) {
        NSString *string = [GToolUtil countDownTimeStringWithLeftTime:currentTimeLeft];
        [weakSelf.countdownLabel setText:string];
    } completion:^{
        [weakSelf stopCountDown];
        [weakSelf reloadNetworkData];
    }];
}

- (void)stopCountDown {
    if (!self.countdownTimer) {
        return;
    }
    [self.countdownTimer stopCountDown];
    self.countdownTimer = nil;
}

- (void)hideCountdown:(BOOL)hide {
    if (hide) {
        [self.countdownBGView setHidden:YES];
        self.countdownBGHeight.constant = 0;
    } else {
        [self.countdownBGView setHidden:NO];
        self.countdownBGHeight.constant = 30;
    }
}

- (void)makePhoneCallWithNumbers:(NSArray *)numbers {
    if (!numbers || ![numbers isKindOfClass:[NSArray class]]) {
        return;
    }
    if ([numbers count] == 0) {
        return;
    } else if ([numbers count] == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [numbers firstObject]]]];
    } else {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择联系电话" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *phoneNumber in numbers) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:phoneNumber style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]]];
            }];
            [controller addAction:action];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:cancelAction];
        [self presentViewController:controller animated:YES completion:nil];
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
        [weakSelf resetTitle];
    } failure:^(NSError *error) {
        [weakSelf.detailView reloadData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf resetTitle];
    }];
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
