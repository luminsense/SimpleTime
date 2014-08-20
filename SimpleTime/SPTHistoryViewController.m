//
//  SPTHistoryViewController.m
//  SimpleTime
//
//  Created by Lumi on 14-8-20.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTHistoryViewController.h"
#import "MZDaypicker.h"
#import "SPTEventStore.h"
#import "PNChart.h"
#import "SPTColor.h"

@interface SPTHistoryViewController () <MZDayPickerDelegate, MZDayPickerDataSource, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet MZDayPicker *dayPicker;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PNPieChart *pieChart;
@property (nonatomic, strong) NSDateFormatter *weekdayFormatter;
@property (nonatomic, strong) NSDateFormatter *monthFormatter;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSArray *events;

@end

@implementation SPTHistoryViewController

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
    self.currentDate = [NSDate date];
    self.events = [[SPTEventStore sharedStore] getEventsForDate:self.currentDate];
    
    self.weekdayFormatter = [[NSDateFormatter alloc] init];
    [self.weekdayFormatter setDateFormat:@"EEE"];
    
    self.monthFormatter = [[NSDateFormatter alloc] init];
    [self.monthFormatter setDateFormat:@"MMMM YYYY"];
    
    [self updateTitleLabel];
    
    // Add close button
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 24, 36, 36)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"newEventCancelButton.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    /*
    // Add bar button item
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    self.navigationItem.leftBarButtonItem = closeButtonItem;
     */
    
    // Load day picker
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    self.dayPicker.dayNameLabelFontSize = 12.0f;
    self.dayPicker.dayLabelFontSize = 18.0f;
    self.dayPicker.activeDayColor = [UIColor blackColor];
    self.dayPicker.inactiveDayColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
    self.dayPicker.activeDayNameColor = [UIColor lightGrayColor];
    self.dayPicker.bottomBorderColor = [SPTColor mainColor];
    //self.dayPicker.dayCellFooterHeight = 2.0;
    [self.dayPicker setStartDate:[NSDate dateFromDay:1 month:1 year:2000] endDate:self.currentDate];
    [self.dayPicker setCurrentDate:self.currentDate animated:NO];
    
    // Configure frame of day picker
    CGRect originalFrame = self.dayPicker.frame;
    CGRect newFrame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, [UIScreen mainScreen].bounds.size.width, originalFrame.size.height);
    self.dayPicker.frame = newFrame;
    
    // Load table view
    CGRect tableViewFrame = CGRectMake(0,
                                       newFrame.origin.y + newFrame.size.height,
                                       [UIScreen mainScreen].bounds.size.width,
                                       [UIScreen mainScreen].bounds.size.height - (newFrame.origin.y + newFrame.size.height));
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
    
    // Load header view of table view
    CGRect headerFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    // Load pie chart
    NSArray *items = [self getDataItemsFromEvents:self.events inDate:self.currentDate];
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 40.0, 240.0, 240.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor clearColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.duration = 0.5;
    [self.tableView.tableHeaderView addSubview:self.pieChart];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Pie chart should first stroke");
    [self.pieChart strokeChart];
}

#pragma mark - Day Picker Data Source and Delegate

- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    //return @"Test";
    NSString *weekday = [self.weekdayFormatter stringFromDate:day.date];
    return [weekday uppercaseString];
}

- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    NSLog(@"Picker did select day");
    self.currentDate = day.date;
    self.events = [[SPTEventStore sharedStore] getEventsForDate:self.currentDate];
    [self updateTitleLabel];
    [self refreshPieChartWithCurrentDate];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Update Components with Current Date

- (void)updateTitleLabel
{
    NSString *newText = [self.monthFormatter stringFromDate:self.currentDate];
    if (![newText isEqualToString:self.titleLabel.text]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.titleLabel.alpha = 0;
        } completion:^(BOOL finished){
            self.titleLabel.text = newText;
            [UIView animateWithDuration:0.3 animations:^{
                self.titleLabel.alpha = 1;
            } completion:NULL];
        }];
    }
}

- (void)refreshPieChartWithCurrentDate
{
    NSArray *items = [self getDataItemsFromEvents:self.events inDate:self.currentDate];
    [self.pieChart setValue:items forKey:@"items"];
    NSLog(@"Items Count: %ld", items.count);
    [self.pieChart strokeChart];
}

#pragma mark - Table View Data Source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    SPTEvent *thisEvent = (SPTEvent *)self.events[indexPath.row];
    cell.textLabel.text = thisEvent.title;
    return cell;
}

#pragma mark - Get pie chart items from events

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

- (void)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
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
