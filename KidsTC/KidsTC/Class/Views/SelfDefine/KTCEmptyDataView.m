//
//  KTCEmptyDataView.m
//  KidsTC
//
//  Created by Altair on 12/5/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCEmptyDataView.h"

@interface KTCEmptyDataView ()

@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) NSString *descriptionString;

@property (nonatomic, strong) UIImage *image;

- (void)buildSubView;

@end

@implementation KTCEmptyDataView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img description:(NSString *)des {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.descriptionString = des;
        if (!img) {
            img = [[KTCUser currentUser].userRole emptyTableBGImage];
        }
        self.image = img;
        [self buildSubView];
    }
    return self;
}

- (void)buildSubView {
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.imageView setCenter:CGPointMake(viewWidth / 2, viewHeight / 2 - 50)];
    [self.imageView setImage:self.image];
    [self addSubview:self.imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.frame.origin.y + self.imageView.frame.size.height + 10, viewWidth, 20)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setText:self.descriptionString];
    [self addSubview:label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
