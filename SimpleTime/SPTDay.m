//
//  SPTDay.m
//  SimpleTime
//
//  Created by Lumi on 14-8-12.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTDay.h"

@interface SPTDay ()
@property (nonatomic, strong) NSMutableArray *privateIssues;
@end

@implementation SPTDay

- (instancetype)init
{
    self = [super init];
    if (self) {
        _date = [NSDate date];
        _privateIssues = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        _date = date;
        _privateIssues = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)issues
{
    return [self.privateIssues copy];
}

- (void)addIssue:(SPTIssue *)issue
{
    [self.privateIssues addObject:issue];
}

- (NSString *)description
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    return [dateFormatter stringFromDate:self.date];
}

@end
