//
//  AUIStairsController.h
//  AUIStairs
//
//  Created by 钱烨 on 7/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_TRANSFORMHEIGHT  (100)

@class AUIStairsController;

@protocol AUIStairsControllerDelegate <NSObject>

@optional

- (void)stairsController:(AUIStairsController *)stairsController willShowView:(UIView *)view onContainer:(UIView *)containerView;

- (void)stairsController:(AUIStairsController *)stairsController didShowView:(UIView *)view onContainer:(UIView *)containerView;

@end

@interface AUIStairsController : NSObject

@property (nonatomic, copy) NSArray *views;

@property (nonatomic, strong, readonly) UIView *currentView;

@property (nonatomic, assign) id<AUIStairsControllerDelegate> delegate;

@property (nonatomic, assign) CGFloat transformHeight;

- (instancetype)initWithTopView:(UIView *)view;

- (void)setViews:(NSArray *)views animated:(BOOL)animated;

- (void)goDownstairsToView:(UIView *)view animated:(BOOL)animated completion:(void(^)())completion;

- (UIView *)backUpstairsAnimated:(BOOL)animated completion:(void(^)())completion;

- (NSArray *)backUpstairsToView:(UIView *)view animated:(BOOL)animated completion:(void(^)())completion;

- (NSArray *)backUpstairsToTopViewAnimated:(BOOL)animated completion:(void(^)())completion;

@end


@interface UIView (AUIStairsController)  <AUIStairsControllerDelegate>

@property (nonatomic, strong) AUIStairsController *stairsController;

@end