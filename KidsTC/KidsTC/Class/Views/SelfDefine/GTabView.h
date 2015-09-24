//
//  GTabView.h
//  iphone
//
//  Created by icson apple on 12-3-31.
//  Copyright (c) 2012年 icson. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class GTabView;
@class GTabButton;

@protocol GTabViewDelegate <NSObject>

- (UIButton*) buttonFor:(GTabView*)tabView atIndex:(NSUInteger)tabIndex;

@optional
- (BOOL) touchUpInsideTabIndex:(NSUInteger)tabIndex;
- (BOOL) touchDownAtTabIndex:(NSUInteger)tabIndex;

@end

@interface GTabView : UIView {
@private
	NSInteger tabCount;
	CGFloat marginX;
	id<GTabViewDelegate> delegate;
}
@property (nonatomic, strong, readonly) NSMutableArray* buttons;

- (id)initWithFrame:(CGRect)frame withTabCount:(NSInteger) _tabCount widthMarginX:(CGFloat) marginX delegate:(id<GTabViewDelegate>) _delegate;
- (void)touchUpInside:(id)sender;
- (void)touchDown:(id)sender;
- (void)otherTouchesAction:(id)sender;

- (NSUInteger )selectedButton;
- (void)setButtonSelected:(NSUInteger) index;
@end

@interface GTabButton : UIButton

@end
