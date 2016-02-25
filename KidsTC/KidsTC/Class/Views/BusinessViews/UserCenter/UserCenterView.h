//
//  UserCenterView.h
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCenterModel.h"

typedef enum {
    UserCenterTagFace = 0,
    UserCenterTagSignUp = 1,
    UserCenterTagMyAppointment = 2,
    UserCenterTagWaitingPay = 3,
    UserCenterTagWaitingComment = 4,
    UserCenterTagAllOrder = 5,
    UserCenterTagMyFlash = 6,
    UserCenterTagCarrotExchangeHistory = 7,
    UserCenterTagMyComment = 8,
    UserCenterTagMyFavourate = 9,
    UserCenterTagCoupon = 10,
    UserCenterTagMessageCenter = 11,
}UserCenterTag;

@class UserCenterView;

@protocol UserCenterViewDataSource <NSObject>

- (UserCenterModel *)modelForUserCenterView:(UserCenterView *)view;

@end

@protocol UserCenterViewDelegate <NSObject>

- (void)didClickedSoftwareButtonOnUserCenterView:(UserCenterView *)view;

- (void)userCenterView:(UserCenterView *)view didClickedWithTag:(UserCenterTag)tag;

- (void)didClickedUserActivityButtonOnUserCenterView:(UserCenterView *)view;

@end

@interface UserCenterView : UIView

@property (nonatomic, assign) id<UserCenterViewDataSource> dataSource;
@property (nonatomic, assign) id<UserCenterViewDelegate> delegate;

- (void)reloadData;

@end
