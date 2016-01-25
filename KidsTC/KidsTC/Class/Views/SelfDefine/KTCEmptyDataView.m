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

@property (nonatomic, assign) BOOL needGoHome;

- (void)buildSubView;

- (void)didClickedGoHomeButton;

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


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img description:(NSString *)des needGoHome:(BOOL)bNeed {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.descriptionString = des;
        if (!img) {
            img = [[KTCUser currentUser].userRole emptyTableBGImage];
        }
        self.image = img;
        self.needGoHome = bNeed;
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
    
    if (self.needGoHome) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat rate = 0.3;
        CGFloat width = SCREEN_WIDTH * rate;
        CGFloat xPos = (SCREEN_WIDTH - width) / 2;
        CGFloat yPos = label.frame.origin.y + label.frame.size.height + 20;
        CGFloat height = 30;
        [button setFrame:CGRectMake(xPos, yPos, width, height)];
        [button setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Normal forState:UIControlStateNormal];
        [button setBackgroundColor:[[KTCThemeManager manager] defaultTheme].buttonBGColor_Highlight forState:UIControlStateHighlighted];
        [button setTitle:@"去首页看看" forState:UIControlStateNormal];
        [button setTitleColor:[[KTCThemeManager manager] defaultTheme].navibarTitleColor_Normal forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didClickedGoHomeButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = YES;
    }
}

- (void)didClickedGoHomeButton {
    [[KTCTabBarController shareTabBarController] setButtonSelected:0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedGoHomeButtonOnEmptyView:)]) {
        [self.delegate didClickedGoHomeButtonOnEmptyView:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
