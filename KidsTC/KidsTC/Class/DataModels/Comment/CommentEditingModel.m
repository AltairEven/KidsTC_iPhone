//
//  CommentEditingModel.m
//  KidsTC
//
//  Created by Altair on 12/2/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "CommentEditingModel.h"

@implementation CommentEditingModel

+ (instancetype)modelFromItem:(MyCommentListItemModel *)item {
    if (!item) {
        return nil;
    }
    CommentEditingModel *model = [[CommentEditingModel alloc] init];
    model.relationIdentifier = item.relationIdentifier;
    model.commentIdentifier = item.commentIdentifier;
    model.strategyIdentifier = item.strategyIdentifier;
    model.linkUrl = item.linkUrl;
    model.relationType = item.relationType;
    model.objectName = item.title;
    model.scoreConfigModel = item.scoreConfigModel;
    model.commentText = item.comments;
    model.needHideName = YES;
    model.originalPhotoUrlStringsArray = item.originalPhotoUrlStringsArray;
    model.thumbnailPhotoUrlStringsArray = item.thumbnailPhotoUrlStringsArray;
    if ([model.thumbnailPhotoUrlStringsArray count] > 0) {
        model.combinedImagesArray = [model.thumbnailPhotoUrlStringsArray copy];
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < [model.thumbnailPhotoUrlStringsArray count]; index ++) {
        NSString *thumb = [model.thumbnailPhotoUrlStringsArray objectAtIndex:index];
        NSString *origin = [model.originalPhotoUrlStringsArray objectAtIndex:index];
        NSString *total = [NSString stringWithFormat:@"%@|%@", origin, thumb];
        [tempArray addObject:total];
    }
    model.uploadPhotoLocationStrings = [NSArray arrayWithArray:tempArray];
    model.photosArray = item.photosArray;
    if (model.relationType == CommentRelationTypeStrategy || model.relationType == CommentRelationTypeStrategyDetail) {
        model.showPhotoGrid = NO;
    } else {
        model.showPhotoGrid = YES;
    }
    return model;
}

- (NSArray *)remoteImageUrlStrings {
    NSUInteger count = [self.originalPhotoUrlStringsArray count];
    if (count == 0) {
        return nil;
    }
    if (count != [self.thumbnailPhotoUrlStringsArray count]) {
        return nil;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < count; index ++) {
        NSString *thumb = [self.thumbnailPhotoUrlStringsArray objectAtIndex:index];
        NSString *origin = [self.originalPhotoUrlStringsArray objectAtIndex:index];
        NSString *total = [NSString stringWithFormat:@"%@|%@", origin, thumb];
        [tempArray addObject:total];
    }
    return [NSArray arrayWithArray:tempArray];
}

@end
