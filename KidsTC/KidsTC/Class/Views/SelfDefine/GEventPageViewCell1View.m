//
//  GEventPageViewCell1View.m
//  iphone51buy
//
//  Created by kunjiang on 12-7-13.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GEventPageViewCell1View.h"


@implementation GEventPageViewCell1View
@synthesize imgView, priceLabel, nameLabel, itemInfo, rightBorderLayer;
@synthesize targetID= _targetID;


- (id)initWithFrame:(CGRect)frame withRightBorder:(BOOL)_rightBorder
{
	if (self = [super initWithFrame: frame]) {
        _targetID = GPageCommonActionUnknow;
		imgView = [[IcsonImageView alloc] initWithFrame: CGRectMake(12.0, 12.0, 80.0, 80.0)];
		[imgView setContentMode: UIViewContentModeScaleAspectFit];
		[self addSubview: imgView];
		
		priceLabel = MAKE_LABEL(CGRectMake(5.0, 100.0, self.frame.size.width - 10.0, 15.0), @"", [UIColor redColor], 15.0);
		[priceLabel setFont: [UIFont boldSystemFontOfSize: 15.0]];
		[self addSubview: priceLabel];
		
		nameLabel = MAKE_LABEL(CGRectMake(5.0, 120.0, self.frame.size.width - 10.0, 40.0), @"", [UIColor blackColor], 14.0);
		[self addSubview: nameLabel];
		
		if (_rightBorder) {
			rightBorderLayer = [CALayer layer];
			rightBorderLayer.backgroundColor = [RGBA(233.0, 233.0, 233.0, 1.0) CGColor];
			[rightBorderLayer setFrame: CGRectMake(self.frame.size.width - 1.0, 0.0, 1.0, self.frame.size.height)];
			
			[self.layer addSublayer: rightBorderLayer];
		}
		
	    [self setBackgroundColor: [UIColor whiteColor]];
	}
	
	return self;
}

- (void)setItemInfo:(NSDictionary *)_itemInfo
{
	if (itemInfo) {
		 itemInfo = nil;
	}
	
	if (!_itemInfo) {
		[imgView cleanImage];
		[priceLabel setText: @""];
		[nameLabel setText: @""];
		return;
	}
	
	itemInfo = _itemInfo;
	
	if([_itemInfo objectForKey: @"pic_url"]){
		imgView.clickDownloadMode = YES;
		[imgView loadAsyncImage: [_itemInfo objectForKey: @"pic_url"]];
	} else {
		[imgView cleanImage];
	}
    int showPrice = [[_itemInfo objectForKey: @"show_price"] intValue];
    if (showPrice == kNotSoldPrice) {
        priceLabel.text = kNotSoldString;
    }
    else {
        [priceLabel setText:[NSString stringWithFormat:@"¥%@",[GToolUtil covertPriceToString:showPrice]]];
    }
	
	
	[priceLabel sizeToFit];
	
	[nameLabel setText: [_itemInfo objectForKey: @"name"]];
    [nameLabel sizeToFitWithMaximumNumberOfLines: 2];
}

//- (void)layoutSubviews
//{
//	[super layoutSubviews];
//
//	if (rightBorderLayer) {
//		[rightBorderLayer setFrame: CGRectMake(self.frame.size.width - 1.0, 0.0, 1.0, self.frame.size.height)];
//	}
//}

@end
