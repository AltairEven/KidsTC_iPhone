//
//  KTCAnnotationTipDestinationView.m
//  KidsTC
//
//  Created by 钱烨 on 8/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCAnnotationTipDestinationView.h"

@interface KTCAnnotationTipDestinationView ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)didClickedConfirmButton:(id)sender;

@end

@implementation KTCAnnotationTipDestinationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"KTCAnnotationTipDestinationView" owner:self options: nil];
        if(arrayOfViews.count < 1) {
            return nil;
        }
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[KTCAnnotationTipDestinationView class]]){
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
        KTCAnnotationTipDestinationView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self.confirmButton setTitleColor:[AUITheme theme].globalThemeColor forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didClickedConfirmButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedConfirmButtonOnAnnotationTipDestinationView:)]) {
        [self.delegate didClickedConfirmButtonOnAnnotationTipDestinationView:self];
    }
}

- (void)setContentText:(NSString *)text {
    CGFloat height = [GConfig heightForLabelWithWidth:self.frame.size.width - 6 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 andText:text];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 100, height + 35)];
    
    [self.descriptionLabel setText:text];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)setConfirmText:(NSString *)text {
    [self.confirmButton setTitle:text forState:UIControlStateNormal];
}

@end
