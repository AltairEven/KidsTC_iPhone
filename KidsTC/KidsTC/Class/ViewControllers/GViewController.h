/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GViewController.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：12-18-2012
 */

#import <UIKit/UIKit.h>
#import "GConfig.h"
#import "GConnectUselessView.h"

@class BaseViewModel;

@interface GViewController : UIViewController<GConnectUselessViewDelegate> {
    UITapGestureRecognizer *_tapGesture;
    NSString *_navigationTitle;
    BOOL showFirstTime;
}


@property (strong, nonatomic) GConnectUselessView *statusView;
@property BOOL isNavShowType;
@property BOOL isConnectFailed;
@property (nonatomic, assign) BOOL bTapToEndEditing;
@property (nonatomic, readonly) CGFloat keyboardHeight;

+ (GPageID)pageID;
- (void)setupBackBarButton;
- (void)setupLeftBarButton;
- (void)setupLeftBarButtonWithFrontImage:(NSString*)frontImgName andBackImage:(NSString *)backImgName;
- (void)setupRightBarButton:(NSString*)title target:(id)object action:(SEL)selector frontImage:(NSString*)frontImgName andBackImage:(NSString *)backImgName;
- (void)setRightBarButtonTitle:(NSString*)title frontImage:(NSString*)frontImgName andBackImage:(NSString *)backImgName;
- (void)goBackController:(id)sender;

- (void)showConnectError:(BOOL)show;
- (void)showConnectError:(BOOL)show opaqueBG:(BOOL)opaque;
- (void)reloadNetworkData;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillDisappear:(NSNotification *)notification;

- (UIView *)stairControledView;

@end
