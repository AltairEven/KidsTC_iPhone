//
//  HomeRecommendViewCell.m
//  KidsTC
//
//  Created by Altair on 12/31/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeRecommendViewCell.h"
#import "RichPriceView.h"

NSString *const kHomeRecommendCellIdentifier = @"HomeRecommendCell";


@interface HomeRecommendViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *promotionPriceView;
@property (weak, nonatomic) IBOutlet RichPriceView *originalPriceView;
@property (weak, nonatomic) IBOutlet UILabel *saledCountLabel;

@end

@implementation HomeRecommendViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HomeRecommendViewCell" owner:self options: nil];
        if(arrayOfViews.count < 1) {
            return nil;
        }
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        [self buildSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)buildSubviews {
    [self setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    
    [self.saledCountLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    
    //price view
    [self.promotionPriceView setContentColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal];
    [self.promotionPriceView setUnitFont:[UIFont systemFontOfSize:16]];
    [self.promotionPriceView setPriceFont:[UIFont systemFontOfSize:20]];
    
    [self.originalPriceView setContentColor:[UIColor lightGrayColor]];
    [self.originalPriceView setUnitFont:[UIFont systemFontOfSize:12]];
    [self.originalPriceView setPriceFont:[UIFont systemFontOfSize:12]];
    [self.originalPriceView setSlashed:YES];
}

- (void)configWithModel:(HomeRecommendElement *)model {
    [self.recommendImageView setImageWithURL:model.imageUrl];
    [self.titleLabel setText:model.title];
    [self.promotionPriceView setPrice:model.promotionPrice];
    if (model.promotionPrice >= model.originalPrice) {
        [self.originalPriceView setHidden:YES];
    } else {
        [self.originalPriceView setHidden:NO];
        [self.originalPriceView setPrice:model.originalPrice];
    }
    [self.saledCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.saledCount]];
}

@end
