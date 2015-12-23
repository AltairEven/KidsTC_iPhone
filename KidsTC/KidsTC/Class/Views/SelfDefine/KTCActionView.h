//
//  KTCActionView.h
//  KidsTC
//
//  Created by Altair on 11/18/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KTCActionViewTagHome,
    KTCActionViewTagSearch,
    KTCActionViewTagShare
}KTCActionViewTag;

@class KTCActionView;

@protocol KTCActionViewDelegate <NSObject>

- (void)actionViewDidClickedWithTag:(KTCActionViewTag)tag;

@end

@interface KTCActionView : UIView

@property (nonatomic, weak) id<KTCActionViewDelegate> delegate;

@property (nonatomic, readonly) BOOL isShowing;

+ (instancetype)actionView;

- (void)showInViewController:(UIViewController *)viewController;

- (void)hide;

@end
