//
//  ServiceDetailMoreInfoView.m
//  KidsTC
//
//  Created by 钱烨 on 10/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailMoreInfoView.h"
#import "StoreListViewCell.h"
#import "CommentListViewCell.h"

NSString *const kStoreCellIdentifier = @"kStoreCellIdentifier";
NSString *const kCommentCellIdentifier = @"kCommentCellIdentifier";

@interface ServiceDetailMoreInfoView () <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UINib *storeCellNib;

@property (nonatomic, strong) UINib *commentCellNib;

@property (nonatomic, assign) CGSize webViewContentSize;

- (void)changeViewHeight:(CGFloat)height;

- (void)didClickedMoreCommentButton;

@end

@implementation ServiceDetailMoreInfoView

#pragma mark Initialization

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ServiceDetailMoreInfoView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        [self buildSubviews];
    }
    return self;
}


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        ServiceDetailMoreInfoView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    [self setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    
    [self.webView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    [self.webView.scrollView setScrollEnabled:NO];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    self.webView.delegate = self;
    NSString *userAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *extInfo = [NSString stringWithFormat:@"KidsTC/Iphone/%@", appVersion];
    if ([userAgent rangeOfString:extInfo].location == NSNotFound)
    {
        NSString *newUserAgent = [NSString stringWithFormat:@"%@ %@", userAgent, extInfo];
        // Set user agent (the only problem is that we can't modify the User-Agent later in the program)
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    
    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalBGColor];
    [self.tableView setScrollEnabled:NO];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    if (!self.storeCellNib) {
        self.storeCellNib = [UINib nibWithNibName:NSStringFromClass([StoreListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.storeCellNib forCellReuseIdentifier:kStoreCellIdentifier];
    }
    if (!self.commentCellNib) {
        self.commentCellNib = [UINib nibWithNibName:NSStringFromClass([CommentListViewCell class]) bundle:nil];
        [self.tableView registerNib:self.commentCellNib forCellReuseIdentifier:kCommentCellIdentifier];
    }
    
    self.viewTag = ServiceDetailMoreInfoViewTagIntroduction;
}

#pragma mark Setter

- (void)setViewTag:(ServiceDetailMoreInfoViewTag)viewTag {
    _viewTag = viewTag;
    switch (viewTag) {
        case ServiceDetailMoreInfoViewTagIntroduction:
        {
            [self bringSubviewToFront:self.webView];
            [self.webView setHidden:NO];
            [self.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [self.tableView setHidden:YES];
            [self changeViewHeight:self.webViewContentSize.height];
        }
            break;
        case ServiceDetailMoreInfoViewTagStore:
        {
            [self bringSubviewToFront:self.tableView];
            [self.webView setHidden:YES];
            [self.tableView setHidden:NO];
            
            [self.tableView reloadData];
            CGSize size = self.tableView.contentSize;
            if (size.height < self.standardViewSize.height) {
                size.height = self.standardViewSize.height;
            }
            [self changeViewHeight:size.height];
            if ([self.storeListModels count] == 0) {
                self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, self.standardViewSize.width, self.standardViewSize.height) image:[UIImage imageNamed:@""] description:@"暂无门店信息~"];
            } else {
                self.tableView.backgroundView = nil;
            }
        }
            break;
        case ServiceDetailMoreInfoViewTagComment:
        {
            [self bringSubviewToFront:self.tableView];
            [self.webView setHidden:YES];
            [self.tableView setHidden:NO];
            
            [self.tableView reloadData];
            CGSize size = self.tableView.contentSize;
            if (size.height < self.standardViewSize.height) {
                size.height = self.standardViewSize.height;
            }
            [self changeViewHeight:size.height];
            if ([self.commentListModels count] == 0) {
                self.tableView.backgroundView = [[KTCEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, self.standardViewSize.width, self.standardViewSize.height) image:[UIImage imageNamed:@"nocomment"] description:@"暂无评论"];
            } else {
                self.tableView.backgroundView = nil;
            }
        }
            break;
        default:
            break;
    }
}

- (void)setIntroductionUrlString:(NSString *)introductionUrlString {
    _introductionUrlString = introductionUrlString;
    [self.webView stopLoading];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:introductionUrlString]]];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger number = 0;
    switch (self.viewTag) {
        case ServiceDetailMoreInfoViewTagStore:
            number = [self.storeListModels count];
            break;
        case ServiceDetailMoreInfoViewTagComment:
            number = [self.commentListModels count];
            break;
        default:
            break;
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;;
    switch (self.viewTag) {
        case ServiceDetailMoreInfoViewTagStore:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kStoreCellIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"StoreListViewCell" owner:nil options:nil] objectAtIndex:0];
            }
            [((StoreListViewCell *)cell) configWithItemModel:[self.storeListModels objectAtIndex:indexPath.row]];
        }
            break;
        case ServiceDetailMoreInfoViewTagComment:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kCommentCellIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell =  [[[NSBundle mainBundle] loadNibNamed:@"CommentListViewCell" owner:nil options:nil] objectAtIndex:0];
            }
            [((CommentListViewCell *)cell) configWithItemModel:[self.commentListModels objectAtIndex:indexPath.row]];
        }
            break;
        default:
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
            break;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (self.viewTag) {
        case ServiceDetailMoreInfoViewTagStore:
        {
            StoreListItemModel *model = [self.storeListModels objectAtIndex:indexPath.row];
            height = [model cellHeight];
        }
            break;
        case ServiceDetailMoreInfoViewTagComment:
        {
            CommentListItemModel *model = [self.commentListModels objectAtIndex:indexPath.row];
            height = [model cellHeight];
        }
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.viewTag == ServiceDetailMoreInfoViewTagComment) {
        return 50;
    }
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.commentListModels count] > 0 && self.viewTag == ServiceDetailMoreInfoViewTagComment) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [bgView setBackgroundColor:[UIColor clearColor]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[[KTCThemeManager manager] defaultTheme].globalCellBGColor];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitle:@"查看全部评论" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setFrame:CGRectMake(20, 10, bgView.frame.size.width - 40, 30)];
        [button addTarget:self action:@selector(didClickedMoreCommentButton) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = BORDER_WIDTH;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        
        [bgView addSubview:button];
        return bgView;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate) {
        if (self.viewTag == ServiceDetailMoreInfoViewTagStore && [self.delegate respondsToSelector:@selector(serviceDetailMoreInfoView:didClickedStoreAtIndex:)]) {
            [self.delegate serviceDetailMoreInfoView:self didClickedStoreAtIndex:indexPath.row];
        }
        if (self.viewTag == ServiceDetailMoreInfoViewTagComment && [self.delegate respondsToSelector:@selector(serviceDetailMoreInfoView:didClickedCommentAtIndex:)]) {
            [self.delegate serviceDetailMoreInfoView:self didClickedCommentAtIndex:indexPath.row];
        }
    }
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self.webView sizeToFit];
    self.webViewContentSize = self.webView.scrollView.contentSize;
    if (self.viewTag == ServiceDetailMoreInfoViewTagIntroduction) {
        [self changeViewHeight:self.webViewContentSize.height];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.webView sizeToFit];
    self.webViewContentSize = self.webView.scrollView.contentSize;
    if (self.viewTag == ServiceDetailMoreInfoViewTagIntroduction) {
        [self changeViewHeight:self.webViewContentSize.height];
    }
}

#pragma mark Private methods

- (void)changeViewHeight:(CGFloat)height {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceDetailMoreInfoView:didChangedViewContentSize:)]) {
        [self.delegate serviceDetailMoreInfoView:self didChangedViewContentSize:CGSizeMake(self.frame.size.width, height)];
    }
}

- (void)didClickedMoreCommentButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedMoreCommentButtonOnServiceDetailMoreInfoView:)]) {
        [self.delegate didClickedMoreCommentButtonOnServiceDetailMoreInfoView:self];
    }
}

#pragma mark Public methods

- (void)setScrollEnabled:(BOOL)enabled {
    [self.webView.scrollView setScrollEnabled:enabled];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
