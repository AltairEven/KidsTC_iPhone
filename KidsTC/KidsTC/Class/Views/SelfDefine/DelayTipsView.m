#import "DelayTipsView.h"

#import <QuartzCore/QuartzCore.h>

#define TIPS_FONT [UIFont fontWithName:@"Verdana" size:18]
#define TIPS_WIDTH	170
#define TIPS_HEIGHT	90

@implementation DelayTipsView

+(void)tips:(NSString*)tips hideAfter:(NSTimeInterval)delay {
	CGSize tipsSize = [tips sizeWithFont:TIPS_FONT constrainedToSize:CGSizeMake(TIPS_WIDTH, INFINITY) lineBreakMode:NSLineBreakByCharWrapping];
	UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
	DelayTipsView *tipsView = [[DelayTipsView alloc] initWithFrame:CGRectMake(0, 0, TIPS_WIDTH, TIPS_HEIGHT)];
	tipsView.center = CGPointMake(CGRectGetMidX(keyWindow.frame), CGRectGetMidY(keyWindow.frame));
	tipsView.backgroundColor = [UIColor clearColor];
	
	[keyWindow addSubview:tipsView];
	
	CALayer *roundRectLayer = [CALayer layer];
	roundRectLayer.cornerRadius = 8;
	roundRectLayer.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7].CGColor;
	roundRectLayer.frame = tipsView.bounds;
	
	[tipsView.layer addSublayer:roundRectLayer];
	
	UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((tipsView.bounds.size.width - tipsSize.width)/2.0, (tipsView.bounds.size.height - tipsSize.height)/2.0, tipsSize.width, tipsSize.height)];
	textLabel.text = tips;
	textLabel.textAlignment = NSTextAlignmentCenter;
	textLabel.numberOfLines = 5;
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.textColor = [UIColor whiteColor];
	
	[tipsView addSubview:textLabel];
	
	CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
	keyFrameAnimation.delegate = tipsView;
	keyFrameAnimation.calculationMode = kCAAnimationLinear;
	keyFrameAnimation.duration = delay / 0.8;
	keyFrameAnimation.values = [NSArray arrayWithObjects :
								[NSNumber numberWithFloat: 0.0],
								[NSNumber numberWithFloat: 1.0],
								[NSNumber numberWithFloat: 1.0],
								[NSNumber numberWithFloat: 0.0],
								nil
								];
	keyFrameAnimation.keyTimes = [NSArray arrayWithObjects:
									[NSNumber numberWithFloat:0.0],
									[NSNumber numberWithFloat:0.1],
									[NSNumber numberWithFloat:0.9],
									[NSNumber numberWithFloat:1.0],
									nil
								  ];
	
	[tipsView.layer addAnimation:keyFrameAnimation forKey:@"keyFrameAnimation"];
	tipsView.layer.opacity = 0.0;
}

-(void)animationStop:(CAAnimation *)anim finished:(BOOL) flag {
	if ( flag ) {
		[self removeFromSuperview];
	}
}

-(void)drawRect:(CGRect) rect {
}


@end
