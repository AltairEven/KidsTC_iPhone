//
//  NewsListView.m
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "NewsListView.h"
#import "NewsListViewCell.h"
#import "AUISegmentView.h"
#import "NewsListViewTagCell.h"
#import "NewsTagItemModel.h"

static NSString *const kSegmentIdentifier = @"kSegmentIdentifier";
static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface NewsListView () <AUISegmentViewDataSource, AUISegmentViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet AUISegmentView *segmentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *newsTagView;
@property (strong, nonatomic) IBOutlet UITableViewCell *moreTagCell;

@property (nonatomic, strong) UINib *segmentNib;
@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *tagModels;
@property (nonatomic, strong) NSArray *listModels;

@property (nonatomic, strong) NSMutableDictionary *noMoreDataDic;
@property (nonatomic, strong) NSMutableDictionary *hideFooterDic;

@property (nonatomic, assign) BOOL newsTagViewIsHidden;

- (void)pullToRefreshTable;

- (void)pullToLoadMoreData;

- (void)buildNewsTagView;

- (void)hideNewsTagView:(BOOL)hidden;

- (void)didClickedButton:(id)sender;

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
    [self.segmentView setScrollEnable:YES];
    self.segmentView.dataSource = self;
    self.segmentView.delegate = self;
    if (!self.segmentNib) {
        self.segmentNib = [UINib nibWithNibName:NSStringFromClass([NewsListViewTagCell class]) bundle:nil];
        [self.segmentView registerNib:self.segmentNib forCellReuseIdentifier:kSegmentIdentifier];
    }
    _currentNewsTagIndex = 0;
    [self.segmentView setSelectedIndex:self.currentNewsTagIndex];
    
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([NewsListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    __weak NewsListView *weakSelf = self;
    [weakSelf.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf pullToRefreshTable];
    }];
    [weakSelf.tableView addGifFooterWithRefreshingBlock:^{
        BOOL noMore = [[weakSelf.noMoreDataDic objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)weakSelf.currentNewsTagIndex]] boolValue];
        if (noMore) {
            [weakSelf.tableView.gifFooter noticeNoMoreData];
            return;
        }
        [weakSelf pullToLoadMoreData];
    }];
    //data
    self.noMoreDataDic = [[NSMutableDictionary alloc] init];
    self.hideFooterDic = [[NSMutableDictionary alloc] init];
    
    //news tag view
    [self.newsTagView setBackgroundColor:[AUITheme theme].globalBGColor];
    [self hideNewsTagView:YES];
}

- (NSUInteger)pageSize {
    return 10;
}

#pragma mark AUISegmentViewDataSource & AUISegmentViewDelegate

- (NSUInteger)numberOfCellsForSegmentView:(AUISegmentView *)segmentView {
    return [self.tagModels count] + 1;
}

- (UITableViewCell *)segmentView:(AUISegmentView *)segmentView cellAtIndex:(NSUInteger)index {
    if (index < [self.tagModels count]) {
        NewsListViewTagCell *cell = [segmentView dequeueReusableCellWithIdentifier:kSegmentIdentifier forIndex:index];
        if (!cell) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"NewsListViewTagCell" owner:nil options:nil] objectAtIndex:0];
        }
        NewsTagItemModel *model = [self.tagModels objectAtIndex:index];
        [cell.titleLabel setText:model.name];
        return cell;
    } else {
        return self.moreTagCell;
    }
}

- (CGFloat)segmentView:(AUISegmentView *)segmentView cellWidthAtIndex:(NSUInteger)index {
    CGFloat width = 0;
    if (index < [self.tagModels count]) {
        width = 100;
    } else {
        width = 40;
    }
    return width;
}

- (void)segmentView:(AUISegmentView *)segmentView didSelectedAtIndex:(NSUInteger)index {
    _currentNewsTagIndex = index;
    if (index == [self.tagModels count]) {
        [self hideNewsTagView:!self.newsTagViewIsHidden];
        if (self.newsTagViewIsHidden) {
            [self.segmentView deselectIndex:index];
        }
    } else {
        [self hideNewsTagView:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(newsListView:didSelectedNewsTagIndex:)]) {
            [self.delegate newsListView:self didSelectedNewsTagIndex:index];
        }
    }
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listModels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"NewsListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    NewsListItemModel *model = [self.listModels objectAtIndex:indexPath.row];
    [cell configWithItemModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NewsListViewCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsListView:didSelectedItem:atNewsTagIndex:)]) {
        NewsListItemModel *model = [self.listModels objectAtIndex:indexPath.row];
        [self.delegate newsListView:self didSelectedItem:model atNewsTagIndex:self.currentNewsTagIndex];
    }
}

