//
//  ParentingStrategyDetailViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyDetailViewCell.h"
#import "ParentingStrategyDetailModel.h"

@interface ParentingStrategyDetailViewCell ()

@property (weak, nonatomic) IBOutlet UIView *cellBGView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeTagImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *relatedInfoButton;

@end

@implementation ParentingStrategyDetailViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.cellBGView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithDetailCellModel:(ParentingStrategyDetailCellModel *)cellModel {
    if (cellModel) {
        [self.cellImageView setImageWithURL:cellModel.imageUrl];
        [self.contentLabel setText:cellModel.cellContentString];
        [self.timeLabel setText:cellModel.timeDescription];
        [self.relatedInfoButton setTitle:cellModel.relatedInfoTitle forState:UIControlStateNormal];
    }
}

@end
