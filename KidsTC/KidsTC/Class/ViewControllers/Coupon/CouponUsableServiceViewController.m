//
//  CouponUsableServiceViewController.m
//  KidsTC
//
//  Created by Altair on 1/19/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "CouponUsableServiceViewController.h"
#import "ServiceListViewCell.h"
#import "ServiceDetailViewController.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface CouponUsableServiceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSMutableArray *listModels;

@property (nonatomic, strong) HttpRequestClient *loadCouponServiceRequest;

@property (nonatomic, assign) BOOL noMoreData;

@property (nonatomic, assign) NSUInteger pageIndex;

@property (nonatomic, copy) NSString *batchId;

- (void)loadServiceDataSucceed:(NSDictionary *)data;

- (void)loadServiceDataFailed:(NSError *)error;

- (void)loadMoreServiceDataSucceed:(NSDictionary *)data;

- (void)loadMoreServiceDataFailed:(NSError *)error;

- (void)reloadViewWithData:(NSDictionary *)data;

- (void)pullToRefreshTable;

- (void)pullToLoadMoreData;

- (void)refresh;

- (void)loadMore;

@end

@implementation CouponUsableServiceViewController

- (instancetype)initWithCouponBatchIdentifier:(NSString *)bId {
    self = [super initWithNibName:@"CouponUsableServiceViewController" bundle:nil];
    if (self) {
        self.batchId = bId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"优惠券可用服务";
    _pageIdentifier = @"pv_coupon_usableserve";
    // Do any additional setup after loading the view from its nib.
    [self buildSubviews];
    self.listModels = [[NSMutableArray alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([ServiceListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    __weak CouponUsableServiceViewController *weakSelf = self;
    [self.tableView addGifHeaderWithRefreshingBlock:^{
        [weakSelf pullToRefreshTable];
    }];
    [self.tableView addGifFooterWithRefreshingBlock:^{
        [weakSelf pullToLoadMoreData];
    }];
    
    
    [self hideLoadMoreFooter:YES];
    [self refresh];
}

- (NSUInteger)pageSize {
    return 10;
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listModels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"ServiceListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    ServiceListItemModel *model = [self.listModels objectAtIndex:indexPath.row];
    [cell configWithItemModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceListItemModel *model = [self.listModels objectAtIndex:indexPath.row];
    return [model cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ServiceListItemModel *item = [self.listModels objectAtIndex:indexPath.row];
    ServiceDetailViewController *controller = [[ServiceDetailViewController alloc] initWithServiceId:item.identifier channelId:item.channelId];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
    //MTA
    [MTA trackCustomEvent:@"event_skip_coupon_prods_dtl" args:nil];
}

#pragma mark Private methods

- (void)pullToRefreshTable {
    self.tableView.backgroundView = nil;
    [self.tableView.mj_footer resetNoMoreData];
    self.noMoreData = NO;
    [self refresh];
}

- (void)pullToLoadMoreData {
    self.tableView.backgroundView = nil;
    [self loadMore];
}

#pragma mark Public methods

- (void)reloadData {
    [self.tableView reloadData];
    if ([self.listModels count] == 0) {
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    } else {
        self.tableView.backgroundView = nil;
    }
}

- (void)refresh {
    if (![self.batchId isKindOfClass:[NSString class]] || [self.batchId length] == 0) {
        return;
    }
    if (!self.loadCouponServiceRequest) {
        self.loadCouponServiceRequest = [HttpRequestClient clientWithUrlAliasName:@"GET_COUPON_PRODUCT"];
    }
    
    self.pageIndex = 1;
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.batchId, @"batchId", [NSNumber numberWithInteger:self.pageIndex], @"page", [NSNumber numberWithInteger:[self pageSize]], @"pageCount", nil];
    
    __weak CouponUsableServiceViewController *weakSelf = self;
    [[GAlertLoadingView sharedAlertLoadingView] show];
    [weakSelf.loadCouponServiceRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadServiceDataSucceed:responseData];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadServiceDataFailed:error];
        [[GAlertLoadingView sharedAlertLoadingView] hide];
    }];
}

- (void)loadMore {
    if (![self.batchId isKindOfClass:[NSString class]] || [self.batchId length] == 0) {
        return;
    }
    if (!self.loadCouponServiceRequest) {
        self.loadCouponServiceRequest = [HttpRequestClient clientWithUrlAliasName:@"GET_COUPON_PRODUCT"];
    }
    
    NSUInteger index = self.pageIndex + 1;
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.batchId, @"batchId", [NSNumber numberWithInteger:index], @"page", [NSNumber numberWithInteger:[self pageSize]], @"pageCount", nil];
    
    __weak CouponUsableServiceViewController *weakSelf = self;
    [weakSelf.loadCouponServiceRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadMoreServiceDataSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadMoreServiceDataFailed:error];
    }];
}

- (void)loadServiceDataSucceed:(NSDictionary *)data {
    [self.listModels removeAllObjects];
    [self reloadViewWithData:data];
}

- (void)loadServiceDataFailed:(NSError *)error {
    [self reloadViewWithData:nil];
    NSString *errMsg = @"";
    if (error.userInfo) {
        errMsg = [error.userInfo objectForKey:@"data"];
    }
    if ([errMsg length] == 0) {
        errMsg = @"未查询到可使用的商品";
    }
    [[iToast makeText:errMsg] show];
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
        [self hideLoadMoreFooter:NO];
        for (NSDictionary *singleService in dataArray) {
            ServiceListItemModel *model = [[ServiceListItemModel alloc] initWithRawData:singleService];
            if (model) {
                [self.listModels addObject:model];
            }
        }
        if ([dataArray count] < [self pageSize]) {
            [self noMoreLoad];
            [self hideLoadMoreFooter:YES];
        }
    } else {
        [self noMoreLoad];
        [self hideLoadMoreFooter:YES];
    }
    [self reloadData];
    [self endRefresh];
    [self endLoadMore];
}

- (void)startRefresh {
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)endLoadMore {
    [self.tableView.mj_footer endRefreshing];
}

- (void)noMoreLoad {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.noMoreData = YES;
}

- (void)hideLoadMoreFooter:(BOOL)hidden {
    [self.tableView.mj_footer setHidden:hidden];
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
