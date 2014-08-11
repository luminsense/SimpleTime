//
//  SPTDay.h
//  SimpleTime
//
//  Created by Lumi on 14-8-12.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPTIssue;

@interface SPTDay : NSObject

@property (nonatomic, strong) NSArray *issues;
@property (nonatomic, strong) NSDate *date;

- (instancetype)initWithDate:(NSDate *)date;
- (void)addIssue:(SPTIssue *)issue;


@end
