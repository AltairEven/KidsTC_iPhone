//
//  HomeRecommendView.m
//  KidsTC
//
//  Created by Altair on 12/31/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeRecommendView.h"
#import "HomeRecommendViewCell.h"
#import "HomeRecommenLayout.h"


@interface HomeRecommendView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataInfosForEachSection;

- (void)buildSubviews;

- (CGSize)sizeToFit;

- (void)setDataForCell:(HomeRecommendViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end

@implementation HomeRecommendView
@synthesize viewHeight = _viewHeight;

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        HomeRecommendView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}


- (void)buildSubviews {
    [self.collectionView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[HomeRecommendViewCell class] forCellWithReuseIdentifier:kHomeRecommendCellIdentifier];
}


#pragma mark Public Methods

- (void)reloadData {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
    [self sizeToFit];
}


#pragma mark Self Methods


- (CGSize)sizeToFit {
    CGSize size = [self.collectionView.collectionViewLayout collectionViewContentSize];
    _viewHeight = size.height;
    return size;
}


- (void)setDataForCell:(HomeRecommendViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(elementOfCellAtIndexPath:onRecommendView:)]) {
            HomeRecommendElement *element = [self.dataSource elementOfCellAtIndexPath:indexPath onRecommendView:self];
            [cell configWithModel:element];
        }
    }
}


#pragma mark UICollectionViewDataSource & UICollectionViewDelegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger number = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInRecommendView:)]) {
        number = [self.dataSource numberOfSectionsInRecommendView:self];
    }
    return number;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(recommendView:numberOfItemsInSection:)]) {
        number = [self.dataSource recommendView:self numberOfItemsInSection:section];
    }
    return number;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeRecommendViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeRecommendCellIdentifier forIndexPath:indexPath];
    if (cell) {
        [self setDataForCell:cell atIndexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recommendView:didSelectItemAtIndexPath:)]) {
        [self.delegate recommendView:self didSelectItemAtIndexPath:indexPath];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
