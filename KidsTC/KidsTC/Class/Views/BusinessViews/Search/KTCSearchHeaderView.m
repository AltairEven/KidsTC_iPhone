//
//  KTCSearchHeaderView.m
//  KidsTC
//
//  Created by 钱烨 on 7/20/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchHeaderView.h"

@interface KTCSearchHeaderView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchFieldBG;
@property (strong, nonatomic) UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *separator;

- (void)didClickedCategoryButton;
- (IBAction)didClickedCancelButton:(id)sender;

@end

@implementation KTCSearchHeaderView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        KTCSearchHeaderView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.backgroundColor = [[KTCThemeManager manager] defaultTheme].navibarBGColor;
    
    [self.searchFieldBG.layer setCornerRadius:5];
    [self.searchFieldBG.layer setMasksToBounds:YES];
    
    self.categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.categoryButton setFrame:CGRectMake(0, 0, 60, 30)];
    [self.categoryButton setBackgroundColor:[UIColor clearColor]];
    [self.categoryButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.categoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.categoryButton addTarget:self action:@selector(didClickedCategoryButton) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryButton setTitle:@"服务" forState:UIControlStateNormal];
    
    [self.textField setLeftView:self.categoryButton];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [self.textField setReturnKeyType:UIReturnKeySearch];
    [self.textField setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Highlight];
    [self.textField setTextColor:[UIColor whiteColor]];
    self.textField.delegate = self;
    [GConfig resetLineView:self.separator withLayoutAttribute:NSLayoutAttributeHeight];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)didClickedCategoryButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCategoryButtonOnKTCSearchHeaderView:)]) {
        [self.delegate didClickedCategoryButtonOnKTCSearchHeaderView:self];
    }
}

- (IBAction)didClickedCancelButton:(id)sender {
    [self.textField resignFirstResponder];
    [self.textField setText:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCancelButtonOnKTCSearchHeaderView:)]) {
        [self.delegate didClickedCancelButtonOnKTCSearchHeaderView:self];
    }
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartEditingOnKTCSearchHeaderView:)]) {
        [self.delegate didStartEditingOnKTCSearchHeaderView:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSearchButtonOnKTCSearchHeaderView:)]) {
        [self.delegate didClickedSearchButtonOnKTCSearchHeaderView:self];
    }
    return NO;
}

#pragma mark Public methods

- (void)startEditing {
    [self.textField becomeFirstResponder];
}

- (void)endEditing {
    [self.textField resignFirstResponder];
}

- (void)setCategoryName:(NSString *)categoryName withPlaceholder:(NSString *)placeholder {
    [self.categoryButton setTitle:categoryName forState:UIControlStateNormal];
    if ([placeholder length] == 0) {
        placeholder = @"请输入关键字";
    }
    [self.textField setPlaceholder:placeholder];
}

- (NSString *)keywords {
    return self.textField.text;
}

- (void)setInputFiledContent:(NSString *)content isPlaceHolder:(BOOL)isPlaceHolder {
    if (isPlaceHolder) {
        [self.textField setPlaceholder:content];
    } else {
        [self.textField setText:content];
    }
}

@end
