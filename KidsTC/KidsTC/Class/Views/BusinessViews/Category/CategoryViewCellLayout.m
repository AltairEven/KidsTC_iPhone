//
//  CategoryViewCellLayout.m
//  KidsTC
//
//  Created by 钱烨 on 7/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CategoryViewCellLayout.h"

#define CELL_HEIGHT (40)

#define CELL_GAP (0.5)

#define VIEW_MARGIN (10)

@interface CategoryViewCellLayout ()

@property (nonatomic, assign) CGSize collectionViewSize;

@property (nonatomic, assign) NSUInteger sectionNumber;

@property (nonatomic, assign) CGFloat cellWidth;

- (CGFloat)getCellXOriginWithCurrentIndexPath:(NSIndexPath *)indexPath;

@end

@implementation CategoryViewCellLayout


- (void)prepareLayout {
    
    //cell width
    self.cellWidth = (SCREEN_WIDTH - (2 * VIEW_MARGIN) - (5 * CELL_GAP)) / [self.collectionView numberOfSections];
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
    CGFloat xOrigin = [self getCellXOriginWithCurrentIndexPath:indexPath];
    CGFloat yOrigin = indexPath.row * (CELL_HEIGHT + CELL_GAP) + CELL_GAP;
    attributes.frame = CGRectMake(xOrigin, yOrigin, self.cellWidth, CELL_HEIGHT);
    return attributes;
}



- (CGSize)collectionViewContentSize {
    //计算宽高
    self.sectionNumber = [self.collectionView numberOfSections];
    self.rowNumber = [self.collectionView numberOfItemsInSection:0];
    if (self.rowNumber == 0) {
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }
    //content size
    CGFloat width = SCREEN_WIDTH - (2 * VIEW_MARGIN);
    CGFloat height = self.rowNumber * (CELL_HEIGHT + CELL_GAP) + CELL_GAP;
    
    self.collectionViewSize = CGSizeMake(width, height);
    return self.collectionViewSize;
}


- (CGFloat)getCellXOriginWithCurrentIndexPath:(NSIndexPath *)indexPath {
    CGFloat xOrigin = CELL_GAP;
    if (indexPath.section == 0) {
        return xOrigin;
    }
    NSIndexPath *preview = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:preview];
    xOrigin += attributes.frame.origin.x + attributes.frame.size.width + CELL_GAP;
    
    return xOrigin;
}

@end
