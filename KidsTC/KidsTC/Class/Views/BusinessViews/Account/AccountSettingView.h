//
//  AccountSettingView.h
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountSettingModel.h"

typedef enum {
    AccountSettingViewTagFaceImage,
    AccountSettingViewTagNickName,
    AccountSettingViewTagPassword,
    AccountSettingViewTagMobilePhone,
    AccountSettingViewTagRole
}AccountSettingViewTag;

@class AccountSettingView;

@protocol AccountSettingViewDataSource <NSObject>

- (AccountSettingModel *)modelForAccountSettingView:(AccountSettingView *)view;

@end

@protocol AccountSettingViewDelegate <NSObject>

- (void)accountSettingView:(AccountSettingView *)settingView didClickedWithViewTag:(AccountSettingViewTag)tag;

- (void)didClickedLogoutButtonOnAccountSettingView:(AccountSettingView *)settingView;

@end

@interface AccountSettingView : UIView

@property (nonatomic, assign) id<AccountSettingViewDataSource> dataSource;

@property (nonatomic, assign) id<AccountSettingViewDelegate> delegate;

- (void)reloadData;

@end
