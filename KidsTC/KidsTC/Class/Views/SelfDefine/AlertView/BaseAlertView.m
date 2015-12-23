/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：BaseAlertView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年10月09日
 */

#import "BaseAlertView.h"
#import "MaskWindow.h"
//#import "UtilClass.h"

#pragma mark -
#pragma mark Global

static CGFloat kTransitionDuration = 0.3;
static NSMutableArray *gViewStack = nil;
static UIWindow *gPreviouseKeyWindow = nil;
static UIWindow *gMaskWindow = nil;

#define SharedApp [UIApplication sharedApplication]
#define DefaultNfCenter [NSNotificationCenter defaultCenter]


#pragma mark -

@interface BaseAlertView(PrivateMethods)

- (void)sizeToFitOrientation:(BOOL)transform;

- (void)bounce;

- (void)registerObservers;
- (void)unregisterObservers;

- (void)deviceOrientationDidChange:(NSNotification *)notification;

- (void)dismissCleanup;

+ (void)maskWindowPresent;
+ (void)maskWindowDismiss;
+ (void)maskWindowAddView:(BaseAlertView *)view;
+ (void)maskWindowRemoveView:(BaseAlertView *)view;

+ (void)viewStackPush:(BaseAlertView *)view;
+ (void)viewStackPop;
+ (BaseAlertView *)viewStackTopItem;

@end


@implementation BaseAlertView(PrivateMethods)

- (void)sizeToFitOrientation:(BOOL)transform{
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    _orientation = SharedApp.statusBarOrientation;
    [self sizeToFit];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.center = CGPointMake(screenSize.width/2, screenSize.height/2);
    
    if (transform) {
        self.transform = [GToolUtil transformForCurrentOrientation];
    }
}

- (void)bounce{
    // Start view pop out animation
    CGAffineTransform base = self.transform;
    
    self.transform = CGAffineTransformConcat(base, CGAffineTransformMakeScale(0.5f, 0.5f));
    
    [UIView animateWithDuration:kTransitionDuration/1.5f 
                     animations:^(void) {
                         self.transform = CGAffineTransformConcat(base, CGAffineTransformMakeScale(1.1f, 1.1f));
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:kTransitionDuration/2.0f
                                          animations:^(void) {
                                              self.transform = CGAffineTransformConcat(base, CGAffineTransformMakeScale(0.85f, 0.85f));
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:kTransitionDuration/1.5f
                                                               animations:^(void) {
                                                                   self.transform = base;
                                                                   if (!_presented) {
                                                                       [self didPresentAlertView];
                                                                       _presented = YES;
                                                                   }
                                                               }];
                                          }];
                     }];
}


