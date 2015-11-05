//
//  UserRoleSelectViewController.m
//  KidsTC
//
//  Created by 钱烨 on 11/5/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "UserRoleSelectViewController.h"
#import "AUILinearView.h"

typedef enum {
    AgeSelectTagPrepregnancy,
    AgeSelectTagPregnancy,
    AgeSelectTagNewBirth,
    AgeSelectTagInOne,
    AgeSelectTagTwo2Three,
    AgeSelectTagFour2Six
}AgeSelectTag;

typedef enum {
    SexSelectTagBoy,
    SexSelectTagGirl
}SexSelectTag;

@interface UserRoleSelectViewController () <AUILinearViewDataSource, AUILinearViewDelegate>

@property (nonatomic, assign) AgeSelectTag ageTag;
@property (nonatomic, assign) SexSelectTag sexTag;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *ageView;
@property (weak, nonatomic) IBOutlet AUILinearView *linearView;
@property (weak, nonatomic) IBOutlet UIButton *ageSelectDoneButton;
@property (nonatomic, assign) CGFloat elementWidth;

//sex view
@property (strong, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)didClickedAgeSelectedDoneButton:(id)sender;
- (IBAction)didClickedDoneButton:(id)sender;
- (IBAction)didClickedBackButton:(id)sender;

- (void)buildFirstAndSecondView;

- (void)resetSecondView;

- (void)moveToSecondView;

- (void)backToFirstView;

- (void)finishedUserRoleSelecting;

@end

@implementation UserRoleSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"状态更改";
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[AUITheme theme].globalBGColor];
    
    [self buildFirstAndSecondView];
    [self.linearView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark AUILinearViewDataSource & AUILinearViewDelegate

- (NSInteger)numberOfCellsInAUIlinearView:(AUILinearView *)linearView {
    return AgeSelectTagFour2Six + 1;
}

- (UIView *)auilinearView:(AUILinearView *)linearView viewForCellAtIndex:(NSUInteger)index withMaxHeight:(CGFloat)height {
    CGFloat diameter = self.elementWidth;
    CGFloat hGap = (self.elementWidth - self.elementWidth / 1.5) / 2;
    if (hGap < 0) {
        self.linearView.horizontalGap = 0;
    } else {
        self.linearView.horizontalGap = 0 - hGap + 20;
    }
    if (diameter > height) {
        diameter = height;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    UIImage *image = nil;
    switch (index) {
        case AgeSelectTagPrepregnancy:
        {
            image = [[UIImage imageNamed:@"roleselect_prepregnancy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
            break;
        case AgeSelectTagPregnancy:
        {
            image = [[UIImage imageNamed:@"roleselect_pregnancy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
            break;
        case AgeSelectTagNewBirth:
        {
            image = [UIImage imageNamed:@"roleselect_newbirth"];
        }
            break;
        case AgeSelectTagInOne:
        {
            image = [UIImage imageNamed:@"roleselect_babyinone"];
        }
            break;
        case AgeSelectTagTwo2Three:
        {
            image = [UIImage imageNamed:@"roleselect_223"];
        }
            break;
        case AgeSelectTagFour2Six:
        {
            image = [UIImage imageNamed:@"roleselect_426"];
        }
            break;
        default:
            break;
    }
    [imageView setImage:image];
    
    return imageView;
}

- (void)auilinearView:(AUILinearView *)linearView didSelectedCellAtIndex:(NSUInteger)index {
    [self.ageSelectDoneButton setEnabled:YES];
    switch (index) {
        case AgeSelectTagPrepregnancy:
        {
            [self.ageSelectDoneButton setTitle:@"完成" forState:UIControlStateNormal];
        }
            break;
        case AgeSelectTagPregnancy:
        {
            [self.ageSelectDoneButton setTitle:@"完成" forState:UIControlStateNormal];
        }
            break;
        case AgeSelectTagNewBirth:
        {
            [self.ageSelectDoneButton setTitle:@"下一步" forState:UIControlStateNormal];
        }
            break;
        case AgeSelectTagInOne:
        {
            [self.ageSelectDoneButton setTitle:@"下一步" forState:UIControlStateNormal];
        }
            break;
        case AgeSelectTagTwo2Three:
        {
            [self.ageSelectDoneButton setTitle:@"下一步" forState:UIControlStateNormal];
        }
            break;
        case AgeSelectTagFour2Six:
        {
            [self.ageSelectDoneButton setTitle:@"下一步" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)auilinearView:(AUILinearView *)linearView didDeselectCellAtIndex:(NSUInteger)index {
}


- (void)auilinearViewDidScrolled:(AUILinearView *)linearView {
    [self.ageSelectDoneButton setEnabled:NO];
}

#pragma mark Private methods

- (IBAction)didClickedAgeSelectedDoneButton:(id)sender {
    self.ageTag = (AgeSelectTag)self.linearView.selectedIndex;
    if (self.ageTag == AgeSelectTagPrepregnancy || self.ageTag == AgeSelectTagPregnancy) {
        [self finishedUserRoleSelecting];
    } else {
        [self resetSecondView];
        [self moveToSecondView];
    }
}

- (IBAction)didClickedDoneButton:(id)sender {
    [self finishedUserRoleSelecting];
}

- (IBAction)didClickedBackButton:(id)sender {
    [self backToFirstView];
}

- (void)buildFirstAndSecondView {
    self.elementWidth = SCREEN_HEIGHT * 0.5 * 0.8;
    
    self.ageSelectDoneButton.layer.cornerRadius = 25;
    self.ageSelectDoneButton.layer.masksToBounds = YES;
    [self.ageSelectDoneButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.ageSelectDoneButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.ageSelectDoneButton setBackgroundColor:[AUITheme theme].buttonBGColor_Disable forState:UIControlStateDisabled];
    
    self.linearView.dataSource = self;
    self.linearView.delegate = self;
    self.linearView.selectedCellScale = 1.5;
    
    //second
    self.backButton.layer.cornerRadius = 25;
    self.backButton.layer.masksToBounds = YES;
    [self.backButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.backButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    self.doneButton.layer.cornerRadius = 25;
    self.doneButton.layer.masksToBounds = YES;
    [self.doneButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.doneButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
}

- (void)resetSecondView {
    [self.leftImageView setImage:[UIImage imageNamed:@"roleselect_newbirth"]];
    [self.rightImageView setImage:[UIImage imageNamed:@"roleselect_babyinone"]];
    
}

- (void)moveToSecondView {
    CGPoint offset = self.scrollView.contentOffset;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, offset.y) animated:YES];
}

- (void)backToFirstView {
    CGPoint offset = self.scrollView.contentOffset;
    [self.scrollView setContentOffset:CGPointMake(0, offset.y) animated:YES];
}

- (void)finishedUserRoleSelecting {
    UserRole role = UserRoleUnknown;
    if (self.ageTag == AgeSelectTagPrepregnancy || self.ageTag == AgeSelectTagPregnancy) {
        role = self.ageTag + 1;
    } else {
        role = self.ageTag + 1 + self.sexTag;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:role] forKey:UserRoleDefaultKey];
    
    __weak UserRoleSelectViewController *weakSelf = self;
    if (weakSelf.completeBlock) {
        weakSelf.completeBlock(role);
    }
}

#pragma mark Super methods

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