//
//  UserRoleSelectViewController.h
//  KidsTC
//
//  Created by 钱烨 on 11/5/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"

#define UserRoleDefaultKey (@"UserRoleDefaultKey")
#define UserSexDefaultKey (@"UserSexDefaultKey")


typedef void(^select_complete)(UserRole role, KTCSex sex);

@interface UserRoleSelectViewController : GViewController

@property (nonatomic, strong) select_complete completeBlock;

- (void)setSelectedRole:(UserRole)role;

@end
