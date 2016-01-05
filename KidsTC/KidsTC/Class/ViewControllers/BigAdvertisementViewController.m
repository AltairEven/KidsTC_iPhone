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

@property (nonatomic, strong) NSArray *adItems;

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, assign) NSUInteger maxCountDownTime;

@property (nonatomic, strong) ATCountDown *countDownTimer;

@property (nonatomic, assign) NSUInteger currentIndex;

- (void)handleTimeCountDownWithLeftTime:(NSTimeInterval)timeInterval;

- (void)handleTimeCountDownCompletionWithSegueModel:(HomeSegueModel *)model;

- (IBAction)didClickedSkipButton:(id)sender;

- (void)didTappedOnAdvertisementImage:(id)sender;

@end

@implementation BigAdvertisementViewController

- (instancetype)initWithAdvertisementItems:(NSArray<KTCAdvertisementItem *> *)adItems {
    if (!adItems || ![adItems isKindOfClass:[NSArray class]]) {
        return nil;
    }
    self = [self initWithNibName:@"BigAdvertisementViewController" bundle:nil];
    if (self) {
        self.adItems = adItems;
        NSUInteger count = [adItems count];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (KTCAdvertisementItem *item in adItems) {
            [tempArray addObject:item.image];
        }
        self.imagesArray = [NSArray arrayWithArray:tempArray];
        self.maxCountDownTime = count * SingleImageDisplayingTime;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnAdvertisementImage:)];
    [self.imageView addGestureRecognizer:tap];
    self.countDownTimer = [[ATCountDown alloc] initWithLeftTimeInterval:self.maxCountDownTime];
    
    self.skipButton.layer.cornerRadius = 10;
    self.skipButton.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak BigAdvertisementViewController *weakSelf = self;
    [weakSelf.countDownTimer startCountDownWithCurrentTimeLeft:^(NSTimeInterval currentTimeLeft) {
        [weakSelf handleTimeCountDownWithLeftTime:currentTimeLeft];
    } completion:^{
        [weakSelf handleTimeCountDownCompletionWithSegueModel:nil];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [self.countDownTimer stopCountDown];
    self.countDownTimer = nil;
}


- (void)handleTimeCountDownWithLeftTime:(NSTimeInterval)timeInterval {
    NSTimeInterval left = [self.imagesArray count] * SingleImageDisplayingTime - timeInterval;
    self.currentIndex = left / SingleImageDisplayingTime;
    [self.imageView setImage:[self.imagesArray objectAtIndex:self.currentIndex]];
}

- (void)handleTimeCountDownCompletionWithSegueModel:(HomeSegueModel *)model {
    [self.countDownTimer stopCountDown];
    __weak BigAdvertisementViewController *weakSelf = self;
    if (weakSelf.completionBlock) {
        weakSelf.completionBlock(model);
    }
}

- (IBAction)didClickedSkipButton:(id)sender {
    [self handleTimeCountDownCompletionWithSegueModel:nil];
}

- (void)didTappedOnAdvertisementImage:(id)sender {
    if (self.currentIndex < [self.adItems count]) {
        KTCAdvertisementItem *item = [self.adItems objectAtIndex:self.currentIndex];
        if (item.segueModel) {
            [self handleTimeCountDownCompletionWithSegueModel:item.segueModel];
        }
    }
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
