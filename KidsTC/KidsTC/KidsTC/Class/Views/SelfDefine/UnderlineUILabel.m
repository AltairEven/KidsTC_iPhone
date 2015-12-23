//
//  UnderlineUILabel.m
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-5-8.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import "UnderlineUILabel.h"

@implementation UnderlineUILabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize fontSize =[self.text sizeWithFont:self.font
                                    forWidth:self.bounds.size.width
                               lineBreakMode:NSLineBreakByTruncatingTail];
    
    
    
    // Get the fonts color.
    const float * colors = CGColorGetComponents(self.textColor.CGColor);
    // Sets the color to draw the line
    CGContextSetRGBStrokeColor(ctx, colors[0], colors[1], colors[2], 1.0f); // Format : RGBA
    
    // Line Width : make thinner or bigger if you want
    CGContextSetLineWidth(ctx, 1.0f);
    
    // Calculate the starting point (left) and target (right)
    CGPoint l = CGPointMake(self.frame.size.width/2.0 - fontSize.width/2.0,
                            fontSize.height - 1.0f);
    CGPoint r = CGPointMake(self.frame.size.width/2.0 + fontSize.width/2.0,
                            fontSize.height - 1.0f);
    
    
    // Add Move Command to point the draw cursor to the starting point
    CGContextMoveToPoint(ctx, l.x, l.y);
    
    // Add Command to draw a Line
    CGContextAddLineToPoint(ctx, r.x, r.y);
    
    
    // Actually draw the line.
    CGContextStrokePath(ctx);
    
    // should be nothing, but who knows...
    [super drawRect:rect];   
}


@end
