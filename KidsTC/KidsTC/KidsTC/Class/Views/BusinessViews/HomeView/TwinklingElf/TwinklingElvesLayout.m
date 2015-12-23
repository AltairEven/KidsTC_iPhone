//
//  TwinklingElvesLayout.m
//  ICSON
//
//  Created by 钱烨 on 4/13/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "TwinklingElvesLayout.h"

@interface TwinklingElvesLayout ()

@property (nonatomic, assign) CGSize collectionViewSize;

@property (nonatomic, assign) NSUInteger sectionNumber;

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, assign) CGFloat cellHeight;

- (CGFloat)getCellXOriginWithCurrentIndexPath:(NSIndexPath *)indexPath;

@end

@implementation TwinklingElvesLayout


- (void)prepareLayout {
    
    //cell width
    self.cellWidth = [[UIScreen mainScreen] bounds].size.width / self.sectionNumber;
    self.cellHeight = self.cellWidth + 15;
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
    CGFloat yOrigin = indexPath.row * self.cellHeight;
    attributes.frame = CGRectMake(xOrigin, yOrigin, self.cellWidth, self.cellHeight);
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
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = self.rowNumber * self.cellHeight;
    
    self.collectionViewSize = CGSizeMake(width, height);
    return self.collectionViewSize;
}


- (CGFloat)getCellXOriginWithCurrentIndexPath:(NSIndexPath *)indexPath {
    CGFloat xOrigin = 0;
    if (indexPath.section == 0) {
        return xOrigin;
    }
    NSIndexPath *preview = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:preview];
    xOrigin += attributes.frame.origin.x + attributes.frame.size.width;
    
    return xOrigin;
}


@end
