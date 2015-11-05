//
//  UserRoleSelectViewController.h
//  KidsTC
//
//  Created by 钱烨 on 11/5/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"

#define UserRoleDefaultKey (@"UserRoleDefaultKey")


typedef void(^select_complete)(UserRole role);

@interface UserRoleSelectViewController : GViewController

@property (nonatomic, strong) select_complete completeBlock;

@end
