//
//  MyCommentListViewCell.m
//  KidsTC
//
//  Created by Altair on 12/1/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "MyCommentListViewCell.h"
#import "FiveStarsView.h"
#import "AUIImageGridView.h"

#define BorderColor (RGBA(196, 179, 157, 1))

@interface MyCommentListViewCell () <AUIImageGridViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
//header
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIView *headerBGView;
@property (weak, nonatomic) IBOutlet UILabel *timeDesLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
//content
@property (weak, nonatomic) IBOutlet UIView *contentBGView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *gapView;
@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet AUIImageGridView *imageGridView;

@property (weak, nonatomic) IBOutlet UIView *separaterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapConstraint;

- (void)drawTriangleForHeader;
- (IBAction)didClickedEditButton:(id)sender;
- (IBAction)didClickedDeleteButton:(id)sender;

@end

@implementation MyCommentListViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.bgView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    [self.headerBGView setBackgroundColor:[AUITheme theme].globalBGColor];
    [self drawTriangleForHeader];
    [self.separaterView setBackgroundColor:BorderColor];
    [GConfig resetLineView:self.separaterView withLayoutAttribute:NSLayoutAttributeHeight];
    [self.imageGridView setOneLineCount:4];
    self.imageGridView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark AUIImageGridViewDelegate

- (void)imageGridView:(AUIImageGridView *)view didClickedImageAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myCommentListViewCell:didClickedImageAtIndex:)]) {
        [self.delegate myCommentListViewCell:self didClickedImageAtIndex:index];
    }
}

#pragma mark Private methods

- (void)drawTriangleForHeader {
    CGFloat width = 10;
    CGFloat height = 5;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 40)];
    [bezierPath addLineToPoint:CGPointMake(15, 40)];
    [bezierPath addLineToPoint:CGPointMake(15 + width / 2, 40 - height)];
    [bezierPath addLineToPoint:CGPointMake(15 + width, 40)];
    [bezierPath addLineToPoint:CGPointMake(SCREEN_WIDTH, 40)];
    
    //    [bezierPath closePath];
    //边框蒙版
    CAShapeLayer *maskBorderLayer = [CAShapeLayer layer];
    //    [maskBorderLayer setFrame:CGRectMake(0, 0, width, height)];
    maskBorderLayer.path = [bezierPath CGPath];
    maskBorderLayer.fillColor = [AUITheme theme].globalCellBGColor.CGColor;
    maskBorderLayer.strokeColor = BorderColor.CGColor;//边框颜色
    maskBorderLayer.lineWidth = BORDER_WIDTH; //边框宽度
    [self.headerBGView.layer addSublayer:maskBorderLayer];
}

- (IBAction)didClickedEditButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedEditButton:)]) {
        [self.delegate didClickedEditButton:self];
    }
}

- (IBAction)didClickedDeleteButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedDeleteButton:)]) {
        [self.delegate didClickedDeleteButton:self];
    }
}

#pragma mark Public methods

- (void)configWithItemModel:(MyCommentListItemModel *)model {
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    if (model) {
        [self.typeImageView setImage:[model bizIcon]];
        [self.timeDesLabel setText:model.commentTime];
        [self.deleteButton setHidden:!model.canDelete];
        [self.editButton setHidden:!model.canEdit];
        
        [self.titleLabel setText:model.title];
        if ([model.scoreConfigModel needShowScore]) {
            [self.starsView setHidden:NO];
            [self.starsView setStarNumber:model.scoreConfigModel.totalScoreItem.score];
            self.gapConstraint.constant = 35;
        } else {
            [self.starsView setHidden:YES];
            self.gapConstraint.constant = 10;
        }
        [self.contentLabel setText:model.comments];
        [self.imageGridView setImageUrlStringsArray:model.thumbnailPhotoUrlStringsArray];
    }
}

@end
