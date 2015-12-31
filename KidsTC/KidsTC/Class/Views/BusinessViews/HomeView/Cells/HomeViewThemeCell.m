//
//  HomeViewThemeCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewThemeCell.h"
#import "HotActivityGroupView.h"

#define SectionNumber (2)

@interface HomeViewThemeCell () <HotActivityGroupViewDataSource, HotActivityGroupViewDelegate>

@property (weak, nonatomic) IBOutlet HotActivityGroupView *groupView;

@property (nonatomic, strong) NSArray *imageUrlsArray;

- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath;

@end

@implementation HomeViewThemeCell

- (void)awakeFromNib {
    // Initialization code
    self.groupView.dataSource = self;
    self.groupView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeTwoColumnCellModel *)model {
    if (model) {
        self.groupView.ratio = [model cellRatio];
        _imageUrlsArray = [model imageUrlsArray];
    }
    [self.groupView reloadData];
}

#pragma mark HotActivityGroupViewDataSource & HotActivityGroupViewDelegate

- (NSInteger)groupView:(HotActivityGroupView *)groupView numberOfItemsInSection:(NSInteger)section {
    NSUInteger number = 0;
    NSUInteger totalNumber = [self.imageUrlsArray count];
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

- (NSURL *)imageUrlOfCellAtIndexPath:(NSIndexPath *)indexPath onHotActivityView:(HotActivityGroupView *)hotView {
    NSURL *url = [self.imageUrlsArray objectAtIndex:[self indexOfIndexPath:indexPath]];
    return url;
}

- (NSInteger)numberOfSectionsInGroupView:(HotActivityGroupView *)groupView {
    return SectionNumber;
}

- (void)hotActivityGroupView:(HotActivityGroupView *)groupView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeViewThemeCell:didSelectedItemAtIndex:)]) {
        [self.delegate homeViewThemeCell:self didSelectedItemAtIndex:[self indexOfIndexPath:indexPath]];
    }
}

#pragma mark Private methods

- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.section + indexPath.row * SectionNumber;
    return index;
}

@end
