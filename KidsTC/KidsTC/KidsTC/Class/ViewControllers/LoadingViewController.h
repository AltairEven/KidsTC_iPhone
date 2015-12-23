//
//  LoadingViewController.h
//  KidsTC
//
//  Created by 钱烨 on 8/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loading_complete)();

@interface LoadingViewController : UIViewController

@property (nonatomic, strong) loading_complete load_complete;

@end
