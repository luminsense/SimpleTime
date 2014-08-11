//
//  SPTIssue.m
//  SimpleTime
//
//  Created by Lumi on 14-8-12.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTIssue.h"

@implementation SPTIssue

- (instancetype)initWithDescription:(NSString *)description
{
    self = [self init];
    if (self) {
        _description = [description copy];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeCreated = [NSDate date];
        _isFinished = NO;
        _timeEnded = [[NSDate alloc] init];
        _description = [[NSString alloc] init];
    }
    return self;
}

@end
