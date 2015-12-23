//
//  GView.h
//  iphone51buy
//
//  Created by icson apple on 12-5-28.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "GActivityIndicatorView.h"
#import "GButton.h"

typedef enum{
	GViewStatusNormal = 0,
	GViewStatusLoading = 1,
	GViewStatusFailed = 2,
	GViewStatusInfo,
} GViewStatus;

typedef enum{
	GViewLoadingSizeDefault = 0,
	GViewLoadingSizeSmall = 1,
	GViewLoadingSizeBig = 2,
} GViewLoadingSize;

@interface GExtFailedView : UIView
@property (strong, nonatomic) UILabel *failedTextLabel;
@property (strong, nonatomic) GButton *retryButton;
@property (strong, nonatomic) UIImageView *bgImgView;
@end

@interface GExtInfoView : UIView
@property (strong, nonatomic) UILabel *infoTextLabel;
@end

@interface GViewExtensionObj : NSObject
@property (strong, nonatomic) UIView *loadingView;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) GActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) GExtFailedView *failedView;
@property (strong, nonatomic) GExtInfoView *infoView;
@property (nonatomic) GViewStatus status;
@end

@interface UIView(GViewExtension)
- (void)showMsgWithAction:(NSString *)msg actionTarget:(id)target doAction:(SEL)action actionTitle:(NSString *)actTitile;
- (void)showLoading:(NSString *)loadingWords size:(GViewLoadingSize)_size;
- (void)showLoading:(NSString *)loadingWords;
- (void)showFailed:(NSError *)error retryTarget:(id)_target retryAction:(SEL)_action;
- (void)showFailed:(NSError *)error;
- (void)showInfo:(NSString *)infoStr;
- (void)resetStatus;

// set orign
- (void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical;
- (void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical addWidth:(CGFloat)widthAdded addHeight:(CGFloat)heightAdded;
- (void)moveToHorizontal:(CGFloat)horizontal toVertical:(CGFloat)vertical;

// set width height
- (void)setWidth:(CGFloat)width height:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

// add width and height

- (void)addWidth:(CGFloat)widthAdded addHeight:(CGFloat)heightAdded;
- (void)addWidth:(CGFloat)widthAdded;
- (void)addHeight:(CGFloat)heightAdded;

// set corner radius

- (void)setCornerRadius:(CGFloat)radius;
- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor;
- (CGRect)frameInWindow;

- (BOOL)findAndResignFirstResponder;
- (UIView *)findFirstResponder;

@end
