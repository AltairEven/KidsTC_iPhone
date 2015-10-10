//
//  HomeViewThreeImageNewsCell.m
//  KidsTC
//
//  Created by 钱烨 on 9/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewThreeImageNewsCell.h"

@interface HomeViewThreeImageNewsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

- (void)didClickedOnImage:(id)sender;

@end

@implementation HomeViewThreeImageNewsCell

- (void)awakeFromNib {
    // Initialization code
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedOnImage:)];
    [self.imageView1 addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedOnImage:)];
    [self.imageView2 addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedOnImage:)];
    [self.imageView3 addGestureRecognizer:tap3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeThreeImageNewsCellModel *)model {
    if (model) {
        [self.imageView1 setImageWithURL:model.firstElement.imageUrl];
        [self.imageView2 setImageWithURL:model.secondeElement.imageUrl];
        [self.imageView3 setImageWithURL:model.thirdElement.imageUrl];
    }
}

- (void)didClickedOnImage:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewThreeImageNewsCell:didClickedAtIndex:)]) {
        [self.delegate homeViewThreeImageNewsCell:self didClickedAtIndex:tap.view.tag];
    }
}

@end
