//
//  KTCBrowseHistoryViewStoreCell.h
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseHistoryStoreListItemModel.h"

@interface KTCBrowseHistoryViewStoreCell : UITableViewCell

- (void)configWithModel:(BrowseHistoryStoreListItemModel *)model;

+ (CGFloat)cellHeight;

@end
