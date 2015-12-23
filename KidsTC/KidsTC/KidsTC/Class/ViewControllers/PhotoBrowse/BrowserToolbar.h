//
//  BrowserToolbar.h
//  imageZoom
//
//  ICSON
//
//  Created by 肖晓春 on 15/5/12.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserToolbar : UIView

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, assign) NSInteger totoalPage;

- (void)setCurrentPageNumber:(NSInteger)page;

- (void)setCurrentPageNumber:(NSInteger)page andTotoal:(NSInteger)totoalPage;
- (void)hidden:(NSTimeInterval)duration;
- (void)show:(NSTimeInterval)duration;
@end
