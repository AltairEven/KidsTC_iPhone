//
//  ParentingStrategyCalendarView.h
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParentingStrategyCalendarView;

@protocol ParentingStrategyCalendarViewDelegate <NSObject>

- (void)parentingStrategyCalendarView:(ParentingStrategyCalendarView *)calendarView didClickedAtIndex:(NSUInteger)index;

@end

@interface ParentingStrategyCalendarView : UIView

@property (nonatomic, assign) id<ParentingStrategyCalendarViewDelegate> delegate;

@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, readonly) NSUInteger currentIndex;

@end
