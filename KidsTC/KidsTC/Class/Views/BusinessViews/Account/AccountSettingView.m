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

@property (nonatomic, strong) AccountSettingModel *settingModel;

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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 40)];
    [button setBackgroundColor:[AUITheme theme].buttonBGColor_Normal];
    [button setTitle:@"退出账号" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didClickedLogoutButton) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = bgView;
    
    [bgView addSubview:button];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return AccountSettingViewTagPassword + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"AccountSettingViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    switch (indexPath.section) {
        case AccountSettingViewTagFaceImage:
        {
            cell.cellImageUrl = self.settingModel.faceImageUrl;
            cell.cellImage = self.settingModel.faceImage;
            [cell resetWithMainTitle:@"头像" subTitle:@"" showImage:YES showArrow:YES];
        }
            break;
        case AccountSettingViewTagRole:
        {
            [cell resetWithMainTitle:@"状态" subTitle:self.settingModel.userRole.roleName showImage:NO showArrow:YES];
        }
            break;
        case AccountSettingViewTagNickName:
        {
            [cell resetWithMainTitle:@"昵称" subTitle:self.settingModel.userName showImage:NO showArrow:YES];
        }
            break;
        case AccountSettingViewTagMobilePhone:
        {
            NSString *phone = self.settingModel.phone;
            NSString *phoneDes = @"未绑定手机";
            if ([phone length] > 0) {
                phoneDes = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            [cell resetWithMainTitle:@"手机号" subTitle:phoneDes showImage:NO showArrow:NO];
        }
            break;
        case AccountSettingViewTagPassword:
        {
            [cell resetWithMainTitle:@"修改密码" subTitle:@"" showImage:NO showArrow:YES];
        }
            break;
        default:
            break;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = [AccountSettingViewCell imageCellHeight];
    } else {
        height = [AccountSettingViewCell normalCellHeight];
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2.5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(accountSettingView:didClickedWithViewTag:)]) {
        [self.delegate accountSettingView:self didClickedWithViewTag:(AccountSettingViewTag)indexPath.section];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(modelForAccountSettingView:)]) {
        self.settingModel = [self.dataSource modelForAccountSettingView:self];
    }
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
