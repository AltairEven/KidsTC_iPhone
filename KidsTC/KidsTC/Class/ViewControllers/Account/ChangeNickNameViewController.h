//
//  ChangeNickNameViewController.h
//  KidsTC
//
//  Created by Altair on 11/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"

typedef void(^ChangeNickNameComplete)(NSString *newName);

@interface ChangeNickNameViewController : GViewController

@property (nonatomic, strong) ChangeNickNameComplete completeBlock;

- (instancetype)initWithNickName:(NSString *)name;

@end
