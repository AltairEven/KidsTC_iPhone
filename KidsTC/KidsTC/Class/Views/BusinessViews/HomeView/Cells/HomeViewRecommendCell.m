//
//  HomeViewRecommendCell.m
//  KidsTC
//
//  Created by Altair on 12/31/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewRecommendCell.h"

#define SectionNumber (2)

@interface HomeViewRecommendCell () <HomeRecommendViewDataSource, HomeRecommendViewDelegate>

@property (weak, nonatomic) IBOutlet HomeRecommendView *groupView;

@property (nonatomic, strong) HomeRecommendCellModel *cellModel;

- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath;

@end

@implementation HomeViewRecommendCell

- (void)awakeFromNib {
    // Initialization code
    self.groupView.dataSource = self;
    self.groupView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configWithModel:(HomeRecommendCellModel *)model {
    self.cellModel = model;
    [self.groupView reloadData];
}

#pragma mark HotActivityGroupViewDataSource & HotActivityGroupViewDelegate

- (NSInteger)recommendView:(HomeRecommendView *)view numberOfItemsInSection:(NSInteger)section {
    NSUInteger number = 0;
    NSUInteger totalNumber = [[self.cellModel elementModelsArray] count];
    NSUInteger leftNumber = totalNumber % SectionNumber;
    BOOL hasLeft = NO;
    if (leftNumber > section) {
        hasLeft = YES;
        leftNumber = 1;
    } else {
        leftNumber = 0;
    }
    number = (totalNumber / SectionNumber) + leftNumber;
    return number;
}

- (HomeRecommendElement *)elementOfCellAtIndexPath:(NSIndexPath *)indexPath onRecommendView:(HomeRecommendView *)view {
    HomeRecommendElement *element = [[self.cellModel elementModelsArray] objectAtIndex:[self indexOfIndexPath:indexPath]];
    return element;
}

- (NSInteger)numberOfSectionsInRecommendView:(HomeRecommendView *)view {
    return SectionNumber;
}

- (void)recommendView:(HomeRecommendView *)view didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewRecommendCell:didSelectedItemAtIndex:)]) {
        [self.delegate homeViewRecommendCell:self didSelectedItemAtIndex:[self indexOfIndexPath:indexPath]];
    }
}

#pragma mark Private methods

- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.section + indexPath.row * SectionNumber;
    return index;
}

@end
