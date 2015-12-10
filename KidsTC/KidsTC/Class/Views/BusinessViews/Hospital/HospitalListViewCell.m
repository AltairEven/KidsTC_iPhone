//
//  HospitalListViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HospitalListViewCell.h"

@interface HospitalListViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneWidth;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *gotoButton;
@property (weak, nonatomic) IBOutlet UIButton *nearbyButton;

- (IBAction)didClickedPhoneButton:(id)sender;
- (IBAction)didClickedGotoButton:(id)sender;
- (IBAction)didClickedNearbyButton:(id)sender;


@end

@implementation HospitalListViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    [self.gotoButton setTitleColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.gotoButton setTitleColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.nearbyButton setTitleColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.nearbyButton setTitleColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HospitalListItemModel *)model {
    if (model) {
        [self.titleLabel setText:model.name];
        [self.contentLabel setText:model.hospitalDescription];
        [self.cellImageView setImageWithURL:model.imageUrl];
        
        if ([model.phoneNumber length] > 0) {
            [self.phoneButton setHidden:NO];
            self.phoneWidth.constant = 40;
        } else {
            [self.phoneButton setHidden:YES];
            self.phoneWidth.constant = 0;
        }
        
        [self.distanceLabel setText:model.distanceDescription];
    }
}

- (IBAction)didClickedPhoneButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedPhoneButtonOnHospitalListViewCell:)]) {
        [self.delegate didClickedPhoneButtonOnHospitalListViewCell:self];
    }
}

- (IBAction)didClickedGotoButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedGotoButtonOnHospitalListViewCell:)]) {
        [self.delegate didClickedGotoButtonOnHospitalListViewCell:self];
    }
}

- (IBAction)didClickedNearbyButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedNearbyButtonOnHospitalListViewCell:)]) {
        [self.delegate didClickedNearbyButtonOnHospitalListViewCell:self];
    }
}

@end
