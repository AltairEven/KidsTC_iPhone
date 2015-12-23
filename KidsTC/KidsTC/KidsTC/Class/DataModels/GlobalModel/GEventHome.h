//
//  GEventHome.h
//  iphone51buy
//
//  Created by icson apple on 12-6-1.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	GEventTemplateType0 = 0,
	GEventTemplateType1 = 1,
	GEventTemplateType2 = 2,
	GEventTemplateType3 = 3,
    GEventTemplateType4 = 4,
    GEventTemplateType5 = 5
} GEventTemplate;

@interface GEventHome : NSObject
@property (nonatomic) NSInteger eventId;
@property (strong, nonatomic) NSString *eventPic;
@property (nonatomic) GEventTemplate eventTemplate;

-(id)initWithEventId:(NSInteger)_eventId eventPic:(NSString *)_eventPic eventTemplate:(GEventTemplate)_eventTemplate;
@end
