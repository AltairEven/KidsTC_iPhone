//
//  GColorsLab.m
//  iphone51buy
//
//  Created by gene chu on 9/10/12.
//  Copyright (c) 2012 icson. All rights reserved.
//

#import "GColorsLab.h"
@interface GColorsLab()
{
    NSArray *_textArr;
    NSArray *_colorArr;
    CGFloat _lineSpace;
    CGRect  _drawRect;
}
+ (NSString *)getDisplayString:(NSString *)string font:(UIFont *)font displayRect:(CGRect)rect strSize:(CGSize *)strSize;

@end

@implementation GColorsLab
@synthesize font = _font;
@synthesize text;
@synthesize numberOfLine = _numberOfLine;
@synthesize lineHeight = _lineHeight;
@synthesize autoFitHeight = _autoFitHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _lineSpace = 2.0;
        self.font = [UIFont systemFontOfSize:16.0];
        _autoFitHeight = NO;
    }
    return self;
}
- (void)setFont:(UIFont *)newfont
{
    _font = newfont;
    NSString *aStr = @"A";
    CGSize aSize = [aStr sizeWithFont:_font];
    _lineHeight = aSize.height + _lineSpace;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (int)drawText:(NSString *)textStr color:(UIColor *)color newLine:(BOOL)inNewLine context:(CGContextRef)context viewRect:(CGRect )rect
{
    int drawLen = 0;
    /*Set color*/
    [color set];
    
    /*Set new draw rect*/
    if (inNewLine) {
        _drawRect.origin.x = rect.origin.x;
        _drawRect.origin.y += _lineHeight;
        _drawRect.size.width = rect.size.width;
    }
    
    /*Get fit width string */
    CGSize strSize;
    NSString *lineStr = [GColorsLab getDisplayString:textStr font:self.font displayRect:_drawRect strSize:&strSize];
    drawLen = (int)[lineStr length];
    [lineStr drawInRect:_drawRect withFont:self.font];
    
    if (drawLen<[textStr length]) {
        NSString *suffixStr = [textStr substringFromIndex:drawLen];
        drawLen += [self drawText:suffixStr color:color newLine:YES context:context viewRect:rect];
    }
    else
    {
        _drawRect.origin.x += strSize.width;
        _drawRect.size.width -= strSize.width;
    }
    
    return drawLen;
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect textRect = CGRectInset(rect, [self.font pointSize]/2, 4);
    _drawRect = CGRectMake(textRect.origin.x, textRect.origin.y, textRect.size.width, _lineHeight);
    for (int i = 0; i < [_textArr count]; i++) {
        NSString *textStr = [_textArr objectAtIndex:i];
        UIColor *textColor = [_colorArr objectAtIndex:i];
        
        CGContextSaveGState(context);
        int drawLen =[self drawText:textStr color:textColor newLine:NO context:context viewRect:textRect];
        CGContextRestoreGState(context);
        
        if (drawLen != [textStr length]) {
            //Draw error.
        }
    }
}


- (NSString *)text
{
    NSString *textStr = [NSString string];
    for (NSString *aStr in _textArr) {
        textStr = [textStr stringByAppendingString:aStr];
    }
    
    return textStr;
}
- (void)setTextAndColor:(id)firstArg,... 
{
    NSMutableArray *texts = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:0];
    
    va_list args;
    va_start(args, firstArg);
    int i = 0;
    for (id arg = firstArg; arg!=nil;arg= va_arg(args, id)) {
        if (i%2 == 0) {
            [texts addObject:arg];
        }
        else {
            [colors addObject:arg];
        }
        ++i;
    }
    /* text and color will appear in pair. */
    if (i%2 == 0) {
        _textArr = texts;
        _colorArr = colors;
    }
    
    
    if (self.autoFitHeight) {
        CGRect aRect = self.frame;
        aRect.size.height = [self fitHeight];
        self.frame = aRect;
    }
    
    [self setNeedsDisplay];
}
- (void)setTexts:(NSArray *)texts andColors:(NSArray *)colors
{
    if ([texts count] == [colors count]) {
        _textArr = texts;
        _colorArr = colors;
    }
    
    if (self.autoFitHeight) {
        CGRect aRect = self.frame;
        aRect.size.height = [self fitHeight];
        self.frame = aRect;
    }
    
    [self setNeedsDisplay];
    /*Exception*/
    
}
- (float)fitHeight
{
    float height = 0.0;
    CGSize textSize = [self.text sizeWithFont:self.font];
    int row = textSize.width/self.bounds.size.width;
    height = _lineHeight * row;
    return height;
}

+ (NSString *)getDisplayString:(NSString *)string font:(UIFont *)font displayRect:(CGRect)rect strSize:(CGSize *)strSize
{
    NSString *strVal = string;
	NSInteger n1 = [string length];
    //	int n2 = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
    //	if (n1 == n2)
	{
		CGSize constraintSize = CGSizeMake(300.0f, MAXFLOAT);
		CGSize labelSize = [string sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
		*strSize = labelSize;
		
		if (labelSize.width > rect.size.width)
		{
			for (int i = 1; i< n1; i++)
			{
				strVal = [strVal substringWithRange:NSMakeRange(0, n1-i)];
				labelSize = [strVal sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
				if (labelSize.width <= rect.size.width)
				{
					break;
				}
			}
		}
	}
	
	return strVal;
}
@end
