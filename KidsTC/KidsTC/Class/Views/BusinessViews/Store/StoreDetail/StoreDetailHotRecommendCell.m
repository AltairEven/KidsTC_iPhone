//
//  StoreDetailHotRecommendCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/26/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "StoreDetailHotRecommendCell.h"
#import "RichPriceView.h"

@interface StoreDetailHotRecommendCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation StoreDetailHotRecommendCell

- (void)awakeFromNib {
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    // Initialization code
    [self.priceView setContentColor:[AUITheme theme].buttonBGColor_Normal];
    [self.priceView.unitLabel setFont:[UIFont systemFontOfSize:16]];
    [self.priceView.priceLabel setFont:[UIFont systemFontOfSize:20]];
    
    [self.countLabel setTextColor:[AUITheme theme].highlightTextColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(StoreDetailHotRecommendModel *)model {
    if (model) {
        [self.cellImageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
        [self.titleLabel setText:model.serviceName];
        [self.priceView setPrice:model.price];
        [self.countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.saleCount]];
    }
}

+ (CGFloat)cellHeight {
    return 80;
}

@end
