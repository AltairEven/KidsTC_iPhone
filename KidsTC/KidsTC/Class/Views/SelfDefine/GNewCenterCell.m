/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GNewCenterCell.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：xiaomanwang
 * 完成日期：12-11-5
 */


#import "GNewCenterCell.h"
#import <UIKit/UIKit.h>

@implementation GVirtualOrderCell

@end

@implementation GNewCenterCell
@synthesize labelOfNum;
@synthesize labelOfOrderNo;
@synthesize labelOfStatus;
@synthesize imageView;
@synthesize backWhiteView;
@synthesize imageViewOfLine;

@end


@implementation GChongZhiCell
@synthesize imageViewOfType, labelOfMoney,labelOfTypeName,labelOfPhoneNumber,imageViewOfAccessory,imageViewOfLine,backWhiteView;

@end


@implementation GProductPicCell
@synthesize imageViewAccessosry,imageViewOfLine, backWhiteView;

- (void)layoutSubviews
{
	[super layoutSubviews];  //111  不重新用320布局  一条包裹的情况 中间的背景图
	//self.backWhiteView.frame = CGRectMake(10.0f, 0.0f, 320.0f - 20.0f, 90.0f);
	self.scrollView.frame = CGRectMake(20, 10, CGRectGetWidth(self.backWhiteView.frame) - 20 - 14 - 10  , 70);
	CGRect rect = self.backWhiteView.frame;
	self.imageViewOfLine.frame = CGRectMake(rect.origin.x , 90 - 1.0f, rect.size.width, 1.0f);
}

@end

@implementation GProductPackageCell

@end

@implementation GMoneyCell
@synthesize labelOfSumHint, labelOfSumMoney, labelOfType, labelOfTime,buttonOfPay,backWhiteView;

@end

@implementation GSumCell


@end

@implementation GDeliveryCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		self.backgroundColor = [UIColor clearColor];
		UIImage* bgImage = LOADIMAGE(@"my_icson_cell_bg_middle", @"png");
		bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2.0f topCapHeight:bgImage.size.height/2.0f];
		self.imageViewOfBg = [[UIImageView alloc] initWithImage:bgImage];
		self.imageViewOfBg.backgroundColor = [UIColor clearColor];
		self.imageViewOfBg.frame = CGRectMake(5.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
		[self.contentView addSubview:self.imageViewOfBg];
		[self.contentView sendSubviewToBack:self.imageViewOfBg];
		
		self.labelOfDelivery = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10.0, 7.0, self.frame.size.width - 20.0 - 140.0, 0.0)];
		self.labelOfDelivery.backgroundColor = [UIColor clearColor];
		self.labelOfDelivery.font = [UIFont systemFontOfSize:14.0];
		self.labelOfDelivery.lineHeightMultiple = 1.0;
		self.labelOfDelivery.leading = 0;
		self.labelOfDelivery.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
		self.labelOfDelivery.textColor = COLOR_EBLACK;
		self.labelOfDelivery.lineBreakMode = NSLineBreakByCharWrapping;
		self.labelOfDelivery.numberOfLines = 0;
		[self.contentView addSubview: self.labelOfDelivery];
		self.labelOfDelivery.frame = CGRectMake(15, 10, CGRectGetWidth(self.labelOfDelivery.frame), CGRectGetHeight(self.labelOfDelivery.frame));
		
//		self.labelOfTel = [[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.labelOfDelivery.frame)+10, CGRectGetWidth(self.labelOfTel.frame), CGRectGetHeight(self.labelOfTel.frame))] autorelease];
//		self.labelOfTel.backgroundColor = [UIColor clearColor];
//		self.labelOfTel.font = [UIFont systemFontOfSize:14.0f];
//		self.labelOfTel.lineHeightMultiple = 1.0;
//		self.labelOfTel.leading = 0;
//		self.labelOfTel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
//		self.labelOfTel.textColor = COLOR_EBLACK;
//		self.labelOfTel.lineBreakMode = NSLineBreakByCharWrapping;
//		self.labelOfTel.numberOfLines = 0;
//		[self.contentView addSubview: self.labelOfTel];
//		self.labelOfTel.text = @"电话:";
		
		self.labelOfTime = MAKE_LABEL(CGRectZero, @"2012 -12 -12", RGBA(68, 68, 68, 1), 15);
		[self.labelOfTime sizeToFit];
		[self.contentView addSubview:self.labelOfTime];
		self.labelOfTime.frame = CGRectMake(CGRectGetMinX(self.labelOfDelivery.frame), CGRectGetMaxY(self.labelOfDelivery.frame)+15, CGRectGetWidth(self.labelOfTime.frame), CGRectGetHeight(self.labelOfTime.frame));
	    UIImage *lineImage = LOADIMAGE(@"line_dash", @"png");
		self.imageViewOfLine = [[UIImageView alloc] initWithImage:lineImage];
		self.imageViewOfLine.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.imageViewOfLine];
		self.imageViewOfLine.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1);
	}
	return self;
}
@end

