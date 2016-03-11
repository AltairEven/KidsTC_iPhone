//
//  FlashStageModel.h
//  KidsTC
//
//  Created by Altair on 2/29/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FlashStageNotReached = 1,
    FlashStageProcessing,
    FlashStageHasDone,
    FlashStageCurrentHasDone
}FlashStage;

@interface FlashStageModel : NSObject

@property (nonatomic, strong) UIImage *bgImage;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) NSUInteger peopleCount;

@property (nonatomic, assign) FlashStage stage;

@property (nonatomic, copy) NSString *stageDescription;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
