//
//  AUILinearView.m
//  KidsTC
//
//  Created by 钱烨 on 9/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AUILinearView.h"



NSString *const kLinearViewCellIdentifier = @"kLinearViewCellIdentifier";

#pragma mark AUILinearViewCell


@interface AUILinearViewCell : UICollectionViewCell


@end

@implementation AUILinearViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"AUILinearViewCell" owner:self options: nil];
//        if([arrayOfViews count] == 0) {
//            return self;
//        }
//        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
//            return self;
//        }
//        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}


@end

#pragma mark AUILinearViewLayout

#define MARGIN_VERTICAL (10)
#define GAP_HORIZONTAL (20)
#define SCALE   (1.2)

@interface AUILinearViewLayout : UICollectionViewLayout

@property (nonatomic, weak) AUILinearView *linearView;

@property (nonatomic, assign) CGSize collectionViewSize;

@property (nonatomic, assign) NSUInteger sectionNumber;

@property (nonatomic, assign) CGFloat marginHorizontal;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGFloat hGap;

- (CGSize)cellSizeAtIndex:(NSUInteger)index;

- (NSIndexPath *)indexPathOfCenter;

@end

@implementation AUILinearViewLayout


- (void)prepareLayout {
    self.marginHorizontal = (SCREEN_WIDTH - [self cellSizeAtIndex:0].width) / 2;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    NSMutableArray *attributesArray = [[NSMutableArray alloc] init];
    for (NSInteger n = 0; n < self.sectionNumber; n ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:n];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (attributes) {
            [attributesArray addObject:attributes];
        }
    }
    NSArray *array = [NSArray arrayWithArray:attributesArray];
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat activeDistance = attributes.size.width + self.hGap;
            CGFloat normalizedDistance = distance / activeDistance;
            if (ABS(distance) <= activeDistance) {
                CGFloat zoom = 1 - ABS(normalizedDistance);
                zoom = self.scale * zoom;
                if (zoom <= 1) {
                    zoom = 1;
                }
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGSize cellSize = [self cellSizeAtIndex:indexPath.section];
    CGFloat xOrigin = self.marginHorizontal + indexPath.section * (cellSize.width + self.hGap);
    CGFloat yOrigin = (self.collectionView.frame.size.height - [self cellSizeAtIndex:0].height) / 2;
    if (yOrigin < MARGIN_VERTICAL) {
        yOrigin = MARGIN_VERTICAL;
    }
    attributes.frame = CGRectMake(xOrigin, yOrigin, cellSize.width, cellSize.height);
//    CGFloat zoomScale = 1;
//    attributes.transform3D = CATransform3DMakeScale(zoomScale, zoomScale, 1.0);
    
    return attributes;
}



- (CGSize)collectionViewContentSize {
    //计算宽高
    self.sectionNumber = [self.collectionView numberOfSections];
    
    CGFloat contentWidth = 0;
    CGFloat contentHeight = 0;
    for (NSUInteger index = 0; index < self.sectionNumber; index ++) {
        CGSize cellSize = [self cellSizeAtIndex:index];
        contentWidth += cellSize.width;
        if (contentHeight < cellSize.height) {
            contentHeight = cellSize.height;
        }
    }
    contentWidth += (self.sectionNumber + 1) * self.hGap + 2 * self.marginHorizontal;
    
    self.collectionViewSize = CGSizeMake(contentWidth, contentHeight + 2 * MARGIN_VERTICAL);
    return self.collectionViewSize;
}

- (CGSize)cellSizeAtIndex:(NSUInteger)index {
    CGSize cellSize = CGSizeZero;
    if ([self.linearView.viewsForLinearView count] > index) {
        UIView *cellView = [self.linearView.viewsForLinearView objectAtIndex:index];
        cellSize = CGSizeMake(cellView.frame.size.width, cellView.frame.size.height);
    }
    return cellSize;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [self layoutAttributesForElementsInRect:targetRect];
    
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSIndexPath *)indexPathOfCenter {
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    NSMutableArray *attributesArray = [[NSMutableArray alloc] init];
    for (NSInteger n = 0; n < self.sectionNumber; n ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:n];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (attributes) {
            [attributesArray addObject:attributes];
        }
    }
    NSArray *array = [NSArray arrayWithArray:attributesArray];
    
    NSIndexPath *indexPath = nil;
    for (UICollectionViewLayoutAttributes* attributes in array) {
        CGPoint centerPoint = CGPointMake(visibleRect.origin.x + visibleRect.size.width / 2, visibleRect.origin.y + visibleRect.size.height / 2);
        if (CGRectContainsPoint(attributes.frame, centerPoint)) {
            indexPath = attributes.indexPath;
            break;
        }
    }
    return indexPath;
}


