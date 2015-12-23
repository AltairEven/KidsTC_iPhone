//
//  LoveHouseListViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "LoveHouseListItemModel.h"
#import "LoveHouseListView.h"

@interface LoveHouseListViewModel : BaseViewModel

- (NSArray *)resutlItemModels;

-(void)getMoreHouses;

@end
