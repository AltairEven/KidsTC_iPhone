//
//  NewsListTagFilterViewCell.m
//  KidsTC
//
//  Created by Altair on 11/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsListTagFilterViewCell.h"
#import "NewsTagItemModel.h"

@interface NewsListTagFilterViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *tagView;

@end

@implementation NewsListTagFilterViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    
    [self.tagView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
    [self.tagView setHidden:YES];
    
    [self.contentView bringSubviewToFront:self.tagView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.tagView setHidden:!selected];
}

- (void)configWithMetaData:(NewsTagTypeModelMetaData *)metaData {
    [self.cellImageView setImage:metaData.image];
    
    [self.mainTitleLabel setText:metaData.mainTitle];
    
    [self.subTitleLabel setText:metaData.subTitle];
}


+ (CGFloat)cellHeight {
    return SCREEN_WIDTH / 4 + 30;
}

@end
