//
//  HeaderRefreshView.h
//  ICSON
//
//  Created by 钱烨 on 4/23/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderRefreshView : UIView

@property (nonatomic, assign) NSTimeInterval duration;

- (void)startAnimation;

- (void)stopAnimation;

@end
