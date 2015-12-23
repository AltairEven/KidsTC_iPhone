//
//  CouponListViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 9/6/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CouponListViewCell.h"
#import "RichPriceView.h"

@interface CouponListViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellBGView;
@property (weak, nonatomic) IBOutlet RichPriceView *discountPriceView;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponTimeDescriptionLabel;

@end

@implementation CouponListViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalBGColor];
    
    UIImage *bgImage = [[UIImage imageNamed:@"coupon_cellBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 28, 30) resizingMode:UIImageResizingModeTile];
    [self.cellBGView setImage:bgImage];
    
    [self.discountPriceView setContentColor:[AUITheme theme].buttonBGColor_Normal];
    [self.discountPriceView setUnitFont:[UIFont systemFontOfSize:25]];
    [self.discountPriceView setPriceFont:[UIFont systemFontOfSize:SCREEN_WIDTH / 10]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItemModel:(CouponBaseModel *)model {
    if (model) {
        CouponFullCutModel *cellModel = (CouponFullCutModel *)model;
        
        [self.discountPriceView setPrice:cellModel.discount];
        
        NSString *name = [NSString stringWithFormat:@"%@", cellModel.couponTitle];
        [self.couponNameLabel setText:name];
        
        NSString *des = [NSString stringWithFormat:@"%@", cellModel.couponDescription];
        [self.couponDescriptionLabel setText:des];
        
        NSString *timeDes = [NSString stringWithFormat:@"%@至%@", cellModel.startTime, cellModel.endTime];
        [self.couponTimeDescriptionLabel setText:timeDes];
    }
}

+ (CGFloat)cellHeight {
    return 180;
}

@end
