//
//  SPTEventStore.m
//  SimpleTime
//
//  Created by Lumi on 14-8-13.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTEventStore.h"

@interface SPTEventStore ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@end

@implementation SPTEventStore

#pragma mark - Singleton Initialization

+ (instancetype)sharedStore
{
    static SPTEventStore *sharedStore;
    
    // Make thread safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use + [SPTEventStore sharedStore"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        // Add persistent store to the coordinator
        NSError *error;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open Failure" format:@"%@", [error localizedDescription]];
        }
        
        // Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        // Load current event in data base
        [self loadCurrentEvent];
    }
    return self;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"events.data"];
}

#pragma mark - Cuurent Event

- (BOOL)hasCurrentEvent
{
    if (self.currentEvent == nil) {
        return NO;
    } else {
        return YES;
    }
}

- (void)finishCurrentEvent
{
    [self.currentEvent finishEvent];
    [self saveChanges];
    self.currentEvent = nil;
}

- (void)loadCurrentEvent
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:[SPTEvent entityName] inManagedObjectContext:self.context];
    request.entity = e;
    
    request.predicate = [NSPredicate predicateWithFormat:@"isFinished == NO"];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"beginDate" ascending:NO];
    request.sortDescriptors = @[sd];

    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch current event failed" format:@"Reason: %@", [error localizedDescription]];
    }

    if (result.count == 0) {
        self.currentEvent = nil;
    } else {
        self.currentEvent = result[0];
        if (result.count > 1) {
            NSLog(@"Potential mistake in database: there's more than one current event, should only have one.");
        }
    }
    NSLog(@"Current event: %@.", self.currentEvent.title);
}

#pragma mark - Add Events

// Testing adding method
- (SPTEvent *)addEventWithTitle:(NSString *)title
                        beginDate:(NSDate *)beginDate
                          endDate:(NSDate *)endDate
                        eventType:(SPTEventType)type
{
    SPTEvent *event = [NSEntityDescription insertNewObjectForEntityForName:[SPTEvent entityName] inManagedObjectContext:self.context];
    event.title = title;
    event.beginDate = beginDate;
    event.endDate = endDate;
    [event setEventTypeRaw:type];
    
    // Testing events must be finished already
    // Or it will cause error in [self loadCurrentEvent] next time the app launches
    [event setIsFinishedRaw:YES];
    
    [self saveChanges];
    return event;
}

// Realworld adding method
// Note: this method will automatically set event's beginDate as current date and set it as currentEvent
- (SPTEvent *)addEventWithTitle:(NSString *)title
                        eventType:(SPTEventType)type
{
    SPTEvent *event = [NSEntityDescription insertNewObjectForEntityForName:[SPTEvent entityName] inManagedObjectContext:self.context];
    event.title = title;
    [event setEventTypeRaw:type];
    [event setIsFinishedRaw:NO];        // Raw event must not be finished
    event.beginDate = [NSDate date];    // Event begins now
    event.endDate = event.beginDate;    // Temporarily no endDate
    
    self.currentEvent = event;          // Event is the current event
    [self saveChanges];
    
    return event;
}

- (void)removeEvent:(SPTEvent *)event
{
    [self.context deleteObject:event];
    [self saveChanges];
}

#pragma mark - Get events

- (NSArray *)getEventsForDate:(NSDate *)date
{
    // Get start of day
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *startOfDay = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    // Get end of day
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    NSDate *endOfDay = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    // Create the request with entity description
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:[SPTEvent entityName] inManagedObjectContext:self.context];
    request.entity = e;
    
    // Set sort descriptor and predicate
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"beginDate" ascending:YES];
    request.sortDescriptors = @[sd];
    request.predicate = [NSPredicate predicateWithFormat:@"((beginDate > %@ AND beginDate < %@) OR (endDate > %@ AND endDate < %@) OR (beginDate < %@ AND endDate > %@)) AND isFinished == YES", startOfDay, endOfDay, startOfDay, endOfDay, startOfDay, endOfDay];
    
    // Excute fetch request
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch events for date failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    return result;
}

- (NSArray *)getAllEvents
{
    // Create the request with entity description
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:[SPTEvent entityName] inManagedObjectContext:self.context];
    request.entity = e;
    
    // Set sort descriptor and predicate
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"beginDate" ascending:NO];
    request.sortDescriptors = @[sd];
    
    // Excute fetch request
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch all events failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    return result;
}

#pragma mark - Save changes

- (BOOL)saveChanges
{
    NSLog(@"Start Saving...");
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    } else {
        NSLog(@"Save Successful");
    }
    return successful;
}

@end