@end

#pragma mark AUILinearView

@interface AUILinearView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

- (void)initLinearView;

@end

@implementation AUILinearView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initLinearView];
    }
    return self;
}


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    [self initLinearView];
    return self;
}

- (void)initLinearView {
    self.backgroundColor = [[KTCThemeManager manager] defaultTheme].globalBGColor;
    AUILinearViewLayout *linearViewLayout = [[AUILinearViewLayout alloc] init];
    linearViewLayout.linearView = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:linearViewLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setAllowsMultipleSelection:NO];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self addSubview:self.collectionView];
    
    [self.collectionView setHidden:YES];
    
    [self.collectionView registerClass:[AUILinearViewCell class] forCellWithReuseIdentifier:kLinearViewCellIdentifier];
    
    self.selectedCellScale = SCALE;
    self.horizontalGap = GAP_HORIZONTAL;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex < self.cellNumber) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:selectedIndex];
        if (indexPath) {
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
        }
    }
}

- (void)setSelectedCellScale:(CGFloat)selectedCellScale {
    _selectedCellScale = selectedCellScale;
    [(AUILinearViewLayout *)self.collectionView.collectionViewLayout setScale:selectedCellScale];
}

- (void)setPageingEnabled:(BOOL)pageingEnabled {
    _pageingEnabled = pageingEnabled;
    [self.collectionView setPagingEnabled:pageingEnabled];
}

- (void)setHorizontalGap:(CGFloat)horizontalGap {
    _horizontalGap = horizontalGap;
    [(AUILinearViewLayout *)self.collectionView.collectionViewLayout setHGap:horizontalGap];
}

- (void)setHMargin:(CGFloat)hMargin {
    _hMargin = hMargin;
}

#pragma mark UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.cellNumber;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AUILinearViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLinearViewCellIdentifier forIndexPath:indexPath];
    if (cell) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        [cell.contentView addSubview:[self.viewsForLinearView objectAtIndex:indexPath.section]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.section;
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(auilinearView:didSelectedCellAtIndex:)]) {
        [self.delegate auilinearView:self didSelectedCellAtIndex:indexPath.section];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(auilinearViewDidScrolled:)]) {
        [self.delegate auilinearViewDidScrolled:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [(AUILinearViewLayout *)self.collectionView.collectionViewLayout indexPathOfCenter];
    if (indexPath) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:self.selectedIndex];
        [self.collectionView deselectItemAtIndexPath:lastIndexPath animated:YES];
        [self collectionView:self.collectionView didDeselectItemAtIndexPath:lastIndexPath];
        
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(auilinearViewDidEndScroll:)]) {
        [self.delegate auilinearViewDidEndScroll:self];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(auilinearView:didDeselectCellAtIndex:)]) {
        [self.delegate auilinearView:self didDeselectCellAtIndex:indexPath.section];
    }
}

#pragma mark Public Methods

- (void)reloadData {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(numberOfCellsInAUIlinearView:)]) {
            _cellNumber = [self.dataSource numberOfCellsInAUIlinearView:self];
        }
        if ([self.dataSource respondsToSelector:@selector(auilinearView:viewForCellAtIndex:withMaxHeight:)]) {
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            CGFloat height = self.frame.size.height - MARGIN_VERTICAL * 2;
            for (NSUInteger index = 0; index < self.cellNumber; index ++) {
                UIView *view = [self.dataSource auilinearView:self viewForCellAtIndex:index withMaxHeight:height];
                if (view) {
                    [temp addObject:view];
                }
            }
            _viewsForLinearView = [NSArray arrayWithArray:temp];
        }
    }
    [self.collectionView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
    [self.collectionView setHidden:NO];
}

- (void)resetLayout {
}

- (void)layoutSubviews {
    [self updateConstraintsIfNeeded];
    self.collectionView.frame = self.frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end