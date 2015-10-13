//
//  NewsRecommendCellView.m
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsRecommendCellView.h"
#import "NewsRecommendListModel.h"
#import "NewsRecommendCellViewBigImageCell.h"
#import "NewsRecommendCellViewSmallImageCell.h"

static NSString *const kBigImageCellIdentifier = @"kBigImageCellIdentifier";
static NSString *const kSmallImageCellIdentifier = @"kSmallImageCellIdentifier";

@interface NewsRecommendCellView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UINib *bigImageCellNib;
@property (nonatomic, strong) UINib *smallImageCellNib;

@end

@implementation NewsRecommendCellView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        NewsRecommendCellView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.tableView.layer.borderWidth = BORDER_WIDTH;
    self.tableView.layer.masksToBounds = YES;
    
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.bigImageCellNib) {
        self.bigImageCellNib = [UINib nibWithNibName:NSStringFromClass([NewsRecommendCellViewBigImageCell class]) bundle:nil];
        [self.tableView registerNib:self.bigImageCellNib forCellReuseIdentifier:kBigImageCellIdentifier];
    }
    if (!self.smallImageCellNib) {
        self.smallImageCellNib = [UINib nibWithNibName:NSStringFromClass([NewsRecommendCellViewSmallImageCell class]) bundle:nil];
        [self.tableView registerNib:self.smallImageCellNib forCellReuseIdentifier:kSmallImageCellIdentifier];
    }
    
    if (self.itemModels) {
        [self.tableView reloadData];
    }
}

- (void)setItemModels:(NSArray *)itemModels {
    _itemModels = [itemModels copy];
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemModels count];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NewsRecommendCellViewBigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kBigImageCellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"NewsRecommendCellViewBigImageCell" owner:nil options:nil] objectAtIndex:0];
        }
        NewsListItemModel *cellModel = [self.itemModels objectAtIndex:indexPath.row];
        [cell.cellImageView setImageWithURL:cellModel.imageUrl];
        [cell.newsTitleLabel setText:cellModel.title];
    } else {
        NewsRecommendCellViewSmallImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kSmallImageCellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"NewsRecommendCellViewSmallImageCell" owner:nil options:nil] objectAtIndex:0];
        }
        NewsListItemModel *cellModel = [self.itemModels objectAtIndex:indexPath.row];
        [cell.cellImageView setImageWithURL:cellModel.imageUrl];
        [cell.newsTitleLabel setText:cellModel.title];
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = [NewsRecommendCellViewBigImageCell cellHeight];
    } else {
        height = [NewsRecommendCellViewSmallImageCell cellHeight];
    }
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];//解决cell刷新问题
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsRecommendCellView:didSelectedItemAtIndex:)]) {
        [self.delegate newsRecommendCellView:self didSelectedItemAtIndex:indexPath.row];
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