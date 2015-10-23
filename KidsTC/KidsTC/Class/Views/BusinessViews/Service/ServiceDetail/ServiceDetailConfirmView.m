//
//  ServiceDetailConfirmView.m
//  KidsTC
//
//  Created by 钱烨 on 7/30/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailConfirmView.h"
#import "StepperView.h"
#import "ServiceDetailConfirmViewCell.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface ServiceDetailConfirmView () <UITableViewDataSource, UITableViewDelegate, StepperDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *tapArea;
@property (strong, nonatomic) IBOutlet UIView *infoBGView;

@property (strong, nonatomic) IBOutlet StepperView *stepperView;
@property (strong, nonatomic) IBOutlet UILabel *stockNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedStoreNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) NSUInteger selectedIndex;

- (IBAction)didClickedSubmitButton:(id)sender;

@end

@implementation ServiceDetailConfirmView

#pragma mark Initialization

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ServiceDetailConfirmView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        [self buildSubviews];
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
        ServiceDetailConfirmView *view = [GConfig getObjectFromNibWithView:self];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    NSArray *constraintsArray = [self.infoBGView constraints];
    for (NSLayoutConstraint *constraint in constraintsArray) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = SCREEN_HEIGHT * 0.7;
            break;
        }
    }
    
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    if (!self.cellNib) {
        self.cellNib = [UINib nibWithNibName:NSStringFromClass([ServiceDetailConfirmViewCell class]) bundle:nil];
        [self.tableView registerNib:self.cellNib forCellReuseIdentifier:kCellIdentifier];
    }
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.tapArea addGestureRecognizer:self.tapGesture];
    [self.tapArea setHidden:YES];
    
    [self.stepperView enableInput:NO];
    self.stepperView.stepperDelegate = self;
    [self.infoBGView setBackgroundColor:[AUITheme theme].globalBGColor];
}

- (void)setStockNumber:(NSUInteger)stockNumber {
    _stockNumber = stockNumber;
    [self.stockNumberLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)stockNumber]];
    [self.stepperView setMaxVal:stockNumber andMinVal:1];
}

- (void)setStoreItemsArray:(NSArray *)storeItemsArray {
    _storeItemsArray = [NSArray arrayWithArray:storeItemsArray];
    [self.tableView reloadData];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.storeItemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceDetailConfirmViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"ServiceDetailConfirmViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    StoreListItemModel *item = [self.storeItemsArray objectAtIndex:indexPath.row];
    [cell setStoreName:item.storeName];
    [cell setStarNumber:item.starNumber];
    [cell setDistance:item.distanceDescription];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.storeItemsArray count] > 0) {
        StoreListItemModel *item = [self.storeItemsArray objectAtIndex:indexPath.row];
        [self.selectedStoreNameLabel setText:item.storeName];
        self.selectedIndex = indexPath.row;
    }
}

#pragma mark StepperViewDelegate

- (void)stepperView:(StepperView *)stepper valueChanged:(NSInteger)val byType:(eSteptype)type {
    [self.priceLabel setText:[NSString stringWithFormat:@"%g元", self.unitPrice * [self.stepperView curVal]]];    
}

#pragma mark Private methods


- (void)doShowAnimationInView:(UIView *)view {
    self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    __weak ServiceDetailConfirmView *weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setFrame:CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height)];
    } completion:^(BOOL finished) {
        [weakSelf.tapArea setHidden:NO];
    }];
}

- (void)doDismissAnimation {
    __weak ServiceDetailConfirmView *weakSelf = self;
    [weakSelf.tapArea setHidden:YES];
    //animation
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setFrame:CGRectMake(0, weakSelf.frame.size.height, weakSelf.frame.size.width, weakSelf.frame.size.height)];
    } completion:^(BOOL finished) {
        //send to back
        [weakSelf.superview sendSubviewToBack:weakSelf];
        [weakSelf removeFromSuperview];
    }];
}

- (IBAction)didClickedSubmitButton:(id)sender {
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSubmitButtonWithBuyNumber:selectedStore:)]) {
        [self.delegate didClickedSubmitButtonWithBuyNumber:self.stepperView.curVal selectedStore:[self.storeItemsArray objectAtIndex:self.selectedIndex]];
    }
}

#pragma mark Public methods

- (void)setMinBuyCount:(NSUInteger)min maxBuyCount:(NSUInteger)max {
    [self.stepperView setMaxVal:max andMinVal:min];
}

- (void)show {
    [self.priceLabel setText:[NSString stringWithFormat:@"%g元", self.unitPrice * [self.stepperView curVal]]];
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self setFrame:appDelegate.window.frame];
    [self layoutIfNeeded];
    [appDelegate.window addSubview:self];
    [appDelegate.window bringSubviewToFront:self];
    [self doShowAnimationInView:appDelegate.window];
}

- (void)dismiss {
    [self doDismissAnimation];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

