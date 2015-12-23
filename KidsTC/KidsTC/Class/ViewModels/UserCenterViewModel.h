//
//  UserCenterViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "UserCenterView.h"


@interface UserCenterViewModel : BaseViewModel

@property (nonatomic, strong, readonly) UserCenterModel *dataModel;

- (void)resetUserCenterModel;

@end
