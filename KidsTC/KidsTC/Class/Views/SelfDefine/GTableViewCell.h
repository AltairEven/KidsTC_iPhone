//
//  GTableViewCell.h
//  iphone
//
//  Created by icson apple on 12-4-20.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTableViewCell;

@protocol GTableViewCellDelegate <NSObject>

@optional
- (BOOL) shouldUpdateContent;

@end

////////////////////////////////////////////////////////////////////////////

@interface GTableViewCell : UITableViewCell
{
	@private
	BOOL noCustomBorder;
}

@property (nonatomic, weak) id<GTableViewCellDelegate>    cellDelegate;
@property (strong, nonatomic, readonly) CALayer *borderLayer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier widthNoCustomBorder:(BOOL)_noCustomBorder;

@end
