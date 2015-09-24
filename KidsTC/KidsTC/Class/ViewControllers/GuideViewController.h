//
//  GuideViewController.h
//  ICSON
//
//  Created by ivy on 15/3/10.
//  Copyright (c) ivy. All rights reserved.
//  引导介绍页面

#import <UIKit/UIKit.h>

typedef void(^guide_complete)();

@interface GuideViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger imgCount;
@property (nonatomic, strong) guide_complete guide_complete;
@end
