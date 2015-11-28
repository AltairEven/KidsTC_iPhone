//
//  FiveStarsView.h
//  KidsTC
//
//  Created by 钱烨 on 7/10/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiveStarsView;

@protocol FiveStarsViewDelegate <NSObject>

- (void)fiveStarsView:(FiveStarsView *)starsView didChangedStarNumberFromValue:(CGFloat)fromVal toValue:(CGFloat)toVal;

@end

@interface FiveStarsView : UIView

@property (nonatomic, assign) CGFloat starNumber;
@property (nonatomic, assign) CGFloat starGap;
@property (nonatomic, assign) CGSize starSize;
@property (nonatomic, strong) UIImage *starImageFull;
@property (nonatomic, strong) UIImage *starImageHalf;
@property (nonatomic, strong) UIImage *starImageEmpty;

@property (nonatomic, assign) id<FiveStarsViewDelegate> delegate;

@property (nonatomic, assign) BOOL editable;

- (instancetype)initWithStarGap:(CGFloat)gap andStarSize:(CGSize)size;

- (CGSize)sizeToFitParameters;

- (CGSize)viewSize;

@end
