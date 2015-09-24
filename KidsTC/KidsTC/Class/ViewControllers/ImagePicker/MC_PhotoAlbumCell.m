//
//  MC_PhotoAlbumCell.m
//  Coordinate
//
//  Created by Qian Ye on 13-11-19.
//  Copyright (c) 2013年 MapABC. All rights reserved.
//

#import "MC_PhotoAlbumCell.h"

@implementation MC_PhotoAlbumCell

@synthesize lbDescription, imvThumbnail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style dataDic:(NSDictionary *)dataDic andReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initElementsWithDataDic:dataDic];
    }
    return self;
}


- (void)initElementsWithDataDic:(NSDictionary *)dataDic
{
    CGFloat fLeft = 5.0;
    CGFloat fTop = 2.5;
    CGFloat fWidth = 75.0;
    CGFloat fHeight = 75.0;
    self.imvThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(fLeft, fTop, fWidth, fHeight)];
    [self.imvThumbnail setImage:[dataDic objectForKey:MCPhotoAlbumDataTypePosterImage]];
    [self addSubview:self.imvThumbnail];
    
    fLeft = 100.0;
    fTop = 20.0;
    fWidth = self.frame.size.width - fLeft;
    fHeight = 40.0;
    self.lbDescription = [[UILabel alloc] initWithFrame:CGRectMake(fLeft, fTop, fWidth, fHeight)];
    [self.lbDescription setTextAlignment:NSTextAlignmentLeft];
    [self.lbDescription setText:[dataDic objectForKey:MCPhotoAlbumDataTypeDescription]];
    [self addSubview:self.lbDescription];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
