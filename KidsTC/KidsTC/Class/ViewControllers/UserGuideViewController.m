//
//  UserGuideViewController.m
//  KidsTC
//
//  Created by Altair on 2/19/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "UserGuideViewController.h"

#define kHasDisplayedHomeGuideKey   @"kHasDisplayedHomeGuideKey"
#define kHasDisplayedUserCenterGuideKey   @"kHasDisplayedUserCenterGuideKey"

//若有改动，则修改这个值，从1开始递增
#define HomeGuideValue (1)
#define UserCenterGuideValue (1)

@interface UserGuideViewController ()

@property (nonatomic, assign) UserGuideViewTag viewTag;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (BOOL)needDisplayGuideForTag:(UserGuideViewTag)tag;

- (void)setHasDisplayedGuideForTag:(UserGuideViewTag)tag;

- (void)loadGuideInfoForTag:(UserGuideViewTag)tag;

- (void)didTappedOnView:(id)sender;

@end

@implementation UserGuideViewController

- (instancetype)initWithViewTag:(UserGuideViewTag)tag {
    self = [super initWithNibName:@"UserGuideViewController" bundle:nil];
    if (self) {
        if (![self needDisplayGuideForTag:tag]) {
            return nil;
        }
        self.viewTag = tag;
    }
    return self;
}

+ (instancetype)instancetypeWithViewTag:(UserGuideViewTag)tag {
    UserGuideViewController *controller = [[UserGuideViewController alloc] initWithViewTag:tag];
    if (controller) {
        controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnView:)];
    [self.view addGestureRecognizer:tap];
    [self loadGuideInfoForTag:self.viewTag];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view.superview setBackgroundColor:[UIColor clearColor]];
}

#pragma mark Private methods

- (BOOL)needDisplayGuideForTag:(UserGuideViewTag)tag {
    BOOL need = YES;
    NSInteger value = 0;
    switch (tag) {
        case UserGuideViewTagHome:
        {
            value = [[[NSUserDefaults standardUserDefaults] objectForKey:kHasDisplayedHomeGuideKey] integerValue];
            if (value == HomeGuideValue) {
                need = NO;
            }
        }
            break;
        case UserGuideViewTagUserCenter:
        {
            value = [[[NSUserDefaults standardUserDefaults] objectForKey:kHasDisplayedUserCenterGuideKey] integerValue];
            if (value == UserCenterGuideValue) {
                need = NO;
            }
        }
            break;
        default:
            break;
    }
    return need;
}


- (void)setHasDisplayedGuideForTag:(UserGuideViewTag)tag {
    switch (tag) {
        case UserGuideViewTagHome:
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:HomeGuideValue] forKey:kHasDisplayedHomeGuideKey];
        }
            break;
        case UserGuideViewTagUserCenter:
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:UserCenterGuideValue] forKey:kHasDisplayedUserCenterGuideKey];
        }
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadGuideInfoForTag:(UserGuideViewTag)tag {
    switch (tag) {
        case UserGuideViewTagHome:
        {
            UIImage *image = [UIImage imageNamed:@"guide_home"];
            [self.imageView setImage:image];
        }
            break;
        case UserGuideViewTagUserCenter:
        {
            UIImage *image = [UIImage imageNamed:@"guide_home"];
            [self.imageView setImage:image];
        }
            break;
        default:
            break;
    }
}

- (void)didTappedOnView:(id)sender {
    [self dismiss];
}

#pragma mark Public methods

- (void)showFromViewController:(UIViewController *)controller {
    if (controller && [controller isKindOfClass:[UIViewController class]]) {
        [controller presentViewController:self animated:NO completion:nil];
    }
    [self setHasDisplayedGuideForTag:self.viewTag];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
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
