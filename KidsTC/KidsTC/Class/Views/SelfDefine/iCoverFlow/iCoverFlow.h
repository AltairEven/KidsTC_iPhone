/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：iCoverFlow.h
 * 文件标识：
 * 摘 要：实现coverFlow特效的封装
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：2013年3月25日
 */

#ifndef AH_RETAIN
#if __has_feature(objc_arc)
#define AH_RETAIN(x) (x)
#define AH_RELEASE(x) (void)(x)
#define AH_AUTORELEASE(x) (x)
#define AH_SUPER_DEALLOC (void)(0)
#else
#define __AH_WEAK
#define AH_WEAK assign
#define AH_RETAIN(x) [(x) retain]
#define AH_RELEASE(x) [(x) release]
#define AH_AUTORELEASE(x) [(x) autorelease]
#define AH_SUPER_DEALLOC [super dealloc]
#endif
#endif

//  Weak reference support

#ifndef AH_WEAK
#if defined __IPHONE_OS_VERSION_MIN_REQUIRED
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_4_3
#define __AH_WEAK __weak
#define AH_WEAK weak
#else
#define __AH_WEAK __unsafe_unretained
#define AH_WEAK unsafe_unretained
#endif
#elif defined __MAC_OS_X_VERSION_MIN_REQUIRED
#if __MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_6
#define __AH_WEAK __weak
#define AH_WEAK weak
#else
#define __AH_WEAK __unsafe_unretained
#define AH_WEAK unsafe_unretained
#endif
#endif
#endif

//  ARC Helper ends


#ifdef USING_CHAMELEON
#define ICoverflow_IOS
#elif defined __IPHONE_OS_VERSION_MAX_ALLOWED
#define ICoverflow_IOS
typedef CGRect NSRect;
typedef CGSize NSSize;
#else
#define ICoverflow_MACOS
#endif


#import <QuartzCore/QuartzCore.h>
#ifdef ICoverflow_IOS
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
typedef NSView UIView;
#endif


typedef enum
{
    iCoverflowTypeLinear = 0,
    iCoverflowTypeRotary,
    iCoverflowTypeInvertedRotary,
    iCoverflowTypeCylinder,
    iCoverflowTypeInvertedCylinder,
    iCoverflowTypeWheel,
    iCoverflowTypeInvertedWheel,
    iCoverflowTypeCoverFlow,
    iCoverflowTypeCoverFlow2,
    iCoverflowTypeTimeMachine,
    iCoverflowTypeInvertedTimeMachine,
    iCoverflowTypeCustom
}
iCoverflowType;


typedef enum
{
    iCoverflowTranformOptionCount = 0,
    iCoverflowTranformOptionArc,
	iCoverflowTranformOptionAngle,
    iCoverflowTranformOptionRadius,
    iCoverflowTranformOptionTilt,
    iCoverflowTranformOptionSpacing
}
iCoverflowTranformOption;


@protocol iCoverflowDataSource, iCoverflowDelegate;

@interface iCoverFlow : UIView

//required for 32-bit Macs
#ifdef __i386__
{
	@private
	
    id<iCoverflowDelegate> __AH_WEAK delegate;
    id<iCoverflowDataSource> __AH_WEAK dataSource;
    iCoverflowType type;
    CGFloat perspective;
    NSInteger numberOfItems;
    NSInteger numberOfPlaceholders;
	NSInteger numberOfPlaceholdersToShow;
    NSInteger numberOfVisibleItems;
    UIView *contentView;
    NSDictionary *itemViews;
    NSMutableSet *itemViewPool;
    NSMutableSet *placeholderViewPool;
    NSInteger previousItemIndex;
    CGFloat itemWidth;
    CGFloat scrollOffset;
    CGFloat offsetMultiplier;
    CGFloat startVelocity;
    id __unsafe_unretained timer;
    BOOL decelerating;
    BOOL scrollEnabled;
    CGFloat decelerationRate;
    BOOL bounces;
    CGSize contentOffset;
    CGSize viewpointOffset;
    CGFloat startOffset;
    CGFloat endOffset;
    NSTimeInterval scrollDuration;
    NSTimeInterval startTime;
    BOOL scrolling;
    CGFloat previousTranslation;
	BOOL centerItemWhenSelected;
	BOOL shouldWrap;
	BOOL dragging;
    BOOL didDrag;
    CGFloat scrollSpeed;
    CGFloat bounceDistance;
    NSTimeInterval toggleTime;
    CGFloat toggle;
    BOOL stopAtItemBoundary;
    BOOL scrollToItemBoundary;
    BOOL useDisplayLink;
	BOOL vertical;
    BOOL ignorePerpendicularSwipes;
    NSInteger animationDisableCount;
}
#endif

