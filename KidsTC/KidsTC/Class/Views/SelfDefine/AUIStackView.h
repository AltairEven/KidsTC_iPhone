//
//  AUIStackView.h
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AUIStackView : UIView

@property (nonatomic, strong) NSArray *subViews;

@property (nonatomic, assign) CGFloat viewGap; //default 10

@end
