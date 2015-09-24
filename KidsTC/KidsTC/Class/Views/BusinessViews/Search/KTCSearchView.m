//
//  KTCSearchView.m
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchView.h"
#import "KTCSearchHeaderView.h"
#import "KTCSearchHistoryView.h"

@interface KTCSearchView () <KTCSearchHeaderViewDelegate, KTCSearchHistoryViewDataSource, KTCSearchHistoryViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet KTCSearchHeaderView *headerView;
@property (weak, nonatomic) IBOutlet KTCSearchHistoryView *historyView;
@property (weak, nonatomic) IBOutlet UITableView *categoryTable;

@end

@implementation KTCSearchView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        KTCSearchView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.headerView.delegate = self;
    
    self.historyView.dataSource = self;
    self.historyView.delegate = self;
    
    self.categoryTable.dataSource = self;
    self.categoryTable.delegate = self;
    self.categoryTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    [self.categoryTable setHidden:YES];
    if ([self.categoryTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.categoryTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.categoryTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.categoryTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _type = KTCSearchTypeService;
}

- (void)setCategoryArray:(NSArray *)categoryArray {
    _categoryArray = [NSArray arrayWithArray:categoryArray];
    if ([categoryArray count] > 0) {
        [self.headerView setCategoryName:[categoryArray objectAtIndex:0] withPlaceholder:nil];
    }
}

#pragma mark KTCSearchHeaderViewDelegate

- (void)didClickedCategoryButtonOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView {
    if ([self.categoryArray count] > 0) {
        [self.categoryTable setHidden:NO];
        [self.categoryTable reloadData];
        [self bringSubviewToFront:self.categoryTable];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCategoryButtonOnKTCSearchView:)]) {
        [self.delegate didClickedCategoryButtonOnKTCSearchView:self];
    }
}

- (void)didClickedCancelButtonOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView {
    [self.categoryTable setHidden:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCancelButtonOnKTCSearchView:)]) {
        [self.delegate didClickedCancelButtonOnKTCSearchView:self];
    }
}

- (void)didClickedSearchButtonOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView {
    [self.categoryTable setHidden:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSearchButtonOnKTCSearchView:)]) {
        [self.delegate didClickedSearchButtonOnKTCSearchView:self];
    }
}


- (void)didStartEditingOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView {
    [self.categoryTable setHidden:YES];
}

#pragma mark KTCSearchHistoryViewDataSource & KTCSearchHistoryViewDelegate

- (NSArray *)hotKeysArrayForKTCSearchHistoryView:(KTCSearchHistoryView *)historyView {
    NSArray *returnArray = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(hotKeysArrayForKTCSearchView:)]) {
        returnArray = [self.dataSource hotKeysArrayForKTCSearchView:self];
    }
    return returnArray;
}

- (NSArray *)historiesArrayForKTCSearchHistoryView:(KTCSearchHistoryView *)historyView {
    NSArray *returnArray = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(historiesArrayForKTCSearchView:)]) {
        returnArray = [self.dataSource historiesArrayForKTCSearchView:self];
    }
    return returnArray;
}

- (void)searchHistoryView:(KTCSearchHistoryView *)historyView didSelectedHotKeyAtIndex:(NSUInteger)index {
    [self.categoryTable setHidden:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchView:didSelectedHotKeyAtIndex:)]) {
        [self.delegate searchView:self didSelectedHotKeyAtIndex:index];
    }
}

- (void)searchHistoryView:(KTCSearchHistoryView *)historyView didSelectedHistoryAtIndex:(NSUInteger)index {
    [self.categoryTable setHidden:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchView:didSelectedHistoryAtIndex:)]) {
        [self.delegate searchView:self didSelectedHistoryAtIndex:index];
    }}

- (void)didClickedClearHistoryButton {
    [self.categoryTable setHidden:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedClearHistoryButtonOnKTCSearchView:)]) {
        [self.delegate didClickedClearHistoryButtonOnKTCSearchView:self];
    }
}


- (void)searchHistoryViewDidScroll:(KTCSearchHistoryView *)historyView {
    [self.categoryTable setHidden:YES];
    [self.headerView endEditing];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categoryArray count];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setText:[self.categoryArray objectAtIndex:indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.headerView setCategoryName:[self.categoryArray objectAtIndex:indexPath.row] withPlaceholder:nil];
    [self.categoryTable setHidden:YES];
    _type = (KTCSearchType)(indexPath.row + 1);
}

#pragma mark Public methods

- (void)startEditing {
    [self.headerView startEditing];
}

- (void)endEditing {
    [self.headerView endEditing];
}

- (void)reloadData {
    [self.historyView reloadData];
}

- (NSString *)keywords {
    return self.headerView.keywords;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
