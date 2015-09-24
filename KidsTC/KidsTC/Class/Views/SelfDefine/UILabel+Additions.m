//
//  UILabel+Additions.m
//  iphone51buy
//
//  Created by icson apple on 12-6-23.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#include <UIKit/UIKit.h>

#import "UILabel+Additions.h"

@implementation UILabel(Additions)

- (CGFloat)sizeToFitWithMaximumNumberOfLines:(NSInteger)lines
{
    return [self sizeOfSizeToFitWithMaximumNumberOfLines:lines].height;
}


- (CGSize)sizeOfSizeToFitWithMaximumNumberOfLines:(NSInteger)lines {
    self.numberOfLines = lines;
    CGSize maxSize = CGSizeMake(self.frame.size.width, lines * self.font.lineHeight);
    /////////edit by Altair, 20150320, for iOS 7+
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 1.0;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.font, NSFontAttributeName,
                               paragraphStyle, NSParagraphStyleAttributeName, nil];
    CGSize size = [self.text boundingRectWithSize:maxSize
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                       attributes:attribute
                                          context:nil].size;
    ///////////////////////////////////////////////
    //CGSize size = [self.text sizeWithFont:self.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByTruncatingTail];
    //self.lineBreakMode = NSLineBreakByTruncatingTail;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    return size;
}


