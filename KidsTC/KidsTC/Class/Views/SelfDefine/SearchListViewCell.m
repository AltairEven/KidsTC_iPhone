//
//  SearchListViewCell.m
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-7-30.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import "SearchListViewCell.h"
#import "NSAttributedString+Attributes.h"

@interface SearchListViewCell ()

@property (strong, nonatomic) UIImageView *tagView;

@end

@implementation SearchListViewCell

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
    //    baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 80.0f, PRODUCT_TABLE_VIEW_CELL_HEIGHT)];
    //	baseView.backgroundColor = [UIColor clearColor];
    //	[self.contentView addSubview:baseView];
    //	[baseView release];
    productPic = [[IcsonImageView alloc] initWithFrame: CGRectMake(8.0f, 10.0f, 80, 80)];
	productPic.userInteractionEnabled = YES;
    [productPic setContentMode: UIViewContentModeScaleAspectFit];
    [self.contentView addSubview: productPic];
    
    productNameLabel = MAKE_LABEL(CGRectMake(103.0, 6.0, self.frame.size.width - 103 - 10, 33.0), @"",[UIColor blackColor], 15.0);
	productNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview: productNameLabel];
    
    promotionWordLabel = MAKE_LABEL(CGRectMake(103.0, 40.0, self.frame.size.width - 103 - 10.0, 20.0), @"", [UIColor colorWithRed:136.0f/255.0f green:136.0f/255.0f blue:136.0f/255.0f alpha:1.0f], 14.0);
    promotionWordLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview: promotionWordLabel];
	
    //    priceLabel = MAKE_LABEL(CGRectMake(80.0, 68.0, 50.0, 30.0), @"", [UIColor redColor], 18.0);
    //    [self.contentView addSubview: priceLabel];
    
	labelOfPrice = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(103.0, 63.0, 150.0, 30.0)];
	labelOfPrice.backgroundColor = [UIColor clearColor];
	labelOfPrice.lineBreakMode = NSLineBreakByWordWrapping;
	labelOfPrice.numberOfLines = 1;
	labelOfPrice.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
	[self.contentView addSubview:labelOfPrice];
    
    commentLabel = MAKE_LABEL(CGRectMake(200.0, 65.0, 100.0, 30.0), @"", [UIColor colorWithRed:153.0/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f], 14.0);
    commentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview: commentLabel];
    
    //    starBgView = [[TiledImageView alloc] initWithFrame: CGRectMake(10.0, 75.0, 55.0, 11.0) tiledImage: LOADIMAGE(@"p_star_off", @"png")];
    //    starView = [[TiledImageView alloc] initWithFrame: CGRectZero tiledImage: LOADIMAGE(@"p_star_on", @"png")];
    //    [starView setBackgroundColor: [UIColor clearColor]];
    //
    //    [starBgView setBackgroundColor: [UIColor clearColor]];
    //    [starBgView addSubview: starView];
    //    [self.contentView addSubview: starBgView];
    
    self.tagView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 44, 44)];
    [self.contentView addSubview:self.tagView];
    
    self.frame = CGRectMake(0.0, 0.0, self.frame.size.width, PRODUCT_TABLE_VIEW_CELL_HEIGHT);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [productNameLabel sizeToFitWithMaximumNumberOfLines: 2];
    [promotionWordLabel sizeToFitWithMaximumNumberOfLines: 1];
    
    [promotionWordLabel setFrame: CGRectMake(promotionWordLabel.frame.origin.x,  productNameLabel.frame.origin.y + productNameLabel.frame.size.height, promotionWordLabel.frame.size.width, promotionWordLabel.frame.size.height)];
}

