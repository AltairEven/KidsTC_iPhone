//
//  HomeSectionModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeSectionModel.h"

@interface HomeSectionModel ()


- (void)parseRawData:(NSDictionary *)data;

@end

@implementation HomeSectionModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        [self parseRawData:data];
    }
    return self;
}


- (void)parseRawData:(NSDictionary *)data {
    _hasTitle = [[data objectForKey:@"hasTitle"] boolValue];
    if (self.hasTitle) {
        HomeTitleCellType titleType = (HomeTitleCellType)[[data objectForKey:@"titleType"] integerValue];
        switch (titleType) {
            case HomeTitleCellTypeNormalTitle:
            {
                _titleModel = [[HomeNormalTitleCellModel alloc] initWithRawData:[data objectForKey:@"titleContent"]];
                
            }
                break;
            case HomeTitleCellTypeCountDownTitle:
            {
                _titleModel = [[HomeCountDownTitleCellModel alloc] initWithRawData:[data objectForKey:@"titleContent"]];
            }
                break;
            case HomeTitleCellTypeMoreTitle:
            {
                _titleModel = [[HomeMoreTitleCellModel alloc] initWithRawData:[data objectForKey:@"titleContent"]];
            }
                break;
            case HomeTitleCellTypeCountDownMoreTitle:
            {
                _titleModel = [[HomeCountDownMoreTitleCellModel alloc] initWithRawData:[data objectForKey:@"titleContent"]];
            }
                break;
            default:
                break;
        }
    }
    HomeContentCellType contentType = (HomeContentCellType)[[data objectForKey:@"contentType"] integerValue];
    switch (contentType) {
        case HomeContentCellTypeBanner:
        {
            _contentModel = [[HomeBannerCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        case HomeContentCellTypeTwinklingElf:
        {
            _contentModel = [[HomeTwinklingElfCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        case HomeContentCellTypeHorizontalList:
        {
            _contentModel = [[HomeHorizontalListCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        case HomeContentCellTypeThree:
        {
            _contentModel = [[HomeThreeCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        case HomeContentCellTypeTwoColumn:
        {
            _contentModel = [[HomeTwoColumnCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        case HomeContentCellTypeNews:
        {
            _contentModel = [[HomeNewsCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        case HomeContentCellTypeImageNews:
        {
            _contentModel = [[HomeImageNewsCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        case HomeContentCellTypeThreeImageNews:
        {
            _contentModel = [[HomeThreeImageNewsCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        case HomeContentCellTypeWholeImageNews:
        {
            _contentModel = [[HomeWholeImageNewsCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        case HomeContentCellTypeNotice:
        {
            _contentModel = [[HomeNoticeCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        case HomeContentCellTypeBigImageTwoDesc:
        {
            _contentModel = [[HomeBigImageTwoDescCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        case HomeContentCellTypeTwoThreeFour:
        {
            _contentModel = [[HomeTwoThreeFourCellModel alloc] initWithRawData:[data objectForKey:@"contents"]];
        }
            break;
        default:
            break;
    }
    [_contentModel setRatio:[[data objectForKey:@"ratio"] floatValue]];
    _marginTop = [[data objectForKey:@"marginTop"] floatValue];
}

@end
