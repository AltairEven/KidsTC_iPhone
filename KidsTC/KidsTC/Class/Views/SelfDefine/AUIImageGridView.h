//
//  AUIImageGridView.h
//  KidsTC
//
//  Created by 钱烨 on 8/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AUIImageGridViewTypeImage,
    AUIImageGridViewTypeImageUrlString
}AUIImageGridViewType;

@class AUIImageGridView;

@protocol AUIImageGridViewDelegate <NSObject>

@optional

- (void)didClickedAddButtonOnImageGridView:(AUIImageGridView *)view;

- (void)imageGridView:(AUIImageGridView *)view didClickedImageAtIndex:(NSUInteger)index;

@end

@interface AUIImageGridView : UIView

@property (nonatomic, readonly) AUIImageGridViewType type;

@property (nonatomic, assign) id<AUIImageGridViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger oneLineCount;

@property (nonatomic, assign) CGFloat hCellGap;

@property (nonatomic, assign) CGFloat vCellGap;

@property (nonatomic, assign) CGFloat hMargin;

@property (nonatomic, assign) CGFloat vMargin;

@property (nonatomic, assign) NSUInteger maxLimit;

//UIImage array
@property (nonatomic, strong) NSArray *imagesArray;

//url string array
@property (nonatomic, strong) NSArray *imageUrlStringsArray;

@property (nonatomic, assign) BOOL showAddButton;

- (CGFloat)viewHeight;

@end
