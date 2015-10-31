//
//  AUIKeyboardAdhesiveView.m
//  KidsTC
//
//  Created by 钱烨 on 10/29/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "AUIKeyboardAdhesiveView.h"
@interface AUIKeyboardAdhesiveView ()

- (void)buildSubviews;

- (void)buildExtensionViewWithType:(AUIKeyboardAdhesiveViewExtensionFunctionType)type;

- (void)hideTextLimit:(BOOL)hidden;

- (void)keyboardWillShow:(NSNotification *)notify;

- (void)keyboardWillHide:(NSNotification *)notify;

- (void)keyboardWillChangedFrame:(NSNotification *)notify;

- (void)didClickedTextButton;

- (void)didClickedFuntionButton:(UIButton *)button;

- (void)didClickedSendButton;

@end

@implementation AUIKeyboardAdhesiveView

- (instancetype)init {
    AUIKeyboardAdhesiveViewExtensionFunction *funtion1 = [AUIKeyboardAdhesiveViewExtensionFunction funtionWithType:AUIKeyboardAdhesiveViewExtensionFunctionTypeEmotionEdit];
    AUIKeyboardAdhesiveViewExtensionFunction *funtion2 = [AUIKeyboardAdhesiveViewExtensionFunction funtionWithType:AUIKeyboardAdhesiveViewExtensionFunctionTypeImageUpload];
    
    NSArray *funtions = [NSArray arrayWithObjects:funtion1, funtion2, nil];
    return [self initWithAvailableFuntions:funtions];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self init];
}

- (void)dealloc {
    [self destroy];
}

#pragma mark Setter & Getter

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self.textView setPlaceHolderStr:placeholder];
}

- (void)setTextLimitLength:(NSUInteger)textLimitLength {
    _textLimitLength = textLimitLength;
    [self hideTextLimit:textLimitLength == INT64_MAX ? YES : NO];
}

- (void)setUploadImageLimitCount:(NSUInteger)uploadImageLimitCount {
    _uploadImageLimitCount = uploadImageLimitCount;
}

- (void)setUploadImages:(NSArray *)uploadImages {
    _uploadImages = uploadImages;
}

#pragma mark Private methods

- (void)buildSubviews {
    //header
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1]];
    [self addSubview:self.headerView];
    
    CGFloat xPosition = 10;
    CGFloat yPosition = 5;
    CGFloat width = 30;
    CGFloat height = 30;
    CGFloat gap = 20;
    
    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hideButton setFrame:CGRectMake(xPosition, yPosition, width, height)];
    [hideButton setImage:[UIImage imageNamed:@"located"] forState:UIControlStateNormal];
    [hideButton addTarget:self action:@selector(shrink) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:hideButton];
    
    xPosition = hideButton.frame.origin.x + hideButton.frame.size.width + gap;
    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [textButton setFrame:CGRectMake(xPosition, yPosition, width, height)];
    [textButton setImage:[UIImage imageNamed:@"located"] forState:UIControlStateNormal];
    [textButton addTarget:self action:@selector(didClickedTextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:textButton];
    
    BOOL needHideTextEditButton = YES;
    gap = 10;
    xPosition = textButton.frame.origin.x + textButton.frame.size.width + gap;
    for (NSUInteger index = 0; index < [self.availableExtFuntions count]; index ++) {
        AUIKeyboardAdhesiveViewExtensionFunction *function = [self.availableExtFuntions objectAtIndex:index];
        UIButton *functionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [functionButton setFrame:CGRectMake(xPosition, yPosition, width, height)];
        [functionButton setImage:function.icon forState:UIControlStateNormal];
        functionButton.tag = index;
        [functionButton addTarget:self action:@selector(didClickedFuntionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:functionButton];
        xPosition += functionButton.frame.size.width + gap;
        //有扩展，则不用隐藏文字按钮
        needHideTextEditButton = NO;
        //创建扩展视图
        [self buildExtensionViewWithType:function.type];
    }
    [textButton setHidden:needHideTextEditButton];
    
    width = 60;
    xPosition = self.headerView.frame.size.width - gap - width;
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setFrame:CGRectMake(xPosition, yPosition, width, height)];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(didClickedSendButton) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.sendButton];
    
    //text view
    CGFloat separatorHeight = 0.5;
    yPosition = self.headerView.frame.size.height;
    self.textView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(0, yPosition, self.frame.size.width, self.frame.size.height - yPosition - separatorHeight)];
    [self addSubview:self.textView];
    
    yPosition = self.frame.size.height - separatorHeight;
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, SCREEN_WIDTH, separatorHeight)];
    [separatorView setBackgroundColor:[UIColor redColor]];
    [self addSubview:separatorView];
}