- (void)registerObservers{
    [DefaultNfCenter addObserver:self
                        selector:@selector(deviceOrientationDidChange:)
                            name:UIDeviceOrientationDidChangeNotification
                          object:nil];
}
- (void)unregisterObservers{
    [DefaultNfCenter removeObserver:self
                               name:UIDeviceOrientationDidChangeNotification
                             object:nil];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification{
    [UIView animateWithDuration:[SharedApp statusBarOrientationAnimationDuration] 
                     animations:^{
                         [self sizeToFitOrientation:YES];
                     }];
}

- (void)dismissCleanup{
    [BaseAlertView maskWindowRemoveView:self];
    
    // If there are no view visible, dissmiss mask window too.
    if (![BaseAlertView viewStackTopItem]) {
        [BaseAlertView maskWindowDismiss];
    }
    
    [self unregisterObservers];
    
    [self didDismissAlertView];
    
}

#pragma mark -

+ (void)maskWindowPresent{
    
    // Only if mask window is not presented,\
    then prepare mask window and show fading in.
    if (nil == gMaskWindow) {
        gMaskWindow = [[MaskWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//#warning temp fix webview keyboard covered bug
        gMaskWindow.windowLevel = UIWindowLevelNormal;
        gMaskWindow.backgroundColor = [UIColor clearColor];
        gMaskWindow.hidden = YES;
        
        gPreviouseKeyWindow = [SharedApp keyWindow];
        [gMaskWindow makeKeyAndVisible];
        
        // Fade in background 
        gMaskWindow.alpha = 0;
        [UIView animateWithDuration:kTransitionDuration animations:^{
            gMaskWindow.alpha = 1;
        }];
    }
}

+ (void)maskWindowDismiss{
    // make previouse window the key again
    if (gMaskWindow) {
        // [gPreviouseKeyWindow makeKeyAndVisible] will make the top view of gPreviouseKeyWindow
        // invisible. Dont know the reason.
        [gPreviouseKeyWindow makeKeyWindow];
        gPreviouseKeyWindow = nil;
        
        gMaskWindow = nil;
    }
}

+ (void)maskWindowAddView:(BaseAlertView *)view{
    if (!gMaskWindow ||
        [gMaskWindow.subviews containsObject:view]) {
        return;
    }
    
    [gMaskWindow addSubview:view];
    view.hidden = NO;
    
    BaseAlertView *previousView = [BaseAlertView viewStackTopItem];
    if (previousView) {
        previousView.hidden = YES;
    }
    [BaseAlertView viewStackPush:view];
}

+ (void)maskWindowRemoveView:(BaseAlertView *)view{
    if (!gMaskWindow ||
        ![gMaskWindow.subviews containsObject:view]) {
        return;
    }
    
    [view removeFromSuperview];
    view.hidden = YES;
    
    [BaseAlertView viewStackPop];
    BaseAlertView *previousView = [BaseAlertView viewStackTopItem];
    if (previousView) {
        previousView.hidden = NO;
        [previousView bounce];
    }
}

+ (void)viewStackPush:(BaseAlertView *)view{
    if (!gViewStack) {
        gViewStack = [[NSMutableArray alloc] initWithCapacity:8];
    }
    [gViewStack addObject:view];
}

+ (void)viewStackPop{
    if (![gViewStack count]) {
        return;
    }
    
    [gViewStack removeLastObject];
    
    if ([gViewStack count] == 0) {
        gViewStack = nil;
    }
}

+ (BaseAlertView *)viewStackTopItem{
    BaseAlertView *result = nil;
    
    if ([gViewStack count]) {
        result = [gViewStack lastObject];
    }
    
    return result;
}

@end



#pragma mark -

@implementation BaseAlertView

@dynamic visible;
- (BOOL)visible{
    return self.superview && !self.hidden;
}

@synthesize contentView = _contentView;
- (UIView *)contentView{
    if (!_contentView) {
        [self loadContentView];
    }
    return _contentView;
}

#pragma mark -
#pragma mark UIView

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        
        self.contentView.autoresizingMask = \
        UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin |\
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:self.contentView];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size{
    return self.contentView.frame.size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark -
#pragma mark Public

- (void)show{
    if (_showing) {
        return;
    }
    _showing = YES;
    
    // Prepare to show
    //[self registerObservers];
    [self sizeToFitOrientation:NO];
    
    [self willPresentAlertView];
    
    // If content view is invisible, mask window is invisible, then presetn mask window.
    if (![BaseAlertView viewStackTopItem]) {
        [BaseAlertView maskWindowPresent];
    }
    [BaseAlertView maskWindowAddView:self];
    
    [self bounce];
}

- (void)showAndFitScreen
{

    if (_showing) {
        return;
    }
    _showing = YES;
    
    // Prepare to show
    
    self.frame = [UIScreen mainScreen].bounds;
    self.contentView.frame =[UIScreen mainScreen].bounds;
    [self willPresentAlertView];
    
    // If content view is invisible, mask window is invisible, then presetn mask window.
    if (![BaseAlertView viewStackTopItem]) {
        [BaseAlertView maskWindowPresent];
    }
    [BaseAlertView maskWindowAddView:self];
}

- (void)dismissAnimated:(BOOL)animated
{
    [self dismissAnimated:animated completion:NULL];
}

- (void)dismissAnimated:(BOOL)animated completion:(void(^)())block{
    if (!_showing) {
        return;
    }
    _showing = NO;
    
    [self willDismissAlertView];
    
    if (animated) {
        [UIView animateWithDuration:kTransitionDuration
                         animations:^(void) {
                             self.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self dismissCleanup];
                             if (block)
                                 block();
                         }];
    } else {
        [self dismissCleanup];
        if (block)
            block();
    }
}

- (void)loadContentView{
    [NSException raise:NSInternalInconsistencyException
                format:@"BaseAlertView::loadContentView must override to provide a valide contentview."];
}

- (void)willPresentAlertView{
}

- (void)didPresentAlertView{
}

- (void)willDismissAlertView{
}

- (void)didDismissAlertView{
}

@end
