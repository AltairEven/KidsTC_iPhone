//
//  NewsListView.m
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "NewsListView.h"
#import "NewsListViewCell.h"
#import "AUILinearView.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface NewsListView () <AUILinearViewDataSource, AUILinearViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet AUILinearView *linearView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *listItemModels;

@property (nonatomic, assign) BOOL noMoreData;

- (void)pullToRefreshTable;

- (void)pullToLoadMoreData;

@end

@implementation NewsListView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        NewsListView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.linearView.dataSource = self;
    self.linearView.delegate = self;
    [self.linearView setHidden:YES];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([NewsListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    __weak NewsListView *weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf pullToRefreshTable];
    }];
    [self.tableView addGifFooterWithRefreshingBlock:^{
        [weakSelf pullToLoadMoreData];
    }];
}

- (NSUInteger)pageSize {
    return 10;
}

#pragma mark AUILinearViewDataSource & AUILinearViewDelegate

- (NSInteger)numberOfCellsInAUIlinearView:(AUILinearView *)linearView {
    return 10;
}

- (UIView *)auilinearView:(AUILinearView *)linearView viewForCellAtIndex:(NSUInteger)index withMaxHeight:(CGFloat)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    [view setBackgroundColor:[UIColor blueColor]];
    return view;
}

- (void)auilinearView:(AUILinearView *)linearView didSelectedCellAtIndex:(NSUInteger)index {
    UIView *view = [self.linearView.viewsForLinearView objectAtIndex:index];
    [view setBackgroundColor:[UIColor redColor]];
}

- (void)auilinearView:(AUILinearView *)linearView didDeselectCellAtIndex:(NSUInteger)index {
    UIView *view = [self.linearView.viewsForLinearView objectAtIndex:index];
    [view setBackgroundColor:[UIColor blueColor]];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _itemCount = [self.listItemModels count];
    return self.itemCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"NewsListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    NewsListItemModel *model = [self.listItemModels objectAtIndex:indexPath.row];
    [cell configWithItemModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NewsListViewCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsListView:didSelectedItem:)]) {
        NewsListItemModel *model = [self.listItemModels objectAtIndex:indexPath.row];
        [self.delegate newsListView:self didSelectedItem:model];
    }
}

#pragma mark Private methods

- (void)pullToRefreshTable {
    [self.tableView.gifFooter resetNoMoreData];
    self.noMoreData = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsListViewDidPulledDownToRefresh:)]) {
        [self.delegate newsListViewDidPulledDownToRefresh:self];
    }
}

- (void)pullToLoadMoreData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsListViewDidPulledUpToloadMore:)]) {
        [self.delegate newsListViewDidPulledUpToloadMore:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(newsListItemModelsForNewsListView:)]) {
        self.listItemModels = [self.dataSource newsListItemModelsForNewsListView:self];
        [self.tableView reloadData];
    }
    [self.linearView reloadData];
    [self.linearView setSelectedIndex:0];
    [self.linearView setHidden:NO];
}

- (void)startRefresh {
    [self.tableView.legendHeader beginRefreshing];
}

- (void)endRefresh {
    [self.tableView.legendHeader endRefreshing];
}

- (void)endLoadMore {
    [self.tableView.gifFooter endRefreshing];
}

- (void)noMoreLoad {
    [self.tableView.gifFooter noticeNoMoreData];
    self.noMoreData = YES;
}

- (void)hideLoadMoreFooter:(BOOL)hidden {
    [self.tableView.gifFooter setHidden:hidden];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
