//
//  HotActivityLayout.m
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HotActivityLayout.h"

@interface HotActivityLayout ()

@property (nonatomic, assign) CGSize collectionViewSize;

@property (nonatomic, assign) NSUInteger sectionNumber;

@property (nonatomic, assign) NSUInteger rowNumber;

@property (nonatomic, assign) CGFloat cellWidth;

- (BOOL)isSingleAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)cellHeight;

@end

@implementation HotActivityLayout


- (void)prepareLayout {
    self.cellWidth = [[UIScreen mainScreen] bounds].size.width / 2 - BORDER_WIDTH;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArray = [[NSMutableArray alloc] init];
    for (NSInteger n = 0; n < self.sectionNumber; n ++) {
        for (NSInteger m = 0; m < self.rowNumber; m ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:m inSection:n];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (attributes) {
                [attributesArray addObject:attributes];
            }
        }
    }
    return [NSArray arrayWithArray:attributesArray];
}



- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger cellNum = [self.collectionView numberOfItemsInSection:indexPath.section];
    if (cellNum <= indexPath.row) {
        return nil;
    }
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat xOrigin = indexPath.section * (self.cellWidth + BORDER_WIDTH);
    CGFloat yOrigin = indexPath.row * ([self cellHeight] + BORDER_WIDTH) + BORDER_WIDTH;
    CGFloat cellWidth = self.cellWidth;
//    if ([self isSingleAtIndexPath:indexPath]) {
//        xOrigin = 0;
//        cellWidth = [[UIScreen mainScreen] bounds].size.width;
//    }
    attributes.frame = CGRectMake(xOrigin, yOrigin, cellWidth, [self cellHeight]);
    
    return attributes;
}



- (CGSize)collectionViewContentSize {
    //计算宽高
    self.sectionNumber = [self.collectionView numberOfSections];
    self.rowNumber = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat width = (self.sectionNumber * self.cellWidth) + (self.sectionNumber - 1) * BORDER_WIDTH;
    CGFloat height = (self.rowNumber * [self cellHeight]) + (self.rowNumber + 1) * BORDER_WIDTH;
    
    self.collectionViewSize = CGSizeMake(width, height);
    return self.collectionViewSize;
}


- (BOOL)isSingleAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger cellNum1 = [self.collectionView numberOfItemsInSection:0];
    NSUInteger cellNum2 = [self.collectionView numberOfItemsInSection:1];
    if (cellNum1 == cellNum2) {
        return NO;
    }
    if (indexPath.section == 0) {
        return (cellNum1 > cellNum2);
    }
    if (indexPath.section == 1) {
        return (cellNum1 < cellNum2);
    }
    return NO;
}


- (CGFloat)cellHeight {
    return self.ratio * (SCREEN_WIDTH / 2);
}


@end
