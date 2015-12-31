//
//  CategoryViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CategoryViewCell.h"
#import "CategorySubLevelCollectionCell.h"

#define SectionNumber (4)

@interface CategoryViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UICollectionView *sublevelView;


- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath;

@end

@implementation CategoryViewCell

- (void)awakeFromNib {
    [self.bgView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    // Initialization code
    self.sublevelView.dataSource = self;
    self.sublevelView.delegate = self;
    
    [self.sublevelView registerClass:[CategorySubLevelCollectionCell class] forCellWithReuseIdentifier:kCategorySubLevelCollectionCellIdentifier];
    
    [GConfig resetLineView:self.lineView withLayoutAttribute:NSLayoutAttributeHeight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSubcategoryNames:(NSArray *)subcategoryNames {
    _subcategoryNames = [NSArray arrayWithArray:subcategoryNames];
    [self.sublevelView.collectionViewLayout invalidateLayout];
    [self.sublevelView reloadData];
}

#pragma mark UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return SectionNumber;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger number = 0;
    NSUInteger totalNumber = [self.subcategoryNames count];
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


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CategorySubLevelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategorySubLevelCollectionCellIdentifier forIndexPath:indexPath];
    if (cell) {
        [cell.titleLabel setText:[self.subcategoryNames objectAtIndex:[self indexOfIndexPath:indexPath]]];
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryViewCell:didClickedSubLevelAtIndex:)]) {
        [self.delegate categoryViewCell:self didClickedSubLevelAtIndex:[self indexOfIndexPath:indexPath]];
    }
}

#pragma mark Private methods

- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.section + indexPath.row * SectionNumber;
    return index;
}

#pragma mark Public Methods

- (void)configWithCategory:(IcsonLevel1Category *)category {
    if (category) {
        [self.level1NameLabel setText:category.name];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (IcsonLevel2Category *level2Category in [category nextLevel]) {
            NSString *subLevelName = level2Category.name;
            [tempArray addObject:subLevelName];
        }
        self.subcategoryNames = [NSArray arrayWithArray:tempArray];
        [self.categoryImageView setImage:[UIImage imageNamed:@"home_twinklingElf_parentingActivity"]];
    }
}

@end
