//
//  FavourateSegmentViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 8/10/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "FavourateSegmentViewCell.h"

@interface FavourateSegmentViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *tagView;

@end

@implementation FavourateSegmentViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.tagView setHidden:!selected];
}

@end
