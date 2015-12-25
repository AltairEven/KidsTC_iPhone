//
//  ParentingStrategyFilterView.m
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyFilterView.h"

@interface ParentingStrategyFilterView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tapArea;
@property (weak, nonatomic) IBOutlet UIView *filterBGView;
@property (weak, nonatomic) IBOutlet UIView *headerBar;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
//single select
@property (weak, nonatomic) IBOutlet UIButton *hotSortButton;
@property (weak, nonatomic) IBOutlet UIButton *timeSortButton;
//area
@property (weak, nonatomic) IBOutlet UIView *areaBGView;
@property (weak, nonatomic) IBOutlet UILabel *selectedAreaLabel;
@property (weak, nonatomic) IBOutlet UITableView *areaTable;
//bottom
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

- (void)selectSortType:(ParentingStrategySortType)type;
- (void)selectAreaAtIndex:(NSUInteger)index;

- (IBAction)didClickedSortButton:(id)sender;
- (IBAction)didClickedConfirmButton:(id)sender;
- (IBAction)didClickedClearButton:(id)sender;

@end

@implementation ParentingStrategyFilterView

#pragma mark Initialization

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ParentingStrategyFilterView" owner:self options:nil] objectAtIndex:0];
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
        ParentingStrategyFilterView *view = [GConfig getObjectFromNibWithView:self];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self.headerBar setBackgroundColor:[[KTCThemeManager manager] currentTheme].navibarBGColor];
    [self.headerLabel setTextColor:[[KTCThemeManager manager] currentTheme].navibarTitleColor_Normal];
    [self.filterBGView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalBGColor];
    [self.areaBGView setHidden:YES];
//    self.areaTable.delegate = self;
//    self.areaTable.dataSource = self;
//    
//    self.areaTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.tapArea addGestureRecognizer:tap];
    [self.tapArea setHidden:YES];
    
    [self.hotSortButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.hotSortButton setImageEdgeInsets:UIEdgeInsetsMake(0, SCREEN_WIDTH -120, 0, 0)];
    [self.timeSortButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.timeSortButton setImageEdgeInsets:UIEdgeInsetsMake(0, SCREEN_WIDTH -120, 0, 0)];
    
    [self.selectedAreaLabel setText:@"全部"];
    
    _currentAreaSelectedIndex = NSUIntegerMax;
    
    [self.hotSortButton setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor forState:UIControlStateNormal];
    [self.hotSortButton setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor forState:UIControlStateHighlighted];
    [self.hotSortButton setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor forState:UIControlStateSelected];
    
    [self.timeSortButton setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor forState:UIControlStateNormal];
    [self.timeSortButton setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor forState:UIControlStateHighlighted];
    [self.timeSortButton setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor forState:UIControlStateSelected];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.areaNameArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setText:[self.areaNameArray objectAtIndex:indexPath.row]];
    UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
    [bgView setBackgroundColor:RGBA(230, 200, 200, 1)];
    [cell setSelectedBackgroundView:bgView];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *areaName = [self.areaNameArray objectAtIndex:indexPath.row];
    [self.selectedAreaLabel setText:areaName];
    _currentAreaSelectedIndex = indexPath.row;
}

#pragma mark Private methods

- (void)selectSortType:(ParentingStrategySortType)type {
    switch (type) {
        case ParentingStrategySortTypeHot:
        {
            [self.hotSortButton setSelected:YES];
            [self.timeSortButton setSelected:NO];
        }
            break;
        case ParentingStrategySortTypeTime:
        {
            [self.hotSortButton setSelected:NO];
            [self.timeSortButton setSelected:YES];
        }
            break;
        default:
            break;
    }
    _currentSortType = type;
}

- (void)selectAreaAtIndex:(NSUInteger)index {
    if ([self.areaNameArray count] > index) {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.areaTable selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:self.areaTable didSelectRowAtIndexPath:selectedIndexPath];
    }
    _currentAreaSelectedIndex = index;
}

- (IBAction)didClickedSortButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    ParentingStrategySortType type = (ParentingStrategySortType)button.tag;
    [self selectSortType:type];
}

- (IBAction)didClickedConfirmButton:(id)sender {
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedConfirmButtonOnParentingStrategyFilterView:withSelectedSortType:selectedAreaIndex:)]) {
        [self.delegate didClickedConfirmButtonOnParentingStrategyFilterView:self withSelectedSortType:self.currentSortType selectedAreaIndex:self.currentAreaSelectedIndex];
    }
}

- (IBAction)didClickedClearButton:(id)sender {
    [self selectSortType:ParentingStrategySortTypeTime];
    if (self.currentAreaSelectedIndex != NSUIntegerMax) {
        [self.areaTable deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentAreaSelectedIndex inSection:0] animated:YES];
    }
    [self.selectedAreaLabel setText:@"全部"];
    [self selectAreaAtIndex:NSUIntegerMax];
}


- (void)doShowAnimationInView:(UIView *)view {
    self.frame = CGRectMake(SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height);
    __weak ParentingStrategyFilterView *weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setFrame:CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height)];
    } completion:^(BOOL finished) {
        [weakSelf.tapArea setHidden:NO];
    }];
}

- (void)doDismissAnimation {
    __weak ParentingStrategyFilterView *weakSelf = self;
    [weakSelf.tapArea setHidden:YES];
    //animation
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setFrame:CGRectMake(SCREEN_WIDTH, 0, weakSelf.frame.size.width, weakSelf.frame.size.height)];
    } completion:^(BOOL finished) {
        //send to back
        [weakSelf.superview sendSubviewToBack:weakSelf];
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark Public methods

- (void)show {
    [self showWithSelectedSortType:self.currentSortType selectedAreaIndex:self.currentAreaSelectedIndex];
}

- (void)showWithSelectedSortType:(ParentingStrategySortType)type selectedAreaIndex:(NSUInteger)index {
    [self setAreaNameArray:[[KTCArea area] areaNames]];
    [self.areaTable reloadData];
    [self selectSortType:type];
    if (self.currentAreaSelectedIndex != NSUIntegerMax) {
        [self selectAreaAtIndex:index];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self setFrame:appDelegate.window.frame];
    [self layoutIfNeeded];
    [appDelegate.window addSubview:self];
    [appDelegate.window bringSubviewToFront:self];
    [self doShowAnimationInView:appDelegate.window];
}

- (void)dismiss {
    [self doDismissAnimation];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
