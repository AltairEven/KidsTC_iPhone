//
//  StoreListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 8/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreListViewController.h"
#import "StoreListView.h"
#import "StoreListItemModel.h"
#import "StoreDetailViewController.h"

#define PageSize (10)

@interface StoreListViewController () <StoreListViewDataSource, StoreListViewDelegate>

@property (weak, nonatomic) IBOutlet StoreListView *listView;

@property (nonatomic, strong) NSMutableArray *listItemModels;

@property (nonatomic, strong) KTCSearchStoreCondition *searchCondition;

@property (nonatomic, assign) NSUInteger pageIndex;

- (void)loadStoreDataSucceed:(NSDictionary *)data;

- (void)loadStoreDataFailed:(NSError *)error;

- (void)loadMoreStoreDataSucceed:(NSDictionary *)data;

- (void)loadMoreStoreDataFailed:(NSError *)error;

- (void)reloadViewWithData:(NSDictionary *)data;

@end

@implementation StoreListViewController

- (instancetype)initWithStoreListItemModels:(NSArray *)models {
    if (!models || ![models isKindOfClass:[NSArray class]]) {
        return nil;
    }
    self = [super initWithNibName:@"StoreListViewController" bundle:nil];
    if (self) {
        self.listItemModels = [NSMutableArray arrayWithArray:models];
    }
    return self;
}

- (instancetype)initWithSearchCondition:(KTCSearchStoreCondition *)condition {
    if (!condition) {
        return nil;
    }
    self = [super initWithNibName:@"StoreListViewController" bundle:nil];
    if (self) {
        self.searchCondition = condition;
        self.pageIndex = 1;
        self.listItemModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"门店列表";
    // Do any additional setup after loading the view from its nib.
    self.listView.dataSource = self;
    self.listView.delegate = self;
    [self.listView setEnableUpdate:NO];
    [self.listView setEnbaleLoadMore:YES];
    [self.listView hideLoadMoreFooter:YES];
    if ([self.listItemModels count] > 0) {
        [self.listView reloadData];
    } else {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:KTCSearchTypeStore], @"type",
                               [NSNumber numberWithInteger:self.pageIndex], @"page",
                               [NSNumber numberWithInteger:PageSize], @"pageSize", nil];
        [[GAlertLoadingView sharedAlertLoadingView] show];
        [[KTCSearchService sharedService] startStoreSearchWithParamDic:param Condition:self.searchCondition success:^(NSDictionary *responseData) {
            [self loadStoreDataSucceed:responseData];
            [[GAlertLoadingView sharedAlertLoadingView] hide];
        } failure:^(NSError *error) {
            [self loadStoreDataFailed:error];
            [[GAlertLoadingView sharedAlertLoadingView] hide];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
    [[KTCSearchService sharedService] stopStoreSearch];
}

#pragma mark StoreListViewDataSource & StoreListViewDelegate

- (NSArray *)itemModelsForStoreListView:(StoreListView *)listView {
    return self.listItemModels;
}


- (void)storeListView:(StoreListView *)listView didSelectedItemAtIndex:(NSUInteger)index {
    StoreListItemModel *model = [self.listItemModels objectAtIndex:index];
    StoreDetailViewController *controller = [[StoreDetailViewController alloc] initWithStoreId:model.identifier];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)storeListViewDidPulledUpToloadMore:(StoreListView *)listView {
    NSUInteger index = self.pageIndex + 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:KTCSearchTypeStore], @"type",
                           [NSNumber numberWithInteger:index], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageSize", nil];
    [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view];
    [[KTCSearchService sharedService] startStoreSearchWithParamDic:param Condition:self.searchCondition success:^(NSDictionary *responseData) {
        [self loadMoreStoreDataSucceed:responseData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(NSError *error) {
        [self loadMoreStoreDataFailed:error];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

#pragma mark Private methods

- (void)loadStoreDataSucceed:(NSDictionary *)data {
    [self.listItemModels removeAllObjects];
    [self reloadViewWithData:data];
}

- (void)loadStoreDataFailed:(NSError *)error {
    [self reloadViewWithData:nil];
}

- (void)loadMoreStoreDataSucceed:(NSDictionary *)data {
    self.pageIndex ++;
    [self reloadViewWithData:data];
}

- (void)loadMoreStoreDataFailed:(NSError *)error {
    [self reloadViewWithData:nil];
}

- (void)reloadViewWithData:(NSDictionary *)data {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
        [self.listView hideLoadMoreFooter:NO];
        for (NSDictionary *singleService in dataArray) {
            StoreListItemModel *model = [[StoreListItemModel alloc] initWithRawData:singleService];
            if (model) {
                [self.listItemModels addObject:model];
            }
        }
        if ([dataArray count] < PageSize) {
            [self.listView noMoreLoad];
            [self.listView hideLoadMoreFooter:YES];
        }
    } else {
        [self.listView noMoreLoad];
        [self.listView hideLoadMoreFooter:YES];
    }
    [self.listView reloadData];
    [self.listView endLoadMore];
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
