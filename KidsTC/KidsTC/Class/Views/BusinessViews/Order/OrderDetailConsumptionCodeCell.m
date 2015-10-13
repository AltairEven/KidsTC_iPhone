//
//  OrderDetailConsumptionCodeCell.m
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderDetailConsumptionCodeCell.h"

@interface OrderDetailConsumptionCodeCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation OrderDetailConsumptionCodeCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
