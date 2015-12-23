//
//  GShoppingCartTableCell.h
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

#import "UITextField+HideKeyboard.h"

enum {
	CART_VIEW_TYPE_NORMAL = 1,
	CART_VIEW_TYPE_EDIT,
    ES_VIEW_TYPE,
};

@class GStrikeLabel;
@interface GShoppingCartTableCell : GTableViewCell <UITextFieldDelegate> {
	IcsonImageView *productPic;
	
	GLabel *productNameLabel;
	GLabel *promotionWordLabel;
	GLabel *priceLabel;

	GLabel *_buyCountLabel;
	UITextField *_buyCountField;
	
	NSInteger _cartViewType;
	
	GStrikeLabel *marketPriceLabel;
	TiledImageView *starView;
	TiledImageView *starBgView;

	NSString *strPid;
}

@property (strong, nonatomic) IBOutlet UITextField *_buyCountLable;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setCartItemInfo:(NSDictionary *)cateItemInfo withEditType:(NSInteger)editType withRowIndex:(NSInteger)rowIndex;

@end
