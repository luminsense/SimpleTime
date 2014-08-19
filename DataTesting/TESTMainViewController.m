//
//  TESTMainViewController.m
//  SimpleTime
//
//  Created by Lumi on 14-8-13.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "TESTMainViewController.h"
#import "SPTEventStore.h"
#import "MZTimerLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "SPTEventTypeSelectView.h"
#import "VWWWaterView.h"

@interface TESTMainViewController () <UITextFieldDelegate, SPTEventTypeSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *currentEventTitleField;
@property (weak, nonatomic) IBOutlet UILabel *currentEventStartDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *currentEventFinishButton;
@property (strong, nonatomic) MZTimerLabel *currentEventTimer;
@property (weak, nonatomic) IBOutlet UILabel *eventTypeTestingLabel;

@end

@implementation TESTMainViewController

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
    
    self.currentEventTimer = [[MZTimerLabel alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 40)];
    self.currentEventTimer.timerType = MZTimerLabelTypeStopWatch;
    self.currentEventTimer.timeLabel.backgroundColor = [UIColor clearColor];
    self.currentEventTimer.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:28];
    self.currentEventTimer.timeLabel.textColor = [UIColor blackColor];
    self.currentEventTimer.timeLabel.textAlignment = NSTextAlignmentCenter; //UITextAlignmentCenter is deprecated in iOS 7.0
    
    [self.view addSubview:self.currentEventTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[SPTEventStore sharedStore] hasCurrentEvent]) {
        
        self.currentEventTitleField.enabled = NO;
        self.currentEventTitleField.text = [[SPTEventStore sharedStore] currentEvent].title;
        self.currentEventFinishButton.enabled = YES;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
        self.currentEventStartDateLabel.text = [dateFormatter stringFromDate:[[SPTEventStore sharedStore] currentEvent].beginDate];
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[[SPTEventStore sharedStore] currentEvent].beginDate];
        [self.currentEventTimer setStopWatchTime:interval];
        [self.currentEventTimer start];
        
    }
    
    // Type selector testing
    /*
    SPTEventTypeSelectView *selector = [[SPTEventTypeSelectView alloc] initWithFrame:CGRectMake([SPTEventTypeSelectView marginLeft], 240, [SPTEventTypeSelectView width], [SPTEventTypeSelectView height])];
    selector.delegate = self;
    [self.view addSubview:selector];
    
    self.eventTypeTestingLabel.text = [NSString stringWithFormat:@"%ld", [selector currentSelectedType]];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.currentEventTitleField) {
        
        [[SPTEventStore sharedStore] addEventWithTitle:self.currentEventTitleField.text eventType:SPTEventTypeNone];
        
        self.currentEventTitleField.enabled = NO;
        self.currentEventTitleField.text = [[SPTEventStore sharedStore] currentEvent].title;
        self.currentEventFinishButton.enabled = YES;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
        self.currentEventStartDateLabel.text = [dateFormatter stringFromDate:[[SPTEventStore sharedStore] currentEvent].beginDate];
        
        // Start timer
        [self.currentEventTimer reset];
        [self.currentEventTimer start];
        
    }
    return YES;
}

- (IBAction)finishCurrentEvent:(id)sender
{
    [[SPTEventStore sharedStore] finishCurrentEvent];
    
    self.currentEventTitleField.enabled = YES;
    self.currentEventTitleField.text = @"";
    self.currentEventFinishButton.enabled = NO;
    self.currentEventStartDateLabel.text = @"N/A";
    
    // End timer
    [self.currentEventTimer pause];
}

- (void)valueDidChangeInTypeSelectView:(SPTEventTypeSelectView *)selector
{
    SPTEventType type = [selector currentSelectedType];
    self.eventTypeTestingLabel.text = [NSString stringWithFormat:@"%ld", type];
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
