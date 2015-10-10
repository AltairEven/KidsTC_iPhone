//
//  HomeViewWholeImageNewsCell.h
//  KidsTC
//
//  Created by 钱烨 on 9/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeWholeImageNewsCellModel.h"

@interface HomeViewWholeImageNewsCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(HomeWholeImageNewsCellModel *)model;

@end
