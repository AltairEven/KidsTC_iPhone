//
//  NewsRecommendListViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsRecommendListViewCell.h"
#import "NewsRecommendCellView.h"

@interface NewsRecommendListViewCell () <NewsRecommendCellViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NewsRecommendCellView *cellView;

@end

@implementation NewsRecommendListViewCell

- (void)awakeFromNib {
    // Initialization code
    self.cellView.delegate = self;
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    
    self.cellView.layer.borderWidth = BORDER_WIDTH;
    self.cellView.layer.borderColor = RGBA(230, 230, 230, 1).CGColor;
    self.cellView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListItemModel:(NewsRecommendListModel *)listItemModel {
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    _listItemModel = listItemModel;
    [self.timeLabel setText:listItemModel.timeDescription];
    [self.cellView setItemModels:listItemModel.cellModelsArray];
}

#pragma mark NewsRecommendCellViewDelegate

- (void)newsRecommendCellView:(NewsRecommendCellView *)cellView didSelectedItemAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsRecommendListViewCell:didClickedAtIndex:)]) {
        [self.delegate newsRecommendListViewCell:self didClickedAtIndex:index];
    }
}

@end
