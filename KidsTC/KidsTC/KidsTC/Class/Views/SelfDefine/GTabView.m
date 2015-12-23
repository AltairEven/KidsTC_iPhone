//
//  GTabView.m
//  iphone
//
//  Created by icson apple on 12-3-31.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GTabView.h"

@implementation GTabView

@synthesize buttons;

- (id)initWithFrame:(CGRect)frame withTabCount:(NSInteger) _tabCount widthMarginX:(CGFloat) _marginX delegate:(id<GTabViewDelegate>) _delegate
{
	if (self = [super initWithFrame: frame]) {
		tabCount = _tabCount;
		
		delegate = _delegate;
		buttons = [NSMutableArray arrayWithCapacity: tabCount];

		for (NSInteger i = 0; i < tabCount; i ++) {
			UIButton *btn = [delegate buttonFor: self atIndex: i];
			[btn addTarget: self action: @selector(touchUpInside:) forControlEvents: UIControlEventTouchUpInside];
			[btn addTarget: self action: @selector(touchDown:) forControlEvents: UIControlEventTouchDown];
			[btn addTarget: self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
			[btn addTarget: self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
			[btn addTarget: self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
	
			[self addSubview: btn];
			[buttons addObject: btn];
		}
		marginX = _marginX;
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGFloat currentX = 0.0;

	for (NSInteger i = 0; i < [buttons count]; i ++) {
		GTabButton *btn = [buttons objectAtIndex: i];
		
		[btn setFrame: CGRectMake(currentX, 0.0, btn.frame.size.width, self.frame.size.height)];
		currentX += btn.frame.size.width + marginX;
	}
}


-(void) dimAllButtonsExcept:(UIButton*)selectedButton
{
	for (GTabButton* button in buttons)
	{
		if (button == selectedButton)
		{
			button.selected = YES;
			button.highlighted = button.selected ? NO : YES;
		}
		else
		{
			button.selected = NO;
			button.highlighted = NO;
		}
	}
}

- (void)touchUpInside:(id)sender
{
	if ([delegate respondsToSelector:@selector(touchUpInsideTabIndex:)]){
		BOOL selected = [delegate touchUpInsideTabIndex:[buttons indexOfObject: sender]];
        if (selected) {
            [self dimAllButtonsExcept: sender];
        }
    }
}

- (void)touchDown:(id)sender
{
	//[self dimAllButtonsExcept: sender];
	
	if ([delegate respondsToSelector:@selector(touchDownAtTabIndex:)])
		[delegate touchDownAtTabIndex:[buttons indexOfObject: sender]];
}

- (void)otherTouchesAction:(id)sender
{
	//[self dimAllButtonsExcept: sender];
}

- (void)setButtonSelected:(NSUInteger) index
{
	if (index >= [buttons count]) {
		return;
	}
	
	[self touchUpInside: [buttons objectAtIndex: index]];
}
- (NSUInteger )selectedButton
{
    int index = 0;
    for (GTabButton* button in buttons)
	{
		if (button.selected)
		{
			break;
        }
        
        index++;
    }
    
    return index;
}
@end

@implementation GTabButton

@end
