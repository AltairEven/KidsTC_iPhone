//
//  ParentingStrategyDetailViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyDetailViewCell.h"
#import "ParentingStrategyDetailModel.h"
#import "TTTAttributedLabel.h"

@interface ParentingStrategyDetailViewCell () <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *cellBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeTagImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *relatedInfoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoHeight;
@property (weak, nonatomic) IBOutlet UIView *locationAlphaView;
@property (weak, nonatomic) IBOutlet UIView *commentAlphaView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

- (IBAction)didClickedRelatedInfoButton:(id)sender;
- (IBAction)didClickedLocationButton:(id)sender;
- (IBAction)didClickedCommentButton:(id)sender;

@end

@implementation ParentingStrategyDetailViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    
    self.shadowView.layer.cornerRadius = 10;
    self.shadowView.layer.masksToBounds = YES;
    
    [self.cellBGView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    self.cellBGView.layer.cornerRadius = 10;
    self.cellBGView.layer.masksToBounds = YES;
    
    [self.relatedInfoButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal forState:UIControlStateNormal];
    [self.relatedInfoButton setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
    self.relatedInfoButton.layer.cornerRadius = 10;
    self.relatedInfoButton.layer.masksToBounds = YES;
    
    self.contentLabel.delegate = self;
    self.contentLabel.lineSpacing = 10;
    [self.contentLabel setLinkAttributes:nil];
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
        NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:cellModel.cellContentString];
        NSDictionary *fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
        [labelString setAttributes:fontAttribute range:NSMakeRange(0, [labelString length])];
        if (cellModel.contentSegueModels) {
            for (TextSegueModel *model in cellModel.contentSegueModels) {
                //[NSNumber numberWithBool:YES], NSUnderlineStyleAttributeName
                NSDictionary *linkAttribute = [NSDictionary dictionaryWithObjectsAndKeys:model.linkColor, NSForegroundColorAttributeName, nil];
                for (NSString *rangeString in model.linkRangeStrings) {
                    NSRange range = NSRangeFromString(rangeString);
                    [labelString addAttributes:linkAttribute range:range];
                    [self.contentLabel addLinkToAddress:[NSDictionary dictionaryWithObject:model forKey:@"promotionSegueModel"] withRange:range];
                }
            }
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:AttributeStringLineSpace];//调整行间距
        [labelString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelString length])];
        [self.contentLabel setText:labelString];
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
            [self.relatedInfoButton setHidden:YES];
        }
        if ([self.timeLabel isHidden] && [self.relatedInfoButton isHidden]) {
            self.infoHeight.constant = 0;
        } else {
            self.infoHeight.constant = 40;
        }
        //loaction
        if (cellModel.location) {
            [self.locationAlphaView setHidden:NO];
            [self.locationButton setHidden:NO];
        } else {
            [self.locationAlphaView setHidden:YES];
            [self.locationButton setHidden:YES];
        }
        //comment
        NSString *commentTitle = @"";
        if (cellModel.commentCount > 99) {
            commentTitle = @" 99+";
        } else if (cellModel.commentCount > 0) {
            commentTitle = [NSString stringWithFormat:@" %lu", (unsigned long)cellModel.commentCount];
        }
        [self.commentButton setTitle:commentTitle forState:UIControlStateNormal];
    }
}

- (IBAction)didClickedRelatedInfoButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedRelatedInfoButtonOnParentingStrategyDetailViewCell:)]) {
        [self.delegate didClickedRelatedInfoButtonOnParentingStrategyDetailViewCell:self];
    }
}

- (IBAction)didClickedLocationButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedLocationButtonOnParentingStrategyDetailViewCell:)]) {
        [self.delegate didClickedLocationButtonOnParentingStrategyDetailViewCell:self];
    }
}

- (IBAction)didClickedCommentButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedCommentButtonOnParentingStrategyDetailViewCell:)]) {
        [self.delegate didClickedCommentButtonOnParentingStrategyDetailViewCell:self];
    }
}

#pragma mark TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    if (self.delegate && [self.delegate respondsToSelector:@selector(parentingStrategyDetailViewCell:didSelectedLinkWithSegueModel:)]) {
        TextSegueModel *model = [addressComponents objectForKey:@"promotionSegueModel"];
        [self.delegate parentingStrategyDetailViewCell:self didSelectedLinkWithSegueModel:model.segueModel];
    }
}


@end
