/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：SystemBarWindow.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年10月19日
 */

#import <Foundation/Foundation.h>

#define NOTIFICATION_KEY_TAPPED         @"notifyTapSysBar"

typedef enum
{
    eSysStatNone = 0,
    eSysStatUpdate,
    eSysStatComplete,
    eSysStatNoNetwork
}eSystemStat;

@interface SystemBarWindow : UIWindow {
    
    UIView *                _currentView;
    UIImageView *           _curImgView;
    UILabel *               _curTitle;
    
    UIView *                _nextView;
    UIImageView *           _nextImgView;
    UILabel *               _nextTitle;
    
    eSystemStat             _currentStat;
    eSystemStat             _nextStat;
    
    BOOL                    _isExpand;
    
    NSTimer *               _hideTimer;
    BOOL                    _isAnimation;
    
}

@property (nonatomic) BOOL          expandOnTap;

+ (SystemBarWindow*) sharedSystemBarWindow;

- (void) setVisiableWithOldWindow:(UIWindow*)oldWindow;

- (void) showTitle:(NSString*)title;
- (void) showTitle:(NSString*)title hideAfter:(NSTimeInterval)duration;
- (void) showStat:(eSystemStat)stat withTitle:(NSString*)title animed:(BOOL)animed;
- (void) showStat:(eSystemStat)stat withTitle:(NSString*)title animed:(BOOL)animed hideAfter:(NSTimeInterval)duration;
- (void) dismissAnimed:(BOOL)animed;

- (eSystemStat) currentStat;
- (eSystemStat) nextStat;

- (void) expand:(BOOL)ifExpand;

@end
