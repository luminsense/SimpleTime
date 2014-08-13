//
//  SPTEvent.h
//  SimpleTime
//
//  Created by Lumi on 14-8-12.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SPTEvent : NSManagedObject

typedef NS_ENUM(NSInteger, SPTEventType) {
    SPTEventTypeNone            = 0,
    SPTEventTypeWork            = 1,
    SPTEventTypeWorkout         = 2,
    SPTEventTypeFun             = 3,
    SPTEventTypeSleep           = 4,
    SPTEventTypeDining          = 5,
    SPTEventTypeTransportation  = 6,
    SPTEventTypeRead            = 7,
    SPTEventTypePersonal        = 8,
    SPTEventTypeHome            = 9
};

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *beginDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic) BOOL isFinished;
@property (nonatomic) SPTEventType eventType;

+ (NSString*)entityName;

- (void)finishEvent;

@end