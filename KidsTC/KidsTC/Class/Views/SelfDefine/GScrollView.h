//
//  GScrollView.h
//  iphone51buy
//
//  Created by gene chu on 10/26/12.
//  Copyright (c) 2012 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GScrollViewDelegate;
@interface GScrollView : UIScrollView
@end
@protocol GScrollViewDelegate <UIScrollViewDelegate>
- (void)scrollView:(UIScrollView *)scrollView didTouchAtContentPoint:(CGPoint) aPoint;
@end
