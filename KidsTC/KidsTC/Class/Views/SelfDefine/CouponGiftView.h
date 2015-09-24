/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：CouponGiftView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：ericjsshen
 * 完成日期：2013年10月16日
 */

#import <UIKit/UIKit.h>

@interface OrderCouponGiftView : UIView

@property (strong, nonatomic) IBOutlet UILabel *currencySymbolLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (assign, nonatomic) NSInteger amount;

@end

@interface ProductCouponGiftView : UIView

@property (strong, nonatomic) IBOutlet UILabel *currencySymbolLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (assign, nonatomic) NSInteger amount;

@end

@interface PhotoCouponGiftView : UIView

@property (strong, nonatomic) IBOutlet UILabel *currencySymbolLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (assign, nonatomic) NSInteger amount;

@end
