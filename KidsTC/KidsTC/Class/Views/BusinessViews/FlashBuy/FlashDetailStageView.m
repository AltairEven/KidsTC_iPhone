//
//  FlashDetailStageView.m
//  KidsTC
//
//  Created by Altair on 2/29/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "FlashDetailStageView.h"
#import "AUILinearView.h"

@interface FlashDetailStageView () <AUILinearViewDataSource, AUILinearViewDelegate>

@property (weak, nonatomic) IBOutlet AUILinearView *linearView;

@end

@implementation FlashDetailStageView


#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        FlashDetailStageView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.linearView.dataSource = self;
    self.linearView.delegate = self;
    self.linearView.selectedCellScale = 1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
