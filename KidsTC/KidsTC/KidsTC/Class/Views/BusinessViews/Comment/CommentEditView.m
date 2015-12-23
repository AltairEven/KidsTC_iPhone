//
//  CommentEditView.m
//  KidsTC
//
//  Created by Altair on 12/2/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentEditView.h"
#import "RichPriceView.h"
#import "PlaceHolderTextView.h"
#import "AUIImageGridView.h"
#import "FiveStarsView.h"

#define PLACEHOLDRERTEXT (@"环境如何，宝宝玩得开心吗？您的意见对其他家长有很大帮助！")
#define MAXCOMMENTLENGTH (500)

@interface CommentEditView () <UITableViewDataSource, UITableViewDelegate, AUIImageGridViewDelegate, UITextViewDelegate, FiveStarsViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *commentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *starHeaderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *starCell;

//comment cell
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;

@property (weak, nonatomic) IBOutlet PlaceHolderTextView *textField;
@property (weak, nonatomic) IBOutlet UILabel *commentLengthLabel;
@property (weak, nonatomic) IBOutlet AUIImageGridView *takePhotoView;

@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) NSArray<CommentScoreItem *> *scoreItems;

- (void)configScoreCell;

- (void)didClickedSubmitButton;

@end

@implementation CommentEditView
@synthesize commentModel = _commentModel;

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        CommentEditView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[AUITheme theme].globalBGColor];
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
    [self.submitButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    [self.submitButton setBackgroundColor:[AUITheme theme].buttonBGColor_Disable forState:UIControlStateDisabled];
    [self.submitButton setTitle:@"提交评价" forState:UIControlStateNormal];
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
    [self.takePhotoView resetBeforeLayoutWithWidth:SCREEN_WIDTH - 20];
    [self.takePhotoView setShowAddButton:YES];
    [self.takePhotoView setMaxLimit:10];
}


- (void)setCommentModel:(CommentEditingModel *)commentModel {
    _commentModel = commentModel;
    [self reloadData];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.scoreItems count] > 0) {
        return 2;
    }
    return 1;
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
            [self.serviceNameLabel setText:self.commentModel.objectName];
            if ([self.commentModel.commentText length] > 0) {
                [self.textField setIsPlaceHolderState:NO];
                [self.textField setText:self.commentModel.commentText];
                self.commentLengthLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.commentModel.commentText length]];

            } else {
                [self.textField setText:@""];
                [self.textField setIsPlaceHolderState:YES];
            }
            [self.takePhotoView setImageOrUrlStringsCombinedArray:self.commentModel.combinedImagesArray];
            [self.commentCell.contentView updateConstraintsIfNeeded];
            [self.commentCell.contentView layoutIfNeeded];
            cell = self.commentCell;
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                cell = self.starHeaderCell;
            } else {
                [self configScoreCell];
                cell = self.starCell;
            }
        }
            break;
        default:
            break;
    }
    [cell.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
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
            height = 150;
            [self.takePhotoView setHidden:YES];
            if ([self.commentModel showPhotoGrid]) {
                height += [self.takePhotoView viewHeight] + 10;
                [self.takePhotoView setHidden:NO];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                height = self.starHeaderCell.frame.size.height;
            } else {
                height = [self.scoreItems count] * 40;
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedAddPhotoButtonOnCommentEditView:)]) {
        [self.delegate didClickedAddPhotoButtonOnCommentEditView:self];
    }
}

- (void)imageGridView:(AUIImageGridView *)view didClickedImageAtIndex:(NSUInteger)index {
    [self endEditing];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentEditView:didClickedThumbImageAtIndex:)]) {
        [self.delegate commentEditView:self didClickedThumbImageAtIndex:index];
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
        self.commentModel.commentText = self.textField.text;
    } else {
        [self.textField setIsPlaceHolderState:YES];
        self.commentModel.commentText = nil;
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

#pragma mark FiveStarsViewDelegate

- (void)fiveStarsView:(FiveStarsView *)starsView didChangedStarNumberFromValue:(CGFloat)fromVal toValue:(CGFloat)toVal {
    for (NSUInteger index = 0; index < [self.scoreItems count]; index ++) {
        if (index == starsView.tag) {
            CommentScoreItem *item = [self.scoreItems objectAtIndex:index];
            [item setScore:toVal];
        }
    }
}

#pragma mark Private methods

- (void)configScoreCell {
    for (UIView *subView in self.starCell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat xPosition = 0;
    CGFloat yPosition = 0;
    CGFloat singleWidth = SCREEN_WIDTH;
    CGFloat singleHeight = 40;
    
    for (NSUInteger index = 0; index < [self.scoreItems count]; index ++) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(xPosition, yPosition, singleWidth, singleHeight)];
        [bgView setBackgroundColor:[UIColor clearColor]];
        
        CommentScoreItem *item = [self.scoreItems objectAtIndex:index];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:13]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:item.title];
        [bgView addSubview:titleLabel];
        
        CGSize starSize = CGSizeMake(30, 30);
        CGFloat tempGap = (singleWidth - 70 - (starSize.width * 5)) / 6;
        CGFloat starGap = tempGap;
        if (tempGap > starSize.width) {
            starGap = starSize.width;
        }
        FiveStarsView *starsView = [[FiveStarsView alloc] initWithFrame:CGRectMake(70 + starGap, 5, starSize.width, starSize.height)];
        [starsView setStarSize:starSize];
        [starsView setStarGap:starGap];
        [starsView setEditable:YES];
        [starsView setStarNumber:item.score];
        starsView.tag = index;
        starsView.delegate = self;
        [bgView addSubview:starsView];
        [starsView setCenter:CGPointMake(starsView.center.x, titleLabel.center.y)];
        
        [self.starCell.contentView addSubview:bgView];
        
        yPosition += singleHeight;
    }
}

- (void)didClickedSubmitButton {
    [self endEditing];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSubmitButtonOnCommentEditView:)]) {
        [self.delegate didClickedSubmitButtonOnCommentEditView:self];
    }
}

#pragma mark Public methods

- (void)reloadData {
    self.scoreItems = [self.commentModel.scoreConfigModel allShowingScoreItems];
    [self.tableView reloadData];
}

- (void)resetPhotoViewWithImagesArray:(NSArray *)imagesArray {
    [self.takePhotoView setImageOrUrlStringsCombinedArray:imagesArray];
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
