/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GFitTextBtn.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：genechu
 * 完成日期：3/29/13
 */

#import "GFitTextBtn.h"

@implementation GFitTextBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *aLab = [[UILabel alloc] initWithFrame:self.bounds];
        aLab.font = [UIFont systemFontOfSize:MIN(frame.size.height,frame.size.width)];
        aLab.numberOfLines = 0;
        aLab.backgroundColor = [UIColor clearColor];
        aLab.textColor = [UIColor whiteColor];
        [self addSubview:aLab];
        self.textLab = aLab;
    }
    return self;
}


- (void)setTitle:(NSString *)titleStr
{
//    titleStr = @"一";
    NSInteger len = [titleStr length];
    if (len>0) {
        UIFont *aFont = [UIFont systemFontOfSize:MIN(self.textLab.frame.size.height,self.textLab.frame.size.width)];
//        UIFont *aFont = self.textLab.font;
        CGSize aSize = [titleStr sizeWithFont:aFont];
        float scaleValue = self.textLab.frame.size.height/self.textLab.frame.size.width;
        
        int lineOfText = 0;
        for(int i=1;i<len;i++)
        {
            if (fabs((aSize.height *i) /(aSize.width/i) - scaleValue) >fabs((aSize.height *(i+1))/(aSize.width/(i+1)) - scaleValue))
            {
                    lineOfText = i;
            }
            else
            {
                lineOfText = i;
                break;

            }
        }
        
        if (lineOfText ==0)
        {
            lineOfText = 1;
        }
        
        NSInteger charCoutPerLine = (len + lineOfText -1)/lineOfText;
        float scale= (float)charCoutPerLine/(float)len;
        float fontSize1 = (self.textLab.frame.size.height/(aSize.height*lineOfText)) * aFont.pointSize;
        float fontSize2 = (self.textLab.frame.size.width/(aSize.width*scale)) * aFont.pointSize;
        UIFont *textFont = [UIFont systemFontOfSize:MIN(fontSize1, fontSize2)];
        self.textLab.font = textFont;
        self.textLab.text = titleStr;
    }
}
@end
