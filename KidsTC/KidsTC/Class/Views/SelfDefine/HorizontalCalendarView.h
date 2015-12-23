//
//  HorizontalCalendarView.h
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizontalCalendarView;

@protocol HorizontalCalendarViewDelegate <NSObject>

- (void)HorizontalCalendarView:(HorizontalCalendarView *)calendarView didClickedAtIndex:(NSUInteger)index;

@end

@interface HorizontalCalendarView : UIView

@property (nonatomic, assign) id<HorizontalCalendarViewDelegate> delegate;

@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, readonly) NSUInteger currentIndex;

@end