- (void)sizeToFitWithMaximumNumberOfLinesExtend:(NSInteger)lines
{
	self.numberOfLines = lines;
    CGSize maxSize = CGSizeMake(self.frame.size.width, lines * self.font.lineHeight);
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
	NSInteger pos = -1;
	if(size.height > maxSize.height)
	{
		NSString *str = self.text;
		NSInteger len = [str length];
		for(NSInteger i = 0; i<len; i++)
		{
			NSString *s = [str substringToIndex: len - i];
			s = [NSString stringWithFormat:@"%@...",s];
			CGSize ss = [s sizeWithFont:self.font  constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
			if(ss.height == maxSize.height)
			{
				pos = i;
				break;
			}
		}
	}
	if(pos != -1)
	{
		NSInteger len = [self.text length];
		NSString *ss = [self.text substringToIndex: len - pos];
		ss = [NSString stringWithFormat:@"%@...",ss];
		self.text = ss;
		size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
	}
    self.lineBreakMode = NSLineBreakByCharWrapping;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
}

typedef enum
{
	OVER_TWO_LINE_INVALID,
	OVER_TWO_LINES,                 //超过两行的高度
	OVER_TWO_LINE_PLUS_ESCAPE,      //不超过两行，但是加上预留的空间就超过两行了
	NOT_OVER_TWO_LINES,             //加上预留的空间也不超过两行
}STATUS_FLAG;

- (void)sizeToFitWithMaximumNumberOfLinesExtend:(NSInteger)lines andLastLineEscapeWidth:(NSInteger)escapeWidth
{
    STATUS_FLAG status = OVER_TWO_LINE_INVALID;
	
	self.numberOfLines = lines;
    CGSize maxSize = CGSizeMake(self.frame.size.width, lines * self.font.lineHeight);
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
	NSInteger pos = -1;
	if(size.height > maxSize.height)
	{
		NSString *str = self.text;
		NSInteger len = [str length];
		for(NSInteger i = 0; i<len; i++)
		{
			NSString *s = [str substringToIndex: len - i];
			s = [NSString stringWithFormat:@"%@...",s];
			CGSize ss = [s sizeWithFont:self.font  constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
			if(ss.height <= maxSize.height)
			{
				pos = i;
				break;
			}
		}
		status = OVER_TWO_LINES;
	}/*get proper position*/
	else if(size.height == maxSize.height)
	{
		//caculate the width when one line
		NSString *s = [NSString stringWithFormat:@"%@...",self.text];
		CGSize size = [s sizeWithFont:self.font constrainedToSize:CGSizeMake(CGFLOAT_MAX,self.font.lineHeight) lineBreakMode:NSLineBreakByCharWrapping];
		if(size.width > self.frame.size.width) //超过一行
		{
			if(size.width + escapeWidth > self.frame.size.width*2)//第二行加 escapeWidth 超过两行长度
			{
				NSString *str = self.text;
				NSInteger len = [str length];
				for(NSInteger i = 0; i<len; i++)
				{
					NSString *s = [str substringToIndex: len - i];
					s = [NSString stringWithFormat:@"%@...",s];
					CGSize ss = [s sizeWithFont:self.font  constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
					if(ss.height <= maxSize.height)
					{
						pos = i;
						break;
					}
				}
				status = OVER_TWO_LINE_PLUS_ESCAPE;
			}
			else  //第二行没超过
			{
				pos = 0;
				status = NOT_OVER_TWO_LINES;
			}
		}
	}
	NSInteger posToFind = -1;
	if(status == OVER_TWO_LINES || status == OVER_TWO_LINE_PLUS_ESCAPE)
	{
		NSInteger len = [self.text length];
		for(NSInteger j = pos; j <len; j++)
		{
			NSString *tempString = [self.text substringWithRange:NSMakeRange(len - j, j-pos)];
			tempString = [NSString stringWithFormat:@"%@...",tempString];
			CGSize sizeTemp = [tempString sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
			if(sizeTemp.width >= escapeWidth)
			{
				posToFind = j;
				break;
			}
		}
	}
	else if(status == NOT_OVER_TWO_LINES)
	{
	}
	if(posToFind == -1)
	{
		if(pos == -1) pos = 0;// protect 
		NSString *ss = [self.text substringToIndex: [self.text length] - pos];
		self.text = ss;
		size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
	}
	else
	{
		NSString *ss = [self.text substringToIndex: [self.text length] - posToFind];
		ss = [NSString stringWithFormat:@"%@...",ss];
		self.text = ss;
		size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
	}
    self.lineBreakMode = NSLineBreakByCharWrapping;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
}


- (void)setClipText:(NSString *)text lines:(NSInteger)lines
{
    [self setClipText:text lines:lines paragrapEndSpace:0.0];
}
- (void)setClipText:(NSString *)text lines:(NSInteger)lines paragrapEndSpace:(float)endSpace
{
    if ([text length]==0 || lines<=0)
    {
        /*空保护*/
        self.text = nil;
        return;
    }
    
    self.lineBreakMode = NSLineBreakByCharWrapping;
    NSString *textStr = [NSString string];
    int rowCount = 0;
    /*
     计算换行符个数
     */
    NSArray * textItems = [text componentsSeparatedByString:@"\n" ];
    NSString *targetItem = nil; //
    int targetItemRow = 0;
    CGSize constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    for (int i = 0; i<[textItems count]; i++)
    {
        NSString *anItem = [textItems objectAtIndex:i];
        CGSize textSize = [anItem sizeWithFont:self.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByCharWrapping];
        int row = textSize.width/(self.frame.size.width-4 - (endSpace/lines)) +1;
        
        if(rowCount + row <= lines)
        {
            textStr = [textStr stringByAppendingString:anItem];
            rowCount += row;
        }
        else
        {
            targetItem = anItem;
            targetItemRow = row;
            break;
        }
        
        if (i<[textItems count]-1)
        {
            rowCount +=1;   //每个Iitem 之间有换行符，最后一个之后不添加换行符。
            textStr = [textStr stringByAppendingString:@"\n"];
        }
    }
    
    if (rowCount + targetItemRow>lines)
    {
        NSInteger len = [targetItem length];
        NSString *sufixStr = [NSString string];
        for (NSInteger i = 2; i< len; i++)
        {
            sufixStr = [targetItem substringWithRange:NSMakeRange(0, len-i)];
            sufixStr = [sufixStr stringByAppendingString:@"..."];
            CGSize textSize = [sufixStr sizeWithFont:self.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByCharWrapping];
            int row = textSize.width/(self.frame.size.width-4-(endSpace/lines)) +1;
            if (rowCount + row <= lines)
            {
                break;
            }
        }
        
        textStr = [textStr stringByAppendingString:sufixStr];
    }
    else if (rowCount+targetItemRow<lines)
    {
        /*不足部分补换行符*/
        for (int j = rowCount; j<lines; j++)
        {
            textStr = [textStr stringByAppendingString:@"\n"];
        }
    }
    
    self.text = textStr;
}

- (void)adjustFontWith:(NSString *)text constrainedToSize:(CGSize)size
{
    self.numberOfLines = 0;
    const CGFloat kDefaultFontSize = 15.0f;
    const CGFloat kLabelHeight = size.height;
    const int kTryNumOfCase = 10;
    for (int i=0; i<=kTryNumOfCase; i++)
    {
        CGFloat fontSize = kDefaultFontSize-i;
        UIFont *font = [UIFont systemFontOfSize:fontSize];
        CGSize nSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(size.width, 2000.0) lineBreakMode:NSLineBreakByCharWrapping];
        if (nSize.height < kLabelHeight)
        {
            [self setFont:[UIFont systemFontOfSize:fontSize]];
            break;
        }
    }
    
    [self setText:text];
}

@end
