//
//  MC_PhotoAlbumCell.h
//  Coordinate
//
//  Created by Qian Ye on 13-11-19.
//  Copyright (c) 2013年 MapABC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MC_PHOTOALBUMCELL_HEIGHT 80

#define MCPhotoAlbumDataTypePosterImage   @"posterImage"
#define MCPhotoAlbumDataTypeDescription   @"description"

@interface MC_PhotoAlbumCell : UITableViewCell

@property (strong, nonatomic) UILabel *lbDescription;
@property (strong, nonatomic) UIImageView *imvThumbnail;


- (id)initWithStyle:(UITableViewCellStyle)style dataDic:(NSDictionary *)dataDic andReuseIdentifier:(NSString *)reuseIdentifier;

@end
