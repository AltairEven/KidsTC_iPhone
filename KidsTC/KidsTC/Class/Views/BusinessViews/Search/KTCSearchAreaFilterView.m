//
//  KTCSearchAreaFilterView.m
//  KidsTC
//
//  Created by 钱烨 on 8/3/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchAreaFilterView.h"

@interface KTCSearchAreaFilterView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (CGFloat)viewHeightWithLimitHeight:(CGFloat)limitHeight;

- (void)resetTableScrollStateWithViewHeight:(CGFloat)height limitHeight:(CGFloat)limitHeight;

@end

@implementation KTCSearchAreaFilterView

#pragma mark Initialization

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"KTCSearchAreaFilterView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        [self buildSubviews];
    }
    return self;
}


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        KTCSearchAreaFilterView *view = [GConfig getObjectFromNibWithView:self];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filterModel.subArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    KTCSearchResultFilterModel *filter = [self.filterModel.subArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:filter.name];
    [cell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentSelectedIndex = indexPath.row;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(searchAreaFilterView:didSelectedAtIndex:)]) {
            [self.delegate searchAreaFilterView:self didSelectedAtIndex:indexPath.row];
        }
        if ([self.delegate respondsToSelector:@selector(searchAreaFilterViewNeedDismiss:)]) {
            [self.delegate searchAreaFilterViewNeedDismiss:self];
        }
    }
}


#pragma mark Public methods

- (CGFloat)showWithSelectedIndex:(NSInteger)index maxHeight:(CGFloat)maxHeight {
    [self.superview bringSubviewToFront:self];
    [self setHidden:NO];
    
    if (self.filterModel) {
        [self.tableView reloadData];
        if (index >= 0) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    
    CGFloat height = [self viewHeightWithLimitHeight:maxHeight];
    
    return height;
}

#pragma mark Private methods

- (CGFloat)viewHeightWithLimitHeight:(CGFloat)limitHeight {
    CGFloat height = 0;
    height = [self.filterModel.subArray count] * 44 + 5;
    [self resetTableScrollStateWithViewHeight:height limitHeight:limitHeight];
    if (height > limitHeight) {
        height = limitHeight;
    }
    return height;
}

- (void)resetTableScrollStateWithViewHeight:(CGFloat)height limitHeight:(CGFloat)limitHeight {
    if (height > limitHeight) {
        [self.tableView setScrollEnabled:YES];
    } else {
        [self.tableView setScrollEnabled:NO];
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
