//
//  HomeViewImageNewsCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeImageNewsCellModel.h"

@interface HomeViewImageNewsCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(HomeImageNewsElement *)model;

@end
