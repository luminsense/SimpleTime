//
//  TESTNewEventViewController.m
//  SimpleTime
//
//  Created by Lumi on 14-8-13.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "TESTNewEventViewController.h"
#import "SPTEvent.h"
#import "SPTEventStore.h"

@interface TESTNewEventViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *eventTitleField;

@property (weak, nonatomic) IBOutlet UITextField *beginDateYearField;
@property (weak, nonatomic) IBOutlet UITextField *beginDateMonthField;
@property (weak, nonatomic) IBOutlet UITextField *beginDateDayField;
@property (weak, nonatomic) IBOutlet UITextField *beginDateHourField;
@property (weak, nonatomic) IBOutlet UITextField *beginDateMinuteField;
@property (weak, nonatomic) IBOutlet UITextField *beginDateSecondField;

@property (weak, nonatomic) IBOutlet UITextField *endDateYearField;
@property (weak, nonatomic) IBOutlet UITextField *endDateMonthField;
@property (weak, nonatomic) IBOutlet UITextField *endDateDayField;
@property (weak, nonatomic) IBOutlet UITextField *endDateHourField;
@property (weak, nonatomic) IBOutlet UITextField *endDateMinuteField;
@property (weak, nonatomic) IBOutlet UITextField *endDateSecondField;

@property (weak, nonatomic) IBOutlet UIPickerView *eventTypePicker;

@end

@implementation TESTNewEventViewController

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
    self.eventTypePicker.delegate = self;
    self.eventTypePicker.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerView DataSource and Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row) {
        case 0:
            return @"General";
            break;
        case 1:
            return @"Work";
            break;
        case 2:
            return @"Workout";
            break;
        case 3:
            return @"Fun";
            break;
        case 4:
            return @"Sleep";
            break;
        case 5:
            return @"Dining";
            break;
        case 6:
            return @"Transportation";
            break;
        case 7:
            return @"Reading";
            break;
        case 8:
            return @"Personal Issue";
            break;
        case 9:
            return @"Stay at Home";
            break;
        default:
            return @"??? unknown ???";
            break;
    }
}

#pragma mark - Cancel and Done

- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)done:(id)sender
{
    NSString *title = self.eventTitleField.text;
    
    NSDateComponents *beginComp = [[NSDateComponents alloc] init];
    [beginComp setYear:[self.beginDateYearField.text integerValue]];
    [beginComp setMonth:[self.beginDateMonthField.text integerValue]];
    [beginComp setDay:[self.beginDateDayField.text integerValue]];
    [beginComp setHour:[self.beginDateHourField.text integerValue]];
    [beginComp setMinute:[self.beginDateMinuteField.text integerValue]];
    [beginComp setSecond:[self.beginDateSecondField.text integerValue]];
    NSDate *beginDate = [[NSCalendar currentCalendar] dateFromComponents:beginComp];
    
    NSDateComponents *endComp = [[NSDateComponents alloc] init];
    [endComp setYear:[self.endDateYearField.text integerValue]];
    [endComp setMonth:[self.endDateMonthField.text integerValue]];
    [endComp setDay:[self.endDateDayField.text integerValue]];
    [endComp setHour:[self.endDateHourField.text integerValue]];
    [endComp setMinute:[self.endDateMinuteField.text integerValue]];
    [endComp setSecond:[self.endDateSecondField.text integerValue]];
    NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endComp];
    
    SPTEventType type;
    long selected = [self.eventTypePicker selectedRowInComponent:0];
    switch (selected) {
        case 0:
            type = SPTEventTypeNone;
            break;
        case 1:
            type = SPTEventTypeWork;
            break;
        case 2:
            type = SPTEventTypeWorkout;
            break;
        case 3:
            type = SPTEventTypeFun;
            break;
        case 4:
            type = SPTEventTypeSleep;
            break;
        case 5:
            type = SPTEventTypeDining;
            break;
        case 6:
            type = SPTEventTypeTransport;
            break;
        case 7:
            type = SPTEventTypeRead;
            break;
        case 8:
            type = SPTEventTypePersonal;
            break;
        case 9:
            type = SPTEventTypeHome;
            break;
        default:
            type = SPTEventTypeNone;
            break;
    }
    
    [[SPTEventStore sharedStore] addEventWithTitle:title beginDate:beginDate endDate:endDate eventType:type];
    
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
