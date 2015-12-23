//
//  KTCSearchResultViewController.m
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchResultViewController.h"
#import "ServiceDetailViewController.h"
#import "StoreDetailViewController.h"
#import "KTCSearchResultHeaderView.h"
#import "KTCSearchResultViewModel.h"
#import "KTCSearchViewController.h"
#import "KTCMapViewController.h"

@interface KTCSearchResultViewController () <KTCSearchResultViewDelegate>

@property (weak, nonatomic) IBOutlet KTCSearchResultView *resultView;
@property (nonatomic, strong) KTCSearchResultViewModel *viewModel;

@property (nonatomic, strong) KTCSearchResultHeaderView *headerView;

- (void)resetLocation;

@end

@implementation KTCSearchResultViewController

- (instancetype)initWithSearchType:(KTCSearchType)type condition:(KTCSearchCondition *)condition {
    self = [super initWithNibName:@"KTCSearchResultViewController" bundle:nil];
    if (self) {
        self.searchType = type;
        self.searchCondition = condition;
        self.needRefresh = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIdentifier = @"pv_search_result";
    // Do any additional setup after loading the view from its nib.
    self.viewModel = [[KTCSearchResultViewModel alloc] initWithView:self.resultView];
    [self.viewModel resetSortFilterWithSearchType:self.searchType];
    self.resultView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetLocation) name:UserLocationHasChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self resetLocation];
    [self.resultView setCurrentSearchType:self.searchType];
    self.viewModel.searchType = self.searchType;
    switch (self.searchType) {
        case KTCSearchTypeService:
        {
            self.viewModel.searchServiceCondition = (KTCSearchServiceCondition *)self.searchCondition;
            [self.viewModel resetSortFilterWithSearchType:self.searchType];
        }
            break;
        case KTCSearchTypeStore:
        {
            self.viewModel.searchStoreCondition = (KTCSearchStoreCondition *)self.searchCondition;
            [self.viewModel resetSortFilterWithSearchType:self.searchType];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.needRefresh) {
        [self.viewModel startUpdateDataWithSearchType:self.viewModel.searchType];
        self.needRefresh = NO;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserLocationHasChangedNotification object:nil];
}

#pragma mark KTCSearchResultViewDelegate

- (void)didClickedBackButtonOnSearchResultView:(KTCSearchResultView *)resultView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchResultView:(KTCSearchResultView *)resultView didClickedSegmentControlWithSearchType:(KTCSearchType)type {
    self.searchType = type;
    switch (type) {
        case KTCSearchTypeService:
        {
            if ([self.searchCondition isKindOfClass:[KTCSearchStoreCondition class]]) {
                self.searchCondition = [KTCSearchServiceCondition conditionFromStoreCondition:(KTCSearchStoreCondition *)self.searchCondition];
                self.viewModel.searchServiceCondition = (KTCSearchServiceCondition *)self.searchCondition;
            }
        }
            break;
        case KTCSearchTypeStore:
        {
            if ([self.searchCondition isKindOfClass:[KTCSearchServiceCondition class]]) {
                self.searchCondition = [KTCSearchStoreCondition conditionFromServiceCondition:(KTCSearchServiceCondition *)self.searchCondition];
                self.viewModel.searchStoreCondition = (KTCSearchStoreCondition *)self.searchCondition;
            }
        }
            break;
        default:
            break;
    }
    [self.viewModel resetSearchResultViewWithSearchType:type];
}

- (void)didClickedSearchButtonOnSearchResultView:(KTCSearchResultView *)headerView {
    KTCSearchViewController *controller = [[KTCSearchViewController alloc] initWithSearchType:self.searchType];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)searchResultView:(KTCSearchResultView *)resultView didSelectedServiceAtIndex:(NSUInteger)index {
    ServiceListItemModel *model = [[self.viewModel serviceResult] objectAtIndex:index];
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:model.identifier channelId:model.channelId];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)searchResultView:(KTCSearchResultView *)resultView didSelectedStoreAtIndex:(NSUInteger)index {
    StoreListItemModel *model = [[self.viewModel storeResult] objectAtIndex:index];
    StoreDetailViewController *controller = [[StoreDetailViewController alloc] initWithStoreId:model.identifier];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)searchResultView:(KTCSearchResultView *)resultView needRefreshTableWithSearchType:(KTCSearchType)type {
    [self.viewModel startUpdateDataWithSearchType:type];
}

- (void)searchResultView:(KTCSearchResultView *)resultView needLoadMoreWithSearchType:(KTCSearchType)type {
    [self.viewModel getMoreDataWithSearchType:type];
}

- (void)searchResultView:(KTCSearchResultView *)resultView didSelectedFilterWithCoordinate:(KTCSearchResultFilterCoordinate)coordinate forAreaOfSearchType:(KTCSearchType)type {
    switch (type) {
        case KTCSearchTypeService:
        {
            self.viewModel.serviceAreaFilterCoordinate = coordinate;
            [self.viewModel startUpdateDataWithSearchType:KTCSearchTypeService];
        }
            break;
        case KTCSearchTypeStore:
        {
            self.viewModel.storeAreaFilterCoordinate = coordinate;
            [self.viewModel startUpdateDataWithSearchType:KTCSearchTypeStore];
        }
            break;
        default:
            break;
    }
}

- (void)searchResultView:(KTCSearchResultView *)resultView didSelectedFilterWithCoordinate:(KTCSearchResultFilterCoordinate)coordinate forSortOfSearchType:(KTCSearchType)type {
    switch (type) {
        case KTCSearchTypeService:
        {
            self.viewModel.serviceSortFilterCoordinate = coordinate;
            [self.viewModel startUpdateDataWithSearchType:KTCSearchTypeService];
        }
            break;
        case KTCSearchTypeStore:
        {
            self.viewModel.storeSortFilterCoordinate = coordinate;
            [self.viewModel startUpdateDataWithSearchType:KTCSearchTypeStore];
        }
            break;
        default:
            break;
    }
}

- (void)searchResultView:(KTCSearchResultView *)resultView didConfirmedAgeCoordinate:(KTCSearchResultFilterCoordinate)ageCoordinate categoryCoordinate:(KTCSearchResultFilterCoordinate)categoryCoordinate forSearchType:(KTCSearchType)type {
    switch (type) {
        case KTCSearchTypeService:
        {
            self.viewModel.serviceAgeFilterCoordinate = ageCoordinate;
            self.viewModel.serviceCategoryFilterCoordinate = categoryCoordinate;
            [self.viewModel startUpdateDataWithSearchType:KTCSearchTypeService];
        }
            break;
        case KTCSearchTypeStore:
        {
            self.viewModel.storeAgeFilterCoordinate = ageCoordinate;
            self.viewModel.storeCategoryFilterCoordinate = categoryCoordinate;
            [self.viewModel startUpdateDataWithSearchType:KTCSearchTypeStore];
        }
            break;
        default:
            break;
    }
}

- (void)didClickedLocateButtonOnSearchResultView:(KTCSearchResultView *)resultView {
    KTCMapViewController *controller = [[KTCMapViewController alloc] initWithMapType:KTCMapTypeLocate destination:[GConfig sharedConfig].currentLocation];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark Private methods


- (void)resetLocation {
    [self.resultView setLocation:[GConfig sharedConfig].currentLocation.locationDescription];
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
