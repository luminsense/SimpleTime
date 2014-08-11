//
//  SPTIssuesStore.h
//  SimpleTime
//
//  Created by Lumi on 14-8-12.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SPTIssue;

@interface SPTIssuesStore : NSObject

@property (nonatomic, strong) NSArray *days;
@property (nonatomic, strong) SPTIssue *currentIssue;
@property (nonatomic) NSTimeInterval *currentIssueLastTime;

+ (instancetype)sharedStore;
- (NSArray *)allDays;


@end
