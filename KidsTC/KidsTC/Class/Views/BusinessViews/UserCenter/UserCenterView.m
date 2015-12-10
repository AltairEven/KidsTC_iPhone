//
//  UserCenterView.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "UserCenterView.h"

#define UserInfoRatio (0.6)

@interface UserCenterView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *userInfoContainerView;
@property (weak, nonatomic) IBOutlet UIView *userInfoBGView;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIImageView *BGImageView;
@property (strong, nonatomic) UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *myAppointmentTapView;
@property (weak, nonatomic) IBOutlet UIView *waitingPaymentTapView;
@property (weak, nonatomic) IBOutlet UIView *waitingCommentTapView;
@property (weak, nonatomic) IBOutlet UILabel *appointCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitpayCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitcommentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageBadgeLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *allOrderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *myCommentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *myFavourateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *couponCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *messageCenterCell;

@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UILabel *userActivityLable;
@property (nonatomic, strong) UIImageView *userActivityIcon;
@property (nonatomic, strong) UIButton *userActivityButton;

@property (nonatomic, strong) UserCenterModel *dataModel;

- (void)buildSubviews;

- (void)reloadTopView;

- (void)didClickedfaceImageView;

- (void)didTappedOnView:(id)sender;

- (IBAction)didClickedSettingButton:(id)sender;

- (void)didClickedUserActivityButton;

@end

@implementation UserCenterView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        UserCenterView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self.bottomView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.faceImageView.tag = 0;
    [self.faceImageView setImage:[UIImage imageNamed:@"userCenter_noLoginFace"]];
    [self.faceImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedfaceImageView)];
    [self.faceImageView addGestureRecognizer:gesture];
    [self addSubview:self.faceImageView];
    
    self.faceImageView.layer.cornerRadius = self.faceImageView.frame.size.width / 2;
    self.faceImageView.layer.borderWidth = 4;
    self.faceImageView.layer.borderColor = RGBA(200, 100, 100, 1).CGColor;
    self.faceImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnView:)];
    [self.myAppointmentTapView addGestureRecognizer:tap1];
    self.appointCountLabel.layer.cornerRadius = 7;
    self.appointCountLabel.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnView:)];
    [self.waitingPaymentTapView addGestureRecognizer:tap2];
    self.waitpayCountLabel.layer.cornerRadius = 7;
    self.waitpayCountLabel.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnView:)];
    [self.waitingCommentTapView addGestureRecognizer:tap3];
    self.waitcommentCountLabel.layer.cornerRadius = 7;
    self.waitcommentCountLabel.layer.masksToBounds = YES;
    
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [self.tableFooterView setBackgroundColor:[UIColor clearColor]];
    
    self.userActivityLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 15)];
    [self.userActivityLable setTextColor:[AUITheme theme].globalThemeColor];
    [self.userActivityLable setFont:[UIFont systemFontOfSize:12]];
    [self.userActivityLable setBackgroundColor:[UIColor clearColor]];
    [self.userActivityLable setLineBreakMode:NSLineBreakByCharWrapping];
    [self.userActivityLable setNumberOfLines:2];
    [self.userActivityLable setBackgroundColor:[UIColor clearColor]];
    [self.tableFooterView addSubview:self.userActivityLable];
    
    self.userActivityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    [self.userActivityIcon setBackgroundColor:[UIColor clearColor]];
    [self.tableFooterView addSubview:self.userActivityIcon];
    
    self.userActivityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userActivityButton setFrame:CGRectMake(20, 30, SCREEN_WIDTH - 40, 40)];
    [self.userActivityButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.userActivityButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.userActivityButton setTitleColor:[AUITheme theme].navibarTitleColor_Normal forState:UIControlStateNormal];
    [self.userActivityButton addTarget:self action:@selector(didClickedUserActivityButton) forControlEvents:UIControlEventTouchUpInside];
    [self.userActivityButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.userActivityButton.layer.cornerRadius = 3;
    self.userActivityButton.layer.masksToBounds = YES;
    [self.tableFooterView addSubview:self.userActivityButton];
    
    [self reloadTopView];
    
    self.messageBadgeLabel.layer.cornerRadius = 7;
    self.messageBadgeLabel.layer.masksToBounds = YES;
    [self.messageBadgeLabel setHidden:YES];
    
    [self.appointCountLabel setBackgroundColor:[AUITheme theme].globalThemeColor];
    [self.waitpayCountLabel setBackgroundColor:[AUITheme theme].globalThemeColor];
    [self.waitcommentCountLabel setBackgroundColor:[AUITheme theme].globalThemeColor];
    [self.messageBadgeLabel setBackgroundColor:[AUITheme theme].globalThemeColor];
    [self.allOrderCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    [self.myCommentCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    [self.myFavourateCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    [self.couponCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    [self.messageCenterCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return UserCenterTagMessageCenter - UserCenterTagWaitingComment;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            return self.allOrderCell;
        }
            break;
        case 1:{
            return self.myCommentCell;
        }
            break;
        case 2:{
            return self.myFavourateCell;
        }
            break;
        case 3:{
            return self.couponCell;
        }
            break;
        case 4:{
            if ([self.dataModel hasUnreadMessage]) {
                [self.messageBadgeLabel setHidden:NO];
                NSString *countString = @"";
                if (self.dataModel.unreadMessageCount > 99) {
                    countString = @"99+";
                    [self.messageBadgeLabel setFont:[UIFont systemFontOfSize:6]];
                } else {
                    [self.messageBadgeLabel setFont:[UIFont systemFontOfSize:10]];
                    countString = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataModel.unreadMessageCount];
                }
                [self.messageBadgeLabel setText:countString];
            } else {
                [self.messageBadgeLabel setHidden:YES];
            }
            return self.messageCenterCell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(userCenterView:didClickedWithTag:)]) {
        UserCenterTag tag = (UserCenterTag)indexPath.section + 4;
        [self.delegate userCenterView:self didClickedWithTag:tag];
    }
}

#pragma mark Private methods


- (void)reloadTopView {
    CGFloat yPosition = (SCREEN_WIDTH * UserInfoRatio - 40) / 2;
    if (self.dataModel) {
        CGFloat xPosition = SCREEN_WIDTH / 2 - 50;
        UIImage *placeHolder = [UIImage imageNamed:@"userCenter_defaultFace_boy"];
        if ([KTCUser currentUser].userRole.sex == KTCSexFemale) {
            placeHolder = [UIImage imageNamed:@"userCenter_defaultFace_girl"];
        }
        [UIView animateWithDuration:0.5 animations:^{
            [self.faceImageView setCenter:CGPointMake(xPosition, yPosition)];
            [self.faceImageView setImageWithURL:self.dataModel.faceImageUrl placeholderImage:placeHolder];
            [self.userInfoBGView setHidden:NO];
        }];
        
        [self.userNameLabel setText:self.dataModel.userName];
        [self.levelTitleLabel setText:self.dataModel.levelTitle];
        [self.scoreLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.dataModel.score]];
        
        if (self.dataModel.appointmentOrderCount > 0) {
            [self.appointCountLabel setHidden:NO];
            NSString *countText = @"...";
            if (self.dataModel.appointmentOrderCount <= 99) {
                countText = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataModel.appointmentOrderCount];
            }
            [self.appointCountLabel setText:countText];
        } else {
            [self.appointCountLabel setHidden:YES];
        }
        
        if (self.dataModel.waitingPaymentOrderCount > 0) {
            [self.waitpayCountLabel setHidden:NO];
            NSString *countText = @"...";
            if (self.dataModel.waitingPaymentOrderCount <= 99) {
                countText = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataModel.waitingPaymentOrderCount];
            }
            [self.waitpayCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.dataModel.waitingPaymentOrderCount]];
        } else {
            [self.waitpayCountLabel setHidden:YES];
        }
        
        if (self.dataModel.waitingCommentOrderCount > 0) {
            [self.waitcommentCountLabel setHidden:NO];
            NSString *countText = @"...";
            if (self.dataModel.waitingCommentOrderCount <= 99) {
                countText = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataModel.waitingCommentOrderCount];
            }
            [self.waitcommentCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.dataModel.waitingCommentOrderCount]];
        } else {
            [self.waitcommentCountLabel setHidden:YES];
        }
        
    } else {
        CGFloat xPosition = SCREEN_WIDTH / 2;
        [self.faceImageView setCenter:CGPointMake(xPosition, yPosition)];
        [self.faceImageView setImage:[UIImage imageNamed:@"userCenter_noLoginFace"]];
        
        [self.userInfoBGView setHidden:YES];
        
        [self.appointCountLabel setHidden:YES];
        [self.waitpayCountLabel setHidden:YES];
        [self.waitcommentCountLabel setHidden:YES];
    }
}

