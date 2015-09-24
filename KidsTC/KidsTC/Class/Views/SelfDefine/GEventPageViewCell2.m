//
//  GEventPageViewCell2.m
//  iphone51buy
//
//  Created by kunjiang on 12-7-13.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GEventPageViewCell2.h"


@implementation GEventPageViewCell2
@synthesize imageView, titleLabel, subTitleLabel;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier widthNoCustomBorder:(BOOL)_noCustomBorder
{
	if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier widthNoCustomBorder: _noCustomBorder]) {
		[self setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
		
		imageView = [[IcsonImageView alloc] initWithFrame: CGRectMake(10.0, 5.0, 70.0, 70.0)];
		[imageView setContentMode: UIViewContentModeScaleAspectFit];
		[self.contentView addSubview: imageView];
		
		titleLabel = MAKE_LABEL(CGRectMake(90.0, 23.0, self.frame.size.width - 90.0, 15.0), @"", [UIColor blackColor], 0);
		[titleLabel setFont: [UIFont boldSystemFontOfSize: 17.0f]];
		[self.contentView addSubview: titleLabel];
		
		subTitleLabel = MAKE_LABEL(CGRectMake(90.0, 44.0, self.frame.size.width - 90.0, 12.0), @"", [UIColor grayColor], 12.0);
		[self.contentView addSubview: subTitleLabel];
	}
	
	return self;
}

- (void)setEventRowData : (NSDictionary *)_rowData
{
	if (_rowData && [_rowData objectForKey: @"pic_url"]) {
		[imageView loadAsyncImage: [_rowData objectForKey: @"pic_url"] placeHolderImage: nil];
	} else {
		[imageView cleanImage];
	}
	
	[titleLabel setText: [_rowData objectForKey: @"title"]];
	[titleLabel sizeToFit];
	
	[subTitleLabel setText: [_rowData objectForKey: @"desc"]];
	[subTitleLabel sizeToFit];
}

@end