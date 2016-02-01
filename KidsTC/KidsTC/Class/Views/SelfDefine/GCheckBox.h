//
//  GCheckBox.h
//  iphone51buy
//
//  Created by icson apple on 12-6-14.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	GCheckBoxDefault,
	GCheckBoxSelect,//筛选
	GCheckBoxPromo, //购物车，选择促销
    GCheckBoxLogin, //登录
}GCheckBoxType;

@protocol GCheckBoxDelegate;

@interface GCheckBox : UIButton
@property (nonatomic) BOOL checked;
@property (nonatomic) NSInteger type;//加一个变量登录界面的chechbox用另一个背景图片
@property (weak, nonatomic) id<GCheckBoxDelegate>delegate;
@property (assign, nonatomic) BOOL touchEnable;  //add by Altair, 20141124
- (void)toggleChecked;
- (id)initWithFrame:(CGRect)frame andType:(NSInteger)newType;
@end
@protocol GCheckBoxDelegate <NSObject>

- (void)gCheckBox:(GCheckBox *)gCheckBox checked:(BOOL)checked;

@end


