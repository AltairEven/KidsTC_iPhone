//
//  KTCSearchViewCategoryCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/19/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCSearchViewCategoryCell.h"

@interface KTCSearchViewCategoryCell ()

@property (weak, nonatomic) IBOutlet UIView *separator;

@end

@implementation KTCSearchViewCategoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)hideSeparator:(BOOL)hidden {
    [self.separator setHidden:hidden];
}

@end
