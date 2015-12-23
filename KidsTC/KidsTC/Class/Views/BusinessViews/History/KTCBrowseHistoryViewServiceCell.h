//
//  KTCBrowseHistoryViewServiceCell.h
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseHistoryServiceListItemModel.h"

@interface KTCBrowseHistoryViewServiceCell : UITableViewCell

- (void)configWithModel:(BrowseHistoryServiceListItemModel *)model;

+ (CGFloat)cellHeight;

@end
