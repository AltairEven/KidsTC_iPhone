/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：AnimedBtn.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-11-5
 */

#import <UIKit/UIKit.h>

@interface AnimedBtn : UIButton {
    
    UIImageView *               _animImg;
    
}

@property (nonatomic, strong) NSArray *         touchDownImgArr;    
@property (nonatomic, strong) NSArray *         touchUpImgArr;      // if nil, set as reverse touchDownImgArr
@property (nonatomic, strong) NSArray *         animImgArr;         // if nil, set as touchDownImgArr + touchUpImgArr. if not nil, ignore touchDownImgArr and touchUpImgArr

- (void) setAnimDuration:(NSTimeInterval)duration;

- (void) playTouchDown;
- (void) playTouchUp;
- (void) playTouchDownAndUp;

@end
