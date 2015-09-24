//
//  GProductTableViewCell.h
//  iphone
//
//  Created by icson apple on 12-3-1.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GToolUtil.h"
#import "TiledImageView.h"
#import "ASIDownloadCache.h"
#import "GTableViewCell.h"
#import "IcsonImageView.h"
#import "TTTAttributedLabel.h"

@class GStrikeLabel;
@interface GProductTableViewCell : GTableViewCell
{
	IcsonImageView *productPic;
	GLabel *productNameLabel;
	GLabel *promotionWordLabel;
//	GLabel *priceLabel;
    GLabel *commentLabel;
//	TiledImageView *starView;
//	TiledImageView *starBgView;

	NSString *strPid;
//	UIView *baseView;
	TTTAttributedLabel *labelOfPrice;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setProductInfo:(NSDictionary *)_productInfo;
@end
