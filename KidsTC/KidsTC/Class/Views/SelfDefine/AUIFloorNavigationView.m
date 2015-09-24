//
//  AUIFloorNavigationView.m
//  KidsTC
//
//  Created by 钱烨 on 9/9/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AUIFloorNavigationView.h"

#define VIEWALPHA_SHOW (0.8)
#define VIEWALPHA_HIDE (0.3)

#define ALPHATIMER_INTERVAL (2)

#define ContainerMaxCount (10)

#define ANIMATION_DURATION (0.3)

typedef enum {
    ItemViewTagItemView = 100,
    ItemViewTagHighlightView
}ItemViewTag;

@interface AUIFloorNavigationView () {
    CGPoint containerCenters[10];
}

@property (nonatomic, assign) CGSize viewSize;

@property (nonatomic, assign) NSUInteger itemCount;

@property (nonatomic, strong) NSArray *itemContainerView;

@property (nonatomic, strong) NSArray *itemViewsArray;

@property (nonatomic, strong) NSArray *itemHighlightedViewsArray;

@property (nonatomic, strong) NSArray *gapViewsArray;

@property (nonatomic, strong) NSTimer *alphaTimer;

@property (nonatomic, strong) UIView *collapseView;

- (void)initNavigationView;

- (void)setItem:(NSUInteger)index highlighted:(BOOL)highlighted;

- (void)addTapGestureToView:(UIView *)view;

- (void)didTappedOnView:(id)sender;

- (void)resizeViewWithNewSize:(CGSize)size;

- (void)buildViewWithNewSize:(CGSize)size;

- (void)backToTranslucent;

@end

@implementation AUIFloorNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initNavigationView];
    }
    return self;
}


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    [self initNavigationView];
    return self;
}

- (void)initNavigationView {
    [self setBackgroundColor:[UIColor clearColor]];
    _selectedIndex = -1;
    self.selectedScale = 1;
    [self setAlpha:VIEWALPHA_HIDE];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0) {
        //都不选中
        [self setItem:_selectedIndex highlighted:NO];
        _selectedIndex = selectedIndex;
        return;
    }
    if (_selectedIndex == selectedIndex) {
        return;
    }
    [self setItem:_selectedIndex highlighted:NO];
    _selectedIndex = selectedIndex;
    [self setItem:_selectedIndex highlighted:YES];
    if (self.isCollapsed) {
        UIView *showingViewWhenCollapsed = [self.itemContainerView objectAtIndex:selectedIndex];
        [self bringSubviewToFront:showingViewWhenCollapsed];
        [self bringSubviewToFront:self.collapseView];
    }
}

#pragma mark Private methods

- (void)setItem:(NSUInteger)index highlighted:(BOOL)highlighted {
    if (self.itemCount <= index) {
        return;
    }
    UIView *containerView = [self.itemContainerView objectAtIndex:index];
    UIView *frontView = nil;
    if (highlighted) {
        frontView = [containerView viewWithTag:ItemViewTagHighlightView];
    } else {
        frontView = [containerView viewWithTag:ItemViewTagItemView];
    }
    [containerView bringSubviewToFront:frontView];
}

- (void)addTapGestureToView:(UIView *)view {
    if ([view respondsToSelector:@selector(setUserInteractionEnabled:)]) {
        [view setUserInteractionEnabled:YES];
    }
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnView:)];
    [view addGestureRecognizer:gesture];
}

- (void)didTappedOnView:(id)sender {
    //timer
    [self.alphaTimer invalidate];
    self.alphaTimer = [NSTimer timerWithTimeInterval:ALPHATIMER_INTERVAL target:self selector:@selector(backToTranslucent) userInfo:nil repeats:NO];
    //gesture
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    NSUInteger tag = gesture.view.tag;
    [self setAlpha:VIEWALPHA_SHOW];
    if (gesture.view == self.collapseView) {
        [self.collapseView setHidden:YES];
        [self expandAll:YES];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(floorNavigationView:didSelectedAtIndex:)]) {
        [self setSelectedIndex:tag];
        //timer
        [[NSRunLoop currentRunLoop] addTimer:self.alphaTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:self.alphaTimer forMode:NSRunLoopCommonModes];
        [self.delegate floorNavigationView:self didSelectedAtIndex:tag];
    }
    
}

