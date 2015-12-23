//
//  TwinklingElfCell.h
//  ICSON
//
//  Created by 钱烨 on 4/13/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kTwinklingElfCellIdentifier;

@interface TwinklingElfCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
