//
//  ActivityFilterView.m
//  KidsTC
//
//  Created by 钱烨 on 11/6/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ActivityFilterView.h"

@interface ActivityFilterView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tapArea;
@property (weak, nonatomic) IBOutlet UIView *filterBGView;
@property (weak, nonatomic) IBOutlet UIView *headerBar;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
//category
@property (weak, nonatomic) IBOutlet UIScrollView *categoryBGView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) NSMutableArray *categoryButtonsArray;
//area
@property (weak, nonatomic) IBOutlet UIView *areaBGView;
@property (weak, nonatomic) IBOutlet UILabel *selectedAreaLabel;
@property (weak, nonatomic) IBOutlet UITableView *areaTable;
//bottom
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, assign) NSInteger lastCategoryIndex;
@property (nonatomic, assign) NSInteger lastAreaIndex;

- (void)selectCategoryAtIndex:(NSInteger)index;
- (void)selectAreaAtIndex:(NSInteger)index;

- (void)didClickedCategoryButton:(id)sender;
- (IBAction)didClickedConfirmButton:(id)sender;
- (IBAction)didClickedCancelButton:(id)sender;

- (void)buildCategoryView;

@end

@implementation ActivityFilterView

#pragma mark Initialization

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ActivityFilterView" owner:self options:nil] objectAtIndex:0];
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
        ActivityFilterView *view = [GConfig getObjectFromNibWithView:self];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self.headerBar setBackgroundColor:[AUITheme theme].navibarBGColor];
    [self.headerLabel setTextColor:[AUITheme theme].navibarTitleColor_Normal];
    [self.filterBGView setBackgroundColor:[AUITheme theme].globalBGColor];
    
    self.areaTable.backgroundView = nil;
    [self.areaTable setBackgroundColor:[AUITheme theme].globalBGColor];
    self.areaTable.delegate = self;
    self.areaTable.dataSource = self;
    self.areaTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.tapArea addGestureRecognizer:tap];
    [self.tapArea setHidden:YES];
    
    
    [self.selectedAreaLabel setText:@"全部"];
    
    _currentCategoryIndex = INVALID_INDEX;
    _currentAreaIndex = INVALID_INDEX;
    
    [self.filterBGView bringSubviewToFront:self.loadingView];
}

- (void)setCategoryNameArray:(NSArray *)categoryNameArray {
    _categoryNameArray = categoryNameArray;
    [self buildCategoryView];
    if (self.currentCategoryIndex != INVALID_INDEX) {
        [self selectCategoryAtIndex:self.currentCategoryIndex];
    }
}

- (void)setAreaNameArray:(NSArray *)areaNameArray {
    _areaNameArray = areaNameArray;
    [self.areaTable reloadData];
    if (self.currentAreaIndex != INVALID_INDEX) {
        [self selectAreaAtIndex:self.currentAreaIndex];
    }
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
    _currentAreaIndex = indexPath.row;
}

#pragma mark Private methods

- (void)selectCategoryAtIndex:(NSInteger)index {
    _currentCategoryIndex = index;
    if ([self.categoryButtonsArray count] > index) {
        for (NSInteger buttonIndex = 0; buttonIndex < [self.categoryButtonsArray count]; buttonIndex ++) {
            UIButton *button = [self.categoryButtonsArray objectAtIndex:buttonIndex];
            if (buttonIndex == index) {
                [button setSelected:YES];
            } else {
                [button setSelected:NO];
            }
        }
    }
}

- (void)selectAreaAtIndex:(NSInteger)index {
    if ([self.areaNameArray count] > index) {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.areaTable selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:self.areaTable didSelectRowAtIndexPath:selectedIndexPath];
    }
    _currentAreaIndex = index;
}

- (void)didClickedCategoryButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self selectCategoryAtIndex:button.tag];
}

- (IBAction)didClickedConfirmButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedConfirmButtonOnActivityFilterView:withSelectedCategoryIndex:selectedAreaIndex:)]) {
        [self.delegate didClickedConfirmButtonOnActivityFilterView:self withSelectedCategoryIndex:self.currentCategoryIndex selectedAreaIndex:self.currentAreaIndex];
    }
    [self dismiss];
}

