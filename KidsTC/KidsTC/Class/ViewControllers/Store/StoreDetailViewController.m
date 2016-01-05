//
//  StoreDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "StoreDetailViewModel.h"
#import "StoreDetailBottomView.h"
#import "Insurance.h"
#import "ActivityLogoItem.h"
#import "ServiceListItemModel.h"
#import "StoreListItemModel.h"
#import "StoreAppointmentViewController.h"
#import "ServiceDetailViewController.h"
#import "StoreListViewController.h"
#import "ServiceListViewController.h"
#import "CommentListViewController.h"
#import "StoreMoreDetailViewController.h"
#import "CommentFoundingViewController.h"
#import "KTCActionView.h"
#import "KTCSearchViewController.h"
#import "CommonShareViewController.h"
#import "KTCWebViewController.h"
#import "KTCBrowseHistoryView.h"
#import "KTCBrowseHistoryManager.h"
#import "KTCMapViewController.h"
#import "CommentDetailViewController.h"

@interface StoreDetailViewController () <StoreDetailViewDelegate, StoreDetailBottomViewDelegate, KTCActionViewDelegate, KTCBrowseHistoryViewDataSource, KTCBrowseHistoryViewDelegate, CommentFoundingViewControllerDelegate>

@property (weak, nonatomic) IBOutlet StoreDetailView *detailView;
@property (weak, nonatomic) IBOutlet StoreDetailBottomView *bottomView;

@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, strong) StoreDetailViewModel *viewModel;
- (void)buildRightBarButtons;

- (void)setupBottomView;


- (void)getHistoryDataForTag:(KTCBrowseHistoryViewTag)tag needMore:(BOOL)need;
- (void)showHistoryView;
- (void)showActionView;

@end

@implementation StoreDetailViewController

- (instancetype)initWithStoreId:(NSString *)storeId {
    self = [super initWithNibName:@"StoreDetailViewController" bundle:nil];
    if (self) {
        self.storeId = storeId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationTitle = @"门店详情";
    _pageIdentifier = @"pv_store_dtl";
    self.hidesBottomBarWhenPushed = YES;
    // Do any additional setup after loading the view from its nib.
    self.detailView.delegate = self;
    self.bottomView.delegate = self;
    
    self.viewModel = [[StoreDetailViewModel alloc] initWithView:self.detailView];
    __weak StoreDetailViewController *weakSelf = self;
    [self.viewModel setNetErrorBlock:^(NSError *error) {
        [weakSelf showConnectError:YES];
    }];
    [self buildRightBarButtons];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
    [self.viewModel stopUpdateData];
    [[KTCActionView actionView] hide];
    [[KTCBrowseHistoryView historyView] hide];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (showFirstTime) {
        [self reloadNetworkData];
    }
}

#pragma mark StoreDetailViewDelegate

- (void)didClickedCouponButtonOnStoreDetailView:(StoreDetailView *)detailView {
    KTCWebViewController * controller = [[KTCWebViewController alloc] init];
    [controller setHidesBottomBarWhenPushed:YES];
    [controller setWebUrlString:self.viewModel.detailModel.couponUrlString];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedTelephoneOnStoreDetailView:(StoreDetailView *)detailView {
    NSArray *numbers = [self.viewModel.detailModel phoneNumbersArray];
    if ([numbers count] <= 1) {
        NSString *telString = [NSString stringWithFormat:@"telprompt://%@",[self.viewModel.detailModel phoneNumber]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
    } else {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择需要拨打的号码" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *phoneNumber in numbers) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:phoneNumber style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *telString = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
                NSLog(@"%@", [NSURL URLWithString:telString]);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
            }];
            [controller addAction:action];
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)didClickedAddressOnStoreDetailView:(StoreDetailView *)detailView {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.viewModel.detailModel.storeCoordinate.latitude longitude:self.viewModel.detailModel.storeCoordinate.longitude];
    KTCLocation *destination = [[KTCLocation alloc] initWithLocation:location locationDescription:self.viewModel.detailModel.storeName];
    if (destination) {
        KTCMapViewController *controller = [[KTCMapViewController alloc] initWithMapType:KTCMapTypeStoreGuide destination:destination];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didClickedActiveOnStoreDetailView:(StoreDetailView *)detailView atIndex:(NSUInteger)index {
//    ActivityLogoItem *item = [self.viewModel.detailModel.activeModelsArray objectAtIndex:index];
//    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:item.itemDescription preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//    [controller addAction:action];
//    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didClickedAllHotRecommendOnStoreDetailView:(StoreDetailView *)detailView {
    
}

- (void)storeDetailView:(StoreDetailView *)detailView didSelectedHotRecommendAtIndex:(NSUInteger)index {
    StoreDetailHotRecommendModel *tuanModel = [self.viewModel.detailModel.hotRecommendServiceArray objectAtIndex:index];
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:tuanModel.serviceId channelId:tuanModel.channelId];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedMoreDetailOnStoreDetailView:(StoreDetailView *)detailView {
//    StoreMoreDetailViewController *controller = [[StoreMoreDetailViewController alloc] initWithStoreId:self.storeId];
//    [controller setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:controller animated:YES];
    
    KTCWebViewController *controller = [[KTCWebViewController alloc] init];
    [controller setWebUrlString:self.viewModel.detailModel.detailUrlString];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickedMoreReviewOnStoreDetailView:(StoreDetailView *)detailView {
    NSDictionary *commentNumberDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentAllNumber], CommentListTabNumberKeyAll,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentGoodNumber], CommentListTabNumberKeyGood,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentNormalNumber], CommentListTabNumberKeyNormal,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentBadNumber], CommentListTabNumberKeyBad,
                                      [NSNumber numberWithInteger:self.viewModel.detailModel.commentPictureNumber], CommentListTabNumberKeyPicture, nil];
    
    CommentListViewController *controller = [[CommentListViewController alloc] initWithIdentifier:self.storeId relationType:CommentRelationTypeStore commentNumberDic:commentNumberDic];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)storeDetailView:(StoreDetailView *)detailView didClickedReviewAtIndex:(NSUInteger)index {
    if ([self.viewModel.detailModel.commentItemsArray count] > 0) {
        CommentListItemModel *model = [self.viewModel.detailModel.commentItemsArray objectAtIndex:index];
        model.relationIdentifier = self.storeId;
        CommentDetailViewController *controller = [[CommentDetailViewController alloc] initWithSource:CommentDetailViewSourceServiceOrStore relationType:CommentRelationTypeStore headerModel:model];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [GToolUtil checkLogin:^(NSString *uid) {
            CommentFoundingViewController *controller = [[CommentFoundingViewController alloc] initWithCommentFoundingModel:[CommentFoundingModel modelFromStore:self.viewModel.detailModel]];
            controller.delegate = self;
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        } target:self];
    }
}

