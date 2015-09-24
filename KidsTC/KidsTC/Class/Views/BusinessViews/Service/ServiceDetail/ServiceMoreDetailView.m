//
//  ServiceMoreDetailView.m
//  KidsTC
//
//  Created by 钱烨 on 7/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceMoreDetailView.h"
#import "AUIStairsController.h"


#define PULL_THRESHOLD (80)

@interface ServiceMoreDetailView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)headerViewDidPulled:(UIScrollView *)sender;

@end

@implementation ServiceMoreDetailView


#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        ServiceMoreDetailView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    self.webView.scrollView.delegate = self;
}


#pragma mark Public methods

- (void)setSupportStairsController:(BOOL)supportStairsController {
    _supportStairsController = supportStairsController;
    
    if (supportStairsController) {
        //header
        UIView *headerBG1 = [[UIView alloc] initWithFrame:CGRectMake(0, -200, SCREEN_WIDTH, 200)];
        UILabel *headerLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 15)];
        [headerLabel1 setTextColor:[UIColor lightGrayColor]];
        [headerLabel1 setFont:[UIFont systemFontOfSize:13]];
        [headerLabel1 setTextAlignment:NSTextAlignmentCenter];
        [headerLabel1 setText:@"下拉返回上一页"];
        [headerBG1 addSubview:headerLabel1];
        
        [self.webView.scrollView addSubview:headerBG1];
    } else {
        self.stairsController.delegate = nil;
    }
}


- (void)setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    [self.webView stopLoading];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat threshold = 0 - PULL_THRESHOLD;
    if (decelerate && (scrollView.contentOffset.y <= threshold)) {
        [self headerViewDidPulled:scrollView];
    }
}

#pragma mark Private methods

- (void)headerViewDidPulled:(UIScrollView *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPulledAtHeaderOnServiceMoreDetailView:)]) {
        [self.delegate didPulledAtHeaderOnServiceMoreDetailView:self];
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