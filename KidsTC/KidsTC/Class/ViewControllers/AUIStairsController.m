                                     //
//  AUIStairsController.m
//  AUIStairs
//
//  Created by 钱烨 on 7/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AUIStairsController.h"
#import <objc/runtime.h>


typedef enum {
    StairsControllerTransiteDirectionUp,
    StairsControllerTransiteDirectionDown
}StairsControllerTransiteDirection;

@interface AUIStairsController ()

@property (nonatomic, strong) NSMutableArray *viewList;

- (void)prepareForTransitionWithNextView:(UIView *)view direction:(StairsControllerTransiteDirection)direction;

- (void)executeTransitionWithNextView:(UIView *)view direction:(StairsControllerTransiteDirection)direction;

- (void)finishTransitionWithNextView:(UIView *)view direction:(StairsControllerTransiteDirection)direction;

- (void)prepareAnimationWithDirection:(StairsControllerTransiteDirection)direction forView:(UIView *)view;

- (void)doAnimationWithDirection:(StairsControllerTransiteDirection)direction forView:(UIView *)view completion:(void(^)())completion;

- (UIImage *)takeSnapshotForView:(UIView *)view;

@end

@implementation AUIStairsController

- (instancetype)init {
    self = [super init];
    if (self) {
        _viewList = [[NSMutableArray alloc] init];
        self.transformHeight = DEFAULT_TRANSFORMHEIGHT;
    }
    return self;
}

- (instancetype)initWithTopView:(UIView *)view {
    self = [super init];
    if (self) {
        _viewList = [[NSMutableArray alloc] initWithObjects:view, nil];
        self.transformHeight = DEFAULT_TRANSFORMHEIGHT;
        _currentView = view;
    }
    return self;
}

- (void)setViews:(NSArray *)views {
    [self setViews:views animated:NO];
}

- (NSArray *)views {
    return [NSArray arrayWithArray:self.viewList];
}

#pragma mark Public Methods


- (void)setViews:(NSArray *)views animated:(BOOL)animated {
    if (!views) {
        return;
    }
    [self.viewList removeAllObjects];
    [self.viewList addObjectsFromArray:views];
    _currentView = [views firstObject];
}

- (void)goDownstairsToView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion {
    if (!view) {
        return;
    }
    [self prepareForTransitionWithNextView:view direction:StairsControllerTransiteDirectionDown];
    [self executeTransitionWithNextView:view direction:StairsControllerTransiteDirectionDown];
    [self finishTransitionWithNextView:view direction:StairsControllerTransiteDirectionDown];
    
    if (animated) {
        //执行动画
        [self prepareAnimationWithDirection:StairsControllerTransiteDirectionDown forView:view];
        [self doAnimationWithDirection:StairsControllerTransiteDirectionDown forView:view completion:completion];
    } else if (completion) {
        completion();
    }
}

- (UIView *)backUpstairsAnimated:(BOOL)animated completion:(void (^)())completion {
    NSUInteger viewsCount = [self.viewList count];
    if (viewsCount <= 1) {
        //已在顶部
        return nil;
    }
    //上一层
    UIView *upperView = [self.viewList objectAtIndex:viewsCount - 2];
    [self prepareForTransitionWithNextView:upperView direction:StairsControllerTransiteDirectionUp];
    [self executeTransitionWithNextView:upperView direction:StairsControllerTransiteDirectionUp];
    [self finishTransitionWithNextView:upperView direction:StairsControllerTransiteDirectionUp];
    
    if (animated) {
        //执行动画
        [self prepareAnimationWithDirection:StairsControllerTransiteDirectionUp forView:upperView];
        [self doAnimationWithDirection:StairsControllerTransiteDirectionUp forView:upperView completion:completion];
    } else if (completion) {
        completion();
    }
    
    return upperView;
}

- (NSArray *)backUpstairsToView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion {
    if (!view) {
        return nil;
    }
    
    NSUInteger index = [self.viewList indexOfObject:view];
    if (index == NSNotFound) {
        return nil;
    }
    //保留需要返回的数据
    NSRange popRange = NSMakeRange(index + 1, [self.viewList count] - 1 - index);
    NSArray *popArray = [NSArray arrayWithArray:[self.viewList subarrayWithRange:popRange]];
    //开始执行
    UIView *upperView = [self.viewList objectAtIndex:index];
    [self prepareForTransitionWithNextView:upperView direction:StairsControllerTransiteDirectionUp];
    [self executeTransitionWithNextView:upperView direction:StairsControllerTransiteDirectionUp];
    [self finishTransitionWithNextView:upperView direction:StairsControllerTransiteDirectionUp];
    
    if (animated) {
        //执行动画
        [self prepareAnimationWithDirection:StairsControllerTransiteDirectionUp forView:upperView];
        [self doAnimationWithDirection:StairsControllerTransiteDirectionUp forView:upperView completion:completion];
    } else if (completion) {
        completion();
    }
    
    return popArray;
}

