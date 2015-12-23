/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：RollingCell.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：12-11-5
 */

#import <UIKit/UIKit.h>

@interface RollingInfo : NSObject 

@property NSInteger  rollId;
@property (strong, nonatomic) NSString * textString;
@property (strong, nonatomic) NSString * imgName;

- (id) initWithId:(NSInteger)idx textString:(NSString*)textStr andImageName:(NSString*)img;

@end

////////////////////////////////////////////////////////////////////////////////////////

@interface RollingCell : UITableViewCell {
    
    UIImageView *           _bgImgView;
    UILabel *               _titleLabel;

}

@property (strong, nonatomic) RollingInfo * info;

@end
