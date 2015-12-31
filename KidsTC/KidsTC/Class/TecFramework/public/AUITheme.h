//
//  AUITheme.h
//  KidsTC
//
//  Created by 钱烨 on 10/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const kAUIThemeTabItemKeyHome;
extern NSString *const kAUIThemeTabItemKeyNews;
extern NSString *const kAUIThemeTabItemKeyStrategy;
extern NSString *const kAUIThemeTabItemKeyUserCenter;

typedef enum {
    AUITabbarItemTypeHome,
    AUITabbarItemTypeNews,
    AUITabbarItemTypeStrategy,
    AUITabbarItemTypeUserCenter
}AUITabbarItemType;

@class AUITabbarItemElement;

@interface AUITheme : NSObject <NSCopying>

+ (instancetype)defaultTheme;

//global

@property (nonatomic, strong) UIColor *globalThemeColor; //全局主题色

@property (nonatomic, strong) UIColor *globalBGColor; //全局背景色

@property (nonatomic, strong) UIColor *globalCellBGColor; //全局背景色

@property (nonatomic, strong) UIColor *darkTextColor; //字体深色

@property (nonatomic, strong) UIColor *lightTextColor; //字体浅色

@property (nonatomic, strong) UIColor *highlightTextColor; //字体高亮色

@property (nonatomic, strong) UIColor *buttonBGColor_Normal; //按钮背景色（普通）

@property (nonatomic, strong) UIColor *buttonBGColor_Highlight; //按钮背景色（高亮）

@property (nonatomic, strong) UIColor *buttonBGColor_Disable; //按钮背景色（不可用）

//navibar

@property (nonatomic, strong) UIColor *navibarBGColor; //导航栏背景色

@property (nonatomic, strong) UIColor *navibarTitleColor_Normal; //导航栏标题颜色（普通）

@property (nonatomic, strong) UIColor *navibarTitleColor_Highlight; //导航栏标题颜色（高亮）

@property (nonatomic, strong) UIImage *naviBackImage_Normal; //导航返回按钮图片（普通）

@property (nonatomic, strong) UIImage *naviBackImage_Highlight; //导航返回按钮图片（高亮）

//tabbar

@property (nonatomic, strong) UIColor *tabbarBGColor; //tab栏背景色

@property (nonatomic, strong) NSArray<AUITabbarItemElement *> *tabbarItmeElements; //tabbar item元素

@end

@interface AUITabbarItemElement : NSObject <NSCopying>

@property (nonatomic, assign) AUITabbarItemType type; //tab类型

@property (nonatomic, copy) NSString *tabbarItemTitle; //tabbar按钮标题

@property (nonatomic, strong) UIColor *tabbarTitleColor_Normal; //tab栏标题颜色（普通）

@property (nonatomic, strong) UIColor *tabbarTitleColor_Highlight; //tab栏标题颜色（高亮）

@property (nonatomic, strong) UIImage *tabbarItemImage_Normal; //tabbar按钮图片（普通）

@property (nonatomic, strong) UIImage *tabbarItemImage_Highlight; //tabbar按钮图片（高亮）

@end