- (void)didClickedMoreBrothersStoreOnStoreDetailView:(StoreDetailView *)detailView {
    StoreListViewController *controller = [[StoreListViewController alloc] initWithStoreListItemModels:self.viewModel.detailModel.brotherStores];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)storeDetailView:(StoreDetailView *)detailView didClickedServiceAtIndex:(NSUInteger)index {
    StoreOwnedServiceModel *serviceModel = [self.viewModel.detailModel.serviceModelsArray objectAtIndex:index];
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:serviceModel.serviceId channelId:serviceModel.channelId];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
    //MTA
    [MTA trackCustomEvent:@"event_skip_store_servers_dtl" args:nil];
}


#pragma mark StoreDetailBottomViewDelegate

- (void)storeDetailBottomView:(StoreDetailBottomView *)bottomView didClickedButtonWithTag:(StoreDetailBottomSubviewTag)tag {
    switch (tag) {
        case StoreDetailBottomSubviewTagFavourate:
        {
            [GToolUtil checkLogin:^(NSString *uid) {
                __weak StoreDetailViewController *weakSelf = self;
                [weakSelf.viewModel addOrRemoveFavouriteWithSucceed:^(NSDictionary *data) {
                    [bottomView setFavourite:weakSelf.viewModel.detailModel.isFavourate];
                } failure:^(NSError *error) {
                    if ([[error userInfo] count] > 0) {
                        [[iToast makeText:[[error userInfo] objectForKey:@"data"]] show];
                    }
                }];
            } target:self];
        }
            break;
        case StoreDetailBottomSubviewTagComment:
        {
            [GToolUtil checkLogin:^(NSString *uid) {
                CommentFoundingViewController *controller = [[CommentFoundingViewController alloc] initWithCommentFoundingModel:[CommentFoundingModel modelFromStore:self.viewModel.detailModel]];
                controller.delegate = self;
                [controller setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:controller animated:YES];
            } target:self];
        }
            break;
        case StoreDetailBottomSubviewTagAppointment:
        {
            [GToolUtil checkLogin:^(NSString *uid) {
                StoreAppointmentViewController *controller = [StoreAppointmentViewController instanceWithStoreDetailModel:self.viewModel.detailModel];
                [self presentViewController:controller animated:YES completion:nil];
            } target:self];
        }
            break;
        default:
            break;
    }
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
            [MTA trackCustomEvent:@"event_skip_historys_dtl_store" args:nil];
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
            KTCSearchViewController *controller = [[KTCSearchViewController alloc] initWithSearchType:KTCSearchTypeStore];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case KTCActionViewTagShare:
        {
            CommonShareViewController *controller = [CommonShareViewController instanceWithShareObject:self.viewModel.detailModel.shareObject sourceType:KTCShareServiceTypeStore];
            
            [self presentViewController:controller animated:YES completion:nil] ;
        }
            break;
        default:
            break;
    }
}

#pragma mark CommentFoundingViewControllerDelegate

- (void)commentFoundingViewControllerDidFinishSubmitComment:(CommentFoundingViewController *)vc {
    [self reloadNetworkData];
}

#pragma mark Privated methods


- (void)setupBottomView {
    if ([[KTCUser currentUser] hasLogin]) {
        [self.bottomView setFavourite:self.viewModel.detailModel.isFavourate];
    }
    [self.bottomView.appointmentButton setEnabled:self.viewModel.detailModel.canAppoint];
    NSString *title = self.viewModel.detailModel.appointButtonTitle;
    if ([title length] == 0) {
        if (self.viewModel.detailModel.canAppoint) {
            title = @"预约门店";
        } else {
            title = @"暂停预约";
        }
    }
    [self.bottomView.appointmentButton setTitle:title forState:UIControlStateNormal];
    [self.bottomView.appointmentButton setTitle:title forState:UIControlStateHighlighted];
    [self.bottomView.appointmentButton setTitle:title forState:UIControlStateDisabled];
}

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
        [self getHistoryDataForTag:KTCBrowseHistoryViewTagStore needMore:NO];
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


#pragma mark Super methods

- (void)reloadNetworkData {
    [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view];
    [self.viewModel startUpdateDataWithStoreId:self.storeId succeed:^(NSDictionary *data) {
        [self.detailView reloadData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [self setupBottomView];
    } failure:^(NSError *error) {
        [self.detailView reloadData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
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
