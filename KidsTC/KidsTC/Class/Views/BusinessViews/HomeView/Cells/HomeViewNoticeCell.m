//
//  HomeViewNoticeCell.m
//  KidsTC
//
//  Created by Altair on 12/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewNoticeCell.h"
#import "AUINoticeView.h"


@interface HomeViewNoticeCell () <AUINoticeViewDataSource, AUINoticeViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet AUINoticeView *noticeView;

@property (nonatomic, strong) HomeNoticeCellModel *cellModel;

@end

@implementation HomeViewNoticeCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    self.noticeView.dataSource = self;
    self.noticeView.delegate = self;
    [self.noticeView setEnableClicking:YES];
    [self.noticeView setMaxLine:2];
    [self.noticeView setPlayDirection:AUINoticeViewPlayDirectionTopToBottom];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeNoticeCellModel *)model {
    self.cellModel = model;
    [self.noticeView reloadData];
}

#pragma mark AUINoticeViewDataSource & AUINoticeViewDelegate

- (NSUInteger)numberOfStringsForNoticeView:(AUINoticeView *)noticeView {
    return [[self.cellModel elementModelsArray] count];
}

- (NSString *)noticeStringForNoticeView:(AUINoticeView *)noticeView atIndex:(NSUInteger)index {
    HomeNoticeItem *item = [[self.cellModel elementModelsArray] objectAtIndex:index];
    return item.content;
}

- (CGSize)sizeForNoticeView:(AUINoticeView *)noticeView {
    return CGSizeMake(SCREEN_WIDTH - 50, [self.cellModel cellHeight]);
}

- (void)auiNoticeView:(AUINoticeView *)noticeView didScrolledToIndex:(NSUInteger)index {
    
}

- (void)auiNoticeView:(AUINoticeView *)noticeView didClickedAtIndex:(NSUInteger)index {
    
}

@end
