//
//  HomeViewTwinklingElfCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewTwinklingElfCell.h"
#import "TwinklingElvesView.h"
#import "HomeTwinklingElfCellModel.h"


#define SectionNumber (4)

@interface HomeViewTwinklingElfCell () <TwinklingElvesViewDataSource, TwinklingElvesViewDelegate>

@property (weak, nonatomic) IBOutlet TwinklingElvesView *twinklingElves;

@property (nonatomic, strong) NSArray *twinklingElfModels;

- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath;

@end

@implementation HomeViewTwinklingElfCell

- (void)awakeFromNib {
    // Initialization code
    self.twinklingElves.dataSource = self;
    self.twinklingElves.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(HomeTwinklingElfCellModel *)model {
    if (model) {
        _twinklingElfModels = model.twinklingElvesArray;
    }
    [self.twinklingElves reloadData];
}

- (void)setTwinklingElfModels:(NSArray *)twinklingElfModels {
}

#pragma mark TwinklingElvesViewDataSource & TwinklingElvesViewDelegate

- (NSInteger)twinklingElvesView:(TwinklingElvesView *)elvesView numberOfItemsInSection:(NSInteger)section {
    NSUInteger number = 0;
    NSUInteger totalNumber = [self.twinklingElfModels count];
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

- (NSInteger)numberOfSectionsForTwinklingElvesView:(TwinklingElvesView *)elvesView {
    return SectionNumber;
}

- (NSURL *)imageUrlOfCellAtIndexPath:(NSIndexPath *)indexPath onTwinklingElvesView:(TwinklingElvesView *)elvesView {
    NSURL *imageUrl = nil;
    HomeTwinklingElf *twinklingElf = [self.twinklingElfModels objectAtIndex:[self indexOfIndexPath:indexPath]];
    if ([twinklingElf hasLocalImage]) {
        imageUrl = [NSURL URLWithString:twinklingElf.imageName];
    } else {
        imageUrl = twinklingElf.imageUrl;
    }
    return imageUrl;
}

- (NSString *)TitleOfCellAtIndexPath:(NSIndexPath *)indexPath onTwinklingElvesView:(TwinklingElvesView *)elvesView {
    HomeTwinklingElf *twinklingElf = [self.twinklingElfModels objectAtIndex:[self indexOfIndexPath:indexPath]];
    return twinklingElf.title;
}

- (void)twinklingElvesView:(TwinklingElvesView *)elvesView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(twinklingElfCell:didClickedAtIndex:)]) {
        [self.delegate twinklingElfCell:self didClickedAtIndex:[self indexOfIndexPath:indexPath]];
    }
}

#pragma mark Private methods

- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.section + indexPath.row * SectionNumber;
    return index;
}

@end
