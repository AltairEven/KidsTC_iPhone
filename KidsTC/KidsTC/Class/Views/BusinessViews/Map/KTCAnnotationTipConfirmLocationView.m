//
//  KTCAnnotationTipConfirmLocationView.m
//  KidsTC
//
//  Created by 钱烨 on 8/27/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCAnnotationTipConfirmLocationView.h"

@interface KTCAnnotationTipConfirmLocationView ()

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)didClickedCancelButton:(id)sender;
- (IBAction)didClickedConfirmButton:(id)sender;

@end

@implementation KTCAnnotationTipConfirmLocationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"KTCAnnotationTipConfirmLocationView" owner:self options: nil];
        if(arrayOfViews.count < 1) {
            return nil;
        }
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[KTCAnnotationTipConfirmLocationView class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        KTCAnnotationTipConfirmLocationView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self.cancelButton setTitleColor:[[KTCThemeManager manager] currentTheme].globalThemeColor forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[[KTCThemeManager manager] currentTheme].globalThemeColor forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didClickedCancelButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCancelButtonOnAnnotationTipConfirmView:)]) {
        [self.delegate didClickedCancelButtonOnAnnotationTipConfirmView:self];
    }
}

- (IBAction)didClickedConfirmButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedConfirmButtonOnAnnotationTipConfirmView:)]) {
        [self.delegate didClickedConfirmButtonOnAnnotationTipConfirmView:self];
    }
}


- (void)setConfirmText:(NSString *)text {
    [self.confirmButton setTitle:text forState:UIControlStateNormal];
}

- (void)setCancelText:(NSString *)text {
    [self.cancelButton setTitle:text forState:UIControlStateNormal];
}

@end
