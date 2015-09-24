//
//  IcsonLevel1Category.h
//  ICSON
//
//  Created by 钱烨 on 2/27/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IcsonBaseCategory.h"


@class IcsonCategories, IcsonLevel2Category;

@interface IcsonLevel1Category : IcsonBaseCategory

@property (nonatomic, retain) NSSet *level2Categories;
@property (nonatomic, retain) IcsonCategories *categoryList;
@end

@interface IcsonLevel1Category (CoreDataGeneratedAccessors)

- (void)addLevel2CategoriesObject:(IcsonLevel2Category *)value;
- (void)removeLevel2CategoriesObject:(IcsonLevel2Category *)value;
- (void)addLevel2Categories:(NSSet *)values;
- (void)removeLevel2Categories:(NSSet *)values;

@end
