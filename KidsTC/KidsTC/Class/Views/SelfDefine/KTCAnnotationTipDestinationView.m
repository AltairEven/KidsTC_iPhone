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
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    [tempLabel setBackgroundColor:RGBA(255, 255, 255, 0.7)];
    [tempLabel setTextColor:[UIColor darkGrayColor]];
    [tempLabel setFont:[UIFont systemFontOfSize:13]];
    [tempLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [tempLabel setTextAlignment:NSTextAlignmentLeft];
    [tempLabel setText:text];
    CGSize fitSize = [tempLabel sizeOfSizeToFitWithMaximumNumberOfLines:0];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, fitSize.width + 6, fitSize.height + 35)];
    
    [self.descriptionLabel setText:text];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)setConfirmText:(NSString *)text {
    [self.confirmButton setTitle:text forState:UIControlStateNormal];
}

@end
