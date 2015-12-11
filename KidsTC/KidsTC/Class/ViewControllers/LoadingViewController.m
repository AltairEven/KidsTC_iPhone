//
//  LoadingViewController.m
//  KidsTC
//
//  Created by 钱烨 on 8/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "LoadingViewController.h"
#import "HomeViewModel.h"

static NSUInteger leftTime = 2;

@interface LoadingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *logoView;

- (void)loadImages;

- (void)startLoadingAnimation;

- (void)endAnimation;

@end

@implementation LoadingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeViewDidFinishLoading) name:kHomeViewDataFinishLoadingNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadImages];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startLoadingAnimation];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHomeViewDataFinishLoadingNotification object:nil];
}


- (void)loadImages {
    NSUInteger width = SCREEN_WIDTH * 2;
    NSUInteger height = SCREEN_HEIGHT * 2;
    //bg
    NSString *bgName = [NSString stringWithFormat:@"loadingBg_%lu_%lu", (unsigned long)width, (unsigned long)height];
    UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:bgName ofType:@"png"]];
    [self.bgImageView setImage:bgImage];
    
    //logo
    NSString *logoName = [NSString stringWithFormat:@"logo_%lu_%lu", (unsigned long)width, (unsigned long)height];
    UIImage *logoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:logoName ofType:@"png"]];
    self.logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logoImage.size.width / 2, logoImage.size.height / 2)];
    [self.logoView setImage:logoImage];
    [self.bgImageView addSubview:self.logoView];
    
    //logo position
    CGFloat centerYPosition = 0;
    switch (height) {
        case 960:
        {
            centerYPosition = 250;
        }
            break;
        case 1136:
        {
            centerYPosition = 350;
        }
            break;
        case 1334:
        {
            centerYPosition = 400;
        }
            break;
        case 1472:
        {
            centerYPosition = 400;
        }
            break;
        default:
            break;
    }
    CGPoint centerPoint = CGPointMake(width / 4, centerYPosition / 2);
    [self.logoView setCenter:centerPoint];
}

- (void)startLoadingAnimation {
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear| UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        CATransform3D rotate = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        self.logoView.layer.transform = rotate;
    } completion:^(BOOL finished) {
    }];
}


- (void)endAnimation {
    __weak LoadingViewController *weakSelf = self;
    if (weakSelf.load_complete) {
        weakSelf.load_complete();
    }
}

#pragma mark HomeViewControllerDelegate

- (void)homeViewDidFinishLoading {
    [NSTimer scheduledTimerWithTimeInterval:leftTime target:self selector:@selector(endAnimation) userInfo:nil repeats:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
