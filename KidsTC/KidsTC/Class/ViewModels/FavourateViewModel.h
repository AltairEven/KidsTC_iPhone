//
//  FavourateViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/10/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "FavouriteServiceItemModel.h"
#import "FavouriteStoreItemModel.h"
#import "FavouriteStrategyItemModel.h"
#import "FavouriteNewsItemModel.h"
#import "FavourateView.h"

@interface FavourateViewModel : BaseViewModel

- (void)startUpdateDataWithFavouratedTag:(FavourateViewSegmentTag)tag;

- (void)getMoreDataWithFavouratedTag:(FavourateViewSegmentTag)tag;

- (void)resetResultWithFavouratedTag:(FavourateViewSegmentTag)tag;

- (void)deleteFavourateDataForTag:(FavourateViewSegmentTag)tag atInde:(NSUInteger)index;

- (NSArray *)resultWithFavouratedTag:(FavourateViewSegmentTag)tag;

@end
