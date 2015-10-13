//
//  AppointmentOrderListCell.m
//  KidsTC
//
//  Created by 钱烨 on 8/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AppointmentOrderListCell.h"

@interface AppointmentOrderListCell ()
@property (weak, nonatomic) IBOutlet UIView *headerBG;
@property (weak, nonatomic) IBOutlet UIView *infoBG;

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusDesLabel;
@property (weak, nonatomic) IBOutlet UIView *gapLine;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *appointmentTimeDesLabel;

@end

@implementation AppointmentOrderListCell

- (void)awakeFromNib {
    // Initialization code
    [GConfig resetLineView:self.gapLine withLayoutAttribute:NSLayoutAttributeHeight];
    [self.headerBG setBackgroundColor:[AUITheme theme].globalCellBGColor];
    [self.infoBG setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithOrderModel:(AppointmentOrderModel *)model {
    if (model) {
        [self.orderIdLabel setText:model.orderId];
        [self.orderStatusDesLabel setText:model.statusDescription];
        [self.storeImageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
        [self.storeName setText:model.storeName];
        [self.appointmentTimeDesLabel setText:model.appointmentTimeDes];
    }
}

+ (CGFloat)cellHeight {
    return 140;
}

@end
