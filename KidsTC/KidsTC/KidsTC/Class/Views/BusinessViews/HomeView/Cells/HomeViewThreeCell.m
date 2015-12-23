//
//  HomeViewThreeCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewThreeCell.h"


@interface HomeViewThreeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

- (void)didClickedOnImage:(id)sender;

@end

@implementation HomeViewThreeCell

- (void)awakeFromNib {
    // Initialization code
    
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

- (void)configWithModel:(HomeThreeCellModel *)model {
    if (model) {
        [self.firstImageView setImageWithURL:model.firstElement.imageUrl];
        [self.secondImageView setImageWithURL:model.secondeElement.imageUrl];
        [self.thirdImageView setImageWithURL:model.thirdElement.imageUrl];
    }
}

- (void)didClickedOnImage:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewThreeCell:didClickedAtIndex:)]) {
        [self.delegate homeViewThreeCell:self didClickedAtIndex:tap.view.tag];
    }
}

@end
