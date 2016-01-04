//
//  HotActivityGroupView.m
//  ICSON
//
//  Created by 钱烨 on 4/10/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HotActivityGroupView.h"
#import "HotActivityGroupViewCell.h"
#import "HotActivityLayout.h"


@interface HotActivityGroupView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataInfosForEachSection;

- (void)buildSubviews;

- (CGSize)sizeToFit;

- (void)setDataForCell:(HotActivityGroupViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end

@implementation HotActivityGroupView
@synthesize viewHeight = _viewHeight;

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        HotActivityGroupView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}


- (void)buildSubviews {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[HotActivityGroupViewCell class] forCellWithReuseIdentifier:kHotActivityCellIdentifier];
}

- (void)setRatio:(CGFloat)ratio {
    _ratio = ratio;
    [(HotActivityLayout *)self.collectionView.collectionViewLayout setRatio:self.ratio];
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


- (void)setDataForCell:(HotActivityGroupViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(imageUrlOfCellAtIndexPath:onHotActivityView:)]) {
            NSURL *url = [self.dataSource imageUrlOfCellAtIndexPath:indexPath onHotActivityView:self];
            [cell.activityImageView setImageWithURL:url placeholderImage:PLACEHOLDERIMAGE_SMALL];
        }
    }
}


#pragma mark UICollectionViewDataSource & UICollectionViewDelegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger number = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInGroupView:)]) {
        number = [self.dataSource numberOfSectionsInGroupView:self];
    }
    return number;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(groupView:numberOfItemsInSection:)]) {
        number = [self.dataSource groupView:self numberOfItemsInSection:section];
    }
    return number;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HotActivityGroupViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotActivityCellIdentifier forIndexPath:indexPath];
    if (cell) {
        [self setDataForCell:cell atIndexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hotActivityGroupView:didSelectItemAtIndexPath:)]) {
        [self.delegate hotActivityGroupView:self didSelectItemAtIndexPath:indexPath];
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
