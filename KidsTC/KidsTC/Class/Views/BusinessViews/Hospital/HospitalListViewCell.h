//
//  HospitalListViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalListItemModel.h"

@class HospitalListViewCell;

@protocol HospitalListViewCellDelegate <NSObject>

- (void)didClickedPhoneButtonOnHospitalListViewCell:(HospitalListViewCell *)cell;

- (void)didClickedGotoButtonOnHospitalListViewCell:(HospitalListViewCell *)cell;

- (void)didClickedNearbyButtonOnHospitalListViewCell:(HospitalListViewCell *)cell;

@end

@interface HospitalListViewCell : UITableViewCell

@property (nonatomic, assign) id<HospitalListViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(HospitalListItemModel *)model;

@end
