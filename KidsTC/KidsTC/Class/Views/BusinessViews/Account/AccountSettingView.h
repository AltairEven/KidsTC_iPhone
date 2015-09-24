//
//  AccountSettingView.h
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountSettingView;

@protocol AccountSettingViewDelegate <NSObject>

- (void)didClickedLogoutButtonOnAccountSettingView:(AccountSettingView *)settingView;

@end

@interface AccountSettingView : UIView

@property (nonatomic, assign) id<AccountSettingViewDelegate> delegate;

- (void)reloadData;

@end
