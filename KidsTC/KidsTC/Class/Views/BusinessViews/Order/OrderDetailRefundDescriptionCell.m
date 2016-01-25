//
//  OrderDetailRefundDescriptionCell.m
//  KidsTC
//
//  Created by Altair on 1/25/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "OrderDetailRefundDescriptionCell.h"

@interface OrderDetailRefundDescriptionCell ()

@property (weak, nonatomic) IBOutlet UILabel *codesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *gapView;

@end

@implementation OrderDetailRefundDescriptionCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    
    [GConfig resetLineView:self.gapView withLayoutAttribute:NSLayoutAttributeHeight];
    [self.flowDescriptionLabel setTextColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(OrderRefundFlowModel *)model {
    [self.codesLabel setText:[model codeString]];
    
    [self.timeDesLabel setText:model.applyTimeDes];
    
    [self.statusLabel setText:model.statusDescription];
    
    if ([model.flowDescription length] > 0) {
        [self.flowTitleLabel setHidden:NO];
        [self.flowDescriptionLabel setText:model.flowDescription];
    } else {
        [self.flowTitleLabel setHidden:YES];
        [self.flowDescriptionLabel setText:@""];
    }
}

@end
