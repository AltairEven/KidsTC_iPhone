//
//  UILabel+Additions.h
//  iphone51buy
//
//  Created by icson apple on 12-6-23.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel(Additions)

- (CGFloat)sizeToFitWithMaximumNumberOfLines:(NSInteger)lines;
- (CGSize)sizeOfSizeToFitWithMaximumNumberOfLines:(NSInteger)lines;
- (void)sizeToFitWithMaximumNumberOfLinesExtend:(NSInteger)lines;
- (void)sizeToFitWithMaximumNumberOfLinesExtend:(NSInteger)lines andLastLineEscapeWidth:(NSInteger)escapeWidth;
- (void)setClipText:(NSString *)text lines:(NSInteger)lines;
- (void)setClipText:(NSString *)text lines:(NSInteger)lines paragrapEndSpace:(float)endSpace;
- (void)adjustFontWith:(NSString *)text constrainedToSize:(CGSize)size;

@end
