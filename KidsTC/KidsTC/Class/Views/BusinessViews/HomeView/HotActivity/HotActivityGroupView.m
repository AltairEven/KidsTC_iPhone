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
        HotActivityGroupView *groupView = [self getObjectFromNibWithClass:[self class]];
        [self replaceAutolayoutConstrainsFromView:self toView:groupView];
        [groupView buildSubviews];
        return groupView;
    }
    bLoad = NO;
    return self;
}


- (id)getObjectFromNibWithClass:(Class)class {
    
    NSString *className = NSStringFromClass(class);
    
    NSArray *topObjArray = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    
    for (id anObj in topObjArray) {
        if ([anObj isKindOfClass:class]) {
            return anObj;
        }
    }
    
    return nil;
}




- (void)replaceAutolayoutConstrainsFromView:(UIView *)placeholderView toView:(UIView *)realView
{
    realView.autoresizingMask = placeholderView.autoresizingMask;
    realView.translatesAutoresizingMaskIntoConstraints = placeholderView.translatesAutoresizingMaskIntoConstraints;
    
    // Copy autolayout constrains from placeholder view to real view
    if (placeholderView.constraints.count > 0) {
        
        // We only need to copy "self" constraints (like width/height constraints)
        // from placeholder to real view
        for (NSLayoutConstraint *constraint in placeholderView.constraints) {
            
            NSLayoutConstraint* newConstraint;
            
            // "Height" or "Width" constraint
            // "self" as its first item, no second item
            if (!constraint.secondItem) {
                newConstraint =
                [NSLayoutConstraint constraintWithItem:realView
                                             attribute:constraint.firstAttribute
                                             relatedBy:constraint.relation
                                                toItem:nil
                                             attribute:constraint.secondAttribute
                                            multiplier:constraint.multiplier
                                              constant:constraint.constant];
            }
            // "Aspect ratio" constraint
            // "self" as its first AND second item
            else if ([constraint.firstItem isEqual:constraint.secondItem]) {
                newConstraint =
                [NSLayoutConstraint constraintWithItem:realView
                                             attribute:constraint.firstAttribute
                                             relatedBy:constraint.relation
                                                toItem:realView
                                             attribute:constraint.secondAttribute
                                            multiplier:constraint.multiplier
                                              constant:constraint.constant];
            }
            
            // Copy properties to new constraint
            if (newConstraint) {
                newConstraint.shouldBeArchived = constraint.shouldBeArchived;
                newConstraint.priority = constraint.priority;
                if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f) {
                    newConstraint.identifier = constraint.identifier;
                }
                [realView addConstraint:newConstraint];
            }
        }
    }
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
            if (indexPath.section == 0) {
                [cell.activityImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home5"]];
            } else {
                [cell.activityImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home6"]];
            }
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