#pragma mark Private methods

- (void)pullToRefreshTable {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsListViewDidPulledDownToRefresh:atNewsTagIndex:)]) {
        [self.delegate newsListViewDidPulledDownToRefresh:self atNewsTagIndex:self.currentNewsTagIndex];
    }
}

- (void)pullToLoadMoreData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsListViewDidPulledUpToloadMore:atNewsTagIndex:)]) {
        [self.delegate newsListViewDidPulledUpToloadMore:self atNewsTagIndex:self.currentNewsTagIndex];
    }
}

- (void)buildNewsTagView {
    for (UIView *subview in self.newsTagView.subviews) {
        [subview removeFromSuperview];
    }
    CGFloat leftMargin = 20;
    CGFloat rightMargin = 20;
    CGFloat cellHMargin = 10;
    CGFloat cellVMargin = 10;
    CGFloat topMargin = 20;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, 100, 30)];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:@"热门："];
    [self.newsTagView addSubview:label];
    
    CGFloat xPosition = leftMargin;
    CGFloat yPosition = label.frame.origin.y + label.frame.size.height + topMargin;
    CGFloat height = yPosition;
    for (NSUInteger index = 0; index < [self.tagModels count]; index ++) {
        NewsTagItemModel *model = [self.tagModels objectAtIndex:index];
        NSString *title = model.name;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(xPosition, yPosition, 10, 10)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.tag = index;
        [button addTarget:self action:@selector(didClickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        [self.newsTagView addSubview:button];
        
        //加点边距
        [button setFrame:CGRectMake(xPosition, yPosition, button.frame.size.width + 10, 30)];
        
        [button.layer setCornerRadius:5];
        [button.layer setBorderWidth:0.5];
        [button.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [button.layer setMasksToBounds:YES];
        //下一个按钮位置调整
        xPosition += button.frame.size.width + cellHMargin;
        CGFloat rightM = button.frame.origin.x + button.frame.size.width;
        CGFloat rightLimit = self.newsTagView.frame.size.width - rightMargin;
        if (rightM > rightLimit) {
            xPosition = leftMargin;
            yPosition += cellVMargin;
            height = yPosition + topMargin;
        }
    }
    [self.newsTagView setContentSize:CGSizeMake(0, height)];
}

- (void)hideNewsTagView:(BOOL)hidden {
    if (hidden) {
        [self sendSubviewToBack:self.newsTagView];
    } else {
        [self bringSubviewToFront:self.newsTagView];
    }
    
    self.newsTagViewIsHidden = hidden;
}

- (void)didClickedButton:(id)sender {
    [self hideNewsTagView:YES];
    NSUInteger tag = ((UIButton *)sender).tag;
    [self.segmentView setSelectedIndex:tag];
    _currentNewsTagIndex = tag;
    [self.segmentView scrollToIndex:tag position:UITableViewScrollPositionMiddle animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsListView:didSelectedNewsTagIndex:)]) {
        [self.delegate newsListView:self didSelectedNewsTagIndex:tag];
    }
}

#pragma mark Public methods

- (void)reloadNewsTag {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(newsTagItemModelsForNewsListView:)]) {
        self.tagModels = [self.dataSource newsTagItemModelsForNewsListView:self];
    }
    [self.segmentView reloadData];
    [self.segmentView setSelectedIndex:self.currentNewsTagIndex];
    [self buildNewsTagView];
}

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(newsListItemModelsForNewsListView:ofNewsTagIndex:)]) {
        self.listModels = [self.dataSource newsListItemModelsForNewsListView:self ofNewsTagIndex:self.currentNewsTagIndex];
        _itemCount = [self.listModels count];
        [self.tableView reloadData];
        if ([self.listModels count] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        if ([[self.noMoreDataDic objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentNewsTagIndex]] boolValue]) {
            [self.tableView.gifFooter noticeNoMoreData];
        } else {
            [self.tableView.gifFooter resetNoMoreData];
        }
    }
    [self.tableView.gifFooter setHidden:[[self.hideFooterDic objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentNewsTagIndex]] boolValue]];
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

- (void)noMoreData:(BOOL)noMore forNewsTagIndex:(NSUInteger)index {
    [self.noMoreDataDic setObject:[NSNumber numberWithBool:noMore] forKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]];
}

- (void)hideLoadMoreFooter:(BOOL)hidden forNewsTagIndex:(NSUInteger)index {
    [self.tableView.gifFooter setHidden:hidden];
    [self.hideFooterDic setObject:[NSNumber numberWithBool:hidden] forKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
