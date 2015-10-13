//
//  AccountSettingView.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AccountSettingView.h"

@interface AccountSettingView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *userNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *passwordCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *mobilePhoneCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *emailCell;

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            [self.userNameCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            return self.userNameCell;
        }
            break;
        case 1:
        {
            [self.passwordCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            return self.passwordCell;
        }
            break;
        case 2:
        {
            [self.mobilePhoneCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            return self.mobilePhoneCell;
        }
            break;
        case 3:
        {
            [self.emailCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            return self.emailCell;
        }
            break;
        default:
            break;
    }
    return nil;
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
