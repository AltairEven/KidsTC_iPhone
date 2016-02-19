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
    UserCenterTagMyAppointment = 1,
    UserCenterTagWaitingPay = 2,
    UserCenterTagWaitingComment = 3,
    UserCenterTagAllOrder = 4,
    UserCenterTagMyComment = 5,
    UserCenterTagMyFavourate = 6,
    UserCenterTagCoupon = 7,
    UserCenterTagMessageCenter = 8,
    UserCenterTagSignUp = 9
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
