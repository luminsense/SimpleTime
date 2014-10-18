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
#import "SPTEventCell.h"

@interface SPTHistoryViewController () <MZDayPickerDelegate, MZDayPickerDataSource, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet MZDayPicker *dayPicker;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PNPieChart *pieChart;
@property (nonatomic, strong) NSDateFormatter *weekdayFormatter;
@property (nonatomic, strong) NSDateFormatter *monthFormatter;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) NSDate *earliestDate;

@end

@implementation SPTHistoryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _earliestDate = [NSDate dateFromDay:1 month:1 year:2000];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentDate = [NSDate date];
    self.events = [[SPTEventStore sharedStore] getEventsForDate:self.currentDate];
    
    self.weekdayFormatter = [[NSDateFormatter alloc] init];
    [self.weekdayFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [self.weekdayFormatter setDateFormat:@"EE"];
    
    self.monthFormatter = [[NSDateFormatter alloc] init];
    [self.monthFormatter setDateFormat:@"MMMM YYYY"];
    [self.monthFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [self updateTitleLabel];
    
    // Add label
    float inset = 15.0;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, 20, [UIScreen mainScreen].bounds.size.width - inset * 2, 44)];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    // Add close button
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(11, 20, 44, 44)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"newEventCancelButton.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    // Load day picker
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    self.dayPicker.dayNameLabelFontSize = 12.0f;
    self.dayPicker.dayLabelFontSize = 18.0f;
    self.dayPicker.activeDayColor = [SPTColor labelColorDark];
    self.dayPicker.inactiveDayColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
    self.dayPicker.activeDayNameColor = [SPTColor labelColorLight];
    self.dayPicker.bottomBorderColor = [SPTColor separatorColor];
    //self.dayPicker.dayCellFooterHeight = 2.0;
    [self.dayPicker setStartDate:self.earliestDate endDate:self.currentDate];
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
    self.tableView.allowsSelection = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 75, 0, 0);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
    
    // Register cell for table view
    UINib *nib = [UINib nibWithNibName:@"SPTEventCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SPTEventCell"];
    
    // Load header view of table view
    CGRect headerFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 280);
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    float pieChartWidth = 220.0;
    
    // Load pie chart
    NSArray *items = [self getDataItemsFromEvents:self.events inDate:self.currentDate];
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - pieChartWidth) / 2, 30.0, pieChartWidth, pieChartWidth) items:items];
    self.pieChart.descriptionTextColor = [UIColor clearColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.duration = 0.5;
    [self.tableView.tableHeaderView addSubview:self.pieChart];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 279.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    separator.backgroundColor = [SPTColor separatorColor];
    [self.tableView.tableHeaderView addSubview:separator];
    
    // Setting swipe recognizer
    self.swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeftInTableView:)];
    self.swipeLeftRecognizer.numberOfTouchesRequired = 1;
    [self.swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.tableView addGestureRecognizer:self.swipeLeftRecognizer];
    
    self.swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRightInTableView:)];
    self.swipeRightRecognizer.numberOfTouchesRequired = 1;
    [self.swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:self.swipeRightRecognizer];
    
    // Load separator view
    self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.dayPicker.frame.origin.y + self.dayPicker.frame.size.height, [UIScreen mainScreen].bounds.size.width, 0.5)];
    self.separatorView.backgroundColor = [SPTColor separatorColor];
    self.separatorView.alpha = 0;
    [self.view addSubview:self.separatorView];
    /*
    UIView *dayPickerSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, self.dayPicker.frame.origin.y + self.dayPicker.frame.size.height - 2, [UIScreen mainScreen].bounds.size.width, 0.5)];
    dayPickerSeparator.backgroundColor = [SPTColor mainColor];
    [self.view addSubview:dayPickerSeparator];
     */
    
}

- (void)viewDidAppear:(BOOL)animated
{
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
    self.currentDate = day.date;
    [self updateEverythingWithCurrentDate];
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
    [self.pieChart strokeChart];
}

- (void)updateEverythingWithCurrentDate
{
    self.events = [[SPTEventStore sharedStore] getEventsForDate:self.currentDate];
    [self updateTitleLabel];
    [self refreshPieChartWithCurrentDate];
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - Swipe Gesture Handling

- (void)swipedLeftInTableView:(UISwipeGestureRecognizer *)gr
{
    NSDateComponents *todayComp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *currentComp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.currentDate];
    
    if (!(todayComp.year == currentComp.year && todayComp.month == currentComp.month && todayComp.day == currentComp.day)) {
        NSTimeInterval secondsInDay = 60 * 60 * 24;
        self.currentDate = [NSDate dateWithTimeInterval:secondsInDay sinceDate:self.currentDate];
        [self.dayPicker setCurrentDate:self.currentDate animated:YES];
        [self updateEverythingWithCurrentDate];
    }
}