@implementation GMapCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		UIImage *imageBg = LOADIMAGE(@"my_icson_cell_bg_down", @"png");
		imageBg = [imageBg stretchableImageWithLeftCapWidth:imageBg.size.width/2.0f topCapHeight:imageBg.size.height/2.0f];
		self.imageViewOfBg = [[UIImageView alloc] initWithImage:imageBg];
		[self.backgroundView addSubview: self.imageViewOfBg];
		
		UIImage *imageMapIcon = LOADIMAGE(@"order_map_icon", @"png");
		self.imageViewOfMap = [[UIImageView alloc] initWithImage:imageMapIcon];
		[self.contentView addSubview:self.imageViewOfMap];
		self.imageViewOfMap.frame = CGRectMake(10, 10, 43, 43);
	
		self.labelOfCheck = MAKE_LABEL(CGRectZero, @"查看快递员位置", RGBA(68.0, 68.0f, 68.0f, 1.0f), 15.0f);
		[self.labelOfCheck sizeToFit];
		[self.contentView addSubview:self.labelOfCheck];
		self.labelOfCheck.frame = CGRectMake(CGRectGetMaxX(self.imageViewOfMap.frame) + 10.0f, (CGRectGetHeight(self.frame) - CGRectGetHeight(self.labelOfCheck.frame))/2.0f, CGRectGetWidth(self.labelOfCheck.frame),CGRectGetHeight(self.labelOfCheck.frame));

		self.labelOfRange = MAKE_LABEL(CGRectZero, @"未进入1公里范围", RGBA(68, 68, 68, 1), 15);
		[self.labelOfRange sizeToFit];
		[self.contentView addSubview:self.labelOfRange];
		self.labelOfRange.frame = CGRectMake(200, (CGRectGetHeight(self.frame)- CGRectGetHeight(self.labelOfRange.frame))/2, CGRectGetWidth(self.labelOfRange.frame), CGRectGetHeight(self.labelOfRange.frame));
		
		UIImage *accesoryImg =LOADIMAGE(@"arrow", @"png");
		self.accessoryImage = [[UIImageView alloc] initWithImage:accesoryImg];
		[self.contentView addSubview:self.accessoryImage];
		self.accessoryImage.frame = CGRectMake(CGRectGetWidth(self.frame)-10-10, 20, 15, 15);
		
		UIImage *lineImage = LOADIMAGE(@"order_detail_line", @"png");
		self.imageViewOfLine = [[UIImageView alloc] initWithImage:lineImage];
		[self.contentView addSubview:self.imageViewOfLine];
		
	}
	return self;
}

@end

@implementation GCornerView
@synthesize backColor;
@synthesize fillColor;
@synthesize  isTop;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
	{
		self.isTop = NO;
		self.backColor = [UIColor clearColor];
		self.fillColor = [UIColor whiteColor];
		self.backgroundColor = self.backColor;
    }
    return self;
}

- (id)initWithIsTop:(BOOL)newIsTop andBackColor:(UIColor*)newBackColor andFillColor:(UIColor*)newFillColor andFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.isTop = newIsTop;
		self.backColor = newBackColor;
		self.fillColor = newFillColor;
		self.backgroundColor = self.backColor;
		self.opaque = NO;
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	CGContextRef context=UIGraphicsGetCurrentContext();
	CGFloat ovalHeight = 0.0f, ovalWidth = 0.0f;
	CGFloat width = CGRectGetWidth(rect);
	CGFloat height = CGRectGetHeight(rect);
    ovalHeight = height/8.0;
	ovalWidth = width/60.0f;
	if(self.isTop)
	{
		addTopRoundedRectToPath(context, rect,ovalWidth , ovalHeight);
		CGFloat red[4] = {205.0f/255.0f, 205.0f/255.0f, 205.0f/255.0f, 1.0f};
		CGContextSetStrokeColor(context, red);
		CGContextSetLineWidth(context,1.0f);
//		CGContextStrokePath(context);
		CGContextSetFillColorWithColor(context,[self.fillColor CGColor]);
//		CGContextFillPath(context);
		CGContextDrawPath(context,kCGPathFillStroke);

	}
	else
	{
		addRoundedDownRectToPath(context, rect,ovalWidth, ovalHeight);
		CGFloat red[4] = {205.0f/255.0f, 205.0f/255.0f, 205.0f/255.0f, 1.0f};
		CGContextSetStrokeColor(context, red);
		CGContextSetLineWidth(context,1.0f);
//		CGContextStrokePath(context);
		CGContextSetFillColorWithColor(context,[self.fillColor CGColor]);
//		CGContextFillPath(context);
		CGContextDrawPath(context,kCGPathFillStroke);
	}
}

static void addTopRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
							 float ovalHeight)
{
	float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0)
	{ // 1
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context); // 2
    CGContextTranslateCTM (context, CGRectGetMinX(rect), // 3
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight); // 4
    fw = CGRectGetWidth (rect) / ovalWidth; // 5
    fh = CGRectGetHeight (rect) / ovalHeight; // 6
    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, 0, fw/2, 0, 1); // 10
    CGContextAddArcToPoint(context, 0, 0, 0, fh/2, 1); // 11
	CGFloat x1, y1;
	x1 = 0.0; y1 = fh;
	CGContextAddLineToPoint(context, x1, y1);
    x1 = fw;
	y1 = fh;
  	CGContextAddLineToPoint(context, x1, y1);
    CGContextClosePath(context); // 12
    CGContextRestoreGState(context); // 13
}


static void addRoundedDownRectToPath(CGContextRef context, CGRect rect,
							  float ovalWidth,float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0)
	{ // 1
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context); // 2
    CGContextTranslateCTM (context, CGRectGetMinX(rect), // 3
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight); // 4
    fw = CGRectGetWidth (rect) / ovalWidth; // 5
    fh = CGRectGetHeight (rect) / ovalHeight; // 6
    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); // 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // 9
	CGFloat x1, y1;
	x1 = 0.0; y1 = 0.0f;
	CGContextAddLineToPoint(context, x1, y1);
    x1 = fw;
	y1 = 0.0f;
  	CGContextAddLineToPoint(context, x1, y1);
    CGContextClosePath(context); // 12
    CGContextRestoreGState(context); // 13
}

@end