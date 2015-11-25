//
//  ServiceListViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceListViewCell.h"
#import "Insurance.h"
#import "AUIStackView.h"

@interface ServiceListViewCell ()

@property (weak, nonatomic) IBOutlet AUIStackView *promotionLogoView;
@property (weak, nonatomic) IBOutlet AUIStackView *insuranceView;

@property (weak, nonatomic) IBOutlet UIView *separateView;
@property (weak, nonatomic) IBOutlet UIView *activityBGView;

- (void)buildActivitysViewWithActivityLogoItems:(NSArray *)items;

@end

@implementation ServiceListViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    
    self.serviceImageView.layer.cornerRadius = 5;
    self.serviceImageView.layer.masksToBounds = YES;
    
    [self.saledCountLabel setTextColor:[AUITheme theme].globalThemeColor];
    
    //price view
    [self.promotionPriceView setContentColor:[AUITheme theme].buttonBGColor_Normal];
    [self.promotionPriceView.unitLabel setFont:[UIFont systemFontOfSize:16]];
    [self.promotionPriceView.priceLabel setFont:[UIFont systemFontOfSize:20]];
    
    [GConfig resetLineView:self.separateView withLayoutAttribute:NSLayoutAttributeHeight];
    
    [self.promotionLogoView setViewGap:2];
    [self.promotionLogoView setBackgroundColor:[UIColor clearColor]];
    [self.insuranceView setViewGap:2];
    [self.insuranceView setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Private methods

- (void)buildActivitysViewWithActivityLogoItems:(NSArray *)items {
    for (UIView *subView in self.activityBGView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat yPosition = 0;
    for (ActivityLogoItem *item in items) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, self.activityBGView.frame.size.width, 20)];
        UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        [checkImageView setImage:item.image];
        [bgView addSubview:checkImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, bgView.frame.size.width - 20, 20)];
        [label setTextColor:[UIColor orangeColor]];
        [label setFont:[UIFont systemFontOfSize:13]];
        [label setText:item.itemDescription];
        [bgView addSubview:label];
        
        [self.activityBGView addSubview:bgView];
        
        yPosition += bgView.frame.size.height + 5;
    }
}

#pragma mark Public methods

- (void)configWithItemModel:(ServiceListItemModel *)model {
    if (!model) {
        return;
    }
    if (model.imageUrl) {
        [self.serviceImageView setImageWithURL:model.imageUrl];
    }
    [self.serviceNameLabel setText:model.serviceName];
    [self.starsView setStarNumber:model.starNumber];
    [self.saledCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)model.saledCount]];
    
    if (model.promotionPrice >= 0) {
        [self.promotionPriceView setPrice:model.promotionPrice];
    } else {
        [self.promotionPriceView setPrice:0];
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (PromotionLogoItem *item in model.promotionLogoItems) {
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
        [logoView setImage:item.image];
        [tempArray addObject:logoView];
    }
    [self.promotionLogoView setSubViews:[NSArray arrayWithArray:tempArray]];
    
    [tempArray removeAllObjects];
    for (Insurance *ins in model.supportedInsurance) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 10)];
        
        UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [checkImageView setImage:[UIImage imageNamed:@"insurance_checked"]];
        [bgView addSubview:checkImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, 10)];
        [label setTextColor:RGBA(89, 209, 160, 1)];
        [label setFont:[UIFont systemFontOfSize:10]];
        [label setText:ins.InsuranceDescription];
        [bgView addSubview:label];
        [tempArray addObject:bgView];
    }
    [self.insuranceView setSubViews:[NSArray arrayWithArray:tempArray]];
    
    if ([model.activityLogoItems count] > 0) {
        [self.separateView setHidden:NO];
    } else {
        [self.separateView setHidden:YES];
    }
    [self buildActivitysViewWithActivityLogoItems:model.activityLogoItems];
}

@end
