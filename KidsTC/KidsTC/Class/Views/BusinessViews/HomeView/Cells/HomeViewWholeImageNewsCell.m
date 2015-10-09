//
//  HomeViewWholeImageNewsCell.m
//  KidsTC
//
//  Created by 钱烨 on 9/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewWholeImageNewsCell.h"

@interface HomeViewWholeImageNewsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HomeViewWholeImageNewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
