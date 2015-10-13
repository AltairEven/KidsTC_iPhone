//
//  StoreDetailTitleCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreDetailTitleCell.h"

@implementation StoreDetailTitleCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle {
    [self.mainTitleLabel setText:mainTitle];
    [self.subTitleLabel setText:subTitle];
}


+ (CGFloat)cellHeight {
    return 44;
}

@end
