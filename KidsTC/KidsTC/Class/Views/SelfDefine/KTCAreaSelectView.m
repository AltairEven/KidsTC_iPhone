//
//  KTCAreaSelectView.m
//  KidsTC
//
//  Created by 钱烨 on 10/12/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCAreaSelectView.h"
#import "AddressSelectTableViewCell.h"

typedef void (^ SelectionBlock) (KTCAreaItem *);

@interface KTCAreaSelectView () <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

//top
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
//header
@property (weak, nonatomic) IBOutlet UIView *headerBGView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
//table
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//tap
@property (weak, nonatomic) IBOutlet UIView *tapArea;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;

@property (nonatomic, strong) UITapGestureRecognizer *tapOnAreaGesture;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) SelectionBlock selectionBlock;

@property (nonatomic, strong) NSArray *dataArray;


- (void)buildSubviews;

- (void)didTappedOnTapArea:(id)sender;

- (void)didSwipedOnView:(id)sender;

- (IBAction)didClickBackButton:(id)sender;

- (void)setHeaderViewHidden:(BOOL)hidden;

- (void)setTapAreaViewHidden:(BOOL)hidden;

- (void)reloadData;

- (void)startLoadingActivity;

- (void)stopLoadingActivity;

@end

@implementation KTCAreaSelectView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KTCAreaSelectView" owner:nil options:nil] objectAtIndex:0];
        [self buildSubviews];
        self.selectedIndex = -1;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [self setFrame:appDelegate.window.frame];
        [self layoutIfNeeded];
        
        [appDelegate.window addSubview:self];
        
    }
    return self;
}


+ (instancetype)areaSelecteView {
    return [[KTCAreaSelectView alloc] init];;
}


//- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
//{
//    self = [super awakeAfterUsingCoder:aDecoder];
//    static BOOL bLoad;
//    if (!bLoad)
//    {
//        bLoad = YES;
//        KTCAreaSelectView *view = [GConfig getObjectFromNibWithView:self];
//        [view buildSubviews];
//        return view;
//    }
//    bLoad = NO;
//    return self;
//}


- (void)buildSubviews {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tapOnAreaGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedOnTapArea:)];
    self.tapOnAreaGesture.delegate = self;
    [self addGestureRecognizer:self.tapOnAreaGesture];
    
    
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipedOnView:)];
    [self.swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:self.swipeGesture];
}


- (void)reloadData {
    if (!self.tableView.tableHeaderView) {
        //table header
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 0.0f, self.tableView.bounds.size.width, 0.5f)];
        [self.tableView.tableHeaderView setBackgroundColor:[UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1]];
    }
    self.dataArray = [[[KTCArea area] areaItems] copy];
    [self.tableView reloadData];
    if (self.selectedIndex >= 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        KTCAgeItem *item = [self.dataArray objectAtIndex:self.selectedIndex];
        NSString *text = item.name;
        if (!text || [text length] == 0) {
            [self.headerLabel setText:@""];
            [self setHeaderViewHidden:YES];
        }
        NSString *showText = [NSString stringWithFormat:@"当前：%@", text];
        [self.headerLabel setText:showText];
        [self setHeaderViewHidden:NO];
    }
    
//    if (self.dataSource) {
//        //back image
//        if ([self.dataSource respondsToSelector:@selector(addressSelectViewShouldDispalyBackArrow)]) {
//            [self.backButton setHidden:![self.dataSource addressSelectViewShouldDispalyBackArrow]];
//        }
//        //data
////        if ([self.dataSource respondsToSelector:@selector(addressStringArrayForAddressSelectView:)]) {
////            self.dataArray = [self.dataSource addressStringArrayForAddressSelectView:self];
////        }
//        self.dataArray = [[[KTCArea area] areaItems] copy];
//        //selected
////        if ([self.dataSource respondsToSelector:@selector(selectedIndexForAddressSelectView:)]) {
////            self.selectedIndex = [self.dataSource selectedIndexForAddressSelectView:self];
////        }
//        [self.tableView reloadData];
//        if (self.selectedIndex >= 0) {
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//        }
//        if ([self.dataSource respondsToSelector:@selector(selectedAddressFullNameForAddressSelectView:)]) {
//            NSString *text = [self.dataSource selectedAddressFullNameForAddressSelectView:self];
//            if (!text || [text length] == 0) {
//                [self.headerLabel setText:@""];
//                [self setHeaderViewHidden:YES];
//            }
//            NSString *showText = [NSString stringWithFormat:@"当前：%@", text];
//            [self.headerLabel setText:showText];
//            [self setHeaderViewHidden:NO];
//        }
//    }
}


