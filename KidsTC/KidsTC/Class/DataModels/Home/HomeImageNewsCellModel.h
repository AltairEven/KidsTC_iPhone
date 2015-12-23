//
//  HomeImageNewsCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@class HomeImageNewsElement;

@interface HomeImageNewsCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray<HomeImageNewsElement *> *elementsArray;

@end


@interface HomeImageNewsElement : HomeNewsBaseModel

@end
