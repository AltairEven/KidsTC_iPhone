/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：SystemBarWindow.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年10月19日
 */

#import "SystemBarWIndow.h"
#import "Constants.h"
#import "NSTimer+Blocks.h"

#define SYSTEM_BAR_HEIGHT               20
#define SYSTEM_BAR_ICON_RECT            CGRectMake(0, 0, 27, 20)
#define SharedApp                       [UIApplication sharedApplication]
#define DefaultNfCenter                 [NSNotificationCenter defaultCenter]

@interface SystemBarWindow ()

- (void)handleTap:(UIGestureRecognizer*)sender;
- (UIImage*) imageByStat:(eSystemStat)stat;
- (void) swapViews;

- (void) registerObservers;
- (void) unregisterObservers;
- (void) deviceOrientationDidChange:(NSNotification *)notification;
- (void) autoFitOrientation;

@end


@implementation SystemBarWindow

static SystemBarWindow* sSystemBarWindow = nil;

+ (SystemBarWindow*) sharedSystemBarWindow
{
    if (sSystemBarWindow == nil)
    {
        sSystemBarWindow = [[SystemBarWindow alloc] init];
    }
    return sSystemBarWindow;
}

- (id) init
{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);//[[UIApplication sharedApplication] statusBarFrame];
    self = [super initWithFrame:frame];
    if (nil != self) {
        self.windowLevel = UIWindowLevelAlert;
        self.backgroundColor = [UIColor clearColor];
        [self setClipsToBounds:YES];
        
        CGRect initRect = frame;
        
        _currentView = [[UIView alloc] initWithFrame:initRect];
        _currentView.backgroundColor = [UIColor blackColor];
        _currentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        _currentView.transform = CGAffineTransformMakeTranslation(0, SYSTEM_BAR_HEIGHT);
        [self addSubview:_currentView];
        
        _curTitle = [[UILabel alloc] initWithFrame:frame];
        _curTitle.textAlignment = NSTextAlignmentCenter;
        _curTitle.textColor = [UIColor whiteColor];
        _curTitle.backgroundColor = [UIColor clearColor];
        [_curTitle setFont:[UIFont systemFontOfSize:14.0f]];
        _curTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        [_currentView addSubview:_curTitle];
        
        _curImgView = [[UIImageView alloc] initWithFrame:SYSTEM_BAR_ICON_RECT];
        [_currentView addSubview:_curImgView];
        
        _nextView = [[UIView alloc] initWithFrame:initRect];
        _nextView.backgroundColor = [UIColor blackColor];
        _nextView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        _nextView.transform = CGAffineTransformMakeTranslation(0, SYSTEM_BAR_HEIGHT);
        [self addSubview:_nextView];
        
        _nextTitle = [[UILabel alloc] initWithFrame:frame];
        _nextTitle.textAlignment = NSTextAlignmentCenter;
        _nextTitle.textColor = [UIColor whiteColor];
        _nextTitle.backgroundColor = [UIColor clearColor];
        [_nextTitle setFont:[UIFont systemFontOfSize:14.0f]];
        _nextTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        [_nextView addSubview:_nextTitle];
        
        _nextImgView = [[UIImageView alloc] initWithFrame:SYSTEM_BAR_ICON_RECT];
        [_nextView addSubview:_nextImgView];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];
        
        _nextStat = _currentStat = eSysStatNone;
        _isExpand = YES;
        
        [self registerObservers];
    }
    return self;
}

- (void) dealloc 
{
    [self unregisterObservers];
    
    [_hideTimer invalidate];
    _hideTimer = nil;
}

- (void)setVisiableWithOldWindow:(UIWindow *)oldWindow
{
    if (nil == oldWindow) {
        oldWindow = [[UIApplication sharedApplication] keyWindow];
    }
    [self makeKeyAndVisible];
    [oldWindow makeKeyAndVisible];
}

- (void) showTitle:(NSString*)title
{
    [self showStat:eSysStatUpdate withTitle:title animed:YES];
}

- (void) showTitle:(NSString*)title hideAfter:(NSTimeInterval)duration
{
    [self showStat:eSysStatUpdate withTitle:title animed:YES hideAfter:duration];
}

- (void) showStat:(eSystemStat)stat withTitle:(NSString*)title animed:(BOOL)animed
{
    [self showStat:stat withTitle:title animed:animed hideAfter:0];
}

- (void) showStat:(eSystemStat)stat withTitle:(NSString*)title animed:(BOOL)animed hideAfter:(NSTimeInterval)duration
{
    [_hideTimer invalidate];
    _hideTimer = nil;
    
    
    if (CGRectEqualToRect([SharedApp statusBarFrame], CGRectZero)) {
        return;
    }
    
    if (eSysStatNone == stat) {
        [self dismissAnimed:animed];
        return;
    }
    
    if (_isAnimation && _nextStat == stat) {
        _curTitle.text = title;
        return;
    }
    
    _isAnimation = animed;
    self.userInteractionEnabled = YES;
    
    [self autoFitOrientation];
    
    if (!animed) 
    {
        _currentStat = _nextStat = stat;
        _curTitle.text = title;
        _curImgView.image = [self imageByStat:stat];
        _currentView.transform = CGAffineTransformIdentity;
        _nextView.transform = CGAffineTransformMakeTranslation(0, SYSTEM_BAR_HEIGHT);
    } 
    else 
    {
        if (eSysStatNone == _currentStat && eSysStatNone == _nextStat) 
        {
            _nextStat = stat;
            _curTitle.text = title;
            _curImgView.image = [self imageByStat:stat];
            _currentView.transform = CGAffineTransformMakeTranslation(0, SYSTEM_BAR_HEIGHT);
            _nextView.transform = CGAffineTransformMakeTranslation(0, SYSTEM_BAR_HEIGHT);
            [UIView animateWithDuration:.25 animations:^{
                _currentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _currentStat = stat;
                _isAnimation = NO;
            }];
        }
        else
        {
            _nextStat = stat;
            _nextTitle.text = title;
            _nextImgView.image = [self imageByStat:stat];
            [UIView animateWithDuration:.25 animations:^{
                _currentView.transform = CGAffineTransformMakeTranslation(0, -SYSTEM_BAR_HEIGHT);
                _nextView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [self swapViews];
                _nextView.transform = CGAffineTransformMakeTranslation(0, SYSTEM_BAR_HEIGHT);
                _currentStat = stat;
                _isAnimation = NO;
            }];
        }
        
        if (duration > 0) {
            _hideTimer = [NSTimer scheduledTimerWithTimeInterval:duration+0.25 block:^{
                [self dismissAnimed:YES];
            } repeats:NO];
        }
    }
}

