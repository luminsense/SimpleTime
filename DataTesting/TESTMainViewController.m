//
//  TESTMainViewController.m
//  SimpleTime
//
//  Created by Lumi on 14-8-13.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "TESTMainViewController.h"
#import "SPTEventStore.h"

@interface TESTMainViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *currentEventTitleField;
@property (weak, nonatomic) IBOutlet UILabel *currentEventStartDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *currentEventFinishButton;


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
        
    }
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