#pragma mark Gesture

- (void)didTappedOnTapArea:(id)sender {
    [self hideAddressSelectView];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didTappedOnTransparentAreaOfAddressSelectView:)]) {
//        [self.delegate didTappedOnTransparentAreaOfAddressSelectView:self];
//    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:self];
    return CGRectContainsPoint(self.tapArea.frame, touchPoint);
}


- (IBAction)didClickBackButton:(id)sender {
    [self hideAddressSelectView];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didTappedOnBackArrow)]) {
//        [self.delegate didTappedOnBackArrow];
//    }
}


- (void)didSwipedOnView:(id)sender {
    [self hideAddressSelectView];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didSwipedOnAddressSelectView:)]) {
//        [self.delegate didSwipedOnAddressSelectView:self];
//    }
}


#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray) {
        return [self.dataArray count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    
    AddressSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"AddressSelectTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    KTCAgeItem *item = [self.dataArray objectAtIndex:indexPath.row];
    [cell.contentLabel setText:item.name];
    if (self.selectedIndex == indexPath.row) {
        cell.selectedImage.hidden = NO;
        [cell.contentLabel setTextColor:[UIColor colorWithRed:4/255.0 green:113/255.0 blue:249/255.0 alpha:1]];
    } else {
        cell.selectedImage.hidden = YES;
        [cell.contentLabel setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideAddressSelectView];
    
    __weak KTCAreaSelectView *weakSelf = self;
    if (weakSelf.selectionBlock) {
        weakSelf.selectionBlock([[[KTCArea area] areaItems] objectAtIndex:indexPath.row]);
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(addressSelectView:didSelectAtIndex:)]) {
//        [self.delegate addressSelectView:self didSelectAtIndex:indexPath.row];
//    }
}



#pragma mark Loading Activity

- (void)startLoadingActivity {
    if (![self.activityIndicator isAnimating]) {
        [self.activityIndicator startAnimating];
    }
}


- (void)stopLoadingActivity {
    if ([self.activityIndicator isAnimating]) {
        [self.activityIndicator stopAnimating];
    }
}


#pragma mark Public methods

- (void)showAddressSelectViewWithCurrent:(KTCAreaItem *)currentItem Selection:(void (^)(KTCAreaItem *))selection {
    //bring to front
    [self setTapAreaViewHidden:YES];
    [self.superview bringSubviewToFront:self];
    //assign block
    self.selectionBlock = selection;
    //设置默认
    if (currentItem) {
        self.selectedIndex = [[KTCArea area] indexOfAreaItem:currentItem];
    } else {
        self.selectedIndex = -1;
    }
    //reload data
    [self reloadData];
    
    //animation
    self.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    __weak KTCAreaSelectView *weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setFrame:CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height)];
    } completion:^(BOOL finished) {
        [weakSelf setTapAreaViewHidden:NO];
    }];
}


#pragma mark Self Methods

- (void)setTapAreaViewHidden:(BOOL)hidden {
    [self.tapArea setHidden:hidden];
}

- (void)setHeaderViewHidden:(BOOL)hidden {
    CGFloat viewHeight = 30;
    if (hidden) {
        viewHeight = 0;
    }
    NSArray *headerBGViewConstraintsArray = [self.headerBGView constraints];
    for (NSLayoutConstraint *constraint in headerBGViewConstraintsArray) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            //height constraint
            //new
            constraint.constant = viewHeight;
            break;
        }
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}


- (void)hideAddressSelectView {
    
    __weak KTCAreaSelectView *weakSelf = self;
    [weakSelf setTapAreaViewHidden:YES];
    //animation
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setFrame:CGRectMake(weakSelf.frame.size.width, 0, weakSelf.frame.size.width, weakSelf.frame.size.height)];
    } completion:^(BOOL finished) {
        //send to back
        [weakSelf.superview sendSubviewToBack:weakSelf];
    }];
}

- (void)destroy {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
