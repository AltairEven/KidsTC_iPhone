//
//  NewsRecommendListView.m
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsRecommendListView.h"
#import "NewsRecommendListViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface NewsRecommendListView () <UITableViewDataSource, UITableViewDelegate, NewsRecommendListViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *listItemModels;

- (void)pullToLoadMoreData;

@end

@implementation NewsRecommendListView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        NewsRecommendListView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([NewsRecommendListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    __weak NewsRecommendListView *weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf pullToLoadMoreData];
    }];
}

- (NSUInteger)pageSize {
    return 3;
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _itemCount = [self.listItemModels count];
    return self.itemCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsRecommendListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"NewsRecommendListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    NewsRecommendListModel *model = [self.listItemModels objectAtIndex:indexPath.row];
    [cell setListItemModel:model];
    cell.delegate = self;
    cell.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsRecommendListModel *model = [self.listItemModels objectAtIndex:indexPath.row];
    return [model cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark NewsRecommendListViewCellDelegate

- (void)newsRecommendListViewCell:(NewsRecommendListViewCell *)cell didClickedAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsRecommendListView:didSelectedCellItem:)]) {
        NewsRecommendListModel *recommendListModel = [self.listItemModels objectAtIndex:cell.indexPath.row];
        NewsListItemModel *model = [recommendListModel.cellModelsArray objectAtIndex:index];
        [self.delegate newsRecommendListView:self didSelectedCellItem:model];
    }
}


#pragma mark Private methods

- (void)pullToLoadMoreData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsRecommendListViewDidPulledToloadMore:)]) {
        [self.delegate newsRecommendListViewDidPulledToloadMore:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(newsRecommendListModelsForNewsRecommendListView:)]) {
        self.listItemModels = [self.dataSource newsRecommendListModelsForNewsRecommendListView:self];
        [self.tableView reloadData];
    }
}

- (void)startLoadMore {
    [self.tableView.legendHeader beginRefreshing];
}

- (void)endLoadMore {
    [self.tableView.legendHeader endRefreshing];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
