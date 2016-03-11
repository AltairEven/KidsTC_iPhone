//
//  FlashDetailStageCell.m
//  KidsTC
//
//  Created by Altair on 2/29/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "FlashDetailStageCell.h"
#import "RichPriceView.h"

@interface FlashDetailStageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet RichPriceView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageLabel;

@end

@implementation FlashDetailStageCell


#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        FlashDetailStageCell *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self.priceView setUnitFont:[UIFont systemFontOfSize:12] priceFont:[UIFont systemFontOfSize:20]];
}

- (void)configWithModel:(FlashStageModel *)model {
    [self.priceView setPrice:model.price];
    [self.peopleCountLabel setText:[NSString stringWithFormat:@"%lu人闪购价", (unsigned long)model.peopleCount]];
    switch (model.stage) {
        case FlashStageHasDone:
        {
            [self.bgImageView setImage:[UIImage imageNamed:@"flashStage_hasDone"]];
            [self.priceView setContentColor:RGBA(204, 204, 204, 1)];
        }
            break;
        case FlashStageCurrentHasDone:
        {
            [self.bgImageView setImage:[UIImage imageNamed:@"flashStage_processing"]];
            [self.priceView setContentColor:RGBA(255, 153, 182, 1)];
        }
            break;
        case FlashStageProcessing:
        {
            [self.bgImageView setImage:[UIImage imageNamed:@"flashStage_processing"]];
            [self.priceView setContentColor:RGBA(204, 204, 204, 1)];
        }
            break;
        case FlashStageNotReached:
        {
            [self.bgImageView setImage:[UIImage imageNamed:@"flashStage_notReached"]];
            [self.priceView setContentColor:RGBA(204, 204, 204, 1)];
        }
            break;
        default:
            break;
    }
    [self.stageLabel setText:model.stageDescription];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
