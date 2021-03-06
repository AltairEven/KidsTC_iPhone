//
//  StoreDetailModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreDetailModel.h"
#import "NSDate+Helpers.h"

@implementation StoreDetailModel

- (BOOL)fillWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSArray *imgUrls = [data objectForKey:@"imgUrl"];
    if ([imgUrls isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSString *urlString in imgUrls) {
            NSURL *url = [NSURL URLWithString:urlString];
            if (url) {
                [tempArray addObject:url];
            }
        }
        self.imageUrls = [NSArray arrayWithArray:tempArray];
    }
    self.imageRatio = [[data objectForKey:@"picRate"] floatValue];
    NSArray *narrowimageUrlStrings = [data objectForKey:@"narrowImg"];
    if ([narrowimageUrlStrings isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSString *urlString in narrowimageUrlStrings) {
            NSURL *url = [NSURL URLWithString:urlString];
            if (url) {
                [tempArray addObject:url];
            }
        }
        self.narrowImageUrls = [NSArray arrayWithArray:tempArray];
    }
    self.storeName = [data objectForKey:@"storeName"];
    self.storeShortName = [data objectForKey:@"simpleName"];
    if (![self.storeShortName isKindOfClass:[NSString class]] || [self.storeShortName length] == 0) {
        self.storeShortName = @"门店详情";
    }
    self.storeBrief = [data objectForKey:@"breif"];
    if (!self.storeBrief) {
        self.storeBrief = @"";
    }
    NSArray *promotionLinks = [data objectForKey:@"promotionLink"];
    if ([promotionLinks isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *rawData in promotionLinks) {
            TextSegueModel *model = [[TextSegueModel alloc] initWithLinkParam:rawData promotionWords:self.storeBrief];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.promotionSegueModels = [NSArray arrayWithArray:tempArray];
    }
    self.starNumber = [[data objectForKey:@"level"] integerValue];
    NSArray *coupons = [data objectForKey:@"coupon_provide"];
    if ([coupons isKindOfClass:[NSArray class]] && [coupons count] > 0) {
        self.couponName = [[coupons firstObject] objectForKey:@"name"];
        self.couponProvideCount = [[[coupons firstObject] objectForKey:@"provideNum"] integerValue];
    }
    self.couponUrlString = [data objectForKey:@"couponLink"];
    self.appointmentNumber = [[data objectForKey:@"bookNum"] integerValue];
    self.commentNumber = [[data objectForKey:@"evaluateNum"] integerValue];
    if ([data objectForKey:@"phone"]) {
        self.phoneNumber = [data objectForKey:@"phone"];
        if ([self.phoneNumber length] > 0) {
            self.phoneNumber = [self.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
            self.phoneNumber = [self.phoneNumber stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
    }
    self.isFavourate = [[data objectForKey:@"favor"] boolValue];
    //appoint times
    self.appointmentTimeDes = [data objectForKey:@"businessHours"];
    //loc
    NSDictionary *location = [data objectForKey:@"loc"];
    if ([location isKindOfClass:[NSDictionary class]]) {
        self.storeAddress = [location objectForKey:@"addr"];
        self.storeCoordinate = [GToolUtil coordinateFromString:[location objectForKey:@"mapAddr"]];
    }
    //activity
    NSArray *eventsArray = [data objectForKey:@"event"];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    if ([eventsArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *singleElem in eventsArray) {
            NSInteger type = [[singleElem objectForKey:@"type"] integerValue];
            NSString *des = [NSString stringWithFormat:@"%@", [singleElem objectForKey:@"des"]];
            ActivityLogoItemType itemType = ActivityLogoItemTypeUnknow;
            if (type == 1) {
                itemType = ActivityLogoItemTypeGift;
            } else if (type == 2) {
                itemType = ActivityLogoItemTypePreferential;
            }
            ActivityLogoItem *item = [[ActivityLogoItem alloc] initWithType:itemType description:des];
            if (item) {
                item.name = [NSString stringWithFormat:@"%@", [singleElem objectForKey:@"name"]];
                [tempArray addObject:item];
            }
        }
    }
    //activity
    NSArray *fullCut = [data objectForKey:@"fullCut"];
    if ([fullCut isKindOfClass:[NSArray class]] && [fullCut count] > 0) {
        for (NSString *fullCutTitle in fullCut) {
            if ([fullCutTitle isKindOfClass:[NSString class]]) {
                ActivityLogoItem *item = [[ActivityLogoItem alloc] initWithType:ActivityLogoItemTypeDiscount description:fullCutTitle];
                if (item) {
                    [tempArray addObject:item];
                }
            }
        }
        self.activeModelsArray = [NSArray arrayWithArray:tempArray];
    }
    //services
    NSArray *services = [data objectForKey:@"serve"];
    if ([services isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *serviceDic in services) {
            StoreOwnedServiceModel *model = [[StoreOwnedServiceModel alloc] initWithRawData:serviceDic];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.serviceModelsArray = [NSArray arrayWithArray:tempArray];
    }
    //hot recommend
    self.hotRecommedService = [[StoreDetailHotRecommendModel alloc] initWithRawData:[data objectForKey:@"recommend_product"]];
    //store relation-----------------------------------------------------------
    NSDictionary *relationDic = [data objectForKey:@"store_relation"];
    if ([relationDic isKindOfClass:[NSDictionary class]]) {
        //strategy
        NSArray *strategies = [relationDic objectForKey:@"relatedExperienceStrategyLs"];
        if ([strategies isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *strategyDic in strategies) {
                StoreRelatedStrategyModel *model = [[StoreRelatedStrategyModel alloc] initWithRawData:strategyDic];
                if (model) {
                    [tempArray addObject:model];
                }
            }
            self.strategyModelsArray = [NSArray arrayWithArray:tempArray];
        }
    }
    //--------------------------------------------------------------------------
    //recommend
    NSDictionary *recommendDic = [data objectForKey:@"note"];
    if ([recommendDic isKindOfClass:[NSDictionary class]] && [recommendDic count] > 0) {
        self.recommenderFaceImageUrl = [NSURL URLWithString:[recommendDic objectForKey:@"imgUrl"]];
        self.recommenderName = [recommendDic objectForKey:@"name"];
        self.recommendString = [recommendDic objectForKey:@"note"];
    }
    //brief
    self.detailUrlString = [data objectForKey:@"detailUrl"];
    //comments
    NSArray *comments = [data objectForKey:@"commentList"];
    if ([comments isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *commentDic in comments) {
            CommentListItemModel *model = [[CommentListItemModel alloc] initWithRawData:commentDic];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.commentItemsArray = [NSArray arrayWithArray:tempArray];
    }
    //nearby
    NSArray *nearbys = [data objectForKey:@"newFactilities"];
    if ([nearbys isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *nearbyDic in nearbys) {
            StoreDetailNearbyModel *model = [[StoreDetailNearbyModel alloc] initWithRawData:nearbyDic];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.nearbyFacilities = [NSArray arrayWithArray:tempArray];
    }
    //brothers
    NSArray *brothers = [data objectForKey:@"broStore"];
    if ([brothers isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *broDic in brothers) {
            StoreListItemModel *model = [[StoreListItemModel alloc] initWithRawData:broDic];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.brotherStores = [NSArray arrayWithArray:tempArray];
    }
    //comments number
    NSDictionary *commentDic = [data objectForKey:@"comment"];
    if ([commentDic isKindOfClass:[NSDictionary class]] && [commentDic count] > 0) {
        self.commentAllNumber = [[commentDic objectForKey:@"all"] integerValue];
        self.commentGoodNumber = [[commentDic objectForKey:@"good"] integerValue];
        self.commentNormalNumber = [[commentDic objectForKey:@"normal"] integerValue];
        self.commentBadNumber = [[commentDic objectForKey:@"bad"] integerValue];
        self.commentPictureNumber = [[commentDic objectForKey:@"pic"] integerValue];
    }
    
    self.shareObject = [CommonShareObject shareObjectWithRawData:[data objectForKey:@"share"]];
    if (self.shareObject) {
        self.shareObject.identifier = self.storeId;
        self.shareObject.followingContent = @"【童成】";
    }
    
    
    NSUInteger status = [[data objectForKey:@"status"] integerValue];
    if (status == 1) {
        self.canAppoint = YES;
    } else {
        self.canAppoint = NO;
    }
    if ([data objectForKey:@"statusDesc"]) {
        self.appointButtonTitle = [NSString stringWithFormat:@"%@", [data objectForKey:@"statusDesc"]];
    }
    
    return YES;
}

- (CGFloat)topCellHeight {
    CGFloat height = self.imageRatio * SCREEN_WIDTH;
    height += 30;
//    height += [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:0 andText:self.storeBrief];
    height += [GConfig heightForAttributeLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:15] topGap:10 bottomGap:10 maxLine:0 andText:self.storeBrief];
    height += 25;
    return height;
}

- (CGFloat)recommendCellHeight {
    CGFloat height = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 90 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:0 andText:self.recommendString];
    if (height < 80) {
        height = 80;
    }
    
    return height;
}

- (CGFloat)briefCellHeight {
    return [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 10 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:0 andText:self.storeBrief];
}

- (CGFloat)nearbyCellHeight {
    CGFloat gap = 0.5;
    CGFloat singleHeight = 40;
    
    NSUInteger itemCount = [self.nearbyFacilities count];
    CGFloat row = 0;
    if (itemCount > 0 && itemCount <= 3) {
        row = 1;
    } else {
        row = itemCount / 3;
        if (itemCount % 3 > 0) {
            row ++;
        }
    }
    
    CGFloat gapTotalHeight = 0;
    if (row > 1) {
        gapTotalHeight = (row - 1) * gap;
    }
    
    CGFloat cellHeight = row * singleHeight + gapTotalHeight;
    
    return cellHeight;
}

- (BOOL)hasCoupon {
    return ([self.couponName length] > 0);
}

- (NSArray<NSString *> *)phoneNumbersArray {
    if ([self.phoneNumber length] == 0) {
        return nil;
    }
    return [self.phoneNumber componentsSeparatedByString:@";"];
}

- (CGFloat)couponCellHeight {
    return 40;
}

- (CGFloat)activityCellHeightAtIndex:(NSUInteger)index {
    if ([self.activeModelsArray count] > index) {
        CGFloat maxWidth = SCREEN_WIDTH - 50;
        ActivityLogoItem *item = [self.activeModelsArray objectAtIndex:index];
        CGFloat height = [GConfig heightForLabelWithWidth:maxWidth LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:15] topGap:13 bottomGap:13 andText:item.itemDescription];
        if (height < 40) {
            height = 40;
        }
        return height;
    }
    return 40;
}

@end
