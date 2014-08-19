//
//  TESTQueryDateViewController.m
//  SimpleTime
//
//  Created by Lumi on 14-8-14.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "TESTQueryDateViewController.h"
#import "TESTEventsInDayTableViewController.h"
#import "TESTPieChartViewController.h"

@interface TESTQueryDateViewController ()

@property (weak, nonatomic) IBOutlet UITextField *yearLabel;
@property (weak, nonatomic) IBOutlet UITextField *monthLabel;
@property (weak, nonatomic) IBOutlet UITextField *dayLabel;

@end

@implementation TESTQueryDateViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowEventsInDay"]) {
        
        TESTEventsInDayTableViewController *tableViewController = (TESTEventsInDayTableViewController *)[segue destinationViewController];
        
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:[self.yearLabel.text integerValue]];
        [components setMonth:[self.monthLabel.text integerValue]];
        [components setDay:[self.dayLabel.text integerValue]];
        NSDate *destDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        tableViewController.date = destDate;
        
    } else if ([segue.identifier isEqualToString:@"ShowPieChartOfDay"]) {
        
        TESTPieChartViewController *pieChartViewController = (TESTPieChartViewController *)[segue destinationViewController];
        
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:[self.yearLabel.text integerValue]];
        [components setMonth:[self.monthLabel.text integerValue]];
        [components setDay:[self.dayLabel.text integerValue]];
        NSDate *destDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        pieChartViewController.date = destDate;
        
    }
}


@end
