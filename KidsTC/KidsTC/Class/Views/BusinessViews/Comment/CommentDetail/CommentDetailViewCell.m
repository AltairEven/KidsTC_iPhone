//
//  CommentDetailViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentDetailViewCell.h"

@interface CommentDetailViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

- (IBAction)didClickedReplyButton:(id)sender;

@end

@implementation CommentDetailViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[AUITheme theme].globalBGColor];
    
    [self.replyButton setBackgroundColor:[AUITheme theme].buttonBGColor_Normal forState:UIControlStateNormal];
    self.replyButton.layer.cornerRadius = 5;
    self.replyButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(CommentReplyItemModel *)model {
    if (model) {
        //face image
        [self.cellImageView setImageWithURL:model.faceImageUrl];
        //content
        NSString *wholeString = [NSString stringWithFormat:@"%@：%@", model.userName, model.replyContent];
        NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
        NSDictionary *attribute = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:15] forKey:NSFontAttributeName];
        [labelString setAttributes:attribute range:NSMakeRange(0, [model.userName length] + 1)];
        [self.contentLabel setAttributedText:labelString];
        //time
        [self.timeLabel setText:model.timeDescription];
    }
}

- (IBAction)didClickedReplyButton:(id)sender {
}
@end
