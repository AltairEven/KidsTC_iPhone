//
//  GEventHome.m
//  iphone51buy
//
//  Created by icson apple on 12-6-1.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GEventHome.h"

@implementation GEventHome
@synthesize eventId, eventPic, eventTemplate;
-(id)initWithEventId:(NSInteger)_eventId eventPic:(NSString *)_eventPic eventTemplate:(GEventTemplate)_eventTemplate
{
	if (self = [super init]) {
		self.eventId = _eventId;
		self.eventPic = _eventPic;
		self.eventTemplate = _eventTemplate;
	}

	return self;
}


@end
