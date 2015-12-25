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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewNumber;
@property (weak, nonatomic) IBOutlet UILabel *commentNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

- (void)didClickedOnImage:(id)sender;

- (void)configTagLabelWithModel:(HomeThreeImageNewsCellModel *)model;

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
    
    self.imageView1.layer.cornerRadius = 3;
    self.imageView1.layer.masksToBounds = YES;
    self.imageView2.layer.cornerRadius = 3;
    self.imageView2.layer.masksToBounds = YES;
    self.imageView3.layer.cornerRadius = 3;
    self.imageView3.layer.masksToBounds = YES;
    
    self.tagLabel.layer.cornerRadius = 3;
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.borderWidth = BORDER_WIDTH;
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
        [self.titleLabel setText:model.title];
        [self configTagLabelWithModel:model];
        [self.viewNumber setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.viewCount]];
        [self.commentNumber setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.commentCount]];
    }
}

- (void)configTagLabelWithModel:(HomeThreeImageNewsCellModel *)model {
    if (model.isHot) {
        [self.tagLabel setHidden:NO];
        self.leftMargin.constant = 10;
        self.tagLabel.layer.borderColor = [[KTCThemeManager manager] currentTheme].globalThemeColor.CGColor;
        [self.tagLabel setTextColor:[[KTCThemeManager manager] currentTheme].globalThemeColor];
        [self.tagLabel setText:@" 热 "];
    } else if (model.isRecommend) {
        [self.tagLabel setHidden:NO];
        self.leftMargin.constant = 10;
        self.tagLabel.layer.borderColor = [[KTCThemeManager manager] currentTheme].highlightTextColor.CGColor;
        [self.tagLabel setTextColor:[[KTCThemeManager manager] currentTheme].highlightTextColor];
        [self.tagLabel setText:@" 推荐 "];
    } else {
        [self.tagLabel setHidden:YES];
        self.leftMargin.constant = 0;
    }
}

- (void)didClickedOnImage:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewThreeImageNewsCell:didClickedAtIndex:)]) {
        [self.delegate homeViewThreeImageNewsCell:self didClickedAtIndex:tap.view.tag];
    }
}

@end
