/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：BaseAlertView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年10月09日
 */

#import <UIKit/UIKit.h>


@interface BaseAlertView : UIView {
@protected 
    UIView *                _contentView;
    UIInterfaceOrientation  _orientation;
    BOOL                    _showing;
    BOOL                    _presented;
}

@property (nonatomic, readonly) BOOL visible;
@property (nonatomic, readwrite, strong) IBOutlet UIView *contentView;

- (void)show;
- (void)showAndFitScreen;
- (void)dismissAnimated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated completion:(void(^)())block;

// Must override to return content view.
- (void)loadContentView;

// Default to do nothing. Override to handle event
- (void)willPresentAlertView;
- (void)didPresentAlertView;
- (void)willDismissAlertView;
- (void)didDismissAlertView;

@end
