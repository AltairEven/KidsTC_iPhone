//
//  HomeThreeImageNewsCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@class HomeThreeImageNewsElement;

@interface HomeThreeImageNewsCellModel : HomeContentCellModel

@property (nonatomic, strong) HomeThreeImageNewsElement *firstElement;

@property (nonatomic, strong) HomeThreeImageNewsElement *secondeElement;

@property (nonatomic, strong) HomeThreeImageNewsElement *thirdElement;

@end

@interface HomeThreeImageNewsElement : HomeNewsBaseModel

@end