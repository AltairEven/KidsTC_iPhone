//
//  GEventPageViewCell2.h
//  iphone51buy
//
//  Created by kunjiang on 12-7-13.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTableViewCell.h"
#import "IcsonImageView.h"

@interface GEventPageViewCell2 : GTableViewCell

@property (strong, nonatomic, readonly) IcsonImageView *imageView;
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *subTitleLabel;

- (void)setEventRowData : (NSDictionary *)_rowData;

@end
