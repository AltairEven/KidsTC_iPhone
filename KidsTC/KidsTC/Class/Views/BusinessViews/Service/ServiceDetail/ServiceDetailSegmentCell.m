//
//  ServiceDetailSegmentCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/22/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailSegmentCell.h"

@interface ServiceDetailSegmentCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *tagView;

@end

@implementation ServiceDetailSegmentCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    [self.tagView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalThemeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.tagView setHidden:!selected];
}

@end
