//
//  HomeViewRecommendNewCell.m
//  KidsTC
//
//  Created by Altair on 1/20/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "HomeViewRecommendNewCell.h"
#import "RichPriceView.h"

@interface HomeViewRecommendNewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *promotionPriceView;
@property (weak, nonatomic) IBOutlet RichPriceView *originalPriceView;

@end

@implementation HomeViewRecommendNewCell

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    
    [self.saleCountLabel setTextColor:[UIColor darkGrayColor]];
    
    //price view
    [self.promotionPriceView setContentColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal];
    [self.promotionPriceView setUnitFont:[UIFont systemFontOfSize:16]];
    [self.promotionPriceView setPriceFont:[UIFont systemFontOfSize:20]];
    
    [self.originalPriceView setContentColor:[UIColor lightGrayColor]];
    [self.originalPriceView setUnitFont:[UIFont systemFontOfSize:12]];
    [self.originalPriceView setPriceFont:[UIFont systemFontOfSize:12]];
    [self.originalPriceView setSlashed:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configWithModel:(HomeRecommendElement *)model {
    self.imageHeight.constant = model.imageRatio * SCREEN_WIDTH;
    [self.cellImageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_BIG];
    [self.titleLabel setText:model.title];
    [self.promotionPriceView setPrice:model.promotionPrice];
    if (model.promotionPrice >= model.originalPrice) {
        [self.originalPriceView setHidden:YES];
    } else {
        [self.originalPriceView setHidden:NO];
        [self.originalPriceView setPrice:model.originalPrice];
    }
    if (model.saledCount > 0) {
        NSString *countString = [NSString stringWithFormat:@"%lu", (unsigned long)model.saledCount];
        NSString *wholeString = [NSString stringWithFormat:@"已售%@", countString];
        NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
        NSDictionary *attribute = [NSDictionary dictionaryWithObject:[[KTCThemeManager manager] defaultTheme].highlightTextColor forKey:NSForegroundColorAttributeName];
        [labelString setAttributes:attribute range:NSMakeRange(2, [countString length])];
        [self.saleCountLabel setAttributedText:labelString];
    } else {
        [self.saleCountLabel setText:@""];
    }
}

@end
