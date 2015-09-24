//
//  GConnectUselessView.m
//  iPhone51Buy
//
//  Created by chu gene on 1/15/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import "GConnectUselessView.h"

@implementation GConnectUselessView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.opaque = NO;
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_backgroundView];
        
        _signImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newwork_useless_sign"]];
        _signImage.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 250);
        _signImage.center = self.center;
        _signImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_signImage];
        
        UITapGestureRecognizer *aTapGensture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:aTapGensture];
    }
    return self;
}

- (void)setOpaqueBG:(BOOL)value
{
    if (_opaqueBG != value)
    {
        _opaqueBG = value;
        if (_opaqueBG)
        {
            self.backgroundView.backgroundColor = COLOR_HOME_GRAY;
            self.backgroundView.opaque = NO;
            self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        }
        else
        {
            self.backgroundView.backgroundColor = [UIColor clearColor];
            self.backgroundView.opaque = NO;
            self.backgroundColor = [UIColor clearColor];
            self.opaque = NO;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)handleTap:(UITapGestureRecognizer*)gesture {
    
    if ([gesture.view isEqual:self]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(connectUselessViewTryReconnect:)])
        {
            [self.delegate connectUselessViewTryReconnect:self];
        }
    }
}

@end
