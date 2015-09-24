//
//  CoudanTableView.h
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-9-4.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CoudanTypeProductDetail,
    CoudanTypeCart,
} CoudanTableViewType;

@protocol CoudanTableViewDelegate <NSObject>

- (void)coudanViewDidSelectRowWithUrl:(NSString *)urlStr;

@end

@interface CoudanTableView : UIView

@property (nonatomic, unsafe_unretained) id <CoudanTableViewDelegate> delegate;

+ (CGFloat)getCoudanTableViewHeightWithData:(NSArray *)data coudanType:(CoudanTableViewType)type andConstraintWidth:(CGFloat)width;

- (id)initWithData:(NSArray *)data delegate:(id<CoudanTableViewDelegate>)delegate coudanType:(CoudanTableViewType)type andConstraintWidth:(CGFloat)width;

- (void)layoutSubviewsWithData:(NSArray *)data;

@end
