//
//  ServiceDetailConfirmViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/30/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailConfirmViewCell.h"
#import "FiveStarsView.h"

@interface ServiceDetailConfirmViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation ServiceDetailConfirmViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [self.bgView setBackgroundColor:[[AUITheme theme].globalThemeColor colorWithAlphaComponent:0.2]];
    } else {
        [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    }
}

- (void)setStoreName:(NSString *)storeName {
    _storeName = storeName;
    [self.storeNameLabel setText:storeName];
}

- (void)setStarNumber:(NSUInteger)starNumber {
    _starNumber = starNumber;
    [self.starsView setStarNumber:starNumber];
}

- (void)setDistance:(NSString *)distance {
    _distance = distance;
    [self.distanceLabel setText:distance];
}

@end