- (IBAction)didClickedCancelButton:(id)sender {
    
//    [self selectCategoryAtIndex:self.lastCategoryIndex];
//    if (self.currentAreaIndex != INVALID_INDEX) {
//        [self.areaTable deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentAreaIndex inSection:0] animated:YES];
//    }
//    [self.selectedAreaLabel setText:[self.areaNameArray objectAtIndex:0]];
//    if (self.lastAreaIndex != INVALID_INDEX) {
//        [self selectAreaAtIndex:self.lastAreaIndex];
//    }
    [self dismiss];
}


- (void)doShowAnimationInView:(UIView *)view {
    self.frame = CGRectMake(SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height);
    __weak ActivityFilterView *weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setFrame:CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height)];
    } completion:^(BOOL finished) {
        [weakSelf.tapArea setHidden:NO];
    }];
}

- (void)doDismissAnimation {
    __weak ActivityFilterView *weakSelf = self;
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

- (void)buildCategoryView {
    [self.categoryButtonsArray removeAllObjects];
    for (UIView *subview in self.categoryBGView.subviews) {
        [subview removeFromSuperview];
    }
    if (!self.categoryButtonsArray) {
        self.categoryButtonsArray = [[NSMutableArray alloc] init];
    }
    
    CGFloat leftMargin = 10;
    CGFloat rightMargin = 10;
    CGFloat cellHMargin = 5;
    CGFloat cellVMargin = 10;
    CGFloat topMargin = 10;
    
    CGFloat xPosition = leftMargin;
    CGFloat yPosition = topMargin;
    CGFloat buttonHeight = 30;
    CGFloat height = 0;
    for (NSInteger index = 0; index < [self.categoryNameArray count]; index ++) {
        NSString *title = [self.categoryNameArray objectAtIndex:index];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(xPosition, yPosition, 10, 10)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:[AUITheme theme].globalThemeColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[AUITheme theme].globalThemeColor forState:UIControlStateSelected];
        [button sizeToFit];
        [self.categoryBGView addSubview:button];
        
        button.tag = index;
        [button addTarget:self action:@selector(didClickedCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //加点边距
        [button setFrame:CGRectMake(xPosition, yPosition, button.frame.size.width + 20, buttonHeight)];
        
        [button.layer setCornerRadius:5];
        [button.layer setBorderWidth:1];
        [button.layer setBorderColor:[AUITheme theme].globalThemeColor.CGColor];
        [button.layer setMasksToBounds:YES];
        
        [self.categoryButtonsArray addObject:button];
        
        CGFloat nextCellWidth = 0;
        if (index + 1 < [self.categoryNameArray count]) {
            NSString *nextTitle = [self.categoryNameArray objectAtIndex:index + 1];
            nextCellWidth = 15 * [nextTitle length] + 20;
            //下一个按钮位置调整
            xPosition += button.frame.size.width + cellHMargin;
        }
        CGFloat rightM = button.frame.origin.x + button.frame.size.width + cellHMargin + nextCellWidth;
        CGFloat rightLimit = SCREEN_WIDTH - 40 - leftMargin - rightMargin;
        if (rightM > rightLimit) {
            xPosition = leftMargin;
            yPosition += cellVMargin + buttonHeight;
            height = yPosition + buttonHeight + topMargin;
        }
    }
    
    [self.categoryBGView setContentSize:CGSizeMake(0, height)];
}

#pragma mark Public methods

- (void)showLoading:(BOOL)bShow {
    if (bShow) {
        [self.loadingView startAnimating];
    } else {
        [self.loadingView stopAnimating];
    }
}

- (void)show {
    [self showWithSelectedCategoryIndex:self.currentCategoryIndex selectedAreaIndex:self.currentAreaIndex];
}

- (void)showWithSelectedCategoryIndex:(NSInteger)categoryIndex selectedAreaIndex:(NSInteger)areaIndex {
    self.lastCategoryIndex = self.currentCategoryIndex;
    self.lastAreaIndex = self.currentAreaIndex;
    
    [self.areaTable reloadData];
    if (categoryIndex != INVALID_INDEX) {
        [self selectCategoryAtIndex:categoryIndex];
    }
    if (areaIndex != INVALID_INDEX) {
        [self selectAreaAtIndex:areaIndex];
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
