//
//  KTCBrowseHistoryViewStoreCell.m
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCBrowseHistoryViewStoreCell.h"

@interface KTCBrowseHistoryViewStoreCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bizZoneLabel;

@end

@implementation KTCBrowseHistoryViewStoreCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalCellBGColor];
    
    self.cellImageView.layer.cornerRadius = 5;
    self.cellImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(BrowseHistoryStoreListItemModel *)model {
    if (model) {
        [self.cellImageView setImageWithURL:model.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
        [self.titleLabel setText:model.name];
        [self.bizZoneLabel setText:model.bizZone];
    }
}

+ (CGFloat)cellHeight {
    return (SCREEN_WIDTH / 4) - 20 + 60;
}

@end
