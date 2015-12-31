//
//  CommentListViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CommentListViewCell.h"
#import "FiveStarsView.h"
#import "AUIImageGridView.h"

@interface CommentListViewCell () <AUIImageGridViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet AUIImageGridView *imageGridView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end

@implementation CommentListViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imageGridView.delegate = self;
    [self.imageGridView resetBeforeLayoutWithWidth:SCREEN_WIDTH - 20];
    [self.bgView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItemModel:(CommentListItemModel *)model {
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    if (model) {
        [self.faceImageView setImageWithURL:model.faceImageUrl];
        [self.userNameLabel setText:model.userName];
        [self.userLevelLabel setText:model.userLevelDescription];
        [self.starsView setStarNumber:model.starNumber];
        [self.contentLabel setText:model.comments];
        [self.imageGridView setImageUrlStringsArray:model.thumbnailPhotoUrlStringsArray];
        [self.timeLabel setText:model.commentTime];
        NSString *replyNum = @"";
        if (model.replyNumber > 0) {
            replyNum = [NSString stringWithFormat:@" %lu", (unsigned long)model.replyNumber];
        }
        [self.commentButton setTitle:replyNum forState:UIControlStateNormal];
    }
}


#pragma mark SaiDanPhotoViewDelegate

- (void)imageGridView:(AUIImageGridView *)view didClickedImageAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListViewCell:didClickedImageAtIndex:)]) {
        [self.delegate commentListViewCell:self didClickedImageAtIndex:index];
    }
}

@end
