//
//  ZoomItem.h
//  imageZoom
//
//  ICSON
//
//  Created by 肖晓春 on 15/5/12.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoItem : NSObject
/**
 * urlString 存放高清图的url字符串
 */
@property (nonatomic, copy) NSString *urlString;

/**
 * hignImage 存放高清图
 */
@property (nonatomic, copy) UIImage *hignImage;

/**
 * thumUrlString 用于存放缩率图url字符串
 */
@property (nonatomic, copy) NSString *thumUrlString;

/**
 * 用于存放缩略图的UIImageView 用于动画变化用
 */
@property (nonatomic, weak) UIImageView *thumImageView;

/**
 * 获得对象在window中的位置
 */
@property (nonatomic, assign, readonly) CGRect itemFrame;

@property (nonatomic, assign) NSInteger tag;

/**
 * 初始化PhotoItem
 * @param thumImageView 缩略图的UIImageView对象
 * @return PhotoItem* 返回photoItem对象
 */
- (instancetype)initWithImageView:(UIImageView *)thumImageView;

@end
