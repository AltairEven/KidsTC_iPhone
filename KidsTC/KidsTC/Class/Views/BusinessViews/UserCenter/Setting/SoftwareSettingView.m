//
//  SoftwareSettingView.m
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "SoftwareSettingView.h"
#import "SoftwareSettingViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface SoftwareSettingView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) SoftwareSettingModel *settingModel;

@end

@implementation SoftwareSettingView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        SoftwareSettingView *view = [GConfig getObjectFromNibWithView:self];
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
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([SoftwareSettingViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SoftwareSettingViewTagFeedback + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SoftwareSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"SoftwareSettingViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    switch (indexPath.section) {
        case SoftwareSettingViewTagCache:
        {
            [cell resetWithMainTitle:@"清理图片缓存" subTitle:[self.settingModel cacheLengthDescription] showArrow:YES];
        }
            break;
        case SoftwareSettingViewTagVersion:
        {
            [cell resetWithMainTitle:@"当前版本" subTitle:self.settingModel.version showArrow:NO];
        }
            break;
        case SoftwareSettingViewTagShare:
        {
            [cell resetWithMainTitle:@"分享给好友" subTitle:nil showArrow:YES];
        }
            break;
        case SoftwareSettingViewTagAbout:
        {
            [cell resetWithMainTitle:@"关于我们" subTitle:nil showArrow:YES];
        }
            break;
        case SoftwareSettingViewTagFeedback:
        {
            [cell resetWithMainTitle:@"反馈" subTitle:nil showArrow:YES];
        }
            break;
        default:
            break;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(softwareSettingView:didClickedWithViewTag:)]) {
        [self.delegate softwareSettingView:self didClickedWithViewTag:(SoftwareSettingViewTag)indexPath.row];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(modelForSoftwareSettingView:)]) {
        self.settingModel = [self.dataSource modelForSoftwareSettingView:self];
    }
    [self.tableView reloadData];
}


#pragma mark Private methods


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
