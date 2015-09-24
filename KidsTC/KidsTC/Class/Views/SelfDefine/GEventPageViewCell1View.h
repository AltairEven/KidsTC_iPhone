//
//  GEventPageViewCell1View.h
//  iphone51buy
//
//  Created by kunjiang on 12-7-13.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IcsonImageView.h"

@interface GEventPageViewCell1View : UIView

@property (strong, nonatomic, readonly) CALayer *rightBorderLayer;
@property (strong, nonatomic, readonly) IcsonImageView *imgView;
@property (strong, nonatomic, readonly) UILabel *priceLabel;
@property (strong, nonatomic, readonly) UILabel *nameLabel;
@property (strong, nonatomic) NSDictionary *itemInfo;
@property (nonatomic)int targetID; /* Uesed for PV UV id.*/

- (id)initWithFrame:(CGRect)frame withRightBorder:(BOOL)_rightBorder;

@end