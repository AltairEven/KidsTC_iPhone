//
//  CommentListViewHeaderCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CommentListViewHeaderCell.h"

@interface CommentListViewHeaderCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CommentListViewHeaderCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)cellHeight {
    return 44;
}

@end
