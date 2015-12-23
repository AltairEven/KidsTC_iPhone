//
//  GSearchSortControl.m
//  iphone
//
//  Created by icson apple on 12-3-6.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GSegmentedControl.h"

@implementation GSegmentedButton

@end

@implementation GSegmentedControl

- (id) initWithSegmentCount:(NSUInteger)segmentCount segmentsize:(CGSize)segmentsize divider:(UIView*)divider tag:(NSInteger)objectTag delegate:(NSObject <GTabViewDelegate>*)_tabViewDelegate
{
	if (self = [super initWithFrame: CGRectZero withTabCount: segmentCount widthMarginX: 0.0 delegate: _tabViewDelegate])
	{
		
		self.tag = objectTag;

		self.backgroundColor = [UIColor whiteColor];
		
		CGFloat dividerWidth = divider ? divider.frame.size.width : 0.0;
		CGFloat horizontalOffset = 0.0;
		for (NSUInteger i = 0 ; i < segmentCount ; i++)
		{
			GSegmentedButton* button = [self.buttons objectAtIndex: i];
			button.frame = CGRectMake(horizontalOffset, 0.0, segmentsize.width, segmentsize.height);
			button.backgroundColor = [UIColor clearColor];
			button.contentMode =  UIViewContentModeScaleToFill;
			if (i != segmentCount - 1)
			{
				if (divider) {
					divider.frame = CGRectMake(horizontalOffset + segmentsize.width, 0.0, divider.frame.size.width, divider.frame.size.height);
					[self addSubview:divider];
				}
			}
			
			horizontalOffset = horizontalOffset + segmentsize.width + dividerWidth;
		}
		
		self.frame = CGRectMake(0, 0, (segmentsize.width * segmentCount) + (dividerWidth * (segmentCount - 1)), segmentsize.height);
	}
	
	return self;
}

@end