@property (nonatomic, AH_WEAK) IBOutlet id<iCoverflowDataSource> dataSource;
@property (nonatomic, AH_WEAK) IBOutlet id<iCoverflowDelegate> delegate;
@property (nonatomic, assign) iCoverflowType type;
@property (nonatomic, assign) CGFloat perspective;
@property (nonatomic, assign) CGFloat decelerationRate;
@property (nonatomic, assign) CGFloat scrollSpeed;
@property (nonatomic, assign) CGFloat bounceDistance;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, readonly) CGFloat scrollOffset;
@property (nonatomic, readonly) CGFloat offsetMultiplier;
@property (nonatomic, assign) CGSize contentOffset;
@property (nonatomic, assign) CGSize viewpointOffset;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, readonly) NSInteger numberOfPlaceholders;
@property (nonatomic, readonly) NSInteger currentItemIndex;
@property (nonatomic, strong, readonly) UIView *currentItemView;
@property (nonatomic, strong, readonly) NSArray *indexesForVisibleItems;
@property (nonatomic, readonly) NSInteger numberOfVisibleItems;
@property (nonatomic, strong, readonly) NSArray *visibleItemViews;
@property (nonatomic, readonly) CGFloat itemWidth;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, readonly) CGFloat toggle;
@property (nonatomic, assign) BOOL stopAtItemBoundary;
@property (nonatomic, assign) BOOL scrollToItemBoundary;
@property (nonatomic, assign) BOOL useDisplayLink;
@property (nonatomic, assign, getter = isVertical) BOOL vertical;
@property (nonatomic, assign) BOOL ignorePerpendicularSwipes;

- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (UIView *)itemViewAtIndex:(NSInteger)index;
- (NSInteger)indexOfItemView:(UIView *)view;
- (NSInteger)indexOfItemViewOrSubview:(UIView *)view;
- (CGFloat)offsetForItemAtIndex:(NSInteger)index;
- (void)reloadData;

#ifdef ICoverflow_IOS

@property (nonatomic, assign) BOOL centerItemWhenSelected;

#endif

@end


@protocol iCoverflowDataSource <NSObject>

- (NSUInteger)numberOfItemsInCoverflow:(iCoverFlow *)Coverflow;
- (UIView *)Coverflow:(iCoverFlow *)Coverflow viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view;

@optional

- (NSUInteger)numberOfPlaceholdersInCoverflow:(iCoverFlow *)Coverflow;
- (UIView *)Coverflow:(iCoverFlow *)Coverflow placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view;
- (NSUInteger)numberOfVisibleItemsInCoverflow:(iCoverFlow *)Coverflow;

//deprecated, use Coverflow:viewForItemAtIndex:reusingView: and Coverflow:placeholderViewAtIndex:reusingView: instead
- (UIView *)Coverflow:(iCoverFlow *)Coverflow viewForItemAtIndex:(NSUInteger)index;
- (UIView *)Coverflow:(iCoverFlow *)Coverflow placeholderViewAtIndex:(NSUInteger)index;

@end


@protocol iCoverflowDelegate <NSObject>
@optional

- (void)CoverflowWillBeginScrollingAnimation:(iCoverFlow *)Coverflow;
- (void)CoverflowDidEndScrollingAnimation:(iCoverFlow *)Coverflow;
- (void)CoverflowDidScroll:(iCoverFlow *)Coverflow;
- (void)CoverflowCurrentItemIndexUpdated:(iCoverFlow *)Coverflow;
- (void)CoverflowWillBeginDragging:(iCoverFlow *)Coverflow;
- (void)CoverflowDidEndDragging:(iCoverFlow *)Coverflow willDecelerate:(BOOL)decelerate;
- (void)CoverflowWillBeginDecelerating:(iCoverFlow *)Coverflow;
- (void)CoverflowDidEndDecelerating:(iCoverFlow *)Coverflow;
- (CGFloat)CoverflowItemWidth:(iCoverFlow *)Coverflow;
- (CGFloat)CoverflowOffsetMultiplier:(iCoverFlow *)Coverflow;
- (BOOL)CoverflowShouldWrap:(iCoverFlow *)Coverflow;
- (CGFloat)Coverflow:(iCoverFlow *)Coverflow itemAlphaForOffset:(CGFloat)offset;
- (CATransform3D)Coverflow:(iCoverFlow *)Coverflow itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform;
- (CGFloat)Coverflow:(iCoverFlow *)Coverflow valueForTransformOption:(iCoverflowTranformOption)option withDefault:(CGFloat)value;

//deprecated, use transformForItemAtIndex:withOffset:baseTransform: instead
- (CATransform3D)Coverflow:(iCoverFlow *)Coverflow transformForItemView:(UIView *)view withOffset:(CGFloat)offset;

#ifdef ICoverflow_IOS

- (BOOL)Coverflow:(iCoverFlow *)Coverflow shouldSelectItemAtIndex:(NSInteger)index;
- (void)Coverflow:(iCoverFlow *)Coverflow didSelectItemAtIndex:(NSInteger)index;

#endif

@end