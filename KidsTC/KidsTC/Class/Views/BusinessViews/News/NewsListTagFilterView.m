//
//  NewsListTagFilterView.m
//  KidsTC
//
//  Created by Altair on 11/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsListTagFilterView.h"
#import "NewsListTagFilterViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface NewsListTagFilterView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ageSelectTable;
@property (weak, nonatomic) IBOutlet UIScrollView *tagContentView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, assign) NSUInteger currentTypeIndex;

@property (nonatomic, strong) NSArray *modelsArray;

@property (nonatomic, assign) BOOL hasBuilt;

- (void)resetTagContentViewWithTagItems:(NSArray<NewsTagItemModel *> *)items;

- (void)didClickedButton:(id)sender;

@end

@implementation NewsListTagFilterView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        NewsListTagFilterView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    
    self.ageSelectTable.backgroundView = nil;
    [self.ageSelectTable setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.ageSelectTable.delegate = self;
    self.ageSelectTable.dataSource = self;
    if ([self.ageSelectTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.ageSelectTable setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([self.ageSelectTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.ageSelectTable setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([NewsListTagFilterViewCell class]) bundle:nil];
        [self.ageSelectTable registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
}

- (void)layoutSubviews {
    if (self.hasBuilt) {
        self.ageSelectTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
        self.ageSelectTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
        self.hasBuilt = YES;
    }
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.modelsArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsListTagFilterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"NewsListTagFilterViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    NewsTagTypeModel *model = [self.modelsArray objectAtIndex:indexPath.row];
    [cell configWithMetaData:model.metaData];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NewsListTagFilterViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentTypeIndex = indexPath.row;
    NewsTagTypeModel *model = [self.modelsArray objectAtIndex:indexPath.row];
    [self resetTagContentViewWithTagItems:model.tagItems];
}

#pragma mark Private methods

- (void)resetTagContentViewWithTagItems:(NSArray<NewsTagItemModel *> *)items {
    for (UIView *subView in self.tagContentView.subviews) {
        [subView removeFromSuperview];
    }
    
    if ([items count] > 0) {
        CGFloat hMargin = 10;
        CGFloat vMargin = 10;
        CGFloat xPosition = hMargin;
        CGFloat yPosition = vMargin;
        CGFloat buttonWidth = ((SCREEN_WIDTH * 0.75) - (3 * hMargin)) / 2;
        CGFloat buttonHeight = 30;
        CGFloat viewHeight = 0;
        
        for (NSUInteger index = 0; index < [items count]; index ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(xPosition, yPosition, buttonWidth, buttonHeight)];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            NewsTagItemModel *model = [items objectAtIndex:index];
            [button setTitle:model.name forState:UIControlStateNormal];
            
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds = YES;
            
            button.tag = index;
            [button addTarget:self action:@selector(didClickedButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.tagContentView addSubview:button];
            
            if (index % 2 != 0) {
                //右边
                xPosition = hMargin;
                yPosition += buttonHeight + vMargin;
            } else {
                xPosition += buttonWidth + hMargin;
            }
            
            viewHeight = yPosition + buttonHeight + vMargin;
        }
        self.tagContentView.contentSize = CGSizeMake(0, viewHeight);
    } else {
        self.tagContentView.contentSize = CGSizeMake(0, 0);
    }
}

- (void)didClickedButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsListTagFilterView:didSelectedNewsTag:)]) {
        UIButton *button = (UIButton *)sender;
        NewsTagTypeModel *typeModel = [self.modelsArray objectAtIndex:self.currentTypeIndex];
        NewsTagItemModel *itemModel = [typeModel.tagItems objectAtIndex:button.tag];
        [self.delegate newsListTagFilterView:self didSelectedNewsTag:itemModel];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(modelsForFilterView:)]) {
        self.modelsArray = [self.dataSource modelsForFilterView:self];
    }
    [self.ageSelectTable reloadData];
    if ([self.modelsArray count] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.ageSelectTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.ageSelectTable didSelectRowAtIndexPath:indexPath];
        
        CGFloat totalHeight = [NewsListTagFilterViewCell cellHeight] * [self.modelsArray count];
        if (totalHeight > SCREEN_HEIGHT - 64) {
            [self.ageSelectTable setScrollEnabled:YES];
        } else {
            [self.ageSelectTable setScrollEnabled:NO];
        }
    }
}


- (void)setSelectedTagIndex:(NSUInteger)index{
    if ([self.modelsArray count] > index) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.ageSelectTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        self.currentTypeIndex = index;
        NewsTagTypeModel *model = [self.modelsArray objectAtIndex:index];
        [self resetTagContentViewWithTagItems:model.tagItems];
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
