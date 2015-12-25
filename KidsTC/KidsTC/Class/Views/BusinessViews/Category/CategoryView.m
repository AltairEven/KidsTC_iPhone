//
//  CategoryView.m
//  KidsTC
//
//  Created by 钱烨 on 7/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CategoryView.h"
#import "CategoryViewCell.h"


static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface CategoryView () <UITableViewDataSource, UITableViewDelegate, CategoryViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *dataArray;

@end


@implementation CategoryView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        CategoryView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([CategoryViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"CategoryViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell configWithCategory:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IcsonLevel1Category *category = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat height = 44;
    
    NSUInteger subCount = [[category nextLevel] count];
    if (subCount > 0) {
        NSUInteger left = subCount % 4;
        NSUInteger rowNumber = subCount / 4;
        if (left > 0) {
            rowNumber += 1;
        }
        height += (40 + 0.5) * rowNumber + 0.5;
    }
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark CategoryViewCellDelegate

- (void)categoryViewCell:(CategoryViewCell *)cell didClickedSubLevelAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CategoryView:didClickedAtLevel1Index:subIndex:)]) {
        [self.delegate CategoryView:self didClickedAtLevel1Index:cell.indexPath.row subIndex:index];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(categoriesOfCategoryView:)]) {
        self.dataArray = [self.dataSource categoriesOfCategoryView:self];
        [self.tableView reloadData];
    }
    if ([self.dataArray count] == 0) {
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    } else {
        self.tableView.backgroundView = nil;
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
