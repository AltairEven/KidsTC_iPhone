//
//  IcsonLevel3Category.h
//  ICSON
//
//  Created by 钱烨 on 2/27/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IcsonBaseCategory.h"

@class IcsonLevel2Category;

@interface IcsonLevel3Category : IcsonBaseCategory

@property (nonatomic, retain) IcsonLevel2Category *parent;

@end
