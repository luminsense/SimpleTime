//
//  TESTPieChartViewController.m
//  SimpleTime
//
//  Created by Lumi on 14-8-19.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "TESTPieChartViewController.h"
#import "SPTEvent.h"
#import "SPTEventStore.h"
#import "PNChart.h"
#import "SPTColor.h"

@interface TESTPieChartViewController ()
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) PNPieChart *pieChart;
@end

@implementation TESTPieChartViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.events = [[SPTEventStore sharedStore] getEventsForDate:self.date];
    NSArray *items = [self getDataItemsFromEvents:self.events inDate:self.date];
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor clearColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    [self.pieChart strokeChart];
    [self.view addSubview:self.pieChart];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //[self.view addSubview:self.pieChart];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (IBAction)refresh:(id)sender
{
    NSTimeInterval secOfDay = 60 * 60 * 24 + 1;
    self.date = [NSDate dateWithTimeInterval:secOfDay sinceDate:self.date];
    self.events = [[SPTEventStore sharedStore] getEventsForDate:self.date];
    NSArray *items = [self getDataItemsFromEvents:self.events inDate:self.date];
    
    [self.pieChart setValue:items forKey:@"items"];
    
    [self.pieChart strokeChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getDataItemsFromEvents:(NSArray *)events inDate:(NSDate *)date
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSLog(@"Events Count: %lu", (unsigned long)events.count);
    
    if (events.count == 0) {
        [items addObject:[PNPieChartDataItem dataItemWithValue:1 color:[SPTColor pieChartBackgroundColor]]];
        return items;
    }
    
    // Get start of day
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    [components setNanosecond:0];
    NSDate *startOfDay = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    // Get end of day
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    NSDate *endOfDay = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    // Basic variabled
    int last = (int)events.count - 1;
    NSTimeInterval secOfDay = 60 * 60 * 24 - 1;
    
    for (int i = 0; i < events.count; i++) {
        
        SPTEvent *event = (SPTEvent *)events[i];
        
        NSTimeInterval eventBeginSec = [event.beginDate timeIntervalSinceDate:startOfDay];
        NSTimeInterval eventEndSec = [event.endDate timeIntervalSinceDate:startOfDay];
        
        if (i == 0) {
            if (event.beginDate < startOfDay) {
                eventBeginSec = 0;
            } else {
                // Add an empty duration from 00:00:00 to beginDate
                [items addObject:[PNPieChartDataItem dataItemWithValue:eventBeginSec / secOfDay
                                                                 color:[SPTColor pieChartBackgroundColor]]];
            }
        }
        
        if (i == last) {
            if (event.endDate > endOfDay) {
                // Add this event as eventBeginSec - 24:59:59
                eventEndSec = [endOfDay timeIntervalSinceDate:startOfDay];
                [items addObject:[PNPieChartDataItem dataItemWithValue:(eventEndSec - eventBeginSec) / secOfDay
                                                                 color:[SPTColor colorForEventType:event.eventTypeRaw]]];
            } else {
                // Add this event as eventBeginSec - eventEndSec
                [items addObject:[PNPieChartDataItem dataItemWithValue:(eventEndSec - eventBeginSec) / secOfDay
                                                                 color:[SPTColor colorForEventType:event.eventTypeRaw]]];
                // Add an empty duration from eventEndSec - 23:59:59
                NSTimeInterval endOfDaySec = [endOfDay timeIntervalSinceDate:startOfDay];
                [items addObject:[PNPieChartDataItem dataItemWithValue:(endOfDaySec - eventEndSec) / secOfDay
                                                                 color:[SPTColor pieChartBackgroundColor]]];
            }
        } else {
            [items addObject:[PNPieChartDataItem dataItemWithValue:(eventEndSec - eventBeginSec) / secOfDay
                                                             color:[SPTColor colorForEventType:event.eventTypeRaw]]];
            SPTEvent *nextEvent = (SPTEvent *)events[i+1];
            NSTimeInterval nextEventBeginSec = [nextEvent.beginDate timeIntervalSinceDate:startOfDay];
            [items addObject:[PNPieChartDataItem dataItemWithValue:(nextEventBeginSec - eventEndSec) / secOfDay
                                                             color:[SPTColor pieChartBackgroundColor]]];
        }
        
    }
    
    return items;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
