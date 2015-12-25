//
//  FavouriteViewStrategyCell.m
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "FavouriteViewStrategyCell.h"

@interface FavouriteViewStrategyCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation FavouriteViewStrategyCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor];
    
    self.cellImageView.layer.cornerRadius = 5;
    self.cellImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItemModel:(FavouriteStrategyItemModel *)model {
    if (model) {
        [self.cellImageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
        [self.titleLabel setText:model.title];
        [self.contentLabel setText:model.content];
    }
}

+ (CGFloat)cellHeight {
    return 100;
}

@end
