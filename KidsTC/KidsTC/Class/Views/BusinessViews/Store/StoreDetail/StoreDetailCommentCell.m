//
//  StoreDetailCommentCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/26/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "StoreDetailCommentCell.h"
#import "FiveStarsView.h"
#import "AUIImageGridView.h"

@interface StoreDetailCommentCell () <AUIImageGridViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet AUIImageGridView *imageGridView;

@end

@implementation StoreDetailCommentCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalCellBGColor];
    
    self.imageGridView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(CommentListItemModel *)model {
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    if (model) {
        [self.faceImageView setImageWithURL:model.faceImageUrl];
        [self.nameLabel setText:model.userName];
        [self.starsView setStarNumber:model.starNumber];
        [self.contentLabel setText:model.comments];
        [self.imageGridView setImageUrlStringsArray:model.thumbnailPhotoUrlStringsArray];
    }
}


#pragma mark SaiDanPhotoViewDelegate

- (void)imageGridView:(AUIImageGridView *)view didClickedImageAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeDetailCommentCell:didClickedImageAtIndex:)]) {
        [self.delegate storeDetailCommentCell:self didClickedImageAtIndex:index];
    }
}

@end
