//
//  StoreMoreDetailView.m
//  KidsTC
//
//  Created by 钱烨 on 8/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreMoreDetailView.h"

@interface StoreMoreDetailView ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation StoreMoreDetailView


#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        StoreMoreDetailView *view = [GConfig getObjectFromNibWithView:self];
        [view setBackgroundColor:[AUITheme theme].globalBGColor];
        return view;
    }
    bLoad = NO;
    return self;
}


- (void)setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    [self.webView stopLoading];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
