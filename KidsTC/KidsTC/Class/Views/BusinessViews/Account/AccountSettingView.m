//
//  AccountSettingView.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AccountSettingView.h"
#import "AccountSettingViewCell.h"


static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface AccountSettingView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UINib *cellNib;

- (void)configCell:(AccountSettingViewCell *)cell withIndexPath:(NSIndexPath *)indexPath;

- (void)didClickedLogoutButton;

@end

@implementation AccountSettingView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        AccountSettingView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([AccountSettingViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"AccountSettingViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [self configCell:cell withIndexPath:indexPath];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 40)];
    [button setBackgroundColor:[AUITheme theme].buttonBGColor_Normal];
    [button setTitle:@"退出账号" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didClickedLogoutButton) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:button];
    return bgView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Public methods

- (void)reloadData {
    [self.tableView reloadData];
}


#pragma mark Private methods

- (void)configCell:(AccountSettingViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    if (!cell) {
        return;
    }
    
}

- (void)didClickedLogoutButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedLogoutButtonOnAccountSettingView:)]) {
        [self.delegate didClickedLogoutButtonOnAccountSettingView:self];
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
