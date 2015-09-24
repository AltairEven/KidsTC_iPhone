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
        self.userName = [data objectForKey:@"user"];
        self.commentTime = [data objectForKey:@"time"];
        self.starNumber = [[data objectForKey:@"level"] integerValue];
        self.comments = [data objectForKey:@"content"];
        NSArray *imgArray = [data objectForKey:@"urls"];
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
    }
    return self;
}

- (CGFloat)contentHeight {
    CGFloat height = 45;
    //Label
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 15)];
    [commentLabel setFont:[UIFont systemFontOfSize:13]];
    [commentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [commentLabel setText:self.comments];
    height += [commentLabel sizeToFitWithMaximumNumberOfLines:0];
    //phots
    NSUInteger pictureCount = [self.thumbnailPhotoUrlStringsArray count];
    NSUInteger photoRowCount = pictureCount / 4;
    if (pictureCount % 4 > 0) {
        photoRowCount ++;
    }
    CGFloat pictureGap = 10;
    CGFloat pictureHeight = (SCREEN_WIDTH - 30 - pictureGap * 3) / 4;
    
    height += photoRowCount * pictureHeight + (photoRowCount - 1) * pictureGap + 30;
    
    return height;
}

@end
