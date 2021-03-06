//
//  CouponUsableListView.m
//  KidsTC
//
//  Created by 钱烨 on 9/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CouponUsableListView.h"
#import "CouponUsableListViewCell.h"


static NSString *const kContentCellIdentifier = @"kContentCellIdentifier";

@interface CouponUsableListView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *contentNib;

@property (nonatomic, strong) NSArray *listModels;

@property (nonatomic, assign) NSInteger currentSelectedIndex;

@end

@implementation CouponUsableListView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        CouponUsableListView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    if (!self.contentNib) {
        self.contentNib = [UINib nibWithNibName:NSStringFromClass([CouponUsableListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.contentNib forCellReuseIdentifier:kContentCellIdentifier];
    }
    
    self.currentSelectedIndex = - 1;
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listModels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponBaseModel *model = [self.listModels objectAtIndex:indexPath.section];
    CouponUsableListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kContentCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"CouponUsableListViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell configWithItemModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CouponUsableListViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    if ([self.listModels count] > 0) {
        [view setBackgroundColor:[UIColor whiteColor]];
    }
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentSelectedIndex == indexPath.section) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.currentSelectedIndex = -1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(couponUsableListView:didDeselectedCouponAtIndex:)]) {
            [self.delegate couponUsableListView:self didDeselectedCouponAtIndex:indexPath.section];
        }
    } else {
        self.currentSelectedIndex = indexPath.section;
        if (self.delegate && [self.delegate respondsToSelector:@selector(couponUsableListView:didSelectedCouponAtIndex:)]) {
            [self.delegate couponUsableListView:self didSelectedCouponAtIndex:indexPath.section];
        }
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(couponModelsOfCouponUsableListView:)]) {
        self.listModels = [self.dataSource couponModelsOfCouponUsableListView:self];
        [self.tableView reloadData];
    }
    if ([self.listModels count] == 0) {
        self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.frame.size.height) image:[UIImage imageNamed:@""] description:@"啥都木有啊···"];
    } else {
        self.tableView.backgroundView = nil;
    }
}

- (void)setIndex:(NSUInteger)index selected:(BOOL)selected {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    if (selected) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        self.currentSelectedIndex = index;
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.currentSelectedIndex = -1;
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
