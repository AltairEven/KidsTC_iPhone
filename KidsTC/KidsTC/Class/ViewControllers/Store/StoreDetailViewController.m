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
#import "ActiveModel.h"
#import "ServiceListItemModel.h"
#import "StoreListItemModel.h"
#import "StoreAppointmentViewController.h"
#import "ServiceDetailViewController.h"
#import "StoreListViewController.h"
#import "ServiceListViewController.h"
#import "CommentListViewController.h"
#import "StoreMoreDetailViewController.h"
#import "OrderCommentViewController.h"
#import "KTCActionView.h"
#import "KTCSearchViewController.h"
#import "CommonShareViewController.h"

@interface StoreDetailViewController () <StoreDetailViewDelegate, StoreDetailBottomViewDelegate, KTCActionViewDelegate>

@property (weak, nonatomic) IBOutlet StoreDetailView *detailView;
@property (weak, nonatomic) IBOutlet StoreDetailBottomView *bottomView;

@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, strong) StoreDetailViewModel *viewModel;

- (void)setupBottomView;

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
    self.hidesBottomBarWhenPushed = YES;
    // Do any additional setup after loading the view from its nib.
    self.detailView.delegate = self;
    self.bottomView.delegate = self;
    
    self.viewModel = [[StoreDetailViewModel alloc] initWithView:self.detailView];
    __weak StoreDetailViewController *weakSelf = self;
    [self.viewModel setNetErrorBlock:^(NSError *error) {
        [weakSelf showConnectError:YES];
    }];
    
    
    [self setupRightBarButton:nil target:self action:@selector(showActionView) frontImage:@"navigation_more" andBackImage:@"navigation_more"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
    [self.viewModel stopUpdateData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (showFirstTime) {
        [self reloadNetworkData];
    }
}

#pragma mark StoreDetailViewDelegate

- (void)didClickedTelephoneOnStoreDetailView:(StoreDetailView *)detailView {
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@",[self.viewModel.detailModel phoneNumber]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

- (void)didClickedAddressOnStoreDetailView:(StoreDetailView *)detailView {
    NSLog(@"Clicked Address");
}

- (void)didClickedActiveOnStoreDetailView:(StoreDetailView *)detailView atIndex:(NSUInteger)index {
    
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
    StoreMoreDetailViewController *controller = [[StoreMoreDetailViewController alloc] initWithStoreId:self.storeId];
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
                OrderCommentViewController *controller = [[OrderCommentViewController alloc] initWithOrderCommentModel:[OrderCommentModel modelFromStore:self.viewModel.detailModel]];
                [controller setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:controller animated:YES];
            } target:self];
        }
            break;
        case StoreDetailBottomSubviewTagAppointment:
        {
            [GToolUtil checkLogin:^(NSString *uid) {
                StoreAppointmentViewController *controller = [[StoreAppointmentViewController alloc] initWithStoreDetailModel:self.viewModel.detailModel];
                [controller setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:controller animated:YES];
            } target:self];
        }
            break;
        default:
            break;
    }
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
            KTCSearchViewController *controller = [[KTCSearchViewController alloc] initWithNibName:@"KTCSearchViewController" bundle:nil];
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case KTCActionViewTagShare:
        {
            CommonShareObject *shareObject = [CommonShareObject shareObjectWithTitle:self.viewModel.detailModel.storeName description:[NSString stringWithFormat:@"【童成网】推荐：%@", self.viewModel.detailModel.storeName] thumbImage:[UIImage imageNamed:@"userCenter_defaultFace_boy"] urlString:@"www.kidstc.com"];
            shareObject.identifier = self.storeId;
            shareObject.followingContent = @"【童成网】";
            CommonShareViewController *controller = [CommonShareViewController instanceWithShareObject:shareObject];
            
            [self presentViewController:controller animated:YES completion:nil] ;
        }
            break;
        default:
            break;
    }
}

#pragma mark Privated methods


- (void)setupBottomView {
    if ([[KTCUser currentUser] hasLogin]) {
        [self.bottomView setFavourite:self.viewModel.detailModel.isFavourate];
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
