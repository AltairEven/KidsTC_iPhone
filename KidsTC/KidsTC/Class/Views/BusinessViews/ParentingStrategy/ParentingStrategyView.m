//
//  ParentingStrategyView.m
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyView.h"
#import "ParentingStrategyCalendarView.h"
#import "ParentingStrategyViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface ParentingStrategyView () <UITableViewDataSource, UITableViewDelegate, ParentingStrategyCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet ParentingStrategyCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *listModels;

@property (nonatomic, strong) NSMutableDictionary *noMoreDataDic;
@property (nonatomic, strong) NSMutableDictionary *hideFooterDic;

- (void)pullDownToRefresh;

- (void)pullUpToLoadMore;

@end

@implementation ParentingStrategyView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        ParentingStrategyView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.calendarView.delegate = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([ParentingStrategyViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    __weak ParentingStrategyView *weakSelf = self;
    [weakSelf.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf pullDownToRefresh];
    }];
    [weakSelf.tableView addGifFooterWithRefreshingBlock:^{
        BOOL noMore = [[weakSelf.noMoreDataDic objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)weakSelf.currentCalendarIndex]] boolValue];
        if (noMore) {
            [weakSelf.tableView.gifFooter noticeNoMoreData];
            return;
        }
        [weakSelf pullUpToLoadMore];
    }];
    //data
    self.noMoreDataDic = [[NSMutableDictionary alloc] init];
    self.hideFooterDic = [[NSMutableDictionary alloc] init];
}

- (void)setCalendarTitles:(NSArray *)calendarTitles {
    _calendarTitles = [NSArray arrayWithArray:calendarTitles];
    [self.calendarView setTitlesArray:calendarTitles];
}


#pragma mark ParentingStrategyCalendarViewDelegate

- (void)parentingStrategyCalendarView:(ParentingStrategyCalendarView *)calendarView didClickedAtIndex:(NSUInteger)index {
    _currentCalendarIndex = self.calendarView.currentIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentingStrategyView:didClickedCalendarButtonAtIndex:)]) {
        [self.delegate parentingStrategyView:self didClickedCalendarButtonAtIndex:index];
    }
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listModels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParentingStrategyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"ParentingStrategyViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell configWithItemModel:[self.listModels objectAtIndex:indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParentingStrategyListItemModel *model = [self.listModels objectAtIndex:indexPath.row];
    return [model cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentingStrategyView:didSelectedItemAtIndex:)]) {
        [self.delegate parentingStrategyView:self didSelectedItemAtIndex:indexPath.row];
    }
}

#pragma mark Private methods

- (void)pullDownToRefresh {
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentingStrategyView:DidPullDownToRefreshForCalendarIndex:)]) {
        [self.delegate parentingStrategyView:self DidPullDownToRefreshForCalendarIndex:self.currentCalendarIndex];
    }
}

- (void)pullUpToLoadMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentingStrategyView:DidPullUpToLoadMoreForCalendarIndex:)]) {
        [self.delegate parentingStrategyView:self DidPullUpToLoadMoreForCalendarIndex:self.currentCalendarIndex];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(listItemModelsOfParentingStrategyView:atCalendarIndex:)]) {
        self.listModels = [self.dataSource listItemModelsOfParentingStrategyView:self atCalendarIndex:self.currentCalendarIndex];
        [self.tableView reloadData];
        if ([self.listModels count] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        if ([[self.noMoreDataDic objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)self.currentCalendarIndex]] boolValue]) {
            [self.tableView.gifFooter noticeNoMoreData];
        } else {
            [self.tableView.gifFooter resetNoMoreData];
        }
    }
    [self.tableView.gifFooter setHidden:[[self.hideFooterDic objectForKey:[NSString stringWithFormat:@"%d", self.currentCalendarIndex]] boolValue]];
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

- (void)noMoreData:(BOOL)noMore forCalendarIndex:(NSUInteger)index {
    [self.noMoreDataDic setObject:[NSNumber numberWithBool:noMore] forKey:[NSString stringWithFormat:@"%d", index]];
}

- (void)hideLoadMoreFooter:(BOOL)hidden forCalendarIndex:(NSUInteger)index {
    [self.tableView.gifFooter setHidden:hidden];
    [self.hideFooterDic setObject:[NSNumber numberWithBool:hidden] forKey:[NSString stringWithFormat:@"%d", index]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