- (NSArray *)backUpstairsToTopViewAnimated:(BOOL)animated completion:(void (^)())completion {
    NSUInteger viewsCount = [self.viewList count];
    if (viewsCount <= 1) {
        //已在顶部
        return nil;
    }
    //保留需要返回的数据
    NSRange popRange = NSMakeRange(1, [self.viewList count] - 1);
    NSArray *popArray = [NSArray arrayWithArray:[self.viewList subarrayWithRange:popRange]];
    //开始执行
    UIView *upperView = [self.viewList objectAtIndex:0];
    [self prepareForTransitionWithNextView:upperView direction:StairsControllerTransiteDirectionUp];
    [self executeTransitionWithNextView:upperView direction:StairsControllerTransiteDirectionUp];
    [self finishTransitionWithNextView:upperView direction:StairsControllerTransiteDirectionUp];
    
    if (animated) {
        //执行动画
        [self prepareAnimationWithDirection:StairsControllerTransiteDirectionUp forView:upperView];
        [self doAnimationWithDirection:StairsControllerTransiteDirectionUp forView:upperView completion:completion];
    } else if (completion) {
        completion();
    }
    
    return popArray;
    return nil;
}


#pragma mark Private methods

- (void)prepareForTransitionWithNextView:(UIView *)view direction:(StairsControllerTransiteDirection)direction {
    //给下一层赋值stairsController
    view.stairsController = self;
    //delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(stairsController:willShowView:onContainer:)]) {
        [self.delegate stairsController:self willShowView:view onContainer:self.currentView.superview];
    }
}

- (void)executeTransitionWithNextView:(UIView *)view direction:(StairsControllerTransiteDirection)direction {
    
    //给当前view截屏，贴到下一个view上
//    UIImage *currentImage = [self takeSnapshotForView:view];
//    UIImageView *snapshotView = [[UIImageView alloc] initWithImage:currentImage];
    [self.currentView.superview addSubview:self.currentView];
    [self.currentView.superview addSubview:view];
    //调整位置
    CGFloat yOffset = 0;
    switch (direction) {
        case StairsControllerTransiteDirectionUp:
        {
            yOffset = view.frame.size.height + self.transformHeight;
            [self.currentView setFrame:CGRectMake(0, yOffset, self.currentView.frame.size.width, self.currentView.frame.size.height)];
        }
            break;
        case StairsControllerTransiteDirectionDown:
        {
            yOffset = - (self.currentView.frame.size.height + self.transformHeight);
        }
        default:
            break;
    }
    [view setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
}

- (void)finishTransitionWithNextView:(UIView *)view direction:(StairsControllerTransiteDirection)direction {
    //给currentViewController赋值
    _currentView = view;
    //delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(stairsController:didShowView:onContainer:)]) {
        [self.delegate stairsController:self didShowView:view onContainer:view.superview];
    }
}

- (void)prepareAnimationWithDirection:(StairsControllerTransiteDirection)direction forView:(UIView *)view {
    
    //下一个view设置位置
    CGFloat yOffset = view.frame.size.height + self.transformHeight;
    CGFloat yPosition = 0;
    switch (direction) {
        case StairsControllerTransiteDirectionUp:
        {
            yPosition = -yOffset;
        }
            break;
        case StairsControllerTransiteDirectionDown:
        {
            yPosition = yOffset;
        }
        default:
            break;
    }
    [view setFrame:CGRectMake(0, yPosition, view.frame.size.width, view.frame.size.height)];
}

- (void)doAnimationWithDirection:(StairsControllerTransiteDirection)direction forView:(UIView *)view completion:(void (^)())completion {
    switch (direction) {
        case StairsControllerTransiteDirectionUp:
        {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [view setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            } completion:^(BOOL finished) {
                if (completion && finished) {
                    completion();
                }
            }];
        }
            break;
        case StairsControllerTransiteDirectionDown:
        {
            UIView *superView = view.superview;
            CGFloat yOffset = -view.frame.origin.y;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [superView setFrame:CGRectMake(0, yOffset, superView.frame.size.width, superView.frame.size.height)];
            } completion:^(BOOL finished) {
                [superView setFrame:CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height)];
                [view setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                if (completion && finished) {
                    completion();
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (UIImage *)takeSnapshotForView:(UIView *)view {
    CGSize imageSize = view.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    } else {
//        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 1);
//    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, view.center.x, view.center.y);
    CGContextConcatCTM(context, view.transform);
    CGContextTranslateCTM(context, -view.bounds.size.width * view.layer.anchorPoint.x, -view.bounds.size.height * view.layer.anchorPoint.y);
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    } else {
        [view.layer renderInContext:context];
    }
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end

static const void *auiKey = @"AUIStairsControllerKey";

@implementation UIView (AUIStairsController)

- (AUIStairsController *)stairsController {
    return objc_getAssociatedObject(self, auiKey);
}

- (void)setStairsController:(AUIStairsController *)stairsController {
    stairsController.delegate = self;
    objc_setAssociatedObject(self, auiKey, stairsController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)stairsController:(AUIStairsController *)stairsController willShowView:(UIView *)view onContainer:(UIView *)containerView {
    [view setFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
}

- (void)stairsController:(AUIStairsController *)stairsController didShowView:(UIView *)view onContainer:(UIView *)containerView {
    
}

@end
