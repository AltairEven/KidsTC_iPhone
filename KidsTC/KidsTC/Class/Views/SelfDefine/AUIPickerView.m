//
//  AUIPickerView.m
//  KidsTC
//
//  Created by 钱烨 on 7/16/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AUIPickerView.h"

@interface AUIPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIView *tapView;

@property (nonatomic, strong) UIPickerView *pickerView;

- (void)didClickedCancelButton:(id)sender;
- (void)didClickedConfirmButton:(id)sender;
- (void)didTapOnTapView:(id)sender;

- (void)doShowAnimationInView:(UIView *)view;

- (void)doDismissAnimation;


@end

@implementation AUIPickerView


#pragma mark Initialization

- (instancetype)initWithDataSource:(id<AUIPickerViewDataSource>)dataSource delegate:(id<AUIPickerViewDelegate>)delegate {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.dataSource = dataSource;
        self.delegate = delegate;
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
        AUIPickerView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    //tapview
    self.tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.6)];
    [self.tapView setBackgroundColor:RGBA(0, 0, 0, 0.3)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTapView:)];
    [self.tapView addGestureRecognizer:tap];
    [self.tapView setHidden:YES];
    
    //picker
    UIView *pickerBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.6, SCREEN_WIDTH, SCREEN_HEIGHT * 0.4)];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.topView setBackgroundColor:[UIColor whiteColor]];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setFrame:CGRectMake(10, 10, 40, 30)];
    [self.cancelButton setTitleColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(didClickedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setFrame:CGRectMake(SCREEN_WIDTH - 50, 10, 40, 30)];
    [self.confirmButton setTitleColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[[KTCThemeManager manager] currentTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.confirmButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(didClickedConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topView addSubview:self.cancelButton];
    [self.topView addSubview:self.confirmButton];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, pickerBG.frame.size.height - 50)];
    [self.pickerView setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalBGColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    [pickerBG addSubview:self.topView];
    [pickerBG addSubview:self.pickerView];
    
    [self addSubview:self.tapView];
    [self addSubview:pickerBG];
}

- (void)show {
    [self.pickerView reloadAllComponents];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self setFrame:appDelegate.window.frame];
    [self layoutIfNeeded];
    [appDelegate.window addSubview:self];
    [appDelegate.window bringSubviewToFront:self];
    [self doShowAnimationInView:appDelegate.window];
}

- (void)doShowAnimationInView:(UIView *)view {
    self.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, view.frame.size.height);
    __weak AUIPickerView *weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setFrame:CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height)];
    } completion:^(BOOL finished) {
        [weakSelf.tapView setHidden:NO];
    }];
}

- (void)doDismissAnimation {
    __weak AUIPickerView *weakSelf = self;
    [weakSelf.tapView setHidden:YES];
    //animation
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setFrame:CGRectMake(0, weakSelf.frame.size.height, weakSelf.frame.size.width, weakSelf.frame.size.height)];
    } completion:^(BOOL finished) {
        //send to back
        [weakSelf.superview sendSubviewToBack:weakSelf];
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark UIPickerViewDataSource & UIPickerViewDelegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger number = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        number = [self.dataSource numberOfComponentsInPickerView:self];
    }
    return number;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger number = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        number = [self.dataSource pickerView:self numberOfRowsInComponent:component];
    }
    return number;
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat width = SCREEN_WIDTH;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:widthForComponent:)]) {
        width = [self.dataSource pickerView:self widthForComponent:component];
    }
    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    CGFloat width = 40;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:rowHeightForComponent:)]) {
        width = [self.dataSource pickerView:self rowHeightForComponent:component];
    }
    return width;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
        title = [self.dataSource pickerView:self titleForRow:row forComponent:component];
    }
    return title;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSAttributedString *title = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:attributedTitleForRow:forComponent:)]) {
        title = [self.dataSource pickerView:self attributedTitleForRow:row forComponent:component];
    }
    return title;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UIView *retView = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)]) {
        retView = [self.dataSource pickerView:self viewForRow:row forComponent:component reusingView:view];
    }
    return retView;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)didClickedCancelButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCanceledPickerView:)]) {
        [self.delegate didCanceledPickerView:self];
    }
    [self doDismissAnimation];
}

- (void)didClickedConfirmButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didConfirmedWithSelectedIndexArrayOfAllComponent:)]) {
        NSInteger componentCount = [self numberOfComponentsInPickerView:self.pickerView];
        NSMutableArray *indexArray = [[NSMutableArray alloc] init];
        for (NSInteger compIndex = 0; compIndex < componentCount; compIndex ++) {
            NSInteger index = [self.pickerView selectedRowInComponent:compIndex];
            [indexArray addObject:[NSNumber numberWithInteger:index]];
        }
        [self.delegate pickerView:self didConfirmedWithSelectedIndexArrayOfAllComponent:[NSArray arrayWithArray:indexArray]];
    }
    [self doDismissAnimation];
}

- (void)didTapOnTapView:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCanceledPickerView:)]) {
        [self.delegate didCanceledPickerView:self];
    }
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
