//
//  HomeViewHorizontalListCell.m
//  KidsTC
//
//  Created by 钱烨 on 8/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewHorizontalListCell.h"
#import "HomeTimeQiangCell.h"
#import "AUISegmentView.h"
#import "HomeHorizontalListCellModel.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface HomeViewHorizontalListCell () <AUISegmentViewDataSource, AUISegmentViewDelegate>

@property (weak, nonatomic) IBOutlet AUISegmentView *listView;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSArray *elementsArray;

@end

@implementation HomeViewHorizontalListCell

- (void)awakeFromNib {
    // Initialization code
    self.listView.dataSource = self;
    self.listView.delegate = self;
    [self.listView setShowSeparator:YES];
    [self.listView setScrollEnable:YES];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([HomeTimeQiangCell class]) bundle:nil];
        [self.listView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeHorizontalListCellModel *)model {
    if (model) {
        self.elementsArray = model.elementsArray;
    }
    [self.listView reloadData];
}

#pragma mark AUISegmentViewDataSource & AUISegmentViewDelegate

- (NSUInteger)numberOfCellsForSegmentView:(AUISegmentView *)segmentView {
    return [self.elementsArray count];
}

- (UITableViewCell *)segmentView:(AUISegmentView *)segmentView cellAtIndex:(NSUInteger)index {
    
    HomeTimeQiangCell *cell = [segmentView dequeueReusableCellWithIdentifier:kCellIdentifier forIndex:index];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"HomeTimeQiangCell" owner:nil options:nil] objectAtIndex:0];
    }
    HomeHorizontalListElement *element = [self.elementsArray objectAtIndex:index];
    [cell setImageUrl:element.imageUrl];
    [cell setPrice:element.price];
    return cell;
}

- (CGFloat)segmentView:(AUISegmentView *)segmentView cellWidthAtIndex:(NSUInteger)index {
    return 120;
}

- (void)segmentView:(AUISegmentView *)segmentView didSelectedAtIndex:(NSUInteger)index {
    [segmentView deselectIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewHorizontalListCell:didSelectedItemAtIndex:)]) {
        [self.delegate homeViewHorizontalListCell:self didSelectedItemAtIndex:index];
    }
}

@end
