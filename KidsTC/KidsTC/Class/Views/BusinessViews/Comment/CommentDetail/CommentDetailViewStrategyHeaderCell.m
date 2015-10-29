//
//  CommentDetailViewStrategyHeaderCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentDetailViewStrategyHeaderCell.h"
#import "ParentingStrategyDetailModel.h"

@interface CommentDetailViewStrategyHeaderCell ()

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *cellBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeTagImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *relatedInfoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoHeight;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

- (IBAction)didClickedRelatedInfoButton:(id)sender;
- (IBAction)didClickedLikeButton:(id)sender;
- (IBAction)didClickedCommentButton:(id)sender;

@end

@implementation CommentDetailViewStrategyHeaderCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalBGColor];
    
    self.shadowView.layer.cornerRadius = 10;
    self.shadowView.layer.masksToBounds = YES;
    
    [self.cellBGView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    self.cellBGView.layer.cornerRadius = 10;
    self.cellBGView.layer.masksToBounds = YES;
    
    [self.relatedInfoButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.relatedInfoButton setBackgroundColor:[AUITheme theme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    self.relatedInfoButton.layer.cornerRadius = 10;
    self.relatedInfoButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configWithDetailCellModel:(ParentingStrategyDetailCellModel *)cellModel {
    if (cellModel) {
        //image
        self.imageHeight.constant = cellModel.ratio * (SCREEN_WIDTH - 20);
        [self.cellImageView setImageWithURL:cellModel.imageUrl];
        //content
        [self.contentLabel setText:cellModel.cellContentString];
        //time
        if ([cellModel.timeDescription length] > 0) {
            [self.timeTagImageView setHidden:NO];
            [self.timeLabel setHidden:NO];
            [self.timeLabel setText:cellModel.timeDescription];
        } else {
            [self.timeTagImageView setHidden:YES];
            [self.timeLabel setHidden:YES];
        }
        //related
        if (cellModel.relatedInfoModel && [cellModel.relatedInfoTitle length] > 0) {
            [self.relatedInfoButton setHidden:NO];
            [self.relatedInfoButton setTitle:cellModel.relatedInfoTitle forState:UIControlStateNormal];
        } else {
            [self.relatedInfoButton setHidden:NO];
        }
        if ([self.timeLabel isHidden] && [self.relatedInfoButton isHidden]) {
            self.infoHeight.constant = 0;
        } else {
            self.infoHeight.constant = 40;
        }
        //loaction
        NSString *likeTitle = @"";
        if (cellModel.commentCount > 99) {
            likeTitle = @" 99+";
        } else {
            likeTitle = [NSString stringWithFormat:@" %lu", (unsigned long)cellModel.commentCount];
        }
        [self.likeButton setTitle:likeTitle forState:UIControlStateNormal];
        //comment
        NSString *commentTitle = @"";
        if (cellModel.commentCount > 99) {
            commentTitle = @" 99+";
        } else {
            commentTitle = [NSString stringWithFormat:@" %lu", (unsigned long)cellModel.commentCount];
        }
        [self.commentButton setTitle:commentTitle forState:UIControlStateNormal];
    }
}

- (IBAction)didClickedRelatedInfoButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedRelatedInfoButtonOnCommentDetailViewStrategyHeaderCell:)]) {
        [self.delegate didClickedRelatedInfoButtonOnCommentDetailViewStrategyHeaderCell:self];
    }
}

- (IBAction)didClickedLikeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedLocationButtonOnCommentDetailViewStrategyHeaderCell:)]) {
        [self.delegate didClickedLocationButtonOnCommentDetailViewStrategyHeaderCell:self];
    }
}

- (IBAction)didClickedCommentButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCommentButtonOnCommentDetailViewStrategyHeaderCell:)]) {
        [self.delegate didClickedCommentButtonOnCommentDetailViewStrategyHeaderCell:self];
    }
}

@end
