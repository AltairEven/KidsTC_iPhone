//
//  StoreListViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreListViewCell.h"
#import "StoreListItemModel.h"
#import "AUIStackView.h"

@interface StoreListViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *stroeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet AUIStackView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation StoreListViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.activityView setViewGap:5];
}

- (void)configWithItemModel:(StoreListItemModel *)model {
    if (!model) {
        return;
    }
    if (model.imageUrl) {
        [self.stroeImageView setImageWithURL:model.imageUrl];
    }
    [self.storeName setText:model.storeName];
    [self.starsView setStarNumber:model.starNumber];
    NSMutableArray *activityViewArray = [[NSMutableArray alloc] init];
    for (ActiveModel *actM in model.activities) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [imgView setImage:actM.image];
        [activityViewArray addObject:imgView];
    }
    [self.activityView setSubViews:[NSArray arrayWithArray:activityViewArray]];
    [self.distanceLabel setText:model.distanceDescription];
}

+ (CGFloat)cellHeight {
    return 130;
}

@end
