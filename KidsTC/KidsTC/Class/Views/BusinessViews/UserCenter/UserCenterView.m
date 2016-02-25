//
//  UserCenterView.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "UserCenterView.h"

@interface UserCenterView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *userInfoContainerView;
@property (weak, nonatomic) IBOutlet UIView *userInfoBGView;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIView *signBGView;
@property (weak, nonatomic) IBOutlet UIImageView *BGImageView;
@property (strong, nonatomic) UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *carrotLabel;
@property (weak, nonatomic) IBOutlet UIView *myAppointTapView;
@property (weak, nonatomic) IBOutlet UIView *waitingPaymentTapView;
@property (weak, nonatomic) IBOutlet UIView *waitingCommentTapView;
@property (weak, nonatomic) IBOutlet UILabel *appointCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitpayCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitcommentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageBadgeLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *allOrderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *myFlashCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *carrotExchangeHistoryCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *myCommentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *myFavourateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *couponCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *messageCenterCell;

@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UILabel *userActivityLable;
@property (nonatomic, strong) UIImageView *userActivityIcon;
@property (nonatomic, strong) UIButton *userActivityButton;

@property (nonatomic, strong) UserCenterModel *dataModel;

@property (nonatomic, strong) NSMutableArray *cellsArray;

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
    self.signBGView.tag = UserCenterTagSignUp;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnView:)];
    [self.signBGView addGestureRecognizer:tapGesture];
    
    [self.bottomView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    
    self.faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.faceImageView.tag = 0;
    [self.faceImageView setImage:[UIImage imageNamed:@"userCenter_noLoginFace"]];
    [self.faceImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedfaceImageView)];
    [self.faceImageView addGestureRecognizer:gesture];
    [self.userInfoContainerView addSubview:self.faceImageView];
    
    self.faceImageView.layer.cornerRadius = self.faceImageView.frame.size.width / 2;
    self.faceImageView.layer.borderWidth = 4;
    self.faceImageView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
    self.faceImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnView:)];
    [self.myAppointTapView addGestureRecognizer:tap1];
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
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [self.tableFooterView setBackgroundColor:[UIColor clearColor]];
    
    self.userActivityLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 15)];
    [self.userActivityLable setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
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
    [self.userActivityButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.userActivityButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.userActivityButton setTitleColor:[[KTCThemeManager manager] defaultTheme].navibarTitleColor_Normal forState:UIControlStateNormal];
    [self.userActivityButton addTarget:self action:@selector(didClickedUserActivityButton) forControlEvents:UIControlEventTouchUpInside];
    [self.userActivityButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.userActivityButton.layer.cornerRadius = 3;
    self.userActivityButton.layer.masksToBounds = YES;
    [self.tableFooterView addSubview:self.userActivityButton];
    
    [self reloadTopView];
    
    self.messageBadgeLabel.layer.cornerRadius = 7;
    self.messageBadgeLabel.layer.masksToBounds = YES;
    [self.messageBadgeLabel setHidden:YES];
    
//    self.appointCountLabel.layer.cornerRadius = 7;
//    self.appointCountLabel.layer.masksToBounds = YES;
//    [self.appointCountLabel setHidden:YES];
    
    [self.appointCountLabel setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [self.waitpayCountLabel setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [self.waitcommentCountLabel setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [self.messageBadgeLabel setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [self.allOrderCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.myCommentCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.myFavourateCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.couponCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.messageCenterCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.myFlashCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.carrotExchangeHistoryCell.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
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
    return [self.cellsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.cellsArray objectAtIndex:indexPath.section];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(userCenterView:didClickedWithTag:)]) {
        UITableViewCell *cell = [self.cellsArray objectAtIndex:indexPath.section];
        [self.delegate userCenterView:self didClickedWithTag:(UserCenterTag)cell.tag];
    }
}

#pragma mark Private methods


- (void)reloadTopView {
//    CGFloat yPosition = (SCREEN_WIDTH * UserInfoRatio - 40) / 2;
    CGFloat yPosition = (SCREEN_WIDTH * 2 / 3 - 64 - 60) / 2;
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
        [self.carrotLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.dataModel.carrotCount]];
        
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
    if (!self.cellsArray) {
        self.cellsArray = [[NSMutableArray alloc] init];
    } else {
        [self.cellsArray removeAllObjects];
    }
    [self.cellsArray addObject:self.allOrderCell];
    if ([self.dataModel hasFlashOrder]) {
        [self.cellsArray addObject:self.myFlashCell];
    }
    if ([self.dataModel hasCarrotExchangeHistory]) {
        [self.cellsArray addObject:self.carrotExchangeHistoryCell];
    }
    [self.cellsArray addObject:self.myCommentCell];
    [self.cellsArray addObject:self.myFavourateCell];
    [self.cellsArray addObject:self.couponCell];
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
    [self.cellsArray addObject:self.messageCenterCell];
    
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
