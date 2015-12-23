//
//  GSegmentedControl.h
//  iphone
//
//  Created by icson apple on 12-3-9.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTabView.h"

@interface GSegmentedButton : UIButton
@end

@interface GSegmentedControl : GTabView

- (id) initWithSegmentCount:(NSUInteger)segmentCount segmentsize:(CGSize)segmentsize divider:(UIView*)divider tag:(NSInteger)objectTag delegate:(NSObject <GTabViewDelegate>*)_tabViewDelegate;

@end