- (void)resizeViewWithNewSize:(CGSize)size {
    NSArray *starsViewConstraintsArray = [self constraints];
    if (starsViewConstraintsArray && [starsViewConstraintsArray count] > 0) {
        for (NSLayoutConstraint *constraint in starsViewConstraintsArray) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                constraint.constant = size.width;
                continue;
            }
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = size.height;
                continue;
            }
        }
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    }
    self.viewSize = size;
}

- (void)buildViewWithNewSize:(CGSize)size {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self resizeViewWithNewSize:size];
    
    for (NSUInteger index = 0; index < ContainerMaxCount; index ++) {
        containerCenters[index] = CGPointZero;
    }
    
    CGFloat xPosition = 0;
    CGFloat yPosition = 0;
    NSMutableArray *tempContainers = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < self.itemCount; index ++) {
        UIView *itemView = [self.itemViewsArray objectAtIndex:index];
        UIView *highlightView = [self.itemHighlightedViewsArray objectAtIndex:index];
        CGFloat height = itemView.frame.size.height;
        if (height < highlightView.frame.size.height) {
            height = highlightView.frame.size.height;
        }
        //create container view
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(xPosition, yPosition, size.width, height)];
        containerView.tag = index;
        [containerView addSubview:highlightView];
        [containerView addSubview:itemView];
        [self addTapGestureToView:containerView];
        [self addSubview:containerView];
        [highlightView setCenter:CGPointMake(size.width / 2, containerView.frame.size.height / 2)];
        [itemView setCenter:CGPointMake(size.width / 2, containerView.frame.size.height / 2)];
        [tempContainers addObject:containerView];
        yPosition += containerView.frame.size.height;
        containerCenters[index] = containerView.center;
        
        //gap view
        if (index < self.itemCount - 1) {
            UIView *gapView = [self.gapViewsArray objectAtIndex:index];
            [self addSubview:gapView];
            [gapView setCenter:CGPointMake(size.width / 2, yPosition + gapView.frame.size.height / 2)];
            yPosition += gapView.frame.size.height;
        }
    }
    self.itemContainerView = [NSArray arrayWithArray:tempContainers];
}

- (void)backToTranslucent {
    [UIView animateWithDuration:1 animations:^{
        [self setAlpha:VIEWALPHA_HIDE];
    }];
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(numberOfItemsOnFloorNavigationView:)]) {
            self.itemCount = [self.dataSource numberOfItemsOnFloorNavigationView:self];
        }
        if ([self.dataSource respondsToSelector:@selector(floorNavigationView:viewForItemAtIndex:)]) {
            CGFloat width = 0;
            CGFloat height = 0;
            NSMutableArray *tempItemViewArray = [[NSMutableArray alloc] init];
            NSMutableArray *tempItemHighlightViewArray = [[NSMutableArray alloc] init];
            NSMutableArray *tempGapViewArray = [[NSMutableArray alloc] init];
            for (NSUInteger index = 0; index < self.itemCount; index ++) {
                //item view
                UIView *itemView = [self.dataSource floorNavigationView:self viewForItemAtIndex:index];
                NSParameterAssert(itemView);
                if (width < itemView.frame.size.width) {
                    width = itemView.frame.size.width;
                }
                height += itemView.frame.size.height;
                itemView.tag = ItemViewTagItemView;
                [tempItemViewArray addObject:itemView];
                //item highlight view
                if ([self.dataSource respondsToSelector:@selector(floorNavigationView:highlightViewForItemAtIndex:)]) {
                    UIView *highlightView = [self.dataSource floorNavigationView:self highlightViewForItemAtIndex:index];
                    if (!highlightView) {
                        highlightView = [GToolUtil duplicate:itemView];
                    }
                    if (width < itemView.frame.size.width) {
                        width = itemView.frame.size.width;
                    }
                    if (itemView.frame.size.height < highlightView.frame.size.height) {
                        height += highlightView.frame.size.height - itemView.frame.size.height;
                    }
                    highlightView.tag = ItemViewTagHighlightView;
                    [tempItemHighlightViewArray addObject:highlightView];
                }
                //gap view
                if (index < self.itemCount - 1 && [self.dataSource respondsToSelector:@selector(floorNavigationView:viewForItemGapAtIndex:)]) {
                    UIView *gapView = [self.dataSource floorNavigationView:self viewForItemGapAtIndex:index];
                    NSParameterAssert(gapView);
                    if (width < itemView.frame.size.width) {
                        width = itemView.frame.size.width;
                    }
                    height += gapView.frame.size.height;
                    [tempGapViewArray addObject:gapView];
                }
            }
            self.itemViewsArray = [NSArray arrayWithArray:tempItemViewArray];
            self.itemHighlightedViewsArray = [NSArray arrayWithArray:tempItemHighlightViewArray];
            self.gapViewsArray = [NSArray arrayWithArray:tempGapViewArray];
            
            [self buildViewWithNewSize:CGSizeMake(width, height)];
        }
        _isCollapsed = NO;
    }
}