- (void)didClickedfaceImageView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userCenterView:didClickedWithTag:)]) {
        [self.delegate userCenterView:self didClickedWithTag:UserCenterTagFace];
    }
}

- (void)didTappedOnView:(id)sender {
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    UIView *gestureView = gesture.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(userCenterView:didClickedWithTag:)]) {
        [self.delegate userCenterView:self didClickedWithTag:(UserCenterTag)(gestureView.tag)];
    }
}

- (IBAction)didClickedSettingButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSoftwareButtonOnUserCenterView:)]) {
        [self.delegate didClickedSoftwareButtonOnUserCenterView:self];
    }
}

- (void)didClickedUserActivityButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedUserActivityButtonOnUserCenterView:)]) {
        [self.delegate didClickedUserActivityButtonOnUserCenterView:self];
    }
}


#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(modelForUserCenterView:)]) {
        self.dataModel = [self.dataSource modelForUserCenterView:self];
        [self reloadTopView];
    }
    [self.tableView reloadData];
    if ([self.dataModel hasUserActivity]) {
        [self.userActivityLable setText:self.dataModel.activityModel.activityDescription];
        CGFloat height = [self.userActivityLable sizeToFitWithMaximumNumberOfLines:2];
        [self.userActivityLable setCenter:CGPointMake(SCREEN_WIDTH / 2, height)];
        
        [self.userActivityIcon setImageWithURL:self.dataModel.activityModel.iconUrl];
        [self.userActivityIcon setCenter:CGPointMake(self.userActivityLable.frame.origin.x - 10, self.userActivityLable.center.y)];
        
        [self.userActivityButton setTitle:self.dataModel.activityModel.buttonTitle forState:UIControlStateNormal];
        self.tableView.tableFooterView = self.tableFooterView;
    } else {
        self.tableView.tableFooterView = nil;
    }
}

@end
