//
//  KTCSearchResultHeaderView.m
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchResultHeaderView.h"

@interface KTCSearchResultHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

- (IBAction)didClickedBackButton:(id)sender;
- (IBAction)didClickedSearchButton:(id)sender;

- (void)segmentControlDidChangedSelectedIndex:(id)sender;

@end

@implementation KTCSearchResultHeaderView

#pragma mark Initialization


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    static BOOL bLoad;
    if (!bLoad)
    {
        bLoad = YES;
        KTCSearchResultHeaderView *view = [GConfig getObjectFromNibWithView:self];
        [view buildSubviews];
        return view;
    }
    bLoad = NO;
    return self;
}

- (void)buildSubviews
{
    [self.segmentControl addTarget:self action:@selector(segmentControlDidChangedSelectedIndex:) forControlEvents:UIControlEventValueChanged];
    [self.segmentControl setSelectedSegmentIndex:KTCSearchResultHeaderViewSegmentTagService];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,[UIColor redColor], NSForegroundColorAttributeName, nil];
    [self.segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:COLOR_GLOBAL_NORMAL forKey:NSForegroundColorAttributeName];
    [self.segmentControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
}

+ (instancetype)showOnNavigationBar:(UINavigationBar *)bar {
    KTCSearchResultHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([KTCSearchResultHeaderView class]) owner:nil options:nil] objectAtIndex:0];

    [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, bar.frame.size.height)];
    [headerView setBackgroundColor:bar.barTintColor];
    [bar addSubview:headerView];
    
    return headerView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didClickedBackButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedBackButtonOnSearchResultHeaderView:)]) {
        [self.delegate didClickedBackButtonOnSearchResultHeaderView:self];
    }
}

- (IBAction)didClickedSearchButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSearchButtonOnSearchResultHeaderView:)]) {
        [self.delegate didClickedSearchButtonOnSearchResultHeaderView:self];
    }
}

- (void)segmentControlDidChangedSelectedIndex:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchResultHeaderView:didClickedSegmentControlWithTag:)]) {
        UISegmentedControl *control = sender;
        KTCSearchResultHeaderViewSegmentTag tag = (KTCSearchResultHeaderViewSegmentTag)(control.selectedSegmentIndex);
        [self.delegate searchResultHeaderView:self didClickedSegmentControlWithTag:tag];
    }
}


@end
