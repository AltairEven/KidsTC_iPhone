//
//  ParentingStrategyDetailView.m
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyDetailView.h"
#import "ParentingStrategyDetailViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface ParentingStrategyDetailView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *itemModels;

@end

@implementation ParentingStrategyDetailView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        ParentingStrategyDetailView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([ParentingStrategyDetailViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemModels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParentingStrategyDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"ParentingStrategyViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell configWithDetailCellModel:[self.itemModels objectAtIndex:indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParentingStrategyDetailCellModel *model = [self.itemModels objectAtIndex:indexPath.row];
    return [model cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
