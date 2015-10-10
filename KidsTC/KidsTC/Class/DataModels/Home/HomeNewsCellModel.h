//
//  HomeNewsCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@class HomeNewsElement;

@interface HomeNewsCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray<HomeNewsElement *> *elementsArray;

@end


@interface HomeNewsElement : HomeNewsBaseModel

@end