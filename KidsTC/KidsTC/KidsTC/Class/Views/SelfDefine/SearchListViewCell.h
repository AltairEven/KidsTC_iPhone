//
//  SearchListViewCell.h
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-7-30.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GToolUtil.h"
#import "TiledImageView.h"
#import "ASIDownloadCache.h"
#import "GTableViewCell.h"
#import "IcsonImageView.h"
#import "TTTAttributedLabel.h"

@class GStrikeLabel;
@interface SearchListViewCell : GTableViewCell
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

