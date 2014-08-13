//
//  SPTEvent.m
//  SimpleTime
//
//  Created by Lumi on 14-8-12.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTEvent.h"


@implementation SPTEvent

@dynamic title;
@dynamic beginDate;
@dynamic endDate;
@dynamic isFinished;
@dynamic eventType;

+ (NSString *)entityName
{
    return @"SPTEvent";
}

- (void)finishEvent
{
    self.isFinished = YES;
    self.endDate = [NSDate date];
}

/*
- (void)updateDateComponentsWithCalendar:(NSCalendar *)calendar
{
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.beginDate];
    self.beginYear = components.year;
    self.beginMonth = components.month;
    self.beginDay = components.day;
    
    components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.endDate];
    self.endYear = components.year;
    self.endMonth = components.month;
    self.endDay = components.day;
}

- (void)updateDateComponentsWithCurrentCalendar
{
    [self updateDateComponentsWithCalendar:[NSCalendar currentCalendar]];
}
*/

@end
