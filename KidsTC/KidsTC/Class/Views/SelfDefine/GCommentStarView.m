//
//  GCommentStarView.h
//  iphone51buy
//
//  Created by Bai Haoquan on 12-9-6.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GCommentStarView.h"

static const CGFloat kHeightOfItemDetailView = 25.0f;
static const CGFloat kHrightOfSearchItemView = 40.0f;
@interface GCommentStarView ()
{
    CGFloat _padding;
    CGFloat _starWidth;
}
@end
@implementation GCommentStarView
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;
@synthesize label1, label2, label3, label4, label5;
@synthesize starValue;
@synthesize delegate;

- (id)initWithStarWidth:(CGFloat) starWidth andPadding:(CGFloat) padding
{
    self = [super init];
    if (self) {
        // Initialization code
        _padding = padding;
        _starWidth = starWidth;
        
        star1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, starWidth, starWidth)];
        [self addSubview:star1];
        
        star2 = [[UIImageView alloc] initWithFrame:CGRectMake((starWidth + padding), 0, starWidth, starWidth)];
        [self addSubview:star2];
        
        star3 = [[UIImageView alloc] initWithFrame:CGRectMake((starWidth + padding) * 2, 0, starWidth, starWidth)];
        [self addSubview:star3];
        
        star4 = [[UIImageView alloc] initWithFrame:CGRectMake((starWidth + padding) * 3, 0, starWidth, starWidth)];
        [self addSubview:star4];
        
        star5 = [[UIImageView alloc] initWithFrame:CGRectMake((starWidth + padding) * 4, 0, starWidth, starWidth)];
        [self addSubview:star5];

//        label1 = MAKE_LABEL(CGRectZero, @"非常不满意", [UIColor grayColor], 12.0f);
//        label2 = MAKE_LABEL(CGRectZero, @"不满意", [UIColor grayColor], 12.0f);
//        label3 = MAKE_LABEL(CGRectZero, @"一般", [UIColor grayColor], 12.0f);
//        label4 = MAKE_LABEL(CGRectZero, @"满意", [UIColor grayColor], 12.0f);
//        label5 = MAKE_LABEL(CGRectZero, @"非常满意", [UIColor grayColor], 12.0f);
        
               
        label1.frame = CGRectMake(CGRectGetMaxX(star1.frame) - CGRectGetWidth(label1.frame), CGRectGetMaxY(star1.frame), CGRectGetWidth(label1.frame), CGRectGetHeight(label1.frame));
        label2.frame = CGRectMake(CGRectGetMinX(star2.frame), CGRectGetMaxY(star2.frame), CGRectGetWidth(label2.frame), CGRectGetHeight(label2.frame));
        label3.frame = CGRectMake(CGRectGetMinX(star3.frame) + 5, CGRectGetMaxY(star3.frame), CGRectGetWidth(label3.frame), CGRectGetHeight(label3.frame));
        label4.frame = CGRectMake(CGRectGetMinX(star4.frame) + 5, CGRectGetMaxY(star4.frame), CGRectGetWidth(label4.frame), CGRectGetHeight(label4.frame));
        label5.frame = CGRectMake(CGRectGetMinX(star5.frame), CGRectGetMaxY(star5.frame), CGRectGetWidth(label5.frame), CGRectGetHeight(label5.frame));
        
        [self addSubview:label1];
        [self addSubview:label2];
        [self addSubview:label3];
        [self addSubview:label4];
        [self addSubview:label5];
        
        self.frame = CGRectMake(0, 0, 5 * starWidth + 4 * padding, starWidth);
    }
    
    return self;
}

- (void) setStarValue:(int)value
{
    starValue = value;
    
    switch (starValue) {
        case 1:
            star1.image = LOADIMAGE(@"star_full", @"png");
            star2.image = LOADIMAGE(@"star_empty", @"png");
            star3.image = LOADIMAGE(@"star_empty", @"png");
            star4.image = LOADIMAGE(@"star_empty", @"png");
            star5.image = LOADIMAGE(@"star_empty", @"png");
            break;
        case 2:
            star1.image = LOADIMAGE(@"star_full", @"png");
            star2.image = LOADIMAGE(@"star_full", @"png");
            star3.image = LOADIMAGE(@"star_empty", @"png");
            star4.image = LOADIMAGE(@"star_empty", @"png");
            star5.image = LOADIMAGE(@"star_empty", @"png");
            break;
        case 3:
            star1.image = LOADIMAGE(@"star_full", @"png");
            star2.image = LOADIMAGE(@"star_full", @"png");
            star3.image = LOADIMAGE(@"star_full", @"png");
            star4.image = LOADIMAGE(@"star_empty", @"png");
            star5.image = LOADIMAGE(@"star_empty", @"png");
            break;
        case 4:
            star1.image = LOADIMAGE(@"star_full", @"png");
            star2.image = LOADIMAGE(@"star_full", @"png");
            star3.image = LOADIMAGE(@"star_full", @"png");
            star4.image = LOADIMAGE(@"star_full", @"png");
            star5.image = LOADIMAGE(@"star_empty", @"png");
            break;
        case 5:
            star1.image = LOADIMAGE(@"star_full", @"png");
            star2.image = LOADIMAGE(@"star_full", @"png");
            star3.image = LOADIMAGE(@"star_full", @"png");
            star4.image = LOADIMAGE(@"star_full", @"png");
            star5.image = LOADIMAGE(@"star_full", @"png");
            break;
        default:
            star1.image = LOADIMAGE(@"star_empty", @"png");
            star2.image = LOADIMAGE(@"star_empty", @"png");
            star3.image = LOADIMAGE(@"star_empty", @"png");
            star4.image = LOADIMAGE(@"star_empty", @"png");
            star5.image = LOADIMAGE(@"star_empty", @"png");
            break;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGFloat touchX = [[touches anyObject] locationInView:self].x;
    int value = 0;
    if (touchX < _starWidth)
    {
        value = 1;
    }
    else if (touchX < 2 * _starWidth + _padding)
    {
        value = 2;
    }
    else if (touchX < 3 * _starWidth + 2 *_padding)
    {
        value = 3;
    }
    else if (touchX < 4 * _starWidth + 3 *_padding)
    {
        value = 4;
    }
    else
    {
        value = 5;
    }
    
    [self setStarValue:value];
    
    if ([delegate respondsToSelector:@selector(gCommentstarView:ValueDidChange:)])
        [delegate gCommentstarView:self ValueDidChange:value];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end

