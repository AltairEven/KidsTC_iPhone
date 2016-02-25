//
//  UserGuideViewController.h
//  KidsTC
//
//  Created by Altair on 2/19/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UserGuideViewTagHome,
    UserGuideViewTagUserCenter
}UserGuideViewTag;

@interface UserGuideViewController : UIViewController

+ (instancetype)instancetypeWithViewTag:(UserGuideViewTag)tag;

- (void)showFromViewController:(UIViewController *)controller;

- (void)dismiss;

@end
