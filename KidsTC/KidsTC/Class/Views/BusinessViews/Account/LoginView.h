//
//  LoginView.h
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginItemModel.h"

@class LoginView;

@protocol LoginViewDelegate <NSObject>

- (void)loginView:(LoginView *)loginView didClickedLoginButtonWithAccount:(NSString *)account password:(NSString *)password;

@end

@interface LoginView : UIView

@property (nonatomic, assign) id<LoginViewDelegate> delegate;

@property (nonatomic, strong) NSArray *supportedLoginItemModels;

@end
