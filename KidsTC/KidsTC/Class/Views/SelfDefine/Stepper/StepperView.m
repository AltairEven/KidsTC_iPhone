/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：StepperView.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2012年09月25日
 */

#import "StepperView.h"

#define STEPPER_BTN_WIDTH       37
#define STEPPER_TEXT_WIDTH      56
#define STEPPER_WIDTH           (STEPPER_BTN_WIDTH*2+STEPPER_TEXT_WIDTH)
#define STEPPER_HEIGHT          37

@implementation StepperView

@synthesize valStep, curVal;

- (void)internalInit
{
    self.bounds = CGRectMake(0, 0, STEPPER_WIDTH, STEPPER_HEIGHT);
    
    _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subBtn.frame = CGRectMake(0.0f, 0.0f, STEPPER_BTN_WIDTH, STEPPER_HEIGHT);
//    [_subBtn setImage:[UIImage imageNamed:@"stepper_sub"] forState:UIControlStateNormal];
//    [_subBtn setImage:[UIImage imageNamed:@"stepper_sub_press"] forState:UIControlStateHighlighted];
//    [_subBtn setImage:[UIImage imageNamed:@"stepper_sub_disable"] forState:UIControlStateDisabled];
    [_subBtn addTarget:self action:@selector(sub) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_subBtn];
	
//    _inputFieldBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stepper_text"]];
//    _inputFieldBg.frame = CGRectMake(STEPPER_BTN_WIDTH, 0, STEPPER_TEXT_WIDTH, STEPPER_HEIGHT);
//    [self addSubview:_inputFieldBg];
    
    _inputField = [[UITextField alloc] initWithFrame:CGRectMake(STEPPER_BTN_WIDTH, 0, STEPPER_TEXT_WIDTH, STEPPER_HEIGHT)];
    [_inputField setBackgroundColor:[UIColor clearColor]];
    _inputField.textAlignment = NSTextAlignmentCenter;
    _inputField.keyboardType = UIKeyboardTypeNumberPad;
    _inputField.delegate = self;
    _inputField.text = @"0";
    _inputField.borderStyle = UITextBorderStyleNone;
    _inputField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self addSubview:_inputField];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(STEPPER_BTN_WIDTH+STEPPER_TEXT_WIDTH, 0.0f, STEPPER_BTN_WIDTH, STEPPER_HEIGHT);
//    [_addBtn setImage:[UIImage imageNamed:@"stepper_add"] forState:UIControlStateNormal];
//    [_addBtn setImage:[UIImage imageNamed:@"stepper_add_press"] forState:UIControlStateHighlighted];
//    [_addBtn setImage:[UIImage imageNamed:@"stepper_add_disable"] forState:UIControlStateDisabled];
    [_addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    
    //add by Altair, 20150320
    [_subBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_subBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_subBtn.layer setBorderWidth:BORDER_WIDTH];
    [_subBtn.layer setBorderColor:CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){0.48,0.56, 0.64, 0.5})];
    [_subBtn setBackgroundImage:[UIImage imageNamed:@"detail_stepper_sub_normal"] forState:UIControlStateNormal];
    [_subBtn setBackgroundImage:[UIImage imageNamed:@"detail_stepper_sub_highlight"] forState:UIControlStateHighlighted];
    [_subBtn setBackgroundImage:[UIImage imageNamed:@"detail_stepper_sub_highlight"] forState:UIControlStateSelected];
    [_subBtn setBackgroundImage:[UIImage imageNamed:@"detail_stepper_sub_disable"] forState:UIControlStateDisabled];
    
//    [_inputField.layer setBorderWidth:BORDER_WIDTH];
//    [_inputField.layer setBorderColor:CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){0.48,0.56, 0.64, 0.5})];
//    [_inputField setTextColor:[UIColor colorWithRed:1.0 green:0.47 blue:0.0 alpha:1]];
    [_inputField setBackground:[UIImage imageNamed:@"detail_stepper_line"]];
    
    [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_addBtn.layer setBorderWidth:BORDER_WIDTH];
    [_addBtn.layer setBorderColor:CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){0.48,0.56, 0.64, 0.5})];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"detail_stepper_add_normal"] forState:UIControlStateNormal];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"detail_stepper_add_highlight"] forState:UIControlStateHighlighted];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"detail_stepper_add_highlight"] forState:UIControlStateSelected];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"detail_stepper_add_disable"] forState:UIControlStateDisabled];
    //////////////////////////////////////////////

    _enableLimit = NO;
	_enabledChange = NO;
    _minVal = 0;
    _maxVal = 100;
    valStep = 1;
	self.enabledInput = YES;
    [self checkBtnStatus];
    
    self.hitThreshold = CGSizeZero;
}

