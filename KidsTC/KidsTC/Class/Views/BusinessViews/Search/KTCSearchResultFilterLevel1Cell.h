//
//  KTCSearchResultFilterLevel1Cell.h
//  KidsTC
//
//  Created by 钱烨 on 7/31/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTCSearchResultFilterLevel1Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)hideDot:(BOOL)hidden;

@end
