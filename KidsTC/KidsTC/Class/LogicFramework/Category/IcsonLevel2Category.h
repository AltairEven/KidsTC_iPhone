//
//  IcsonLevel2Category.h
//  ICSON
//
//  Created by 钱烨 on 2/27/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IcsonBaseCategory.h"

@class IcsonLevel1Category, IcsonLevel3Category;

@interface IcsonLevel2Category : IcsonBaseCategory

@property (nonatomic, retain) NSSet *level3Categories;
@property (nonatomic, retain) IcsonLevel1Category *parent;
@end

@interface IcsonLevel2Category (CoreDataGeneratedAccessors)

- (void)addLevel3CategoriesObject:(IcsonLevel3Category *)value;
- (void)removeLevel3CategoriesObject:(IcsonLevel3Category *)value;
- (void)addLevel3Categories:(NSSet *)values;
- (void)removeLevel3Categories:(NSSet *)values;

@end
