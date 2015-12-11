//
//  ServiceListViewController.m
//  KidsTC
//
//  Created by 钱烨 on 8/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceListViewController.h"
#import "ServiceListView.h"
#import "ServiceListItemModel.h"
#import "ServiceDetailViewController.h"

#define PageSize (10)

@interface ServiceListViewController () <ServiceListViewDataSource, ServiceListViewDelegate>

@property (weak, nonatomic) IBOutlet ServiceListView *listView;

@property (nonatomic, strong) NSMutableArray *listItemModels;

@property (nonatomic, strong) KTCSearchServiceCondition *searchCondition;

@property (nonatomic, assign) NSUInteger pageIndex;

- (void)loadServiceDataSucceed:(NSDictionary *)data;

- (void)loadServiceDataFailed:(NSError *)error;

- (void)loadMoreServiceDataSucceed:(NSDictionary *)data;

- (void)loadMoreServiceDataFailed:(NSError *)error;

- (void)reloadViewWithData:(NSDictionary *)data;

@end

@implementation ServiceListViewController

- (instancetype)initWithListItemModels:(NSArray *)models {
    if (!models || ![models isKindOfClass:[NSArray class]]) {
        return nil;
    }
    self = [super initWithNibName:@"ServiceListViewController" bundle:nil];
    if (self) {
        self.listItemModels = [NSMutableArray arrayWithArray:models];
    }
    return self;
}

- (instancetype)initWithSearchCondition:(KTCSearchServiceCondition *)condition {
    if (!condition) {
        return nil;
    }
    self = [super initWithNibName:@"ServiceListViewController" bundle:nil];
    if (self) {
        self.searchCondition = condition;
        self.pageIndex = 1;
        self.listItemModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"服务列表";
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
                               [NSNumber numberWithInteger:KTCSearchTypeService], @"type",
                               [NSNumber numberWithInteger:self.pageIndex], @"page",
                               [NSNumber numberWithInteger:PageSize], @"pageSize", nil];
        [[GAlertLoadingView sharedAlertLoadingView] show];
        [[KTCSearchService sharedService] startServiceSearchWithParamDic:param Condition:self.searchCondition success:^(NSDictionary *responseData) {
            [self loadServiceDataSucceed:responseData];
            [[GAlertLoadingView sharedAlertLoadingView] hide];
        } failure:^(NSError *error) {
            [self loadServiceDataFailed:error];
            [[GAlertLoadingView sharedAlertLoadingView] hide];
        }];
    }
}

#pragma mark ServiceListViewDataSource & ServiceListViewDelegate

- (NSArray *)itemModelsForServiceListView:(ServiceListView *)listView {
    return self.listItemModels;
}

- (void)serviceListView:(ServiceListView *)listView didSelectedItemAtIndex:(NSUInteger)index {
    ServiceListItemModel *model = [self.listItemModels objectAtIndex:index];
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:model.identifier channelId:model.channelId];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)serviceListViewDidPulledUpToloadMore:(ServiceListView *)listView {
    NSUInteger index = self.pageIndex + 1;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:KTCSearchTypeService], @"type",
                           [NSNumber numberWithInteger:index], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pageSize", nil];
    [[GAlertLoadingView sharedAlertLoadingView] showInView:self.view];
    [[KTCSearchService sharedService] startServiceSearchWithParamDic:param Condition:self.searchCondition success:^(NSDictionary *responseData) {
        [self loadMoreServiceDataSucceed:responseData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(NSError *error) {
        [self loadMoreServiceDataFailed:error];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

#pragma mark Private methods

- (void)loadServiceDataSucceed:(NSDictionary *)data {
    [self.listItemModels removeAllObjects];
    [self reloadViewWithData:data];
}

- (void)loadServiceDataFailed:(NSError *)error {
    [self reloadViewWithData:nil];
}

- (void)loadMoreServiceDataSucceed:(NSDictionary *)data {
    self.pageIndex ++;
    [self reloadViewWithData:data];
}

- (void)loadMoreServiceDataFailed:(NSError *)error {
    [self reloadViewWithData:nil];
}

- (void)reloadViewWithData:(NSDictionary *)data {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
        [self.listView hideLoadMoreFooter:NO];
        for (NSDictionary *singleService in dataArray) {
            ServiceListItemModel *model = [[ServiceListItemModel alloc] initWithRawData:singleService];
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
