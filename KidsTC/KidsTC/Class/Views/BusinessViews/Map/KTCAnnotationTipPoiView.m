//
//  KTCAnnotationTipPoiView.m
//  KidsTC
//
//  Created by Altair on 1/21/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "KTCAnnotationTipPoiView.h"

@implementation KTCAnnotationTipPoiView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"KTCAnnotationTipPoiView" owner:self options: nil];
        if(arrayOfViews.count < 1) {
            return nil;
        }
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[KTCAnnotationTipPoiView class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        KTCAnnotationTipPoiView *view = [GConfig getObjectFromNibWithView:self];
        return view;
    }
    bLoad = NO;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
