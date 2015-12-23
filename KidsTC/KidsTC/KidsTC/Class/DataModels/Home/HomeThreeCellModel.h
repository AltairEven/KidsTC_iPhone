//
//  HomeThreeCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@class HomeThreePictureElement;

@interface HomeThreeCellModel : HomeContentCellModel

@property (nonatomic, strong) HomeThreePictureElement *firstElement;

@property (nonatomic, strong) HomeThreePictureElement *secondeElement;

@property (nonatomic, strong) HomeThreePictureElement *thirdElement;

@end


@interface HomeThreePictureElement : HomeElementBaseModel

@end