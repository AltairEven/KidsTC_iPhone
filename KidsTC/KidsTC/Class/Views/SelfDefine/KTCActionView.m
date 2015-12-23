//
//  KTCActionView.m
//  KidsTC
//
//  Created by Altair on 11/18/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCActionView.h"

#define ActionHeight (40)

static KTCActionView *_sharedInstance = nil;

@interface KTCActionView ()

@property (nonatomic, strong) IBOutlet UIView *actionBGView;

@property (nonatomic, strong) IBOutlet UIButton *homeButton;

@property (nonatomic, strong) IBOutlet UIButton *searchButton;

@property (nonatomic, strong) IBOutlet UIButton *shareButton;

@property (nonatomic, strong) IBOutlet UIView *tapView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *actionBGHeight;

@property (nonatomic, assign) BOOL animationBlock;

- (void)buildSubViews;

- (IBAction)didClickedButton:(id)sender;

@end

@implementation KTCActionView

+ (instancetype)actionView {
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
        _sharedInstance = [[[NSBundle mainBundle] loadNibNamed:@"KTCActionView" owner:nil options:nil] firstObject];
        [_sharedInstance buildSubViews];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark Private methods

- (void)buildSubViews {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.tapView addGestureRecognizer:tap];
}


- (IBAction)didClickedButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionViewDidClickedWithTag:)]) {
        [self.delegate actionViewDidClickedWithTag:(KTCActionViewTag)button.tag];
    }
}


#pragma mark Public methods

- (void)showInViewController:(UIViewController *)viewController {
    if (self.animationBlock || [self isShowing]) {
        return;
    }
    self.frame = CGRectMake(0, 0 - ActionHeight, viewController.view.frame.size.width, viewController.view.frame.size.height + ActionHeight) ;
    [self setAlpha:0];
    [viewController.view addSubview:self];
    _isShowing = YES;
    
    self.animationBlock = YES;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) ;
        [self setAlpha:1];
    } completion:^(BOOL finished) {
        self.animationBlock = NO;
    }];
}

- (void)hide {
    if (self.animationBlock || ![self isShowing]) {
        return;
    }
    self.animationBlock = YES;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, 0 - ActionHeight, self.frame.size.width, self.frame.size.height) ;
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _isShowing = NO;
        self.animationBlock = NO;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
