//
//  OrderRefundView.m
//  KidsTC
//
//  Created by Altair on 11/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "OrderRefundView.h"
#import "RichPriceView.h"
#import "PlaceHolderTextView.h"

#define MAXREASONLENGTH (200)

@interface OrderRefundView () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet RichPriceView *refundAmountView;
@property (weak, nonatomic) IBOutlet UILabel *backPointNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *reasonButton;
@property (weak, nonatomic) IBOutlet PlaceHolderTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) OrderRefundModel *refundModel;

- (IBAction)didClickedReasonButton:(id)sender;
- (IBAction)didClickedSubmitButton:(id)sender;

@end

@implementation OrderRefundView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        OrderRefundView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self.refundAmountView setContentColor:[AUITheme theme].globalThemeColor];
    [self.refundAmountView.unitLabel setFont:[UIFont systemFontOfSize:16]];
    [self.refundAmountView.priceLabel setFont:[UIFont systemFontOfSize:20]];
    
    [self.backPointNumberLabel setTextColor:[AUITheme theme].globalThemeColor];
    
    self.reasonButton.layer.cornerRadius = 3;
    self.reasonButton.layer.masksToBounds = YES;
    self.reasonButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.reasonButton.layer.borderWidth = BORDER_WIDTH;
    
    self.descriptionTextView.layer.cornerRadius = 3;
    self.descriptionTextView.layer.masksToBounds = YES;
    self.descriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.descriptionTextView.layer.borderWidth = BORDER_WIDTH;
    [self.descriptionTextView setPlaceHolderColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5]];
    [self.descriptionTextView setPlaceHolderStr:@"请详细说明退款原因"];
    self.descriptionTextView.delegate = self;
    
    [self.submitButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
}


#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.descriptionTextView.isPlaceHolderState)
    {
        [self.descriptionTextView setText:@""];
        [self.descriptionTextView setIsPlaceHolderState:NO];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text length] > 0) {
        [self.descriptionTextView setIsPlaceHolderState:NO];
    } else {
        [self.descriptionTextView setIsPlaceHolderState:YES];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger number = [text length];
    if (number > MAXREASONLENGTH) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字数不能大于500" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:MAXREASONLENGTH];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > MAXREASONLENGTH) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字数不能大于500" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:MAXREASONLENGTH];
        number = MAXREASONLENGTH;
    }
    self.characterCountLabel.text = [NSString stringWithFormat:@"%ld/%d",(long)number, MAXREASONLENGTH];
}

#pragma mark Private methods

- (IBAction)didClickedReasonButton:(id)sender {
    [self endEditing:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedReasonButtonOnOrderRefundView:)]) {
        [self.delegate didClickedReasonButtonOnOrderRefundView:self];
    }
}

- (IBAction)didClickedSubmitButton:(id)sender {
    [self endEditing:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSubmitButtonOnOrderRefundView:)]) {
        [self.delegate didClickedSubmitButtonOnOrderRefundView:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(refundModelForOrderRefundView:)]) {
        self.refundModel = [self.dataSource refundModelForOrderRefundView:self];
    }
    if (self.refundModel) {
        [self.refundAmountView setPrice:self.refundModel.refundAmount];
        [self.backPointNumberLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.refundModel.backPointNumber]];
        if (self.refundModel.selectedReasonItem) {
            [self.reasonButton setTitle:self.refundModel.selectedReasonItem.reasonName forState:UIControlStateNormal];
        } else {
            [self.reasonButton setTitle:@"退款原因" forState:UIControlStateNormal];
        }
        if ([self.refundModel.refundDescription length] > 0) {
            [self.descriptionTextView setIsPlaceHolderState:NO];
            [self.descriptionTextView setText:self.refundModel.refundDescription];
        } else {
            [self.descriptionTextView setText:@""];
            [self.descriptionTextView setIsPlaceHolderState:YES];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