- (void)setEnabledInput:(BOOL)enabledInput
{
	_enabledInput = enabledInput;
    _inputField.enabled = _enabledInput;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (void)setHitThreshold:(CGSize)hitThreshold
{
    if (hitThreshold.width >= 0 && hitThreshold.height >= 0) {
        _hitThreshold = hitThreshold;
        [self updateHitThreshold];
    }
}

- (void)updateHitThreshold
{
    self.bounds = CGRectMake(0, 0, STEPPER_WIDTH+2*_hitThreshold.width, STEPPER_HEIGHT+2*_hitThreshold.height);
    
    _subBtn.frame = CGRectMake(_hitThreshold.width, _hitThreshold.height, STEPPER_BTN_WIDTH, STEPPER_HEIGHT);

    //_inputFieldBg.frame = CGRectMake(CGRectGetMaxX(_subBtn.frame), _hitThreshold.height, STEPPER_TEXT_WIDTH, STEPPER_HEIGHT);
    _inputField.frame = CGRectMake(CGRectGetMaxX(_subBtn.frame), _hitThreshold.height, STEPPER_TEXT_WIDTH, STEPPER_HEIGHT);

    _addBtn.frame = CGRectMake(CGRectGetMaxX(_inputField.frame), _hitThreshold.height, STEPPER_BTN_WIDTH, STEPPER_HEIGHT);
}

- (BOOL)resignFirstResponder
{
    [_inputField resignFirstResponder];
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
	[_inputField becomeFirstResponder];
	return [super becomeFirstResponder];
}

- (void)checkBtnStatus
{
	//LOG_METHOD

    if (_enableLimit) {
        if (curVal >= _maxVal) {
            curVal = _maxVal;
            _addBtn.enabled = NO;
        } else
		{
            _addBtn.enabled = YES;
        }
        
        if (curVal <= _minVal)
		{
            curVal = _minVal;
            _subBtn.enabled = NO;
        }
		else
		{
            _subBtn.enabled = YES;
        }
    } else {
        _addBtn.enabled = YES;
        _subBtn.enabled = YES;
    }
}


- (void)sub
{
    [self setCurVal:[self curVal] - valStep];
    if (_stepperDelegate) {
        [_stepperDelegate stepperView:self valueChanged:curVal byType:eSteptypeSub];
    }
}

- (void)add
{
    [self setCurVal:[self curVal] + valStep];
    if (_stepperDelegate) {
        [_stepperDelegate stepperView:self valueChanged:curVal byType:eSteptypeAdd];
    }
}

- (void) setMaxVal:(NSInteger)maxVal andMinVal:(NSInteger)minVal
{
    if (maxVal < minVal) {
        minVal = maxVal;
    }
    
    _maxVal = maxVal;
    _minVal = minVal;
    _enableLimit = YES;
    
    NSInteger cal = [self curVal];
    if (cal < _minVal) {
        [self setCurVal:_minVal];
    } else if (cal > _maxVal) {
        [self setCurVal:_maxVal];
    } else {
       [self checkBtnStatus]; 
    }
}

- (UITextField*)getTextField
{
	return _inputField;
}

- (NSInteger)curVal
{
    return [_inputField.text intValue];
}

- (void)setCurVal:(NSInteger)curVal_
{
	if(self.enabledChange)
	{
		curVal = curVal_;
		_inputField.text = [NSString stringWithFormat:@"%ld", (long)curVal];
		return;
	}
    curVal = _enableLimit ? MAX(MIN(curVal_, _maxVal), _minVal) : curVal_;
    _inputField.text = [NSString stringWithFormat:@"%ld", (long)curVal];
    [self checkBtnStatus];
}

- (void) enableInput:(BOOL)isEnable
{
    _inputField.enabled = isEnable;
}


#pragma mark - UITextFieldDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_stepperDelegate && [_stepperDelegate respondsToSelector:@selector(didStartEditWithKeyboardOnStepperView:)]) {
        [_stepperDelegate didStartEditWithKeyboardOnStepperView:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range  withString:string];
	
	if([toBeString intValue] > 99)
	{
		textField.text = @"99";
		return NO;
	}
//	else if([toBeString intValue] <= 0)
//	{
//		textField.text = @"1";
//		return NO;
//	}
	else
	{
		return YES;
	}	
//    if ((string.length == 0 || [string isEqualToString:@"0"] || [string intValue] > 0)
//		&&
//		(([[textField text] intValue]*10 + [string intValue]) <= 99)
//		)
//	{
//        return YES;
//    }
//	else if(([[textField text] intValue]*10 + [string intValue]) > 99)
//	{
//	    textField.text = @"99";
//		return NO;
//	}
//    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_inputField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setCurVal:[textField.text intValue]];
    if (_stepperDelegate) {
        id<StepperDelegate> retainDelegate = _stepperDelegate;
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [retainDelegate stepperView:self valueChanged:curVal byType:eSteptypeEdit];
        });
        
        if ([_stepperDelegate respondsToSelector:@selector(didStartEditWithKeyboardOnStepperView:)]) {
            [_stepperDelegate didEndEditWithKeyboardOnStepperView:self];
        }
        //NSLog(@"stepper value changed");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIButton*)addButton
{
	return _addBtn;
}
- (UIButton*)subButton
{
	return _subBtn;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isHidden) {
        return [super hitTest:point withEvent:event];
    }
    
	CGRect rectSub = _subBtn.frame;
    CGRect rectEdit = _inputField.frame;
	CGRect rectAdd = _addBtn.frame;
    
    if (!CGSizeEqualToSize(_hitThreshold, CGSizeZero))
    {
        rectSub.origin.x = rectSub.origin.y = 0;
        rectSub.size.width += _hitThreshold.width;
        rectSub.size.height += _hitThreshold.height +2;
        
        rectEdit.origin.x = CGRectGetMaxX(rectSub);
        rectEdit.origin.y = 0;
        rectEdit.size.height = rectSub.size.height;
        
        rectAdd.origin.x = CGRectGetMaxX(rectEdit);
        rectAdd.origin.y = 0;
        rectAdd.size.width += _hitThreshold.width;
        rectAdd.size.height = rectSub.size.height;
    }
    
	if (CGRectContainsPoint(rectAdd, point))
	{
		return _addBtn;
	}
    else if (CGRectContainsPoint(rectSub, point))
    {
		return _subBtn;
    }
    else if (CGRectContainsPoint(rectEdit, point))
    {
		return _inputField;
    }
    return [super hitTest:point withEvent:event];
}


- (CGSize)size {
    CGSize size = CGSizeMake(STEPPER_WIDTH, STEPPER_HEIGHT);
    return size;
}

@end
