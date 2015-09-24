//
//  AUIFloorNavigationView.h
//  KidsTC
//
//  Created by 钱烨 on 9/9/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AUIFloorNavigationViewAnimateDirectionUp,
    AUIFloorNavigationViewAnimateDirectionDown
}AUIFloorNavigationViewAnimateDirection;

@class AUIFloorNavigationView;

@protocol AUIFloorNavigationViewDataSource <NSObject>

- (NSUInteger)numberOfItemsOnFloorNavigationView:(AUIFloorNavigationView *)navigationView;

- (UIView *)floorNavigationView:(AUIFloorNavigationView *)navigationView viewForItemAtIndex:(NSUInteger)index;

@optional

- (UIView *)floorNavigationView:(AUIFloorNavigationView *)navigationView highlightViewForItemAtIndex:(NSUInteger)index;

- (UIView *)floorNavigationView:(AUIFloorNavigationView *)navigationView viewForItemGapAtIndex:(NSUInteger)index;

@end

@protocol AUIFloorNavigationViewDelegate <NSObject>

- (void)floorNavigationView:(AUIFloorNavigationView *)navigationView didSelectedAtIndex:(NSUInteger)index;

@end

@interface AUIFloorNavigationView : UIView

@property (nonatomic, assign) id<AUIFloorNavigationViewDataSource> dataSource;

@property (nonatomic, assign) id<AUIFloorNavigationViewDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedIndex; // 小于0，表示都不选中

@property (nonatomic, assign) CGFloat selectedScale; //选中状态缩放比例，默认为1;

@property (nonatomic, assign) BOOL enableCollapse;

@property (nonatomic, readonly) BOOL isCollapsed;

@property (nonatomic, assign) AUIFloorNavigationViewAnimateDirection animateDirection;

- (void)reloadData;

- (void)collapse:(BOOL)animated;

- (void)expandAll:(BOOL)animated;

@end
