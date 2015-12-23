//
//  GEventPageViewCell1.m
//  iphone51buy
//
//  Created by kunjiang on 12-7-13.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GEventPageViewCell1.h"
 
@implementation GEventPageViewCell1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier widthNoCustomBorder:(BOOL)_noCustomBorder
{
if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier widthNoCustomBorder: _noCustomBorder]) {
	[self setAccessoryType: UITableViewCellAccessoryNone];
	self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
	itemViews = [[NSMutableArray alloc] initWithCapacity: 3];
}

return self;
}

- (void)dealloc
{
	 itemViews = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // ...
}

- (void)clearItemViews
{
    for (UIView *itemView in itemViews) {
        [itemView removeFromSuperview];
    }
	
    [itemViews removeAllObjects];
}

- (void)addItemView: (GEventPageViewCell1View *)_itemView
{
	NSUInteger count = [itemViews count];
	if (count >= 3) {
		return;
	}
	
	[itemViews addObject: _itemView];
	
	[_itemView setFrame: CGRectMake(count * self.frame.size.width/ 3, 0.0, _itemView.frame.size.width, _itemView.frame.size.height)];
	[self.contentView addSubview: _itemView];
}

@end