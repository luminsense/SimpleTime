//
//  SPTIssuesStore.m
//  SimpleTime
//
//  Created by Lumi on 14-8-12.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTIssuesStore.h"
#import "SPTDay.h"
#import "SPTIssue.h"

@interface SPTIssuesStore ()
@property (nonatomic, strong) NSMutableArray *privateDays;
@end

@implementation SPTIssuesStore

+ (instancetype)sharedStore
{
    static SPTIssuesStore *sharedStore;
    
    // Make thread safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

// [[LNGItemStore alloc] init] will create an error
- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use + [SPTIssuesStore sharedStore"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        // TODO: Load items from archives or database
        _privateDays = [[NSMutableArray alloc] init];
        
        _currentIssue = nil;
        _currentIssueLastTime = nil;
        
        // Load Fake Data
        [self loadFakeData];
        
        NSLog(@"Created Issues Store");
    }
    return self;
}

- (NSArray *)allDays
{
    return [self.privateDays copy];
}

#pragma mark - Load Fake Data

- (void)loadFakeData
{
    SPTDay *firstDay = [[SPTDay alloc] init];
    
    SPTIssue *issue01 = [[SPTIssue alloc] initWithDescription:@"Created Issue #01"];
    issue01.isFinished = YES;
    issue01.timeEnded = [NSDate date];
    [firstDay addIssue:issue01];
    
    SPTIssue *issue02 = [[SPTIssue alloc] initWithDescription:@"Created Issue #02"];
    issue02.isFinished = YES;
    issue02.timeEnded = [NSDate date];
    [firstDay addIssue:issue02];
    
    SPTIssue *issue03 = [[SPTIssue alloc] initWithDescription:@"Created Issue #03"];
    issue03.isFinished = YES;
    issue03.timeEnded = [NSDate date];
    [firstDay addIssue:issue03];
    
    SPTDay *secondDay = [[SPTDay alloc] init];
    
    SPTIssue *issue04 = [[SPTIssue alloc] initWithDescription:@"Created Issue #04"];
    issue04.isFinished = YES;
    issue04.timeEnded = [NSDate date];
    [secondDay addIssue:issue04];
    
    SPTIssue *issue05 = [[SPTIssue alloc] initWithDescription:@"Created Issue #05"];
    issue05.isFinished = YES;
    issue05.timeEnded = [NSDate date];
    [secondDay addIssue:issue05];
    
    [_privateDays addObject:firstDay];
    [_privateDays addObject:secondDay];

}

@end
