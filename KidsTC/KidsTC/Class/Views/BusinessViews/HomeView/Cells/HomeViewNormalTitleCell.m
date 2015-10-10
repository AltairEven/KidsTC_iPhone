//
//  HomeViewNormalTitleCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewNormalTitleCell.h"

@interface HomeViewNormalTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HomeViewNormalTitleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeNormalTitleCellModel *)model {
    if (model) {
        [self.titleLabel setText:model.mainTitle];
    }
}

@end
