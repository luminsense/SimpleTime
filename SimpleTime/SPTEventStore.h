//
//  SPTEventStore.h
//  SimpleTime
//
//  Created by Lumi on 14-8-13.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SPTEvent.h"

@interface SPTEventStore : NSObject

@property (nonatomic, strong) SPTEvent *currentEvent;

+ (instancetype)sharedStore;

- (BOOL)hasCurrentEvent;
- (void)finishCurrentEvent;
- (void)loadCurrentEvent;

// Testing adding method
- (SPTEvent *)addEventWithTitle:(NSString *)title
                      beginDate:(NSDate *)beginDate
                        endDate:(NSDate *)endDate
                      eventType:(SPTEventType)type;

// Realworld adding method
- (SPTEvent *)addEventWithTitle:(NSString *)title
                      eventType:(SPTEventType)type;

- (NSArray *)getEventsForDate:(NSDate *)date;
- (NSArray *)getAllEvents;
- (BOOL)saveChanges;

@end
