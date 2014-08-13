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

@end
