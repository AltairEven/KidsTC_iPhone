//
//  CommentListItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "CommentListItemModel.h"
#import "MWPhoto.h"

@implementation CommentListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"id"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
        self.faceImageUrl = [NSURL URLWithString:[data objectForKey:@"userImgUrl"]];
        self.userName = [data objectForKey:@"userName"];
        self.commentTime = [data objectForKey:@"time"];
        NSDictionary *scoreData = [data objectForKey:@"score"];
        if ([scoreData isKindOfClass:[NSDictionary class]]) {
            self.starNumber = [[scoreData objectForKey:@"OverallScore"] integerValue];
        }
        self.comments = [data objectForKey:@"content"];
        NSArray *imgArray = [data objectForKey:@"imageUrl"];
        if ([imgArray isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempOrigin = [[NSMutableArray alloc] init];
            NSMutableArray *tempThumb = [[NSMutableArray alloc] init];
            NSMutableArray *tempPhoto = [[NSMutableArray alloc] init];
            for (NSArray *singleItem in imgArray) {
                if ([singleItem count] == 2) {
                    NSString *originUrlString = [singleItem firstObject];
                    NSString *thumbUrlString = [singleItem lastObject];
                    if ([originUrlString length] > 0 && [thumbUrlString length] > 0) {
                        [tempOrigin addObject:originUrlString];
                        [tempThumb addObject:thumbUrlString];
                        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:originUrlString]];
                        if (photo) {
                            [tempPhoto addObject:photo];
                        }
                    }
                } else {
                    continue;
                }
            }
            if ([tempOrigin count] > 0 && [tempOrigin count] == [tempThumb count]) {
                self.originalPhotoUrlStringsArray = [NSArray arrayWithArray:tempOrigin];
                self.thumbnailPhotoUrlStringsArray = [NSArray arrayWithArray:tempThumb];
                self.photosArray = [NSArray arrayWithArray:tempPhoto];
            }
        }
        self.isLiked = [[data objectForKey:@"isPraise"] boolValue];
        self.likeNumber = [[data objectForKey:@"praiseCount"] integerValue];
        self.replyNumber = [[data objectForKey:@"replyCount"] integerValue];
    }
    return self;
}

- (CGFloat)cellHeight {
    CGFloat height = 50 + 30;
    //Label
    CGFloat labelHeight = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 andText:self.comments];
    //phots
    NSUInteger pictureCount = [self.thumbnailPhotoUrlStringsArray count];
    CGFloat row = 0;
    NSUInteger oneLineCount = 4;
    if (pictureCount > 0 && pictureCount <= oneLineCount) {
        row = 1;
    } else {
        row = pictureCount / oneLineCount;
        if (pictureCount % oneLineCount > 0) {
            row ++;
        }
    }
    CGFloat pictureGap = 10;
    CGFloat pictureHeight = (SCREEN_WIDTH - 20 - pictureGap * (oneLineCount - 1)) / oneLineCount + pictureGap;
    
    CGFloat gapTotalHeight = 0;
    if (row > 1) {
        gapTotalHeight = (row - 1) * pictureGap;
    }
    
    height += labelHeight + gapTotalHeight + pictureHeight * row;
    
    return height;
}

- (CGFloat)storeDetailCellHeight {
    CGFloat height = 100;
    //Label
    CGFloat labelHeight = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 80 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 andText:self.comments];
    //phots
    NSUInteger pictureCount = [self.thumbnailPhotoUrlStringsArray count];
    CGFloat row = 0;
    NSUInteger oneLineCount = 4;
    if (pictureCount > 0 && pictureCount <= oneLineCount) {
        row = 1;
    } else {
        row = pictureCount / oneLineCount;
        if (pictureCount % oneLineCount > 0) {
            row ++;
        }
    }
    CGFloat pictureGap = 10;
    CGFloat pictureHeight = (SCREEN_WIDTH - 80 - pictureGap * (oneLineCount - 1)) / oneLineCount;
    
    CGFloat gapTotalHeight = 0;
    if (row > 1) {
        gapTotalHeight = (row - 1) * pictureGap;
    }
    
    CGFloat contentHeight = labelHeight + 40 + gapTotalHeight + pictureHeight * row;
    if (height < contentHeight) {
        height = contentHeight;
    }
    
    return height;
}

@end
