//
//  HotActivityGroupView.h
//  ICSON
//
//  Created by 钱烨 on 4/10/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotActivityGroupView;

@protocol HotActivityGroupViewDataSource <NSObject>

@required

- (NSInteger)groupView:(HotActivityGroupView *)groupView numberOfItemsInSection:(NSInteger)section;

- (NSURL *)imageUrlOfCellAtIndexPath:(NSIndexPath *)indexPath onHotActivityView:(HotActivityGroupView *)hotView;

@optional

- (NSInteger)numberOfSectionsInGroupView:(HotActivityGroupView *)groupView;

@end

@protocol HotActivityGroupViewDelegate <NSObject>

- (void)hotActivityGroupView:(HotActivityGroupView *)groupView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface HotActivityGroupView : UIView

@property (nonatomic, assign) id<HotActivityGroupViewDataSource> dataSource;
@property (nonatomic, assign) id<HotActivityGroupViewDelegate> delegate;

@property (nonatomic, readonly) CGFloat viewHeight;

@property (nonatomic, assign) CGFloat ratio;

- (void)reloadData;

@end
