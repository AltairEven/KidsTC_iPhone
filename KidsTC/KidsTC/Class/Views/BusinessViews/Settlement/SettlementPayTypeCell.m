//
//  SettlementPayTypeCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "SettlementPayTypeCell.h"

@interface SettlementPayTypeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *paymentNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectionView;

@end

@implementation SettlementPayTypeCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [self.selectionView setImage:[UIImage imageNamed:@"selected"]];
    } else {
        [self.selectionView setImage:[UIImage imageNamed:@"unselected"]];
    }
}


- (void)setLogo:(UIImage *)logo {
    _logo = logo;
    [self.iconView setImage:logo];
}


- (void)setPaymentName:(NSString *)paymentName {
    _paymentName = paymentName;
    [self.paymentNameLabel setText:paymentName];
}

+ (CGFloat)cellHeight {
    return 44;
}

@end
