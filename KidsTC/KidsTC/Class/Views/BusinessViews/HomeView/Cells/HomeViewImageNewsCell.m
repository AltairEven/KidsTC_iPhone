//
//  HomeViewImageNewsCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewImageNewsCell.h"

@interface HomeViewImageNewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@end

@implementation HomeViewImageNewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
