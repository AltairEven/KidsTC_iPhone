//
//  AccountSettingViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "AccountSettingView.h"

@interface AccountSettingViewModel : BaseViewModel

@property (nonatomic, strong, readonly) AccountSettingModel *settingModel;

- (void)setUserRole:(UserRole)role;

- (void)setMobilePhone:(NSString *)number;

@end