- (void)setProductInfo:(NSDictionary *)_productInfo
{
	NSString *name = [_productInfo objectForKey:@"productTitle"];
	[productNameLabel setText:name];
    //[productNameLabel sizeToFitWithMaximumNumberOfLines: 2];
    
	[promotionWordLabel setText: [_productInfo objectForKey: @"promotionDesc"]];
    //[promotionWordLabel sizeToFitWithMaximumNumberOfLines: 1];
	
    //[promotionWordLabel setFrame: CGRectMake(promotionWordLabel.frame.origin.x,  productNameLabel.frame.origin.y + productNameLabel.frame.size.height, promotionWordLabel.frame.size.width, promotionWordLabel.frame.size.height)];
    //过滤无货商品显示价格为999999
    int showPrice = [[_productInfo objectForKey:@"price"] intValue];
    
	//NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    [labelOfPrice setTextColor:[UIColor redColor]];
    if (showPrice == kNotSoldPrice)
	{
        [labelOfPrice setText: kNotSoldString];
    }
    else {
        //[labelOfPrice setTextColor:[UIColor redColor]];
        [labelOfPrice setText:[NSString stringWithFormat:@"¥%@",[GToolUtil covertPriceToString:showPrice]]];
		/*NSMutableAttributedString *a = [[NSMutableAttributedString alloc] initWithString:@"¥"];
         [a setTextColor:[UIColor redColor]];
         [a setFont:[UIFont systemFontOfSize:12.0f]];
         [attributedStr appendAttributedString:a];
         [a release];
         
         NSString *str = [NSString stringWithFormat:@"%d",showPrice];
         int len = [str length];
         if(len > 5) //千位以上不显示小数
         {
         NSString *strB = [NSString stringWithFormat:@"%d",showPrice/100];
         NSMutableAttributedString *b = [[NSMutableAttributedString alloc] initWithString:strB];
         [b setTextColor:[UIColor colorWithRed:233.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:1.0]];
         [b setFont:[UIFont boldSystemFontOfSize:18.0f]];
         [attributedStr appendAttributedString:b];
         [b release];
         
         }
         else //如果是0留一位 否则留二位
         {
         NSString *strB = [NSString stringWithFormat:@"%d",showPrice/100];
         NSMutableAttributedString *b = [[NSMutableAttributedString alloc] initWithString:strB];
         [b setTextColor:[UIColor colorWithRed:233.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:1.0]];
         [b setFont:[UIFont boldSystemFontOfSize:18.0f]];
         [attributedStr appendAttributedString:b];
         [b release];
         
         NSString *strC = nil;
         int temp = showPrice%100;
         if(temp>10)
         {
         strC = [str substringFromIndex:len-2];
         }
         else// if(temp == 0)
         {
         strC = @"0";
         }
         NSString *strCNew = [NSString stringWithFormat:@".%@",strC];
         NSMutableAttributedString *c = [[NSMutableAttributedString alloc] initWithString:strCNew];
         [c setTextColor:[UIColor colorWithRed:233.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:1.0]];
         [c setFont:[UIFont boldSystemFontOfSize:18.0f]];
         [attributedStr appendAttributedString:c];
         [c release];
         }
         [labelOfPrice setText:attributedStr];
         [attributedStr release];*/
    }
    //	[labelOfPrice sizeToFit];
	
    
    
	strPid = [NSString stringWithFormat: @"%@", [_productInfo objectForKey: @"sysNo"]];
    int commontCount = [[_productInfo objectForKey:@"evaluationNum"] intValue];
    if (commontCount > 0) {
        commentLabel.text = [NSString stringWithFormat:@"%d人评论", commontCount];
    } else {
        commentLabel.text = @"";
    }
    
    //	[starView setHidden: !stared];
    //	[starBgView setHidden: !stared];
	productPic.clickDownloadMode = YES;
	[productPic loadAsyncImage: [GToolUtil getProductPic: [_productInfo objectForKey:@"productID"] type: @"middle" index: 0]];
    
    BOOL noSale = [_productInfo[@"onlineQty"] integerValue] <= 0;
    BOOL notReachable = [_productInfo[@"reachable"] boolValue];
    if (noSale) {
        self.tagView.hidden = NO;
        self.tagView.image = LOADIMAGE(@"Search_NoSale", @"png");
    }
    else if (notReachable) {
        self.tagView.hidden = NO;
        self.tagView.image = LOADIMAGE(@"Search_NotReachable", @"png");
    }
    else {
        self.tagView.hidden = YES;
        self.tagView.image = nil;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
    // ...
}

//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//	NSTimeInterval system = [[NSProcessInfo processInfo] systemUptime];
//	
//	NSLog(@"<%f,%f>",point.x,point.y);
//	if (system - event.timestamp > 0.1)
//	{}
//	else
//	{
//	 	if(point.x>= 10.0f && point.x <= 90.0f)
//		{
//			return [baseView hitTest:point withEvent:event];
//		}
//		else 
//		{
//			return [super hitTest:point withEvent:event];;
//		}
//	}
//	return [super hitTest:point withEvent:event];
//}

@end
