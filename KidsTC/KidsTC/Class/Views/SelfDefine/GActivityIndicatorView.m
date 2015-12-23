//
//  GActivityIndicatorView.m
//  iphone51buy
//
//  Created by icson apple on 12-5-29.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GActivityIndicatorView.h"

@implementation GActivityIndicatorView

- (void)internalInit
{
    @autoreleasepool {
        CGRect frame = self.bounds;
        loadingImageView = [[UIImageView alloc] initWithFrame:frame];
        [loadingImageView setImage:[UIImage imageNamed:@"loading_image"]];
        [self addSubview:loadingImageView];
        
        isAnimating = NO;
        
        [self setClipsToBounds: YES];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInit];
    }
    return self;        
}

- (void)startAnimating
{
    isAnimating = YES;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        CATransform3D rotate = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        loadingImageView.layer.transform = rotate;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(animationCompleted)])
        {
            [self.delegate animationCompleted];
        }
    }];
}

- (void)stopAnimating
{
    isAnimating = NO;
}

- (BOOL)isAnimating
{
	return isAnimating;
}
@end
