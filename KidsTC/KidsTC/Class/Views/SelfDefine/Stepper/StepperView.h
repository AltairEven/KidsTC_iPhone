/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：StepperView.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2012年09月25日
 */

#import <UIKit/UIKit.h>

typedef enum
{
    eSteptypeNone = 0,
    eSteptypeAdd,
    eSteptypeSub,
    eSteptypeEdit
}eSteptype;

@protocol StepperDelegate;

@interface StepperView : UIView <UITextFieldDelegate> {
    
    UIImageView *       _inputFieldBg;
    UITextField *       _inputField;
    UIButton *          _subBtn;
    UIButton *          _addBtn;
    
    BOOL                _enableLimit;           // default is no limit
    
}

@property (nonatomic, weak) id<StepperDelegate>       stepperDelegate;
@property (nonatomic) NSInteger                         valStep;      // default is 1
@property (nonatomic) NSInteger                         curVal;

@property (nonatomic, readonly) NSInteger               minVal;
@property (nonatomic, readonly) NSInteger               maxVal;
@property (nonatomic, assign)   BOOL                    enabledInput;
@property (nonatomic, assign)   BOOL                    enabledChange;

@property (nonatomic) CGSize                            hitThreshold;

- (void) enableInput:(BOOL)isEnable;
- (void) setMaxVal:(NSInteger)maxVal andMinVal:(NSInteger)minVal;
- (UITextField*)getTextField;
- (void)checkBtnStatus;
- (UIButton*)addButton;
- (UIButton*)subButton;

- (CGSize)size;

@end

@protocol StepperDelegate <NSObject>

@optional

- (void)didStartEditWithKeyboardOnStepperView:(StepperView *)stepper;

- (void)didEndEditWithKeyboardOnStepperView:(StepperView *)stepper;

- (void)stepperView:(StepperView *)stepper valueChanged:(NSInteger)val byType:(eSteptype)type;

@end
