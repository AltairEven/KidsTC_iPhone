//
//  ServiceDetailViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/15/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "ServiceDetailViewModel.h"
#import "ServiceMoreDetailViewController.h"
#import "ServiceDetailBottomView.h"
#import "AUIStairsController.h"
#import "AppDelegate.h"
#import "Insurance.h"
#import "AUIPickerView.h"
#import "SettlementViewController.h"
#import "CommentListViewController.h"
#import "ServiceDetailConfirmView.h"
#import "ServiceMoreDetailView.h"


@interface ServiceDetailViewController () <ServiceDetailViewDelegate, AUIPickerViewDataSource, AUIPickerViewDelegate, ServiceDetailBottomViewDelegate, ServiceDetailConfirmViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailBGView;
@property (weak, nonatomic) IBOutlet ServiceDetailView *detailView;

@property (weak, nonatomic) IBOutlet ServiceDetailBottomView *bottomView;
@property (nonatomic, strong) AUIPickerView *pickerView;
@property (nonatomic, strong) ServiceDetailConfirmView *confirmView;

@property (nonatomic, strong) AUIStairsController *stairsController;

@property (nonatomic, strong) ServiceMoreDetailViewController *moreDetailViewController;

@property (nonatomic, copy) NSString *serviceId;
@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, strong) ServiceDetailViewModel *viewModel;

- (void)createStairsVC;
- (void)loadConfirmView;
- (void)setupBottomView;

- (void)goSettlement;

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
    
    self.pickerView = [[AUIPickerView alloc] initWithDataSource:self delegate:self];
    
    self.bottomView.delegate = self;
    
    self.confirmView = [[ServiceDetailConfirmView alloc] init];
    self.confirmView.delegate = self;
    
    self.viewModel = [[ServiceDetailViewModel alloc] initWithView:self.detailView];
    __weak ServiceDetailViewController *weakSelf = self;
    [self.viewModel setNetErrorBlock:^(NSError *error) {
        [weakSelf showConnectError:YES];
    }];
    [self reloadNetworkData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark ServiceDetailViewDelegate

- (void)didPulledAtFooterViewOnServiceDetailView:(ServiceDetailView *)detailView {
    id nextView = [self.stairsController.views lastObject];
    if (nextView) {
        [self.stairsController goDownstairsToView:nextView animated:YES completion:^{
            
        }];
    } else  {
        [self createStairsVC];
        nextView = [self.stairsController.views lastObject];
        [self.stairsController goDownstairsToView:nextView animated:YES completion:^{
            
        }];
    }
}

- (void)didClickedGoIntoStoreButton {
    
}

- (void)didClickedMoreStoresButton {
    [self.pickerView show];
}

- (void)didClickedCheckReviewsButton {
    CommentListViewController *controller = [[CommentListViewController alloc] initWithIdentifier:self.serviceId object:KTCCommentObjectService];
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

#pragma mark UIPickerViewDataSource & UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(AUIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(AUIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.viewModel.detailModel.storeItemsArray count];
}

- (NSString *)pickerView:(AUIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    ServiceOwnerStoreModel *model = [self.viewModel.detailModel.storeItemsArray objectAtIndex:row];
    return model.storeName;
}

- (void)didCanceledPickerView:(AUIPickerView *)pickerView {
    
}

- (void)pickerView:(AUIPickerView *)pickerView didConfirmedWithSelectedIndexArrayOfAllComponent:(NSArray *)indexArray {
    ServiceOwnerStoreModel *model = [self.viewModel.detailModel.storeItemsArray objectAtIndex:[[indexArray firstObject] integerValue]];
    if (![model.storeId isEqualToString:self.viewModel.detailModel.currentStoreModel.storeId]) {
        [self.viewModel.detailModel setCurrentStoreModel:model];
        [self.detailView resetStoreSection];
    }
}

#pragma mark ServiceDetailConfirmViewDelegate

- (void)didClickedSubmitButtonWithBuyNumber:(NSUInteger)number selectedStore:(ServiceOwnerStoreModel *)store {
    [GToolUtil checkLogin:^(NSString *uid) {
        __weak ServiceDetailViewController *weakSelf = self;
        [[GAlertLoadingView sharedAlertLoadingView] show];
        [weakSelf.viewModel addToSettlementWithBuyCount:number storeId:store.storeId succeed:^(NSDictionary *data) {
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

#pragma mark Private methods

- (void)createStairsVC {
    if (!self.stairsController) {
        self.stairsController = [[AUIStairsController alloc] init];
    }
    if (!self.moreDetailViewController) {
        self.moreDetailViewController = [[ServiceMoreDetailViewController alloc] initWithServiceId:self.serviceId supportStairsController:YES];
    }
    [self.stairsController setViews:[NSArray arrayWithObjects:[self stairControledView], [self.moreDetailViewController stairControledView], nil]];
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
}


- (void)goSettlement {
    [GToolUtil checkLogin:^(NSString *uid) {
        SettlementViewController *controller = [[SettlementViewController alloc] initWithNibName:@"SettlementViewController" bundle:nil];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    } target:self];
}

#pragma mark Super method


- (UIView *)stairControledView {
    return self.detailView;
}

- (void)reloadNetworkData {
    [[GAlertLoadingView sharedAlertLoadingView] show];
    __weak ServiceDetailViewController *weakSelf = self;
    [self.viewModel startUpdateDataWithServiceId:self.serviceId channelId:self.channelId Succeed:^(NSDictionary *data) {
        [weakSelf.detailView reloadData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
        [weakSelf createStairsVC];
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
