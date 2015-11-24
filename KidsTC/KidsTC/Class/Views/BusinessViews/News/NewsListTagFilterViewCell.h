//
//  NewsListTagFilterViewCell.h
//  KidsTC
//
//  Created by Altair on 11/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsTagTypeModelMetaData;

@interface NewsListTagFilterViewCell : UITableViewCell

- (void)configWithMetaData:(NewsTagTypeModelMetaData *)metaData;

+ (CGFloat)cellHeight;

@end
