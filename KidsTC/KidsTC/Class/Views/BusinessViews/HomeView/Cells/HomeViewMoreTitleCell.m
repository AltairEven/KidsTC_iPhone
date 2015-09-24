//
//  HomeViewMoreTitleCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewMoreTitleCell.h"

@interface HomeViewMoreTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation HomeViewMoreTitleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMainTitle:(NSString *)main subTitle:(NSString *)sub {
    [self.mainTitleLabel setText:main];
    if ([sub length] > 0) {
        [self.subTitleLabel setText:sub];
        [self.subTitleLabel setHidden:NO];
    } else {
        [self.subTitleLabel setHidden:YES];
    }
}

+ (CGFloat)cellHeight {
    return 44;
}

@end
