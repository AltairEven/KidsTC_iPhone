//
//  HomeBigImageTwoDescCellModel.h
//  KidsTC
//
//  Created by Altair on 12/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"
#import "TextSegueModel.h"

@class HomeBigImageTwoDescItem;

@interface HomeBigImageTwoDescCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray<HomeBigImageTwoDescItem *> *cellItemsArray;

@end


@interface HomeBigImageTwoDescItem : HomeElementBaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, strong) TextSegueModel *textSegue;

@end