- (void)buildExtensionViewWithType:(AUIKeyboardAdhesiveViewExtensionFunctionType)type {
    switch (type) {
        case AUIKeyboardAdhesiveViewExtensionFunctionTypeEmotionEdit:
        {
            self.emotionInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.2)];
            [self.emotionInputView setBackgroundColor:[UIColor blueColor]];
            
        }
            break;
        case AUIKeyboardAdhesiveViewExtensionFunctionTypeImageUpload:
        {
            
        }
            break;
        default:
            break;
    }
}


- (void)hideTextLimit:(BOOL)hidden {
    
}

- (void)keyboardWillShow:(NSNotification *)notify {
    NSDictionary *keyborardInfo = notify.userInfo;
    
    CGRect beginRect = [[keyborardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[keyborardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[keyborardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSUInteger curveInfo = [[keyborardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    self.frame = CGRectMake(0, beginRect.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:duration delay:0 options:curveInfo animations:^{
        self.frame = CGRectMake(0, endRect.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notify {
    NSDictionary *keyborardInfo = notify.userInfo;
    
    CGRect beginRect = [[keyborardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[keyborardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[keyborardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSUInteger curveInfo = [[keyborardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    self.frame = CGRectMake(0, beginRect.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:duration delay:0 options:curveInfo animations:^{
        self.frame = CGRectMake(0, endRect.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)keyboardWillChangedFrame:(NSNotification *)notify {
    
}

- (void)didClickedTextButton {
    self.textView.inputView = nil;
    [self.textView reloadInputViews];
    
    if (![self.textView isFirstResponder]) {
        [self.textView becomeFirstResponder];
    }
}

- (void)didClickedFuntionButton:(UIButton *)button {
    AUIKeyboardAdhesiveViewExtensionFunction *function = [self.availableExtFuntions objectAtIndex:button.tag];
    switch (function.type) {
        case AUIKeyboardAdhesiveViewExtensionFunctionTypeEmotionEdit:
        {
            self.textView.inputView = self.emotionInputView;
            [self.textView reloadInputViews];
        }
            break;
        case AUIKeyboardAdhesiveViewExtensionFunctionTypeImageUpload:
        {
            
        }
            break;
        default:
            break;
    }
    
    if (![self.textView isFirstResponder]) {
        [self.textView becomeFirstResponder];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardAdhesiveView:didClickedExtensionFunctionButtonWithType:)]) {
        [self.delegate keyboardAdhesiveView:self didClickedExtensionFunctionButtonWithType:function.type];
    }
}

- (void)didClickedSendButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSendButtonOnKeyboardAdhesiveView:)]) {
        [self.delegate didClickedSendButtonOnKeyboardAdhesiveView:self];
    }
}

#pragma mark Public methods

- (instancetype)initWithAvailableFuntions:(NSArray<AUIKeyboardAdhesiveViewExtensionFunction *> *)funtions {
    CGFloat height = SCREEN_HEIGHT * 0.2;
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT - self.frame.size.height, SCREEN_WIDTH, height)];
    if (self) {
        _availableExtFuntions = [funtions copy];
        
        [self buildSubviews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangedFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)expand {
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.textView becomeFirstResponder];
    [self setHidden:NO];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}

- (void)shrink {
    [self.textView resignFirstResponder];
}

- (void)destroy {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation AUIKeyboardAdhesiveViewExtensionFunction

+ (instancetype)funtionWithType:(AUIKeyboardAdhesiveViewExtensionFunctionType)type {
    AUIKeyboardAdhesiveViewExtensionFunction *funtion = [[AUIKeyboardAdhesiveViewExtensionFunction alloc] init];
    funtion.type = type;
    switch (type) {
        case AUIKeyboardAdhesiveViewExtensionFunctionTypeEmotionEdit:
        {
            funtion.functionName = @"表情";
            funtion.icon = [UIImage imageNamed:@"located"];
        }
            break;
        case AUIKeyboardAdhesiveViewExtensionFunctionTypeImageUpload:
        {
            funtion.functionName = @"图片";
            funtion.icon = [UIImage imageNamed:@"located"];
        }
            break;
        default:
            break;
    }
    return funtion;
}

@end