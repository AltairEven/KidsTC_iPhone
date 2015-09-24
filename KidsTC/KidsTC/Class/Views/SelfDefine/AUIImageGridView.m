//
//  AUIImageGridView.m
//  KidsTC
//
//  Created by 钱烨 on 8/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AUIImageGridView.h"

@interface AUIImageGridView ()

@property (nonatomic, assign) CGSize gridSize;

- (void)initSubViews;

- (void)createAddButtonWithFrame:(CGRect)frame;

- (void)resetGridSize;

- (void)resetSubViewsWithType:(AUIImageGridViewType)type;

- (void)didClickedAddButton;

- (void)didCLickedImageView:(id)sender;

- (void)resetViewHeight;

@end

@implementation AUIImageGridView
@synthesize imagesArray = _imagesArray;

#pragma Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    [self initSubViews];
    return self;
}

#pragma mark Private methods


- (void)initSubViews {
    _oneLineCount = 4;
    _hCellGap = 10;
    _vCellGap = 10;
    _hMargin = 0;
    _vMargin = 0;
    _maxLimit = UINT32_MAX;
    
    [self resetGridSize];
    if (self.showAddButton) {
        [self createAddButtonWithFrame:CGRectMake(self.hMargin, self.vMargin, self.gridSize.width, self.gridSize.height)];
    }
}

- (void)createAddButtonWithFrame:(CGRect)frame {
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setFrame:frame];
    [addButton setBackgroundImage:[UIImage imageNamed:@"addPhoto"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(didClickedAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
}

- (void)resetGridSize {
    CGFloat width = (self.frame.size.width - self.hMargin * 2 - self.hCellGap * (self.oneLineCount - 1)) / self.oneLineCount;
    _gridSize = CGSizeMake(width, width);
}


- (void)resetSubViewsWithType:(AUIImageGridViewType)type {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self resetGridSize];
    
    CGFloat xPosition = self.hMargin;
    CGFloat yPosition = self.vMargin;
    
    NSArray *dataArray = nil;
    if (type == AUIImageGridViewTypeImage) {
        dataArray = self.imagesArray;
    } else {
        dataArray = self.imageUrlStringsArray;
    }
    NSUInteger index = 0;
    for (; index < [dataArray count]; index ++) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(xPosition, yPosition, self.gridSize.width, self.gridSize.height)];
        [tempView setBackgroundColor:[UIColor redColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, self.gridSize.width, self.gridSize.height)];
        if (type == AUIImageGridViewTypeImage) {
            UIImage *image = [dataArray objectAtIndex:index];
            [imageView setImage:image];
        } else {
            NSString *urlString = [dataArray objectAtIndex:index];
            [imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:PLACEHOLDERIMAGE_SMALL];
        }
        [imageView setTag:index];
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCLickedImageView:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
        
        if (index >= (self.maxLimit - 1)) {
            break;
        }
        
        NSUInteger totalCount = index + 1;
        if ((totalCount % self.oneLineCount) == 0) {
            xPosition = self.hMargin;
            yPosition += self.gridSize.height + self.vCellGap;
        } else {
            xPosition += self.gridSize.width + self.hCellGap;
        }
    }
    
    if (index < (self.maxLimit - 1) && self.showAddButton) {
        [self createAddButtonWithFrame:CGRectMake(xPosition, yPosition, self.gridSize.width, self.gridSize.height)];
    }
    [self resetViewHeight];
}

- (void)didClickedAddButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedAddButtonOnImageGridView:)]) {
        [self.delegate didClickedAddButtonOnImageGridView:self];
    }
}

- (void)didCLickedImageView:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageGridView:didClickedImageAtIndex:)]) {
        UIView *imageView = ((UITapGestureRecognizer *)sender).view;
        [self.delegate imageGridView:self didClickedImageAtIndex:imageView.tag];
    }
}

- (void)resetViewHeight {
    CGFloat viewHeight = [self viewHeight];
    
    NSArray *starsViewConstraintsArray = [self constraints];
    if (starsViewConstraintsArray && [starsViewConstraintsArray count] > 0) {
        for (NSLayoutConstraint *constraint in starsViewConstraintsArray) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = viewHeight;
            }
        }
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, viewHeight);
    }
}


#pragma mark Setter & Getter

- (void)setOneLineCount:(NSUInteger)oneLineCount {
    _oneLineCount = oneLineCount;
    [self resetSubViewsWithType:self.type];
}

- (void)setHCellGap:(CGFloat)hCellGap {
    _hCellGap = hCellGap;
    [self resetSubViewsWithType:self.type];
}

- (void)setVCellGap:(CGFloat)vCellGap {
    _vCellGap = vCellGap;
    [self resetSubViewsWithType:self.type];
}

- (void)setHMargin:(CGFloat)hMargin {
    _hMargin = hMargin;
    [self resetSubViewsWithType:self.type];
}

- (void)setVMargin:(CGFloat)vMargin {
    _vMargin = vMargin;
    [self resetSubViewsWithType:self.type];
}

- (void)setMaxLimit:(NSUInteger)maxLimit {
    _maxLimit = maxLimit;
    [self resetSubViewsWithType:self.type];
}

- (void)setImagesArray:(NSArray *)imagesArray {
    if ([imagesArray count] > self.maxLimit) {
        _imagesArray = [NSArray arrayWithArray:[imagesArray subarrayWithRange:NSMakeRange(0, self.maxLimit)]];
    } else {
        _imagesArray = [NSArray arrayWithArray:imagesArray];
    }
    _type = AUIImageGridViewTypeImage;
    [self resetSubViewsWithType:self.type];
}

- (void)setImageUrlStringsArray:(NSArray *)imageUrlStringsArray {
    if ([_imageUrlStringsArray count] > self.maxLimit) {
        _imageUrlStringsArray = [NSArray arrayWithArray:[imageUrlStringsArray subarrayWithRange:NSMakeRange(0, self.maxLimit)]];
    } else {
        _imageUrlStringsArray = [NSArray arrayWithArray:imageUrlStringsArray];
    }
    _type = AUIImageGridViewTypeImageUrlString;
    [self resetSubViewsWithType:self.type];
}

- (void)setShowAddButton:(BOOL)showAddButton {
    _showAddButton = showAddButton;
    [self resetSubViewsWithType:self.type];
}


- (CGFloat)viewHeight {
    NSUInteger photoCount = [self.imagesArray count];
    if (photoCount == 0) {
        photoCount = [self.imageUrlStringsArray count];
    }
    CGFloat rowCount = photoCount / self.oneLineCount;
    NSUInteger leftCount = photoCount % self.oneLineCount;
    if (leftCount > 0) {
        rowCount ++;
    } else if (self.showAddButton && photoCount < self.maxLimit) {
        rowCount ++;
    }
    if (photoCount == 0 && self.showAddButton) {
        rowCount = 1;
    }
    CGFloat height = (self.vMargin * 2) + (self.gridSize.height * rowCount) + (self.vCellGap * (rowCount - 1));
    if (height < 0) {
        height = 0;
    }
    return height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
