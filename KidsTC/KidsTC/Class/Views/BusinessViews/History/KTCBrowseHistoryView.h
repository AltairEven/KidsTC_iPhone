//
//  KTCBrowseHistoryView.h
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTCBrowseHistoryManager.h"

typedef enum {
    KTCBrowseHistoryViewTagService,
    KTCBrowseHistoryViewTagStore
}KTCBrowseHistoryViewTag;

@class KTCBrowseHistoryView;

@protocol KTCBrowseHistoryViewDataSource <NSObject>

- (NSString *)titleForBrowseHistoryView:(KTCBrowseHistoryView *)view withTag:(KTCBrowseHistoryViewTag)tag;

- (NSArray *)itemModelsForBrowseHistoryView:(KTCBrowseHistoryView *)view withTag:(KTCBrowseHistoryViewTag)tag;

@end

@protocol KTCBrowseHistoryViewDelegate <NSObject>

- (void)browseHistoryView:(KTCBrowseHistoryView *)view didChangedTag:(KTCBrowseHistoryViewTag)tag;

- (void)browseHistoryView:(KTCBrowseHistoryView *)view didPulledUpToloadMoreForTag:(KTCBrowseHistoryViewTag)tag;

@end

@interface KTCBrowseHistoryView : UIView

@property (nonatomic, assign) id<KTCBrowseHistoryViewDataSource> dataSource;

@property (nonatomic, assign) id<KTCBrowseHistoryViewDelegate> delegate;

@property (nonatomic, readonly) KTCBrowseHistoryViewTag currentTag;

@property (nonatomic, readonly) BOOL isShowing;

+ (instancetype)historyView;

- (void)showInViewController:(UIViewController *)viewController;

- (void)hide;

- (void)startLoadingAnimation:(BOOL)start;

- (void)reloadDataForTag:(KTCBrowseHistoryViewTag)tag;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore forTag:(KTCBrowseHistoryViewTag)tag;

- (void)hideLoadMoreFooter:(BOOL)hidden forTag:(KTCBrowseHistoryViewTag)tag;

+ (KTCBrowseHistoryType)typeOfViewTag:(KTCBrowseHistoryViewTag)tag;

@end
