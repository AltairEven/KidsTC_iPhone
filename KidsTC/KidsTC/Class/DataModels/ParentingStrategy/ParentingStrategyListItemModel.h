//
//  ParentingStrategyListItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ParentingStrategyListTagNone,
    ParentingStrategyListTagRecommend,
    ParentingStrategyListTagHot,
    ParentingStrategyListTagRNH
}ParentingStrategyListTag;

@interface ParentingStrategyListItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *editorFaceImageUrl;
@property (nonatomic, copy) NSString *editorName;
@property (nonatomic, assign) NSUInteger viewCount;
@property (nonatomic, assign) NSUInteger commentCount;
@property (nonatomic, assign) ParentingStrategyListTag listTag;
@property (nonatomic, assign) NSUInteger likeCount;
@property (nonatomic, copy) NSString *brief;

@property (nonatomic, assign) CGFloat imageRatio;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)cellHeight;

@end
