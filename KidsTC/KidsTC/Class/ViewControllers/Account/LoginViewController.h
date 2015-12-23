//
//  LoginViewController.h
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^loginResultBlock)(NSString *, NSError*);

@interface LoginViewController : GViewController

@property (nonatomic, copy) loginResultBlock block;

@end
