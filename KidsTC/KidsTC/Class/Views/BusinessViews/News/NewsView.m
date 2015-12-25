//
//  NewsView.m
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsView.h"

@interface NewsView () <NewsRecommendListViewDelegate, NewsListViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tabControl;
@property (weak, nonatomic) IBOutlet UIButton *roleSelectButton;
@property (weak, nonatomic) IBOutlet UIView *listBG;

- (void)tabControlDidChangedSelectedIndex:(id)sender;
- (IBAction)didClickedRoleSelectButton:(id)sender;
- (IBAction)didClickedSearchButton:(id)sender;

@end

@implementation NewsView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        NewsView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews {
    //top
    self.topView.backgroundColor = [[KTCThemeManager manager] currentTheme].navibarBGColor;
    
    //header
    [self.tabControl addTarget:self action:@selector(tabControlDidChangedSelectedIndex:) forControlEvents:UIControlEventValueChanged];
    [self.tabControl setSelectedSegmentIndex:0];
    
    [self.tabControl setTintColor:[UIColor whiteColor]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.tabControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[[KTCThemeManager manager] currentTheme].buttonBGColor_Normal forKey:NSForegroundColorAttributeName];
    [self.tabControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    self.roleSelectButton.layer.cornerRadius = 14;
    self.roleSelectButton.layer.masksToBounds = YES;
    self.roleSelectButton.layer.borderColor = [[KTCThemeManager manager] currentTheme].navibarTitleColor_Normal.CGColor;
    self.roleSelectButton.layer.borderWidth = 1;
    [self.roleSelectButton setHidden:YES];
    //list
    [self.listBG setBackgroundColor:[[KTCThemeManager manager] currentTheme].globalBGColor];
    self.recommendListView.delegate = self;
    
    self.newsListView.delegate = self;
    [self.listBG bringSubviewToFront:self.recommendListView];
}

#pragma mark NewsRecommendListViewDelegate

- (void)newsRecommendListView:(NewsRecommendListView *)listView didSelectedCellItem:(NewsListItemModel *)item {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsView:didSelectedItem:)]) {
        [self.delegate newsView:self didSelectedItem:item];
    }
}

- (void)newsRecommendListViewDidPulledToloadMore:(NewsRecommendListView *)listView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsView:needLoadMoreWithNewsViewTag:tagIndex:)]) {
        [self.delegate newsView:self needLoadMoreWithNewsViewTag:NewsViewTagRecommend tagIndex:0];
    }
}

#pragma mark NewsListViewDelegate

- (void)newsListView:(NewsListView *)listView didSelectedNewsTagIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsView:didChangedNewsTagIndex:)]) {
        [self.delegate newsView:self didChangedNewsTagIndex:index];
    }
}

- (void)newsListView:(NewsListView *)listView didSelectedItem:(NewsListItemModel *)item atNewsTagIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsView:didSelectedItem:)]) {
        [self.delegate newsView:self didSelectedItem:item];
    }
}

- (void)newsListViewDidPulledDownToRefresh:(NewsListView *)listView atNewsTagIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsView:needRefreshTableWithNewsViewTag:tagIndex:)]) {
        [self.delegate newsView:self needRefreshTableWithNewsViewTag:NewsViewTagMore tagIndex:index];
    }
}

- (void)newsListViewDidPulledUpToloadMore:(NewsListView *)listView atNewsTagIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsView:needLoadMoreWithNewsViewTag:tagIndex:)]) {
        [self.delegate newsView:self needLoadMoreWithNewsViewTag:NewsViewTagMore tagIndex:index];
    }
}

#pragma mark Private methods

- (void)tabControlDidChangedSelectedIndex:(id)sender {
    UISegmentedControl *control = sender;
    NewsViewTag viewTag = (NewsViewTag)control.selectedSegmentIndex;
    _currentViewTag = viewTag;
    switch (viewTag) {
        case NewsViewTagRecommend:
        {
            [self.listBG bringSubviewToFront:self.recommendListView];
            if (self.recommendListView.itemCount == 0) {
                [self.recommendListView startLoadMore];
            }
            [self.roleSelectButton setHidden:YES];
        }
            break;
        case NewsViewTagMore:
        {
            [self.listBG bringSubviewToFront:self.newsListView];
            if (self.newsListView.itemCount == 0) {
                [self.newsListView startRefresh];
            }
            [self.roleSelectButton setHidden:NO];
        }
            break;
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsView:didClickedSegmentControlWithNewsViewTag:)]) {
        [self.delegate newsView:self didClickedSegmentControlWithNewsViewTag:viewTag];
    }
}

- (IBAction)didClickedRoleSelectButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedUserRoleButton)]) {
        [self.delegate didClickedUserRoleButton];
    }
}

- (IBAction)didClickedSearchButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSearchButton)]) {
        [self.delegate didClickedSearchButton];
    }
}

#pragma mark Public

- (void)resetRoleTypeWithImage:(UIImage *)image {
    [self.roleSelectButton setImage:image forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
