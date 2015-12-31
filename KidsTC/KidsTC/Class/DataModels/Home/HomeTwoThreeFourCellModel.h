//
//  HomeTwoThreeFourCellModel.h
//  KidsTC
//
//  Created by Altair on 12/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@class HomeTwoThreeFourItem;

@interface HomeTwoThreeFourCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray<HomeTwoThreeFourItem *> *itemsArray;

@end



@interface HomeTwoThreeFourItem : HomeElementBaseModel

@end