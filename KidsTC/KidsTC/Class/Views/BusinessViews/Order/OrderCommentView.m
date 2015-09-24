//
//  OrderCommentView.m
//  KidsTC
//
//  Created by 钱烨 on 7/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderCommentView.h"
#import "RichPriceView.h"
#import "PlaceHolderTextView.h"
#import "AUIImageGridView.h"
#import "FiveStarsView.h"

#define PLACEHOLDRERTEXT (@"环境如何，宝宝玩得开心吗？您的意见对其他家长有很大帮助！")
#define MAXCOMMENTLENGTH (500)

@interface OrderCommentView () <UITableViewDataSource, UITableViewDelegate, AUIImageGridViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *commentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *starHeaderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *starCell;

//comment cell
@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;

@property (weak, nonatomic) IBOutlet PlaceHolderTextView *textField;
@property (weak, nonatomic) IBOutlet UILabel *commentLengthLabel;
@property (weak, nonatomic) IBOutlet AUIImageGridView *takePhotoView;

//star cell
//@property (weak, nonatomic) IBOutlet FiveStarsView *totalStarView;
@property (weak, nonatomic) IBOutlet FiveStarsView *environmentStarView;
@property (weak, nonatomic) IBOutlet FiveStarsView *serviceStarView;
@property (weak, nonatomic) IBOutlet FiveStarsView *qualityStarView;


@property (nonatomic, strong) UIButton *submitButton;

- (void)didClickedSubmitButton;


@end

@implementation OrderCommentView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        OrderCommentView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    UIView *footBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 40)];
    [self.submitButton setBackgroundColor:COLOR_GLOBAL_NORMAL forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:COLOR_GLOBAL_HIGHLIGHT forState:UIControlStateHighlighted];
    [self.submitButton setBackgroundColor:COLOR_GLOBAL_DISABLE forState:UIControlStateDisabled];
    [self.submitButton setTitle:@"发表评价" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(didClickedSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    [footBG addSubview:self.submitButton];
    self.tableView.tableFooterView = footBG;
    
    //text view
    [self.textField setFont:[UIFont systemFontOfSize:13]];
    [self.textField setTextColor:[UIColor darkGrayColor]];
    [self.textField setPlaceHolderFont:[UIFont systemFontOfSize:13]];
    [self.textField setPlaceHolderColor:[UIColor lightGrayColor]];
    [self.textField setPlaceHolderStr:PLACEHOLDRERTEXT];
    [self.textField setIsPlaceHolderState:YES];
    self.textField.delegate = self;
    
    //take photo
    self.takePhotoView.delegate = self;
    [self.takePhotoView setShowAddButton:YES];
    [self.takePhotoView setMaxLimit:10];
    
    //star views
    CGSize starSize = CGSizeMake(30, 30);
    
    CGFloat tempGap = (SCREEN_WIDTH - 250) / 4;
    CGFloat starGap = tempGap;
    if (tempGap > starSize.width) {
        starGap = starSize.width;
    }
    
//    [self.totalStarView setStarSize:starSize];
//    [self.totalStarView setStarGap:starGap];
//    [self.totalStarView setEditable:YES];
    
    [self.environmentStarView setStarSize:starSize];
    [self.environmentStarView setStarGap:starGap];
    [self.environmentStarView setEditable:YES];
    
    [self.serviceStarView setStarSize:starSize];
    [self.serviceStarView setStarGap:starGap];
    [self.serviceStarView setEditable:YES];
    
    [self.qualityStarView setStarSize:starSize];
    [self.qualityStarView setStarGap:starGap];
    [self.qualityStarView setEditable:YES];
}

- (OrderCommentModel *)commentModel {
    if (![self.textField.text isEqualToString:PLACEHOLDRERTEXT]) {
        _commentModel.commentText = self.textField.text;
    } else {
        _commentModel.commentText = nil;
    }
    _commentModel.environmentStarNumber = [self.environmentStarView starNumber];
    _commentModel.serviceStarNumber = [self.serviceStarView starNumber];
    _commentModel.qualityStarNumber = [self.qualityStarView starNumber];
    return _commentModel;
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (section) {
        case 0:
        {
            number = 1;
        }
            break;
        case 1:
        {
            number = 2;
        }
            break;
        default:
            break;
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:{
            [self.serviceImageView setImageWithURL:self.commentModel.imageUrl placeholderImage:PLACEHOLDERIMAGE_SMALL];
            [self.serviceNameLabel setText:self.commentModel.objectName];
            if ([self.commentModel.commentText length] > 0) {
                [self.textField setText:self.commentModel.commentText];
            }
            cell = self.commentCell;
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                cell = self.starHeaderCell;
            } else {
                [self.environmentStarView setStarNumber:self.commentModel.environmentStarNumber];
                [self.serviceStarView setStarNumber:self.commentModel.serviceStarNumber];
                [self.qualityStarView setStarNumber:self.commentModel.qualityStarNumber];
//                [self.totalStarView setStarNumber:self.commentModel.totalStarNumber];
                cell = self.starCell;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
        {
            height = 220 + [self.takePhotoView viewHeight];
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                height = self.starHeaderCell.frame.size.height;
            } else {
                height = self.starCell.frame.size.height;
            }
        }
            break;
        default:
            break;
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section > 0) {
        height = 2.5;
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self endEditing];
}


#pragma mark AUITakePhotoViewDelegate

- (void)didClickedAddButtonOnImageGridView:(AUIImageGridView *)view {
    [self endEditing];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedAddPhotoButtonOnOrderCommentView:)]) {
        [self.delegate didClickedAddPhotoButtonOnOrderCommentView:self];
    }
}

- (void)imageGridView:(AUIImageGridView *)view didClickedImageAtIndex:(NSUInteger)index {
    [self endEditing];
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCommentView:didClickedThumbImageAtIndex:)]) {
        [self.delegate orderCommentView:self didClickedThumbImageAtIndex:index];
    }
}


#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.textField.isPlaceHolderState)
    {
        [self.textField setText:@""];
        [self.textField setIsPlaceHolderState:NO];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text length] > 0) {
        [self.textField setIsPlaceHolderState:NO];
    } else {
        [self.textField setIsPlaceHolderState:YES];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger number = [text length];
    if (number > MAXCOMMENTLENGTH) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字数不能大于500" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:MAXCOMMENTLENGTH];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > MAXCOMMENTLENGTH) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字数不能大于500" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:MAXCOMMENTLENGTH];
        number = MAXCOMMENTLENGTH;
    }
    self.commentLengthLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
}

#pragma mark Private methods

- (void)didClickedSubmitButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSubmitButtonOnOrderCommentView:)]) {
        [self.delegate didClickedSubmitButtonOnOrderCommentView:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    if (self.commentModel) {
        [self.tableView reloadData];
    }
}

- (void)resetPhotoViewWithImagesArray:(NSArray *)imagesArray {
    [self.takePhotoView setImagesArray:imagesArray];
    [self.tableView reloadData];
}

- (void)endEditing {
    [self.textField resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
