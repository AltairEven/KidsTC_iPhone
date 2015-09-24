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

@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet AUIImageGridView *imageGridView;

@end

@implementation CommentListViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imageGridView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItemModel:(CommentListItemModel *)model {
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    if (model) {
        [self.starsView setStarNumber:model.starNumber];
        [self.commentLabel setText:model.comments];
        [self.imageGridView setImageUrlStringsArray:model.thumbnailPhotoUrlStringsArray];
    }
}


#pragma mark SaiDanPhotoViewDelegate

- (void)imageGridView:(AUIImageGridView *)view didClickedImageAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentListViewCell:didClickedImageAtIndex:)]) {
        [self.delegate commentListViewCell:self didClickedImageAtIndex:index];
    }
}

@end
