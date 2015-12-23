/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：PenddingImageView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年11月21日
 */

#import <UIKit/UIKit.h>
#import "DownLoadManager.h"

typedef enum
{
    ePenddingNormal = 0,
    ePenddingHasSent,
    ePenddingComplete,
    ePenddingFail
}PenddingImageStat;


@interface PenddingImageView : UIView {
@public
    NSString *                          _group;
    NSString *                          _imgUrl;
    
    UIImageView *                       _imgView;
    UIImageView *                       _swapImgView;
    UIImage *                           _imgToDisplay;

    // put some additional info in userInfo if need to
    NSDictionary *                      _userInfo;
    
    BOOL                                _showWithAnimation;
}

@property (nonatomic) BOOL                          showWithAnimation;      // default YES
@property (nonatomic) BOOL                          showASAP;               // default YES

@property (nonatomic, strong) NSString *            group;
@property (nonatomic, strong) NSString *            imgUrl;
@property (nonatomic, strong) NSDictionary *        userInfo;

@property (nonatomic, strong) UIImage *             placeHolderImg;
@property (nonatomic, strong) UIImage *             failImg;

@property (nonatomic) UIEdgeInsets                  imgInset;
@property (nonatomic, readonly) PenddingImageStat   penddingStat;
@property (nonatomic, strong) UIImageView *imgView;

- (void) refresh;
- (void) goFetching;
- (void) realDisplayImage;      // if showASAP==YES, this function will be called automatically when data is ready
- (void) stop;

- (CGSize) sizeForCurrentImage;
- (UIImage*) showingImage;

// 选择继承并重载以下函数处理对应事件

- (void) internalInit;
- (DownloadOption*) downloadOption;

- (void) onWillDisplay;
- (void) onLoadSuccess;
- (void) onLoadFail;

@end