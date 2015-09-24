//
//  GTableViewCell.m
//  iphone
//
//  Created by icson apple on 12-4-20.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GTableViewCell.h"

@implementation GTableViewCell

@synthesize borderLayer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
		[self _setDefaultBackground];
		noCustomBorder = NO;
        [self _createLayer];
	}
	
	return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier widthNoCustomBorder:(BOOL)_noCustomBorder
{
	if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
		[self _setDefaultBackground];
		noCustomBorder = _noCustomBorder;
        if(!noCustomBorder){
            [self _createLayer];
        }
	}

	[self setNeedsDisplay];
	return self;
}

- (void) dealloc
{
    _cellDelegate = nil;
}

- (void)_setDefaultBackground
{
    UIView * view = [[UIView alloc] init];
	self.selectedBackgroundView =view;
	self.selectedBackgroundView.backgroundColor = RGBA(237.0, 244.0, 254.0, 1.0);
}

- (void)_createLayer
{
    borderLayer = [CALayer layer];
    borderLayer.backgroundColor = [RGBA(233.0, 233.0, 233.0, 1.0) CGColor];
    [self.layer addSublayer: borderLayer];
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	if(borderLayer){
		borderLayer.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
	}
    
//    self.backgroundColor = [UIColor whiteColor];
}

@end
