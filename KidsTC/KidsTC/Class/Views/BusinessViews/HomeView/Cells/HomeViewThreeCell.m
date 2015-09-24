//
//  HomeViewThreeCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewThreeCell.h"


@interface HomeViewThreeCell ()

- (void)didClickedOnImage:(id)sender;

@end

@implementation HomeViewThreeCell

- (void)awakeFromNib {
    // Initialization code
    self.ratio = 1;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedOnImage:)];
    [self.firstImageView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedOnImage:)];
    [self.secondImageView addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedOnImage:)];
    [self.thirdImageView addGestureRecognizer:tap3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didClickedOnImage:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewThreeCell:didClickedAtIndex:)]) {
        [self.delegate homeViewThreeCell:self didClickedAtIndex:tap.view.tag];
    }
}

@end
