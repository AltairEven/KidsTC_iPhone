//
//  HomeRecommendViewCell.h
//  KidsTC
//
//  Created by Altair on 12/31/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRecommendCellModel.h"

extern NSString *const kHomeRecommendCellIdentifier;

@interface HomeRecommendViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recommendImageView;

- (void)configWithModel:(HomeRecommendElement *)model;

@end
