/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GNewCenterCell.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：xiaomanwang
 * 完成日期：12-11-5
 */

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@class GCornerView;

@interface GVirtualOrderCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView *backWhiteView;
@property(nonatomic,strong)IBOutlet UILabel *labelOfTitle;
@property(nonatomic,strong)IBOutlet UIImageView *imageViewOfAccessory;
@end

@interface GNewCenterCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView *backWhiteView;
@property(nonatomic,strong)IBOutlet UILabel *labelOfOrderNo;
@property(nonatomic,strong)IBOutlet UILabel *labelOfNum;
@property(nonatomic,strong)IBOutlet UILabel *labelOfStatus;
@property(nonatomic,strong)IBOutlet UIImageView *imageViewOfLine;
@end


@interface GChongZhiCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView *backWhiteView;
@property(nonatomic,strong)IBOutlet UIImageView *imageViewOfType;
@property(nonatomic,strong)IBOutlet UILabel *labelOfMoney;
@property(nonatomic,strong)IBOutlet UILabel *labelOfTypeName;
@property(nonatomic,strong)IBOutlet UILabel *labelOfPhoneNumber;
@property(nonatomic,strong)IBOutlet UIImageView *imageViewOfAccessory;
@property(nonatomic,strong)IBOutlet UIImageView *imageViewOfLine;

@end
@interface GProductPicCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIScrollView*scrollView;
@property(nonatomic,strong)IBOutlet UIImageView *backWhiteView;
@property(nonatomic,strong)IBOutlet UIImageView *imageViewAccessosry;
@property(nonatomic,strong)IBOutlet UIImageView *imageViewOfLine;

@end

//每个包裹的cell，它严格意义上不是一个单独的cell，而是订单列表中的一个cell的小cell
@interface GProductPackageCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView *backWhiteView;
@property(nonatomic,strong)IBOutlet UILabel *labelOfPackge;
@property(nonatomic,strong)IBOutlet UILabel *labelOfStatus;
@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)IBOutlet UIImageView *imageViewAccessory;
@property(nonatomic,strong)IBOutlet UIImageView *imageViewOfLine;

@end

@interface GMoneyCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView *backWhiteView;
@property(nonatomic,strong)IBOutlet UILabel*labelOfSumHint;
@property(nonatomic,strong)IBOutlet UILabel *labelOfSumMoney;
@property(nonatomic,strong)IBOutlet UILabel *labelOfType;
@property(nonatomic,strong)IBOutlet UILabel *labelOfTime;
@property(nonatomic,strong)IBOutlet UIButton *buttonOfPay;
@property(nonatomic,strong)IBOutlet UIImageView *imageViewLine;

@end

@interface GSumCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *backWhiteView;
@property(nonatomic,strong)IBOutlet UILabel *labelTimeHint;
@property(nonatomic,strong)IBOutlet UILabel *labelTime;
@property(nonatomic,strong)IBOutlet UILabel *labelSumHint;
@property(nonatomic,strong)IBOutlet UILabel *labelSum;
@property(nonatomic,strong)IBOutlet UILabel *labelPayType;
@property(nonatomic,strong)IBOutlet UIButton *buttonPay;
@property(nonatomic,strong)IBOutlet UIButton *buttonCancel;
@end


@interface GDeliveryCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imageViewOfBg;
@property(nonatomic,strong)TTTAttributedLabel *labelOfDelivery;
//@property(nonatomic,retain)TTTAttributedLabel *labelOfTel;
@property(nonatomic,strong)UILabel *labelOfTime;
@property(nonatomic,strong)UIImageView *imageViewOfLine;
@end

@interface GMapCell : UITableViewCell
@property(nonatomic,strong)UIImageView*imageViewOfBg;
@property(nonatomic,strong)UIImageView*imageViewOfMap;
@property(nonatomic,strong)UILabel *labelOfCheck;
@property(nonatomic,strong)UILabel *labelOfRange;
@property(nonatomic,strong)UIImageView *accessoryImage;
@property(nonatomic,strong)UIImageView *imageViewOfLine;

@end
@interface GCenterViewCell:UITableViewCell
@property(nonatomic, retain)IBOutlet UILabel *labelOrderIdHint;

@end

@interface GCornerView : UIView
@property(nonatomic,assign)BOOL isTop;
@property(nonatomic,strong)UIColor *backColor;
@property(nonatomic,strong)UIColor *fillColor;
- (id)initWithIsTop:(BOOL)newIsTop andBackColor:(UIColor*)newBackColor andFillColor:(UIColor*)newFillColor andFrame:(CGRect)frame;
@end