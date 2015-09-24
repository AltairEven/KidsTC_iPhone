//
//  KTCSearchResultHeaderView.h
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KTCSearchResultHeaderViewSegmentTagService,
    KTCSearchResultHeaderViewSegmentTagStore
}KTCSearchResultHeaderViewSegmentTag;

@class KTCSearchResultHeaderView;

@protocol KTCSearchResultHeaderViewDelegate <NSObject>

- (void)didClickedBackButtonOnSearchResultHeaderView:(KTCSearchResultHeaderView *)headerView;
- (void)searchResultHeaderView:(KTCSearchResultHeaderView *)headerView didClickedSegmentControlWithTag:(KTCSearchResultHeaderViewSegmentTag)tag;
- (void)didClickedSearchButtonOnSearchResultHeaderView:(KTCSearchResultHeaderView *)headerView;

@end

@interface KTCSearchResultHeaderView : UIView

@property (nonatomic, assign) id<KTCSearchResultHeaderViewDelegate> delegate;

+ (instancetype)showOnNavigationBar:(UINavigationBar *)bar;

@end
