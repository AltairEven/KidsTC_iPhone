//
//  LoveHouseListViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "LoveHouseListViewCell.h"

@interface LoveHouseListViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *gotoButton;
@property (weak, nonatomic) IBOutlet UIButton *nearbyButton;

- (IBAction)didClickedGotoButton:(id)sender;
- (IBAction)didClickedNearbyButton:(id)sender;

@end

@implementation LoveHouseListViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor];
    [self.gotoButton setTitleColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.gotoButton setTitleColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.nearbyButton setTitleColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.nearbyButton setTitleColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(LoveHouseListItemModel *)model {
    if (model) {
        [self.titleLabel setText:model.name];
        [self.contentLabel setText:model.houseDescription];
        [self.cellImageView setImageWithURL:model.imageUrl];
        [self.distanceLabel setText:model.distanceDescription];
    }
}

+ (CGFloat)cellHeight {
    return 140;
}

- (IBAction)didClickedGotoButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedGotoButtonOnLoveHouseListViewCell:)]) {
        [self.delegate didClickedGotoButtonOnLoveHouseListViewCell:self];
    }
}

- (IBAction)didClickedNearbyButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedNearbyButtonOnLoveHouseListViewCell:)]) {
        [self.delegate didClickedNearbyButtonOnLoveHouseListViewCell:self];
    }
}
@end
