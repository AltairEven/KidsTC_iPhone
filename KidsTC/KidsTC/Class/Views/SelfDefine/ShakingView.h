/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：ShakingView.h
 * 文件标识：
 * 摘 要： use to handle shake gesture, warning, ios 4 do not support handle motion in view, they do this in viewcontrollers
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年12月26日
 */

#import <UIKit/UIKit.h>

typedef void (^ShakeBlock)();

@interface ShakingView : UIView {
    
    ShakeBlock            _shakeBlock;
    
}

@property (nonatomic, copy) ShakeBlock            shakeBlock;

@end
