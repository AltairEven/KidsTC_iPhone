//
//  GEventPageViewCell1.h
//  iphone51buy
//
//  Created by kunjiang on 12-7-13.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTableViewCell.h"
#import "GEventPageViewCell1View.h"

@interface GEventPageViewCell1 : GTableViewCell
{
	NSMutableArray *itemViews;
}

- (void)clearItemViews;
- (void)addItemView: (GEventPageViewCell1View *)_itemView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier widthNoCustomBorder:(BOOL)_noCustomBorde;

@end