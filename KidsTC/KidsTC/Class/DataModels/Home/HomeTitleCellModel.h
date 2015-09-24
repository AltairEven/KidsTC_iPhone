//
//  HomeTitleCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeCellModel.h"

typedef enum {
    HomeTitleCellTypeNormalTitle = 1,
    HomeTitleCellTypeCountDownTitle,
    HomeTitleCellTypeMoreTitle
}HomeTitleCellType;

@interface HomeTitleCellModel : HomeCellModel

@property (nonatomic, assign) HomeTitleCellType type;

@property (nonatomic, copy) NSString *mainTitle;

@property (nonatomic, assign) HomeSegueDestination segueDestination;

@property (nonatomic, copy) NSString *linkUrl;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (void)parseRawData:(NSDictionary *)data;

@end
