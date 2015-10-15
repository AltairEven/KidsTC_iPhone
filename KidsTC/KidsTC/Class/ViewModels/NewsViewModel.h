//
//  NewsViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 9/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "NewsView.h"

@interface NewsViewModel : BaseViewModel

@property (nonatomic, assign) NewsViewTag currentViewTag;

@property (nonatomic, assign) NSUInteger currentNewsTagIndex;

- (void)refreshNewsWithViewTag:(NewsViewTag)viewTag newsTagIndex:(NSUInteger)index;

- (void)getMoreNewsWithViewTag:(NewsViewTag)viewTag newsTagIndex:(NSUInteger)index;

- (void)resetNewsViewWithViewTag:(NewsViewTag)viewTag newsTagIndex:(NSUInteger)index;

- (NSArray *)resultListItemsWithViewTag:(NewsViewTag)viewTag;

@end
