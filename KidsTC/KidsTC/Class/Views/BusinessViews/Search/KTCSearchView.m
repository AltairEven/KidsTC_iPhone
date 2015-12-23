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
#import "KTCSearchViewCategoryCell.h"

#define TriangleHeight (15)

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface KTCSearchView () <KTCSearchHeaderViewDelegate, KTCSearchHistoryViewDataSource, KTCSearchHistoryViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet KTCSearchHeaderView *headerView;
@property (weak, nonatomic) IBOutlet KTCSearchHistoryView *historyView;
@property (weak, nonatomic) IBOutlet UIView *categoryTableBGView;
@property (weak, nonatomic) IBOutlet UITableView *categoryTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryTableHeight;
@property (strong, nonatomic) UINib *cellNib;

- (void)drawTriangleForCategoryTable;

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
    
    self.categoryTable.layer.cornerRadius = 5;
    self.categoryTable.layer.masksToBounds = YES;
    self.categoryTable.dataSource = self;
    self.categoryTable.delegate = self;
    self.categoryTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([KTCSearchViewCategoryCell class]) bundle:nil];
        [self.categoryTable registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    [self drawTriangleForCategoryTable];
    [self.categoryTableBGView setHidden:YES];
    
    _type = KTCSearchTypeService;
}

- (void)setCategoryArray:(NSArray *)categoryArray {
    _categoryArray = [NSArray arrayWithArray:categoryArray];
    if ([categoryArray count] > 0) {
        KTCSearchTypeItem *item = [self.categoryArray firstObject];
        [self.headerView setCategoryName:item.name withPlaceholder:nil];
    }
}

#pragma mark KTCSearchHeaderViewDelegate

- (void)didClickedCategoryButtonOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView {
    if ([self.categoryArray count] > 0) {
        [self.categoryTableBGView setHidden:NO];
        [self.categoryTable reloadData];
        CGFloat height = 40 * [self.categoryArray count];
        if (self.categoryTableHeight.constant > 200) {
            self.categoryTableHeight.constant = 200 + TriangleHeight;
            [self.categoryTable setScrollEnabled:YES];
        } else {
            self.categoryTableHeight.constant = height + TriangleHeight;
            [self.categoryTable setScrollEnabled:NO];
        }
        [self bringSubviewToFront:self.categoryTableBGView];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCategoryButtonOnKTCSearchView:)]) {
        [self.delegate didClickedCategoryButtonOnKTCSearchView:self];
    }
}

- (void)didClickedCancelButtonOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView {
    [self.categoryTableBGView setHidden:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCancelButtonOnKTCSearchView:)]) {
        [self.delegate didClickedCancelButtonOnKTCSearchView:self];
    }
}

- (void)didClickedSearchButtonOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView {
    [self.categoryTableBGView setHidden:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSearchButtonOnKTCSearchView:)]) {
        [self.delegate didClickedSearchButtonOnKTCSearchView:self];
    }
}


- (void)didStartEditingOnKTCSearchHeaderView:(KTCSearchHeaderView *)headerView {
    [self.categoryTableBGView setHidden:YES];
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
    [self.categoryTableBGView setHidden:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchView:didSelectedHotKeyAtIndex:)]) {
        [self.delegate searchView:self didSelectedHotKeyAtIndex:index];
    }
}

- (void)searchHistoryView:(KTCSearchHistoryView *)historyView didSelectedHistoryAtIndex:(NSUInteger)index {
    [self.categoryTableBGView setHidden:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchView:didSelectedHistoryAtIndex:)]) {
        [self.delegate searchView:self didSelectedHistoryAtIndex:index];
    }}

- (void)didClickedClearHistoryButton {
    [self.categoryTableBGView setHidden:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedClearHistoryButtonOnKTCSearchView:)]) {
        [self.delegate didClickedClearHistoryButtonOnKTCSearchView:self];
    }
}


- (void)searchHistoryViewDidScroll:(KTCSearchHistoryView *)historyView {
    [self.categoryTableBGView setHidden:YES];
    [self.headerView endEditing];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categoryArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTCSearchViewCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"KTCSearchViewCategoryCell" owner:nil options:nil] objectAtIndex:0];
    }
    KTCSearchTypeItem *item = [self.categoryArray objectAtIndex:indexPath.row];
    [cell.cellImageView setImage:item.relationImage];
    [cell.titleLabel setText:item.name];
    if (indexPath.row >= [self.categoryArray count] - 1) {
        [cell hideSeparator:YES];
    } else {
        [cell hideSeparator:NO];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.categoryTableBGView setHidden:YES];
    KTCSearchTypeItem *item = [self.categoryArray objectAtIndex:indexPath.row];
    [self.headerView setCategoryName:item.name withPlaceholder:nil];
    _type = item.type;
    if (self.delegate && [self.delegate respondsToSelector:@selector(KTCSearchView:didChangedToSearchType:)]) {
        [self.delegate KTCSearchView:self didChangedToSearchType:self.type];
    }
}

#pragma Private methods

- (void)drawTriangleForCategoryTable {
    CGFloat width = 20;
    CGFloat height = TriangleHeight;
    UIView *triangleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.categoryTable.bounds.size.width, height)];
    [triangleView setBackgroundColor:[UIColor clearColor]];
    [self.categoryTableBGView addSubview:triangleView];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(width / 2, 0 - height)];
    [bezierPath addLineToPoint:CGPointMake(width, 0)];
    [bezierPath closePath];
    //边框蒙版
    CGFloat start = 20;
    CAShapeLayer *maskBorderLayer = [CAShapeLayer layer];
    [maskBorderLayer setFrame:CGRectMake(start, height, start + width, height)];
    maskBorderLayer.path = [bezierPath CGPath];
    maskBorderLayer.fillColor = [[[UIColor blackColor] colorWithAlphaComponent:0.7] CGColor];
    maskBorderLayer.strokeColor = self.categoryTable.layer.borderColor;//边框颜色
    maskBorderLayer.lineWidth = self.categoryTable.layer.borderWidth; //边框宽度
    [self.categoryTableBGView.layer addSublayer:maskBorderLayer];
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

- (void)setCurrentSearchTypeItemIndex:(NSUInteger)index {
    if ([self.categoryArray count] > index) {
        KTCSearchTypeItem *item = [self.categoryArray objectAtIndex:index];
        [self.headerView setCategoryName:item.name withPlaceholder:nil];
        _type = item.type;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
