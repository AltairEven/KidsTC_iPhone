//
//  TwinklingElvesView.h
//  ICSON
//
//  Created by 钱烨 on 4/13/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwinklingElvesView;


@protocol TwinklingElvesViewDataSource <NSObject>

@required

- (NSInteger)twinklingElvesView:(TwinklingElvesView *)elvesView numberOfItemsInSection:(NSInteger)section;

- (NSInteger)numberOfSectionsForTwinklingElvesView:(TwinklingElvesView *)elvesView;

- (NSURL *)imageUrlOfCellAtIndexPath:(NSIndexPath *)indexPath onTwinklingElvesView:(TwinklingElvesView *)elvesView;

- (NSString *)TitleOfCellAtIndexPath:(NSIndexPath *)indexPath onTwinklingElvesView:(TwinklingElvesView *)elvesView;

@end

@protocol TwinklingElvesViewDelegate <NSObject>

- (void)twinklingElvesView:(TwinklingElvesView *)elvesView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface TwinklingElvesView : UIView

@property (nonatomic, assign) id<TwinklingElvesViewDataSource> dataSource;
@property (nonatomic, assign) id<TwinklingElvesViewDelegate> delegate;

@property (nonatomic, readonly) CGFloat viewHeight;

- (void)reloadData;

@end