- (void) dismissAnimed:(BOOL)animed
{
    [_hideTimer invalidate];
    _hideTimer = nil;
    
    if (_nextStat == eSysStatNone) {
        return;
    }
    
    _isAnimation = animed;
    
    if (!animed) {
        _currentView.transform = CGAffineTransformMakeTranslation(0, SYSTEM_BAR_HEIGHT);
        _nextView.transform = CGAffineTransformMakeTranslation(0, SYSTEM_BAR_HEIGHT);
        _nextStat = _currentStat = eSysStatNone;
        self.userInteractionEnabled = NO;
    } else {
        [UIView animateWithDuration:.25 animations:^{
            _currentView.transform = CGAffineTransformMakeTranslation(0, -SYSTEM_BAR_HEIGHT);
        } completion:^(BOOL finished) {
            _currentView.transform = CGAffineTransformMakeTranslation(0, SYSTEM_BAR_HEIGHT);
            _nextView.transform = CGAffineTransformMakeTranslation(0, SYSTEM_BAR_HEIGHT);
            _nextStat = _currentStat = eSysStatNone;
            self.userInteractionEnabled = NO;
            _isAnimation = NO;
        }];
    }
}

- (eSystemStat) currentStat {
    return _currentStat;
}

- (eSystemStat) nextStat {
    return _nextStat;
}

- (void) expand:(BOOL)ifExpand
{
    _isExpand = ifExpand;
    
    [UIView animateWithDuration:.25 animations:^{
        [self autoFitOrientation];
    }];
}


#pragma mark - Private


- (void)handleTap:(UIGestureRecognizer*)sender 
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KEY_TAPPED object:nil];
    
    if (_expandOnTap) {
        [self expand:!_isExpand];
    }
}

- (UIImage*) imageByStat:(eSystemStat)stat
{
    NSString * imgName = nil;
    switch (stat) {
        case eSysStatUpdate:
            imgName = @"image_icon_downloading.png";
            break;
        case eSysStatComplete:
            imgName = @"image_icon_download_completed.png";
            break;
        case eSysStatNoNetwork:
            imgName = @"image_icon_downloading_error.png";
            break;
        default:
            break;
    }
    if (imgName) {
        return [UIImage imageNamed:imgName];
    }
    return nil;
}

- (void) swapViews
{
    UIView * tmpView = _currentView;
    _currentView = _nextView;
    _nextView = tmpView;
    
    UIImageView * tmpImg = _curImgView;
    _curImgView = _nextImgView;
    _nextImgView = tmpImg;
    
    UILabel * tmpLabel = _curTitle;
    _curTitle = _nextTitle;
    _nextTitle = tmpLabel;
}

- (void) registerObservers {
    [DefaultNfCenter addObserver:self
                        selector:@selector(deviceOrientationDidChange:)
                            name:UIDeviceOrientationDidChangeNotification
                          object:nil];
}
- (void) unregisterObservers {
    [DefaultNfCenter removeObserver:self
                               name:UIDeviceOrientationDidChangeNotification
                             object:nil];
}

- (void) deviceOrientationDidChange:(NSNotification *)notification
{
    if (notification.userInfo) {
        NSNumber * boolNumber = [notification.userInfo objectForKey:@"needAnim"];
        if (boolNumber && ![boolNumber boolValue]) {
            [self autoFitOrientation];
            return;
        }
    }
    
    [UIView animateWithDuration:[SharedApp statusBarOrientationAnimationDuration] 
                     animations:^{
                         [self autoFitOrientation];
                     }];
}

- (void) autoFitOrientation
{
    CGRect rcStatus = [SharedApp statusBarFrame];
    
    CGFloat midX = CGRectGetMidX(rcStatus);
    CGFloat midY = CGRectGetMidY(rcStatus);
    self.center = CGPointMake(midX, midY);
    
    UIInterfaceOrientation orient = [SharedApp statusBarOrientation];
    if (orient == UIInterfaceOrientationLandscapeLeft) 
    {
        self.bounds = CGRectMake(0, 0, 480, 20);
        self.transform = _isExpand ? CGAffineTransformMakeRotation(-M_PI/2.0) : CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI/2.0), 450, 0);
    } 
    else if (orient == UIInterfaceOrientationLandscapeRight) 
    {
        self.bounds = CGRectMake(0, 0, 480, 20);
        self.transform = _isExpand ? CGAffineTransformMakeRotation(M_PI/2.0) : CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI/2.0), 450, 0);
    }
    else if (orient == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
        self.transform = _isExpand ? CGAffineTransformMakeRotation(-M_PI) : CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI), 290, 0);
    } 
    else 
    {
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
        self.transform = _isExpand ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(290, 0);
    }
}

@end

