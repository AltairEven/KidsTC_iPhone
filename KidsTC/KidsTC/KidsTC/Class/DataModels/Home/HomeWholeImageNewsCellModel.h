//
//  HomeWholeImageNewsCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"
#import "HomeNewsBaseModel.h"

@interface HomeWholeImageNewsCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray<HomeNewsBaseModel *> *newsModels;

@property (nonatomic, strong) HomeNewsBaseModel *newsModel;

@end