- (void)swipedRightInTableView:(UISwipeGestureRecognizer *)gr
{
    NSDateComponents *earlistComp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.earliestDate];
    NSDateComponents *currentComp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.currentDate];
    
    if (!(earlistComp.year == currentComp.year && earlistComp.month == currentComp.month && earlistComp.day == currentComp.day)) {
        NSTimeInterval secondsInDay = 60 * 60 * 24;
        self.currentDate = [NSDate dateWithTimeInterval:-secondsInDay sinceDate:self.currentDate];
        [self.dayPicker setCurrentDate:self.currentDate animated:YES];
        [self updateEverythingWithCurrentDate];
    }
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPTEventCell *cell = (SPTEventCell *)[tableView dequeueReusableCellWithIdentifier:@"SPTEventCell" forIndexPath:indexPath];
    SPTEvent *thisEvent = (SPTEvent *)self.events[indexPath.row];
    
    cell.eventTitleLabel.text = thisEvent.title;
    cell.eventTypeImageView.image = [self eventImageForType:thisEvent.eventTypeRaw];
    
    // Configure duration
    NSDateComponents *diff = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute
                                                             fromDate:thisEvent.beginDate
                                                               toDate:thisEvent.endDate
                                                              options:0];
    NSString *durationText;
    if (diff.hour == 0) {
        durationText = [NSString stringWithFormat:@"%ld min", diff.minute];
    } else {
        durationText = [NSString stringWithFormat:@"%ld hrs %ld min", diff.hour, diff.minute];
    }
    cell.eventDurationLabel.text = durationText;
    
    // Configure begin and end time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    
    cell.eventBeginTimeLabel.text = [formatter stringFromDate:thisEvent.beginDate];
    cell.eventEndTimeLabel.text = [formatter stringFromDate:thisEvent.endDate];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SPTEvent *thisEvent = (SPTEvent *)self.events[indexPath.row];
        [[SPTEventStore sharedStore] removeEvent:thisEvent];
        self.events = [[SPTEventStore sharedStore] getEventsForDate:self.currentDate];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self refreshPieChartWithCurrentDate];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 30) {
        [UIView animateWithDuration:0.3 animations:^{
            self.separatorView.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.separatorView.alpha = 1;
        }];
    }
}

- (UIImage *)eventImageForType:(SPTEventType)type
{
    UIImage *image;
    switch (type) {
        case SPTEventTypeNone:
            image = [UIImage imageNamed:@"eventTypeNoneIcon.png"];
            break;
        case SPTEventTypeWork:
            image = [UIImage imageNamed:@"eventTypeWorkIcon.png"];
            break;
        case SPTEventTypeStudy:
            image = [UIImage imageNamed:@"eventTypeStudyIcon.png"];
            break;
        case SPTEventTypeFun:
            image = [UIImage imageNamed:@"eventTypeFunIcon.png"];
            break;
        case SPTEventTypeSleep:
            image = [UIImage imageNamed:@"eventTypeSleepIcon.png"];
            break;
        case SPTEventTypeWorkout:
            image = [UIImage imageNamed:@"eventTypeWorkoutIcon.png"];
            break;
        case SPTEventTypeDining:
            image = [UIImage imageNamed:@"eventTypeDiningIcon.png"];
            break;
        case SPTEventTypeRead:
            image = [UIImage imageNamed:@"eventTypeReadIcon.png"];
            break;
        case SPTEventTypeTransport:
            image = [UIImage imageNamed:@"eventTypeTransportIcon.png"];
            break;
        case SPTEventTypeRelax:
            image = [UIImage imageNamed:@"eventTypeRelaxIcon.png"];
            break;
        default:
            image = [UIImage imageNamed:@"eventTypeNoneIcon.png"];
            break;
    }
    return image;
}

#pragma mark - Get pie chart items from events

- (NSArray *)getDataItemsFromEvents:(NSArray *)events inDate:(NSDate *)date
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    //NSLog(@">>>> Events Count: %lu", (unsigned long)events.count);
    
    if (events.count == 0) {
        [items addObject:[PNPieChartDataItem dataItemWithValue:10 color:[SPTColor pieChartBackgroundColor] description:@"Test"]];
        return items;
    }
    
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
    
    // Basic variabled
    int last = (int)events.count - 1;
    NSTimeInterval secOfDay = 60 * 60 * 24 - 1;
    
    for (int i = 0; i < events.count; i++) {
        
        SPTEvent *event = (SPTEvent *)events[i];
        
        NSTimeInterval eventBeginSec = [event.beginDate timeIntervalSinceDate:startOfDay];
        NSTimeInterval eventEndSec = [event.endDate timeIntervalSinceDate:startOfDay];
        
        // For test
        /*
        NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:event.beginDate];
        NSLog(@"BeginTime: %ld %ld %ld %ld:%ld:%ld", comp.year, comp.month, comp.day, comp.hour, comp.minute, comp.second);
        comp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:startOfDay];
        NSLog(@"Start Of Day: %ld %ld %ld %ld:%ld:%ld", comp.year, comp.month, comp.day, comp.hour, comp.minute, comp.second);
         */
        
        if (i == 0) {
            if ([event.beginDate compare:startOfDay] == NSOrderedAscending) {
                eventBeginSec = 0;
            } else {
                // Add an empty duration from 00:00:00 to beginDate
                [items addObject:[PNPieChartDataItem dataItemWithValue:eventBeginSec / secOfDay
                                                                 color:[SPTColor pieChartBackgroundColor]]];
            }
        }
        
        if (i == last) {
            //NSLog(@"%@ is the last item", event.title);
            if ([event.endDate compare:endOfDay] == NSOrderedDescending) {
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
    
    //NSLog(@">>>> Items Count: %lu", (unsigned long)items.count);
    
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
