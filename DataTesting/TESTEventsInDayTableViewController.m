//
//  TESTEventsInDayTableViewController.m
//  SimpleTime
//
//  Created by Lumi on 14-8-14.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "TESTEventsInDayTableViewController.h"
#import "SPTEvent.h"
#import "SPTEventStore.h"

@interface TESTEventsInDayTableViewController ()
@property (nonatomic, strong) NSArray *events;
@end

@implementation TESTEventsInDayTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.events = [[SPTEventStore sharedStore] getEventsForDate:self.date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TESTCell" forIndexPath:indexPath];
    
    SPTEvent *thisEvent = (SPTEvent *)self.events[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", thisEvent.title, thisEvent.eventType];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSString *beginDateString = [dateFormatter stringFromDate:thisEvent.beginDate];
    NSString *endDateString = [dateFormatter stringFromDate:thisEvent.endDate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", beginDateString, endDateString];
    
    return cell;
    
    return cell;
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