- (void)collapse:(BOOL)animated {
    if (self.isCollapsed || !self.enableCollapse) {
        return;
    }
    _isCollapsed = YES;
    
    //collapse view
    if (!self.collapseView) {
        self.collapseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.width)];
        [self addTapGestureToView:self.collapseView];
        [self addSubview:self.collapseView];
        [self.collapseView setHidden:YES];
    }
    [self bringSubviewToFront:self.collapseView];
    
    for (UIView *gapView in self.gapViewsArray) {
        [gapView setHidden:YES];
    }
    
    CGPoint collapseCenter;
    if (self.animateDirection == AUIFloorNavigationViewAnimateDirectionUp) {
        collapseCenter = CGPointMake(self.viewSize.width / 2, self.viewSize.width / 2);
    } else {
        collapseCenter = CGPointMake(self.viewSize.width / 2, self.viewSize.height - self.viewSize.width / 2);
    }
    
    [self.collapseView setCenter:collapseCenter];
    [self.collapseView setHidden:NO];
    
    if (animated) {
        [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            for (UIView *containerView in self.itemContainerView) {
                [containerView setCenter:collapseCenter];
            }
        } completion:^(BOOL finished) {
            [self.collapseView setHidden:NO];
        }];
    } else {
        [self.collapseView setHidden:NO];
        for (UIView *containerView in self.itemContainerView) {
            [containerView setCenter:CGPointMake(self.viewSize.width / 2, self.viewSize.width / 2)];
        }
    }
    //timer
    [self.alphaTimer invalidate];
    self.alphaTimer = [NSTimer timerWithTimeInterval:ALPHATIMER_INTERVAL target:self selector:@selector(backToTranslucent) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.alphaTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:self.alphaTimer forMode:NSRunLoopCommonModes];
}

- (void)expandAll:(BOOL)animated {
    [self.collapseView setHidden:YES];
    
    if (animated) {
        [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            for (NSUInteger index = 0; index < [self.itemContainerView count]; index ++) {
                UIView *containerView = [self.itemContainerView objectAtIndex:index];
                [containerView setCenter:containerCenters[index]];
            }
        } completion:^(BOOL finished) {
            for (UIView *gapView in self.gapViewsArray) {
                [gapView setHidden:NO];
            }
        }];
    } else {
        for (NSUInteger index = 0; index < [self.itemContainerView count]; index ++) {
            UIView *containerView = [self.itemContainerView objectAtIndex:index];
            [containerView setCenter:containerCenters[index]];
        }
        for (UIView *gapView in self.gapViewsArray) {
            [gapView setHidden:NO];
        }
        [self.collapseView setHidden:YES];
    }
    _isCollapsed = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
