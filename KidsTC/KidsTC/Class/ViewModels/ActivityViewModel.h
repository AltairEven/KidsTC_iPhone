//
//  ActivityViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/12/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "ActivityView.h"

@interface ActivityViewModel : BaseViewModel

@property (nonatomic, strong) KTCAreaItem *currentAreaItem;

- (NSArray *)currentResultArray;

- (void)startUpdateDataWithCalendarIndex:(NSUInteger)index;

- (void)getMoreDataWithCalendarIndex:(NSUInteger)index;

- (void)resetResultWithCalendarIndex:(NSUInteger)index;

@end
