//
//  HomeViewBigImageTwoDescCell.m
//  KidsTC
//
//  Created by Altair on 12/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeViewBigImageTwoDescCell.h"

@interface HomeViewBigImageTwoDescCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

- (void)didClickedImageView:(id)sender;

@end

@implementation HomeViewBigImageTwoDescCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedImageView:)];
    self.cellImageView.tag = 0;
    [self.cellImageView setUserInteractionEnabled:YES];
    [self.cellImageView addGestureRecognizer:gesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithCellModel:(HomeBigImageTwoDescCellModel *)model {
    HomeBigImageTwoDescItem *item = [model.cellItemsArray firstObject];
    [self.cellImageView setImageWithURL:item.imageUrl placeholderImage:PLACEHOLDERIMAGE_BIG];
    //title
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:item.title];
    NSDictionary *fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
    [labelString setAttributes:fontAttribute range:NSMakeRange(0, [labelString length])];
    if (item.textSegue) {
        //[NSNumber numberWithBool:YES], NSUnderlineStyleAttributeName
        NSDictionary *linkAttribute = [NSDictionary dictionaryWithObjectsAndKeys:item.textSegue.linkColor, NSForegroundColorAttributeName, nil];
        for (NSString *rangeString in item.textSegue.linkRangeStrings) {
            NSRange range = NSRangeFromString(rangeString);
            [labelString addAttributes:linkAttribute range:range];
        }
    }
    [self.titleLabel setAttributedText:labelString];
    [self.subTitleLabel setText:item.subTitle];
}

- (void)didClickedImageView:(id)sender {
    UIView *view = ((UITapGestureRecognizer *)sender).view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(bigImageTwoDescCell:didClickedAtIndex:)]) {
        [self.delegate bigImageTwoDescCell:self didClickedAtIndex:view.tag];
    }
}

@end
