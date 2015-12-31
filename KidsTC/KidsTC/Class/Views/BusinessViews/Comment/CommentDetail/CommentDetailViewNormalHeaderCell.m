//
//  CommentDetailViewNormalHeaderCell.m
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentDetailViewNormalHeaderCell.h"
#import "FiveStarsView.h"
#import "UIImage+GImageExtension.h"

@interface CommentDetailViewNormalHeaderCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (weak, nonatomic) IBOutlet FiveStarsView *starsView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *photosView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (nonatomic, strong) NSMutableArray *photoImageViews;
@property (nonatomic, strong) NSArray<NSString *> *photoUrlStrings;
@property (nonatomic, assign) CGFloat totalPhotoHeight;

@property (nonatomic, assign) CGSize photoViewSize;
@property (nonatomic, assign) CGFloat cellHeight;

- (void)buildPhotosViewWithPhotoUrlStrings:(NSArray<NSString *> *)urlStrings;

@end

@implementation CommentDetailViewNormalHeaderCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(CommentListItemModel *)model {
    self.cellHeight = self.frame.size.height;
    if (model) {
        [self.faceImageView setImageWithURL:model.faceImageUrl];
        [self.userNameLabel setText:model.userName];
        [self.userLevelLabel setText:model.userLevelDescription];
        [self.starsView setStarNumber:model.starNumber];
        [self.contentLabel setText:model.comments];
        [self buildPhotosViewWithPhotoUrlStrings:model.originalPhotoUrlStringsArray];
        [self.timeLabel setText:model.commentTime];
        [self.commentButton setTitle:[NSString stringWithFormat:@" %lu", (unsigned long)model.replyNumber] forState:UIControlStateNormal];
    }
}

- (void)buildPhotosViewWithPhotoUrlStrings:(NSArray<NSString *> *)urlStrings {
    if (![urlStrings isKindOfClass:[NSArray class]] || [urlStrings count] == 0) {
        return;
    }
    
    
    BOOL sameDataSource = [self.photoUrlStrings isEqualToArray:urlStrings];
    
    for (UIView *subview in self.photosView.subviews) {
        [subview removeFromSuperview];
    }
    if (!self.photoImageViews) {
        self.photoImageViews = [[NSMutableArray alloc] init];
    } else if (!sameDataSource) {
        [self.photoImageViews removeAllObjects];
        self.totalPhotoHeight = 0;
    }
    self.photoUrlStrings = urlStrings;
    
    CGFloat yPosition = 0;
    CGFloat vMargin = 5;
    
    if (sameDataSource) {
        //相同的数据，防止重复刷新
        for (NSUInteger index = 0; index < [self.photoImageViews count]; index ++) {
            UIImageView *imageView = [self.photoImageViews objectAtIndex:index];
            CGFloat height = imageView.image.size.height;
            [imageView setFrame:CGRectMake(imageView.frame.origin.x, yPosition, imageView.frame.size.width, height)];
            yPosition += height + vMargin;
            [self.photosView addSubview:imageView];
        }
    } else {
        //不同的数据
        CGFloat xPosition = 0;
        CGFloat viewWidth = SCREEN_WIDTH - 20;
        CGFloat viewStandardHeight = viewWidth;
        
        CGFloat defaultHeight = viewStandardHeight * [urlStrings count] + vMargin * (([urlStrings count] - 1));
        _photoViewSize = CGSizeMake(viewWidth, defaultHeight);
        
        for (NSString *string in urlStrings) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, viewWidth, viewStandardHeight)];
            [self.photosView addSubview:imageView];
            [self.photoImageViews addObject:imageView];
            yPosition += viewStandardHeight + vMargin;
            
            __weak UIImageView *weakView = imageView;
            //异步加载图片
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
            [imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder_400_400"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                //原始图片
                CGSize originalSize = [image size];
                if (viewStandardHeight != originalSize.height) {
                    //裁剪图片
                    CGFloat needHeight = originalSize.height / originalSize.width * viewWidth;
                    image = [image imageByScalingProportionallyToSize:CGSizeMake(viewWidth, needHeight)];
                }
                [weakView setImage:image];
                //更新高度
                CGFloat freshHeight = [image size].height + vMargin;
                self.totalPhotoHeight += freshHeight;
                self.photoViewHeight.constant = freshHeight;
                self.photoViewSize = CGSizeMake(viewWidth, self.totalPhotoHeight);
            } failure:nil];
        }
    }
}

- (void)setPhotoViewSize:(CGSize)photoViewSize {
    self.cellHeight -= _photoViewSize.height;
    self.cellHeight += photoViewSize.height;
    _photoViewSize = photoViewSize;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerCell:didChangedBoundsWithNewHeight:)]) {
        [self.delegate headerCell:self didChangedBoundsWithNewHeight:self.cellHeight];
    }
}

@end
