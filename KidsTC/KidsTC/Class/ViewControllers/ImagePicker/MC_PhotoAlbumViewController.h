//
//  MC_PhotoAlbumViewController.h
//  Coordinate
//
//  Created by Qian Ye on 13-11-19.
//  Copyright (c) 2013年 MapABC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define PhotoAlbumName (@"name")
#define PhotoAlbumAssetsCount (@"count")
#define PhotoAlbumPosterImage (@"posterImage")
#define PhotoAlbumAssetsGroup (@"assetGroup")

@class MC_PhotoAlbumViewController;

@protocol MC_PhotoAlbumViewControllerDelegate <NSObject>

- (void)MC_PhotoAlbumViewController:(MC_PhotoAlbumViewController *)albumViewController didChooseAlbumGroup:(ALAssetsGroup *)group;

@end

@interface MC_PhotoAlbumViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id<MC_PhotoAlbumViewControllerDelegate> delegate;

+ (MC_PhotoAlbumViewController *)sharedInstance;

@end
