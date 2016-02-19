//
//  SettlementScoreEditViewController.m
//  KidsTC
//
//  Created by Altair on 2/16/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "SettlementScoreEditViewController.h"

@interface SettlementScoreEditViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *alertBGView;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelVGap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmVGap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHGap;

- (void)buildSubViews;

- (IBAction)didClickedCancel:(id)sender;
- (IBAction)didClickedConfirm:(id)sender;

@end

@implementation SettlementScoreEditViewController

+ (instancetype)alertInstance {
    SettlementScoreEditViewController *controller = [[SettlementScoreEditViewController alloc] initWithNibName:@"SettlementScoreEditViewController" bundle:nil];
    if (controller) {
        controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view.superview setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)setUsedScore:(NSUInteger)usedScore {
    _usedScore = usedScore;
    
    CGFloat discount = self.usedScore * ScoreCoefficient;
    [self.discountLabel setText:[NSString stringWithFormat:@"%g元", discount]];
}


#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.usedScore = 0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.usedScore = [textField.text integerValue];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *finalString = textField.text;
    BOOL canReturn = NO;
    if ([string length] == 0) {
        finalString = [finalString substringToIndex:[finalString length] - 1];
        canReturn = YES;
    } else {
        finalString = [NSString stringWithFormat:@"%@%@", finalString, string];
    }
    NSInteger score = [finalString integerValue];
    if (score < 0) {
        [textField setText:@"0"];
        self.usedScore = 0;
        return NO;
    } else if (score > self.totalScore) {
        [textField setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.totalScore]];
        self.usedScore = self.totalScore;
        return NO;
    } else if (score == 0 && !canReturn) {
        self.usedScore = 0;
        return NO;
    }
    self.usedScore = score;
    return YES;
}

#pragma mark Private methods

- (void)buildSubViews {
    self.cancelVGap.constant = BORDER_WIDTH;
    self.confirmVGap.constant = BORDER_WIDTH;
    self.buttonHGap.constant = BORDER_WIDTH;
    
    self.alertBGView.layer.cornerRadius = 10;
    self.alertBGView.layer.masksToBounds = YES;
    
    NSString *usedScoreString = [NSString stringWithFormat:@"%lu", (unsigned long)self.usedScore];
    [self.inputField setText:usedScoreString];
    self.inputField.delegate = self;
    
    NSString *scoreCountString = [NSString stringWithFormat:@"%lu", (unsigned long)self.totalScore];
    NSString *wholeString = [NSString stringWithFormat:@"您本次最多可使用%@积分", scoreCountString];
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
    NSDictionary *attribute = [NSDictionary dictionaryWithObject:[[KTCThemeManager manager] defaultTheme].globalThemeColor forKey:NSForegroundColorAttributeName];
    [labelString setAttributes:attribute range:NSMakeRange(8, [scoreCountString length])];
    [self.availableScoreLabel setAttributedText:labelString];
    
    CGFloat discount = self.usedScore * ScoreCoefficient;
    [self.discountLabel setText:[NSString stringWithFormat:@"%g元", discount]];
}

- (IBAction)didClickedCancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)didClickedConfirm:(id)sender {
    if (self.dismissBlock) {
        __weak SettlementScoreEditViewController *weakSelf = self;
        weakSelf.dismissBlock(weakSelf.usedScore);
    }
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
