//
//  CommentDetailViewNormalHeaderCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentDetailViewNormalHeaderCell.h"
#import "FiveStarsView.h"

@interface CommentDetailViewNormalHeaderCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end

@implementation CommentDetailViewNormalHeaderCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(CommentListItemModel *)model {
    if (model) {
        [self.faceImageView setImageWithURL:model.faceImageUrl];
        [self.userNameLabel setText:model.userName];
        [self.userLevelLabel setText:model.userLevelDescription];
        [self.starsView setStarNumber:model.starNumber];
        [self.contentLabel setText:model.comments];
        [self.timeLabel setText:model.commentTime];
        [self.likeButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)model.likeNumber] forState:UIControlStateNormal];
        [self.commentButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)model.replyNumber] forState:UIControlStateNormal];
    }
}

@end
