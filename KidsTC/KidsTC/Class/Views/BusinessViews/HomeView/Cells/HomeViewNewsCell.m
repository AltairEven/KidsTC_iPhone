//
//  HomeViewNewsCell.m
//  KidsTC
//
//  Created by 钱烨 on 9/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewNewsCell.h"

@interface HomeViewNewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewNumber;
@property (weak, nonatomic) IBOutlet UILabel *commentNumber;

@end

@implementation HomeViewNewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeNewsElement *)model {
    if (model) {
        [self.titleLabel setText:model.title];
        [self.viewNumber setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.viewCount]];
        [self.commentNumber setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.commentCount]];
    }
}

@end
