//
//  GProductTableViewCell.m
//  iphone
//
//  Created by icson apple on 12-3-1.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GConfig.h"
#import "GShoppingCartTableCell.h"
#import "UITextField+HideKeyboard.h"

@implementation GShoppingCartTableCell
@synthesize _buyCountLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier widthNoCustomBorder:(BOOL)_noCustomBorder
{
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier widthNoCustomBorder: _noCustomBorder];
    if (self) {
        [self initCustomViews];
    }

    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCustomViews];
    }
    return self;
}

- (void)initCustomViews
{
    self.textLabel.highlightedTextColor = self.textLabel.textColor;
    
    productPic = [[IcsonImageView alloc] initWithFrame: CGRectMake(10.0, 10.0, 60.0, 60.0)];
    [productPic setContentMode: UIViewContentModeScaleAspectFit];
	[productPic setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview: productPic];
    
    productNameLabel = MAKE_LABEL(CGRectMake(75.0, 10.0, self.frame.size.width - 75.0 - 10.0 - 10.0 - 34.0f, 33.0), @"", RGBA(51.0, 51.0, 51.0, 1.0), 15.0);
    productNameLabel.textAlignment = UITextAlignmentLeft;
	[productNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview: productNameLabel];
    
    promotionWordLabel = MAKE_LABEL(CGRectMake(75.0, 35.0, self.frame.size.width - 75.0 - 10.0 - 10.0 - 34.0f, 20.0), @"", [UIColor redColor], 13.0);
    promotionWordLabel.textAlignment = UITextAlignmentLeft;
	[promotionWordLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview: promotionWordLabel];
    
    priceLabel = MAKE_LABEL(CGRectMake(75.0, 70.0, 50.0, 30.0), @"", [UIColor redColor], 15.0);
	[priceLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview: priceLabel];
	
	_buyCountLabel = MAKE_LABEL(CGRectMake(150.0, 70.0, 50.0, 30.0), @"数量:", [UIColor grayColor], 15.0);
	[_buyCountLabel setBackgroundColor:[UIColor clearColor]];
	[_buyCountLabel sizeToFit];
    [self.contentView addSubview:_buyCountLabel];
    
	_buyCountField = [[UITextField alloc] initWithFrame:CGRectMake(185.0, 69.0, 45.0, 26.0)];
	
	_buyCountField.textColor = [UIColor grayColor];
	_buyCountField.textAlignment = UITextAlignmentLeft;
	_buyCountField.borderStyle = UITextBorderStyleNone;
	_buyCountField.keyboardType = UIKeyboardTypeNumberPad;
	_buyCountField.returnKeyType = UIReturnKeyDone;
	
	_buyCountField.userInteractionEnabled = NO;
	
	[_buyCountField hideKeyboard:self.contentView];
	[_buyCountField setBackgroundColor:[UIColor clearColor]];
	[self.contentView addSubview: _buyCountField];
    
	
    starBgView = [[TiledImageView alloc] initWithFrame: CGRectMake(10.0, 75.0, 55.0, 11.0) tiledImage: LOADIMAGE(@"p_star_on", @"png")];
    starView = [[TiledImageView alloc] initWithFrame: CGRectZero tiledImage: LOADIMAGE(@"p_star_on", @"png")];
    [starView setBackgroundColor: [UIColor clearColor]];
    
    [starBgView setBackgroundColor: [UIColor clearColor]];
    [starBgView addSubview: starView];
    [self.contentView addSubview: starBgView];
    
    self.frame = CGRectMake(0.0, 0.0, self.frame.size.width, PRODUCT_TABLE_VIEW_CELL_HEIGHT);
}

- (void)dealloc
{
	if (strPid) {
		 strPid = nil;
	}

}

- (void)setCartItemInfo:(NSDictionary *)cateItemInfo withEditType:(NSInteger)editType withRowIndex:(NSInteger)rowIndex {
	[productNameLabel setText: [cateItemInfo objectForKey: @"name"]];
    [productNameLabel sizeToFitWithMaximumNumberOfLines: 2];

	[promotionWordLabel setText: [cateItemInfo objectForKey: @"promotion_word"]];
    [promotionWordLabel sizeToFitWithMaximumNumberOfLines: 1];

    [promotionWordLabel setFrame: CGRectMake(promotionWordLabel.frame.origin.x,  productNameLabel.frame.origin.y + productNameLabel.frame.size.height, promotionWordLabel.frame.size.width, promotionWordLabel.frame.size.height)];
    int showPrice = [[cateItemInfo objectForKey: @"price"] intValue];
    if (showPrice == kNotSoldPrice) {
        [priceLabel setText:kNotSoldString];
    }
    else {
        [priceLabel setText:[NSString stringWithFormat:@"¥%@",[GToolUtil covertPriceToString:[[cateItemInfo objectForKey: @"price"] intValue]]]];
    }
	[priceLabel sizeToFit];

	if ( editType == CART_VIEW_TYPE_NORMAL || editType == ES_VIEW_TYPE) {
		_buyCountField.userInteractionEnabled = NO;
		_buyCountField.borderStyle = UITextBorderStyleNone;
	} else {
		_buyCountField.userInteractionEnabled = YES;
		_buyCountField.borderStyle = UITextBorderStyleRoundedRect;
	}
    
	_buyCountField.tag = rowIndex;
    if (editType == ES_VIEW_TYPE)
    {
        // For ES_product only 1 item every time
        [_buyCountField setText:[NSString stringWithFormat:@"%d", 1]];
    }
    else
    {
        [_buyCountField setText:[NSString stringWithFormat:@"%ld", (long)[[cateItemInfo objectForKey:@"buy_count"] integerValue]]];
    }
    
	[_buyCountField addTarget:self.superview action:@selector(cartItemNumFieldOnFocus:) forControlEvents:UIControlEventEditingDidBegin];
	[_buyCountField addTarget:self.superview action:@selector(cartItemNumChanged:) forControlEvents:UIControlEventEditingChanged];
	[_buyCountField addTarget:self.superview action:@selector(cartItemNumChangedDone:) forControlEvents:UIControlEventEditingDidEnd];
	
	[_buyCountField setDelegate:self];


	strPid = [NSString stringWithFormat: @"%@", [cateItemInfo objectForKey: @"product_id"]];
	NSDictionary *commentDic = [cateItemInfo objectForKey: @"comment"];
	BOOL stared = NO;

	if (commentDic && [commentDic isKindOfClass: [NSDictionary class]] && [commentDic objectForKey: @"star_length"]) {
		NSInteger starLength = [[commentDic objectForKey: @"star_length"] integerValue];
		if (starLength >= 0 && starLength <= 100) {
            [starView setFrame: CGRectMake(0.0, 0.0, starLength * 55.0 / 100.0, 11.0)];
            [starView setNeedsDisplay];
            stared = YES;
		}
	}

	[starView setHidden: !stared];
	[starBgView setHidden: !stared];

	[productPic loadAsyncImage: [GToolUtil getProductPic: [cateItemInfo objectForKey: @"product_char_id"] type: @"middle" index: 0]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
	NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
	
	if ( [string isEqualToString:filtered] ) {
	} else {
		return NO;
	}
	
	if ( range.location >= 2 ) {
		return NO;
	}
	
	return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // ...
}


@end
