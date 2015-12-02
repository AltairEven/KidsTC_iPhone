//
//  MyCommentListItemModel.m
//  KidsTC
//
//  Created by Altair on 12/1/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "MyCommentListItemModel.h"
#import "MWPhoto.h"

@interface MyCommentListItemModel ()


@end

@implementation MyCommentListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"rId"]) {
            self.relationIdentifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"rId"]];
        }
        self.relationType = (CommentRelationType)[[data objectForKey:@"type"] integerValue];
        self.title = [data objectForKey:@"title"];
        NSDictionary *commentDic = [data objectForKey:@"comment"];
        if ([commentDic isKindOfClass:[NSDictionary class]] && [commentDic count] > 0) {
            if ([commentDic objectForKey:@"commentId"]) {
                self.commentIdentifier = [NSString stringWithFormat:@"%@", [commentDic objectForKey:@"commentId"]];
            }
            self.commentTime = [commentDic objectForKey:@"commentTime"];
            //score
            NSDictionary *scoreData = [commentDic objectForKey:@"commentScore"];
            if ([scoreData isKindOfClass:[NSDictionary class]] && [scoreData count] > 0) {
                NSUInteger totalScore = [[scoreData objectForKey:@"overallScore"] integerValue];
                CommentScoreItem *totalItem = [CommentScoreItem scoreItemWithTitle:@"总体评价" andKey:@"total"];
                if (totalItem) {
                    totalItem.score = totalScore;
                }
                NSArray *scoreDetails = [scoreData objectForKey:@"scoreDetail"];
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                if ([scoreDetails isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *singleElem in scoreDetails) {
                        NSString *key = [singleElem objectForKey:@"Key"];
                        NSString *name = [singleElem objectForKey:@"ScoreName"];
                        NSUInteger score = [[singleElem objectForKey:@"Score"] integerValue];
                        CommentScoreItem *item = [CommentScoreItem scoreItemWithTitle:name andKey:key];
                        if (item) {
                            item.score = score;
                            [tempArray addObject:item];
                        }
                    }
                }
                self.scoreConfigModel = [[CommentScoreConfigModel alloc] initWithTotalScoreItem:totalItem ScoreItems:[NSArray arrayWithArray:tempArray]];
                if (self.relationType != CommentRelationTypeNews || self.relationType != CommentRelationTypeStrategy || self.relationType != CommentRelationTypeStrategyDetail) {
                    [self.scoreConfigModel setNeedShowScore:YES];
                } else {
                    [self.scoreConfigModel setNeedShowScore:NO];
                }
            } else {
                self.scoreConfigModel = [[CommentScoreConfigModel alloc] init];
                [self.scoreConfigModel setNeedShowScore:NO];
            }
            //comments
            self.comments = [commentDic objectForKey:@"content"];
            //image
            NSArray *imgArray = [commentDic objectForKey:@"imgArr"];
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
            self.canEdit = [[commentDic objectForKey:@"isModify"] boolValue];
            self.canDelete = [[commentDic objectForKey:@"isDelete"] boolValue];
            if ([data objectForKey:@"linkUrlOrStrategyNo"]) {
                if (self.relationType == CommentRelationTypeStrategy || self.relationType == CommentRelationTypeStrategyDetail) {
                    self.strategyIdentifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"linkUrlOrStrategyNo"]];
                } else if (self.relationType == CommentRelationTypeNews) {
                    self.linkUrl = [NSString stringWithFormat:@"%@", [data objectForKey:@"linkUrlOrStrategyNo"]];
                }
            }
        }
    }
    return self;
}

- (CGFloat)cellHeight {
    CGFloat height = 80;
    if ([self.scoreConfigModel needShowScore]) {
        height += 25;
    }
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

- (UIImage *)bizIcon {
    UIImage *image = nil;
    switch (self.relationType) {
        case CommentRelationTypeStore:
        {
            image = [UIImage imageNamed:@"bizicon_store_h"];
        }
            break;
        case CommentRelationTypeNews:
        {
            image = [UIImage imageNamed:@"bizicon_news_h"];
        }
            break;
        case CommentRelationTypeStrategy:
        case CommentRelationTypeStrategyDetail:
        {
            image = [UIImage imageNamed:@"bizicon_strategy_h"];
        }
            break;
        default:
        {
            image = [UIImage imageNamed:@"bizicon_service_h"];
        }
            break;
    }
    
    return image;
}

@end
