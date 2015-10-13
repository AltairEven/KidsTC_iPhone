//
//  StoreDetailTuanCell.m
//  KidsTC
//
//  Created by 钱烨 on 8/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreDetailTuanCell.h"
#import "RichPriceView.h"

@interface StoreDetailTuanCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *tuanImageView;
@property (weak, nonatomic) IBOutlet UILabel *tuanTitleLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *tuanPriceView;
@property (weak, nonatomic) IBOutlet UILabel *tuanCountLabel;

@end

@implementation StoreDetailTuanCell

- (void)awakeFromNib {
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    // Initialization code
    [self.tuanPriceView setContentColor:[AUITheme theme].buttonBGColor_Normal];
    [self.tuanPriceView.unitLabel setFont:[UIFont systemFontOfSize:16]];
    [self.tuanPriceView.priceLabel setFont:[UIFont systemFontOfSize:20]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(StoreTuanModel *)model {
    if (model) {
        [self.tuanImageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
        [self.tuanTitleLabel setText:model.tuanName];
        [self.tuanPriceView setPrice:model.price];
        [self.tuanCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.tuanCount]];
    }
}

+ (CGFloat)cellHeight {
    return 80;
}

@end
