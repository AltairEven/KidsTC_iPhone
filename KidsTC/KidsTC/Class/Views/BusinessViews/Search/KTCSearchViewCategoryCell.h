//
//  KTCSearchViewCategoryCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/19/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTCSearchViewCategoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)hideSeparator:(BOOL)hidden;

@end
