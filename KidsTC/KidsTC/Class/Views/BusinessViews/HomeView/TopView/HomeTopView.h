//
//  HomeTopView.h
//  ICSON
//
//  Created by 钱烨 on 4/14/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeTopView;

@protocol HomeTopViewDelegate <NSObject>

- (void)didTouchedCategoryButtonOnHomeTopView:(HomeTopView *)topView;
- (void)didTouchedInputFieldOnHomeTopView:(HomeTopView *)topView;
- (void)didTouchedRoleButtonOnHomeTopView:(HomeTopView *)topView;
@end

@interface HomeTopView : UIView

@property (nonatomic, assign) id<HomeTopViewDelegate> delegate;

- (void)setRoleWithImage:(UIImage *)image;

- (void)resetInputFieldContent:(NSString *)content isPlaceHolder:(BOOL)isPlaceHolder;

@end
