//
//  BigAdvertisementViewController.m
//  KidsTC
//
//  Created by Altair on 12/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BigAdvertisementViewController.h"

#define SingleImageDisplayingTime (3)

@interface BigAdvertisementViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, assign) NSUInteger maxCountDownTime;

@property (nonatomic, strong) ATCountDown *countDownTimer;

- (void)handleTimeCountDownWithLeftTime:(NSTimeInterval)timeInterval;

- (void)handleTimeCountDownCompletion;

- (IBAction)didClickedSkipButton:(id)sender;

@end

@implementation BigAdvertisementViewController

- (instancetype)initWithImages:(NSArray<UIImage *> *)images {
    if (!images || ![images isKindOfClass:[NSArray class]]) {
        return nil;
    }
    self = [self initWithNibName:@"BigAdvertisementViewController" bundle:nil];
    if (self) {
        self.imagesArray = images;
        self.maxCountDownTime = [images count] * SingleImageDisplayingTime;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView setAnimationImages:self.imagesArray];
    [self.imageView setAnimationDuration:self.maxCountDownTime];
    self.countDownTimer = [[ATCountDown alloc] initWithLeftTimeInterval:self.maxCountDownTime];
    
    self.skipButton.layer.cornerRadius = 10;
    self.skipButton.layer.masksToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.imageView startAnimating];
    __weak BigAdvertisementViewController *weakSelf = self;
    [weakSelf.countDownTimer startCountDownWithCurrentTimeLeft:^(NSTimeInterval currentTimeLeft) {
        [weakSelf handleTimeCountDownWithLeftTime:currentTimeLeft];
    } completion:^{
        [weakSelf handleTimeCountDownCompletion];
    }];
}

- (void)dealloc {
    [self.countDownTimer stopCountDown];
    self.countDownTimer = nil;
}


- (void)handleTimeCountDownWithLeftTime:(NSTimeInterval)timeInterval {
    
}

- (void)handleTimeCountDownCompletion {
    __weak BigAdvertisementViewController *weakSelf = self;
    if (weakSelf.completionBlock) {
        weakSelf.completionBlock();
    }
}

- (IBAction)didClickedSkipButton:(id)sender {
    [self handleTimeCountDownCompletion];
}

- (void)didReceiveMemoryWarning {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
