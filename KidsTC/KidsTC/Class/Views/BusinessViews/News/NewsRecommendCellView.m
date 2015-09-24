//
//  NewsRecommendCellView.m
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsRecommendCellView.h"
#import "NewsRecommendListModel.h"

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.bigImageCellNib) {
        self.bigImageCellNib = [UINib nibWithNibName:NSStringFromClass([NewsRecommendCellViewBigImageCell class]) bundle:nil];
        [self.tableView registerNib:self.bigImageCellNib forCellReuseIdentifier:kBigImageCellIdentifier];
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


@implementation NewsRecommendCellViewBigImageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 150;
}

@end

@implementation NewsRecommendCellViewSmallImageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 60;
}

@end