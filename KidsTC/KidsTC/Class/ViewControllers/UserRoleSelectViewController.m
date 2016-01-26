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

#define SCALE (1.5)

@interface UserRoleSelectViewController () <AUILinearViewDataSource, AUILinearViewDelegate>

@property (nonatomic, assign) AgeSelectTag ageTag;
@property (nonatomic, assign) SexSelectTag sexTag;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *ageView;
@property (weak, nonatomic) IBOutlet AUILinearView *linearView;
@property (weak, nonatomic) IBOutlet UIButton *ageSelectDoneButton;
@property (nonatomic, assign) CGFloat elementWidth;

@property (nonatomic, assign) UserRole selectedRole;

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

- (void)resetLinearView;

- (void)resetSecondView;

- (void)moveToSecondView;

- (void)backToFirstView;

- (void)finishedUserRoleSelecting;

- (void)didClickedSexImage:(id)sender;

- (void)selectSexWithTag:(NSUInteger)tag;

@end

@implementation UserRoleSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationTitle = @"请选择阶段";
    _pageIdentifier = @"pv_stage_switch";
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    
    [self buildFirstAndSecondView];
    [self.linearView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self resetLinearView];
}

#pragma mark AUILinearViewDataSource & AUILinearViewDelegate

- (NSInteger)numberOfCellsInAUIlinearView:(AUILinearView *)linearView {
    return AgeSelectTagFour2Six + 1;
}

- (UIView *)auilinearView:(AUILinearView *)linearView viewForCellAtIndex:(NSUInteger)index withMaxHeight:(CGFloat)height {
    CGFloat diameter = self.elementWidth;
    CGFloat hGap = (SCREEN_WIDTH - self.elementWidth * SCALE) / 2;
    if (hGap < 20) {
        self.linearView.horizontalGap = 20;
    } else {
        self.linearView.horizontalGap = hGap - 20;
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
            image = [UIImage imageNamed:@"roleselect_123"];
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

- (void)auilinearViewDidEndScroll:(AUILinearView *)linearView {
    [self.ageSelectDoneButton setEnabled:YES];
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
    self.elementWidth = SCREEN_HEIGHT * 0.6 * 0.4;
    
    self.ageSelectDoneButton.layer.cornerRadius = 25;
    self.ageSelectDoneButton.layer.masksToBounds = YES;
    [self.ageSelectDoneButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.ageSelectDoneButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.ageSelectDoneButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Disable forState:UIControlStateDisabled];
    
    self.linearView.dataSource = self;
    self.linearView.delegate = self;
    self.linearView.selectedCellScale = SCALE;
    
    //second
    self.backButton.layer.cornerRadius = 25;
    self.backButton.layer.masksToBounds = YES;
    [self.backButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.backButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    self.doneButton.layer.cornerRadius = 25;
    self.doneButton.layer.masksToBounds = YES;
    [self.doneButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.doneButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    
    [self.leftImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedSexImage:)];
    [self.leftImageView addGestureRecognizer:tap1];
    
    [self.rightImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedSexImage:)];
    [self.rightImageView addGestureRecognizer:tap2];
    
    [self selectSexWithTag:self.leftImageView.tag];
}

- (void)resetSecondView {
    switch (self.ageTag) {
        case AgeSelectTagNewBirth:
        {
            [self.leftImageView setImage:[UIImage imageNamed:@"sexselect_boy_1"]];
            [self.rightImageView setImage:[UIImage imageNamed:@"sexselect_girl_1"]];
        }
            break;
        case AgeSelectTagInOne:
        {
            [self.leftImageView setImage:[UIImage imageNamed:@"sexselect_boy_1"]];
            [self.rightImageView setImage:[UIImage imageNamed:@"sexselect_girl_1"]];
        }
            break;
        case AgeSelectTagTwo2Three:
        {
            [self.leftImageView setImage:[UIImage imageNamed:@"sexselect_boy_123"]];
            [self.rightImageView setImage:[UIImage imageNamed:@"sexselect_girl_123"]];
        }
            break;
        case AgeSelectTagFour2Six:
        {
            [self.leftImageView setImage:[UIImage imageNamed:@"sexselect_boy_426"]];
            [self.rightImageView setImage:[UIImage imageNamed:@"sexselect_girl_426"]];
        }
            break;
        default:
            break;
    }
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
    switch (self.ageTag) {
        case AgeSelectTagPrepregnancy:
        {
            role = UserRolePrepregnancy;
        }
            break;
        case AgeSelectTagPregnancy:
        {
            role = UserRolePregnancy;
        }
            break;
        case AgeSelectTagNewBirth:
        {
            role = UserRoleBirth;
        }
            break;
        case AgeSelectTagInOne:
        {
            role = UserRoleBabyInOne;
        }
            break;
        case AgeSelectTagTwo2Three:
        {
            role = UserRoleBabyOneToThree;
        }
            break;
        case AgeSelectTagFour2Six:
        {
            role = UserRoleBabyFourToSix;
        }
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:role] forKey:UserRoleDefaultKey];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.sexTag + 1] forKey:UserSexDefaultKey];
    
    __weak UserRoleSelectViewController *weakSelf = self;
    if (weakSelf.completeBlock) {
        weakSelf.completeBlock(role, weakSelf.sexTag + 1);
    }
}

- (void)didClickedSexImage:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSUInteger tag = tap.view.tag;
    [self selectSexWithTag:tag];
}

- (void)selectSexWithTag:(NSUInteger)tag {
    if (tag == self.leftImageView.tag) {
        self.sexTag = SexSelectTagBoy;
        [self.leftImageView setAlpha:1];
        [self.rightImageView setAlpha:0.3];
    } else if (tag == self.rightImageView.tag) {
        self.sexTag = SexSelectTagGirl;
        [self.leftImageView setAlpha:0.3];
        [self.rightImageView setAlpha:1];
    }
}

- (void)resetLinearView {
    NSUInteger index = 0;
    switch (self.selectedRole) {
        case UserRolePrepregnancy:
        {
            index = 0;
        }
            break;
        case UserRolePregnancy:
        {
            index = 1;
        }
            break;
        case UserRoleBirth:
        {
            index = 2;
        }
            break;
        case UserRoleBabyInOne:
        {
            index = 3;
        }
            break;
        case UserRoleBabyOneToThree:
        {
            index = 4;
        }
            break;
        case UserRoleBabyFourToSix:
        {
            index = 5;
        }
            break;
        default:
            break;
    }
    [self.linearView setSelectedIndex:index animated:YES];
}

#pragma mark Public methods

- (void)setSelectedRole:(UserRole)role {
    _selectedRole = role;
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
