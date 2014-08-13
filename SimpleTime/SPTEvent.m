//
//  SPTEvent.m
//  SimpleTime
//
//  Created by Lumi on 14-8-13.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTEvent.h"


@implementation SPTEvent

@dynamic beginDate;
@dynamic endDate;
@dynamic eventType;
@dynamic isFinished;
@dynamic title;

+ (NSString *)entityName
{
    return @"SPTEvent";
}

- (SPTEventType)eventTypeRaw
{
    return (SPTEventType)[[self eventType] intValue];
}

- (void)setEventTypeRaw:(SPTEventType)type
{
    [self setEventType:[NSNumber numberWithInt:type]];
}

- (void)finishEvent
{
    self.isFinished = YES;
    self.endDate = [NSDate date];
}

@end
