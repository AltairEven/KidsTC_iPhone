//
//  UserCenterView.m
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "UserCenterView.h"

#define UserInfoRatio (0.5)

@interface UserCenterView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *userInfoContainerView;
@property (weak, nonatomic) IBOutlet UIView *userInfoBGView;
@property (weak, nonatomic) IBOutlet UIImageView *BGImageView;
@property (strong, nonatomic) UIButton *faceButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *myAppointmentTapView;
@property (weak, nonatomic) IBOutlet UIView *waitingPaymentTapView;
@property (weak, nonatomic) IBOutlet UIView *waitingCommentTapView;
@property (weak, nonatomic) IBOutlet UILabel *appointCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitpayCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitcommentCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *allOrderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *couponCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *myFavourateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *settingCell;

@property (nonatomic, strong) UserCenterModel *dataModel;

- (void)buildSubviews;

- (void)reloadTopView;

- (void)didClickedFaceButton;

- (void)didTappedOnView:(id)sender;

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
    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceButton setFrame:CGRectMake(0, 0, 80, 80)];
    self.faceButton.tag = 0;
    [self.faceButton setImage:[UIImage imageNamed:@"userCenter_noLoginFace"] forState:UIControlStateNormal];
    [self.faceButton addTarget:self action:@selector(didClickedFaceButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.faceButton];
    
    self.faceButton.layer.cornerRadius = self.faceButton.frame.size.width / 2;
    self.faceButton.layer.borderWidth = 4;
    self.faceButton.layer.borderColor = RGBA(200, 100, 100, 1).CGColor;
    self.faceButton.layer.masksToBounds = YES;
    
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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    
    [self reloadTopView];
    
    [self.appointCountLabel setBackgroundColor:[AUITheme theme].globalThemeColor];
    [self.waitpayCountLabel setBackgroundColor:[AUITheme theme].globalThemeColor];
    [self.waitcommentCountLabel setBackgroundColor:[AUITheme theme].globalThemeColor];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            [self.allOrderCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            return self.allOrderCell;
        }
            break;
        case 1:{
            [self.couponCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            return self.couponCell;
        }
            break;
        case 2:{
            [self.myFavourateCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            return self.myFavourateCell;
        }
            break;
        case 3:{
            [self.settingCell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
            return self.settingCell;
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
    CGFloat yPosition = (SCREEN_WIDTH * UserInfoRatio - 60) / 2;
    if (self.dataModel) {
        CGFloat xPosition = SCREEN_WIDTH / 2 - 50;
        [UIView animateWithDuration:0.5 animations:^{
            [self.faceButton setCenter:CGPointMake(xPosition, yPosition)];
            [self.faceButton setImage:[UIImage imageNamed:@"userCenter_defaultFace"] forState:UIControlStateNormal];
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
        CGFloat xPosition = SCREEN_WIDTH * UserInfoRatio;
        [self.faceButton setCenter:CGPointMake(xPosition, yPosition)];
        [self.faceButton setImage:[UIImage imageNamed:@"userCenter_noLoginFace"] forState:UIControlStateNormal];
        
        [self.userInfoBGView setHidden:YES];
        
        [self.appointCountLabel setHidden:YES];
        [self.waitpayCountLabel setHidden:YES];
        [self.waitcommentCountLabel setHidden:YES];
    }
}

- (void)didClickedFaceButton {
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


#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(modelForUserCenterView:)]) {
        self.dataModel = [self.dataSource modelForUserCenterView:self];
        [self reloadTopView];
        [self.tableView reloadData];
    }
}

@end
