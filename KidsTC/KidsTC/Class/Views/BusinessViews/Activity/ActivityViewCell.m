//
//  ActivityViewCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ActivityViewCell.h"
#import "RichPriceView.h"
#import "ActivityListItemModel.h"

@interface ActivityViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet RichPriceView *priceView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation ActivityViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithItemModel:(ActivityListItemModel *)itemModel {
    if (itemModel) {
        [self.mainImageView setImageWithURL:itemModel.imageUrl];
        [self.titleLabel setText:itemModel.title];
        [self.contentLabel setText:itemModel.activityContent];
        [self.priceView setPrice:itemModel.price];
        //tips
        NSString *wholeString = [NSString stringWithFormat:@"已售%f%%,剩余%lu", itemModel.percent, (unsigned long)itemModel.leftNumber];
        NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:wholeString];
        NSDictionary *attribute = [NSDictionary dictionaryWithObject:[UIColor cyanColor] forKey:NSForegroundColorAttributeName];
        NSUInteger commaIndex = [wholeString rangeOfString:@","].location;
        NSRange percentRange = NSMakeRange(2, commaIndex - 2);
        NSRange leftRange = NSMakeRange(commaIndex + 2, [wholeString length] - commaIndex - 2);
        [labelString setAttributes:attribute range:percentRange];
        [labelString addAttributes:attribute range:leftRange];
        [self.tipsLabel setAttributedText:labelString];
    }
}

@end
