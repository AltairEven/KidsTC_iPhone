//
//  HomeNoticeCellModel.h
//  KidsTC
//
//  Created by Altair on 12/22/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@class HomeNoticeItem;

@interface HomeNoticeCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray<HomeNoticeItem *> *noticeItemsArray;

@end


@interface HomeNoticeItem : HomeElementBaseModel

@property (nonatomic, copy) NSString *content; //标题

@end
