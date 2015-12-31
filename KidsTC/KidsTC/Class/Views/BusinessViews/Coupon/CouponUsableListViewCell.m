//
//  CouponUsableListViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 9/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CouponUsableListViewCell.h"
#import "RichPriceView.h"

@interface CouponUsableListViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellBgView;
@property (weak, nonatomic) IBOutlet UIView *couponBGView;
@property (weak, nonatomic) IBOutlet RichPriceView *discountPriceView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDescriptionLabel;

@end

@implementation CouponUsableListViewCell

- (void)awakeFromNib {
    // Initialization code
    UIImage *bgImage = [[UIImage imageNamed:@"coupon_cellBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 28, 30) resizingMode:UIImageResizingModeTile];
    [self.cellBgView setImage:bgImage];
    
    [self.discountPriceView setContentColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal];
    [self.discountPriceView setUnitFont:[UIFont systemFontOfSize:25]];
    [self.discountPriceView setPriceFont:[UIFont systemFontOfSize:SCREEN_WIDTH / 10]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        UIImage *bgImage = [[UIImage imageNamed:@"coupon_cellBG_h"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 28, 30) resizingMode:UIImageResizingModeTile];
        [self.cellBgView setImage:bgImage];
    } else {
        UIImage *bgImage = [[UIImage imageNamed:@"coupon_cellBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 28, 30) resizingMode:UIImageResizingModeTile];
        [self.cellBgView setImage:bgImage];
    }
}

- (void)configWithItemModel:(CouponBaseModel *)model {
    if (model) {
        CouponFullCutModel *cellModel = (CouponFullCutModel *)model;
        
        [self.discountPriceView setPrice:cellModel.discount];
        
        NSString *name = [NSString stringWithFormat:@"%@", cellModel.couponTitle];
        [self.nameLable setText:name];
        
        NSString *des = [NSString stringWithFormat:@"%@", cellModel.couponDescription];
        [self.descriptionLabel setText:des];
        
        NSString *timeDes = [NSString stringWithFormat:@"%@至%@", cellModel.startTime, cellModel.endTime];
        [self.timeDescriptionLabel setText:timeDes];
    }
}

+ (CGFloat)cellHeight {
    return 180;
}

@end
