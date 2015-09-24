//
//  ZommViewsController.h
//  imageZoom
//
//  ICSON
//
//  Created by 肖晓春 on 15/5/12.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
///

//#import "ViewController.h"
typedef void (^finishBlock)(BOOL isCurrent);


@protocol PhotoBrowseViewControllerDelegate <NSObject>

@optional
- (void)deletePhoto :(NSInteger )currentindex;
@end

@interface PhotosBrowserController : UIViewController
@property (nonatomic,weak) id<PhotoBrowseViewControllerDelegate>delegate;
/**
 * 用于存放滚动视图中的viewController
 */
@property (nonatomic, strong) NSMutableArray *zoomViewControllers;

/**
 * 用于存放PhotoItem对象的数组
 */
@property (nonatomic, strong) NSArray *photos;

/**
 * 用于创建并初始化一个PhotoBrowserController
 * @param imageArr 一个存放PhotoItem的数组
 * @param index 当前打开的是第几张图片的放大图
 * @param block 回调
 */
- (instancetype)initWithImageArr:(NSArray *)imageArr imageIndex:(NSInteger)index finish:(finishBlock)block;

//image url
- (instancetype)initWithImageUrlStringsArray:(NSArray *)urlStringsArray imageIndex:(NSInteger)index finish:(finishBlock)block;

//uiimage
- (instancetype)initWithImagesArray:(NSArray *)imageArray imageIndex:(NSInteger)index finish:(finishBlock)block;

@end
