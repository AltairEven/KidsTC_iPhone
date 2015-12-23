//
//  NewSearchResultViewController.m
//  KidsTC
//
//  Created by Altair on 12/2/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewSearchResultViewController.h"
#import "NewsSearchResultListView.h"
#import "NewsListItemModel.h"
#import "KTCWebViewController.h"

#define PageSize (10)

@interface NewSearchResultViewController () <NewsSearchResultListViewDataSource, NewsSearchResultListViewDelegate>

@property (weak, nonatomic) IBOutlet NewsSearchResultListView *listView;

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, assign) NSUInteger pageIndex;

- (void)loadNewsSucceedWithData:(NSDictionary *)data;

- (void)loadNewsFailedWithError:(NSError *)error;

- (void)loadMoreNewsSucceedWithData:(NSDictionary *)data;

- (void)loadMoreNewsFailedWithError:(NSError *)error;

- (void)reloadNewsListViewWithData:(NSDictionary *)data;

@end

@implementation NewSearchResultViewController

- (instancetype)initWithKeyWord:(NSString *)keyword {
    self = [super initWithNibName:@"NewSearchResultViewController" bundle:nil];
    if (self) {
        self.keyword = keyword;
        self.resultArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"知识库";
    // Do any additional setup after loading the view from its nib.
    self.listView.dataSource = self;
    self.listView.delegate = self;
    __weak NewSearchResultViewController *weakSelf = self;
    self.pageIndex = 1;
    [[KTCSearchService sharedService] startNewsSearchWithKeyWord:weakSelf.keyword pageIndex:weakSelf.pageIndex pageSize:PageSize success:^(NSDictionary *responseData) {
        [weakSelf loadNewsSucceedWithData:responseData];
    } failure:^(NSError *error) {
        [weakSelf loadMoreNewsFailedWithError:error];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[KTCSearchService sharedService] stopNewsSearch];
}

#pragma mark NewsSearchResultListViewDataSource & NewsSearchResultListViewDelegate

- (NSArray<NewsListItemModel *> *)itemModelsForNewsSearchResultListView:(NewsSearchResultListView *)view {
    return [NSArray arrayWithArray:self.resultArray];
}

- (void)didPullDownToRefreshForNewsSearchResultListView:(NewsSearchResultListView *)view {
    self.pageIndex = 1;
    __weak NewSearchResultViewController *weakSelf = self;
    [[KTCSearchService sharedService] startNewsSearchWithKeyWord:weakSelf.keyword pageIndex:weakSelf.pageIndex pageSize:PageSize success:^(NSDictionary *responseData) {
        [weakSelf loadNewsSucceedWithData:responseData];
    } failure:^(NSError *error) {
        [weakSelf loadMoreNewsFailedWithError:error];
    }];
}

- (void)didPullUpToLoadMoreForNewsSearchResultListView:(NewsSearchResultListView *)view {
    __weak NewSearchResultViewController *weakSelf = self;
    [[KTCSearchService sharedService] startNewsSearchWithKeyWord:weakSelf.keyword pageIndex:weakSelf.pageIndex + 1 pageSize:PageSize success:^(NSDictionary *responseData) {
        [weakSelf loadMoreNewsSucceedWithData:responseData];
    } failure:^(NSError *error) {
        [weakSelf loadMoreNewsFailedWithError:error];
    }];
}

- (void)newsSearchResultListView:(NewsSearchResultListView *)view didClickedAtIndex:(NSUInteger)index {
    NewsListItemModel *item = [self.resultArray objectAtIndex:index];
    KTCWebViewController *controller = [[KTCWebViewController alloc] init];
    [controller setWebUrlString:item.linkUrl];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark Private methods

- (void)loadNewsSucceedWithData:(NSDictionary *)data {
    [self.resultArray removeAllObjects];
    [self reloadNewsListViewWithData:data];
}

- (void)loadNewsFailedWithError:(NSError *)error {
    [self.listView endRefresh];
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -1003:
        {
            //没有数据
            [self.listView noMoreData:YES];
        }
            break;
        default:
            break;
    }
    [self.resultArray removeAllObjects];
    [self reloadNewsListViewWithData:nil];
}

- (void)loadMoreNewsSucceedWithData:(NSDictionary *)data {
    self.pageIndex ++;
    [self reloadNewsListViewWithData:data];
    [self.listView endLoadMore];
}

- (void)loadMoreNewsFailedWithError:(NSError *)error {
    switch (error.code) {
        case -999:
        {
            //cancel
            return;
        }
            break;
        case -1003:
        {
            //没有数据
            [self.listView noMoreData:YES];
        }
            break;
        default:
            break;
    }
    [self reloadNewsListViewWithData:nil];
    [self.listView endLoadMore];
}

- (void)reloadNewsListViewWithData:(NSDictionary *)data {
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
        [self.listView hideLoadMoreFooter:NO];
        
        for (NSDictionary *singleItem in dataArray) {
            NewsListItemModel *model = [[NewsListItemModel alloc] initWithRawData:singleItem];
            if (model) {
                [self.resultArray addObject:model];
            }
        }
        
        if ([dataArray count] < PageSize) {
            [self.listView noMoreData:YES];
        } else {
            [self.listView noMoreData:NO];
        }
    } else {
        [self.listView noMoreData:YES];
        [self.listView hideLoadMoreFooter:YES];
    }
    [self.listView reloadData];
    [self.listView endRefresh];
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
