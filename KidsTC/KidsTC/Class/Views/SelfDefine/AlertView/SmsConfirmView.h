/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：SmsConfirmView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年10月09日
 */

#import <UIKit/UIKit.h>
#import "BaseAlertView.h"

typedef void(^ConfirmBlock)(NSString*);
typedef void(^CancelBlock) ();

@interface SmsConfirmView : BaseAlertView {
    
    BOOL                        _replaceView;
    NSArray *                   _phoneList;
    
}

@property (copy, nonatomic) ConfirmBlock    confirmBlock;
@property (copy, nonatomic) CancelBlock    cancelBlock;

@property (strong, nonatomic) IBOutlet UIView *confirmInputView;
@property (strong, nonatomic) IBOutlet UITextField *verifyText;
@property (strong, nonatomic) IBOutlet UILabel *verifyLabel;

@property (strong, nonatomic) IBOutlet UIView *phoneNoView;
@property (strong, nonatomic) IBOutlet UITextField *phoneText;
@property (strong, nonatomic) IBOutlet UILabel *phoneNoTitle;
@property (strong, nonatomic) IBOutlet UILabel *phoneNoLabel;

@property (strong, nonatomic) IBOutlet UIView *CallSupportView;

@property (strong, nonatomic) IBOutlet UIView *simplePhontView;
@property (strong, nonatomic) IBOutlet UITableView *phoneTable;


- (void)showSmsConfirmViewWithHint:(NSString*)hint;
- (void)showPhoneNoViewWithTitle:(NSString*)title andHint:(NSString*)hint;
- (void)showCallSupportView;
- (void)showSimplePhoneView:(NSArray*)phoneArr;


- (IBAction)callHelp;
- (IBAction)fetchVerifyCode;
- (IBAction)verifyConform;
- (IBAction)cancel;

@end
