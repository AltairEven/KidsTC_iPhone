//
//  AUINoticeView.h
//  KidsTC
//
//  Created by Altair on 12/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AUINoticeViewPlayDirectionLeftToRight,
    AUINoticeViewPlayDirectionRightToLeft,
    AUINoticeViewPlayDirectionTopToBottom,
    AUINoticeViewPlayDirectionBottomToTop
}AUINoticeViewPlayDirection;

@class AUINoticeView;

@protocol AUINoticeViewDataSource <NSObject>

- (NSUInteger)numberOfStringsForNoticeView:(AUINoticeView *)noticeView;

- (NSString *)noticeStringForNoticeView:(AUINoticeView *)noticeView atIndex:(NSUInteger)index;

- (CGSize)sizeForNoticeView:(AUINoticeView *)noticeView;

@end

@protocol AUINoticeViewDelegate <NSObject>

@optional

- (void)auiNoticeView:(AUINoticeView *)noticeView didScrolledToIndex:(NSUInteger)index;

- (void)auiNoticeView:(AUINoticeView *)noticeView didClickedAtIndex:(NSUInteger)index;

@end

@interface AUINoticeView : UIView

@property (nonatomic, assign) id<AUINoticeViewDataSource> dataSource;

@property (nonatomic, assign) id<AUINoticeViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger maxLine; //default 1

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) BOOL enableClicking;

@property (nonatomic, assign) NSUInteger autoPlayDuration; //0 means no auto play, default is 3

//default AUINoticeViewPlayDirectionLeftToRigth
@property (nonatomic, assign) AUINoticeViewPlayDirection playDirection;

- (void)reloadData;


@end
