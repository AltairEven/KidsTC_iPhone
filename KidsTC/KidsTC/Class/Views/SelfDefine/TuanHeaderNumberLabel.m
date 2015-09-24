//
//  TuanHeaderNumberLabel.m
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-9-3.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import "TuanHeaderNumberLabel.h"

static const int kTuanHeaderNumberBGTag = 31415;
@implementation TuanHeaderNumberLabel
- (id)initWitNumber:(int)number
{
    if (self = [super init])
    {
        UIImageView *bgImgView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"tuan_header_num_bg", @"png")];
        bgImgView.tag = kTuanHeaderNumberBGTag;
        bgImgView.layer.cornerRadius = 1.0f;
        bgImgView.layer.masksToBounds = YES;
        [self addSubview:bgImgView];
        
        [self setNumber:number];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIImageView *bgImgView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"tuan_header_num_bg", @"png")];
        bgImgView.tag = kTuanHeaderNumberBGTag;
        bgImgView.layer.cornerRadius = 1.0f;
        bgImgView.layer.masksToBounds = YES;
        [self addSubview:bgImgView];
    }
    
    return self;
}

- (void)setNumber:(int)number
{
    if (_number != number)
    {
        _number = number;
        int numOfDigit = 0;
        while (number != 0)
        {
            numOfDigit++;
            number /= 10;
        }
        
        UIImageView *bgImageView = (UIImageView *)[self viewWithTag:kTuanHeaderNumberBGTag];
        for (UIView *subview in self.subviews)
        {
            if (subview != bgImageView)
            {
                [subview removeFromSuperview];
            }
        }
        
        static const CGFloat kNumberWidth = 15.0f;
        static const CGFloat kLineWidth = 1.0f;
        [self setWidth:kNumberWidth*numOfDigit+(numOfDigit-1)*kLineWidth height:kNumberWidth];
        [bgImageView setWidth:kNumberWidth*numOfDigit+(numOfDigit-1)*kLineWidth height:kNumberWidth];
        int factor = pow(10, numOfDigit-1);
        for (int i=0; i<numOfDigit; i++)
        {
            int digit = (_number / factor) % 10;
            factor /= 10;
            NSString *imgName = [NSString stringWithFormat:@"tuan_header_num_%d", digit];
            UIImage *numImg = LOADIMAGE(imgName, @"png");
            UIImageView *numImageView = [[UIImageView alloc] initWithImage:numImg];
            [numImageView setFrame:CGRectMake(i*(kNumberWidth+kLineWidth)+3, 1.8, 8, 11)];
            [self addSubview:numImageView];
            
            if (i < numOfDigit-1)
            {
                UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 12)];
                [lineImageView setImage:LOADIMAGE(@"tuan_header_num_line", @"png")];
                [lineImageView moveToHorizontal:CGRectGetMaxX(numImageView.frame)+3.5 toVertical:1];
                [self addSubview:lineImageView];
            }
        }
    }
}

@end
