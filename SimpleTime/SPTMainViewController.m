//
//  SPTMainViewController.m
//  SimpleTime
//
//  Created by Lumi on 14-8-17.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTMainViewController.h"
#import "SPTEventTypeSelectView.h"
#import "MZTimerLabel.h"
#import "SPTColor.h"
#import "SPTEventStore.h"

@interface SPTMainViewController () <SPTEventTypeSelectViewDelegate, UITextFieldDelegate>

// Components in No Event Status
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addEventButton;
@property (weak, nonatomic) IBOutlet UIButton *myRecordButton;

// Components in Current Event Status
@property (weak, nonatomic) IBOutlet UILabel *currentEventTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *currentEventFinishButton;
@property (nonatomic, strong) MZTimerLabel *currentEventTimer;

// Components in Creating Event Status
@property (weak, nonatomic) IBOutlet UITextField *eventTitleField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) SPTEventTypeSelectView *typeSelector;

@end

@implementation SPTMainViewController

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
    
    self.eventTitleField.delegate = self;
    
    // Load type selector
    self.typeSelector = [[SPTEventTypeSelectView alloc] initWithFrame:CGRectMake(15, 128, 290, 110)];
    self.typeSelector.delegate = self;
    [self.view addSubview:self.typeSelector];
    self.typeSelector.hidden = YES;
    
    // TODO: Load highlight background image of buttons
    
    
    // Load MZTimer
    self.currentEventTimer = [[MZTimerLabel alloc] initWithFrame:CGRectMake(15, 0, 290, 44)];
    self.currentEventTimer.timerType = MZTimerLabelTypeStopWatch;
    self.currentEventTimer.timeLabel.backgroundColor = [UIColor clearColor];
    self.currentEventTimer.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    self.currentEventTimer.timeLabel.textColor = [SPTColor labelColorLight];
    self.currentEventTimer.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.currentEventTimer];
    self.currentEventTimer.hidden = YES;
    
    // Test
    /*
    self.currentEventTitleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.backgroundColor = [UIColor greenColor];
    self.currentEventTimer.backgroundColor = [UIColor blueColor];
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.cancelButton.hidden = YES;
    self.doneButton.hidden = YES;
    self.eventTitleField.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    // Reset color
    self.titleLabel.textColor = [SPTColor labelColorDark];
    self.myRecordButton.titleLabel.textColor = [SPTColor labelColorLight];
    self.currentEventTitleLabel.textColor = [SPTColor labelColorDark];
    self.currentEventFinishButton.titleLabel.textColor = [SPTColor mainColor];
    
    if ([[SPTEventStore sharedStore] hasCurrentEvent]) {
        [self loadWithCurrentEvent];
    } else {
        [self loadWithoutCurrentEvent];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Events Handling

- (IBAction)addEvent:(id)sender
{
    [self transitionToEditingStatus];
}

- (IBAction)addEventCancelled:(id)sender
{
    [self quitEditingStatus];
    [self transitionToNoEventStatus];
}

- (IBAction)addEventDone:(id)sender
{
    NSLog(@"Event title text: %@", self.eventTitleField.text);
    NSString *title;
    if (self.eventTitleField.text.length > 0) {
        title = self.eventTitleField.text;
        NSLog(@">>> Has Text");
    } else if (self.eventTitleField.placeholder.length > 0) {
        title = self.eventTitleField.placeholder;
        NSLog(@">>> Has Placeholder");
    } else {
        title = @"Default event";
        NSLog(@">>> No Title");
    }
    
    // Add new event to store
    [[SPTEventStore sharedStore] addEventWithTitle:title eventType:[self.typeSelector currentSelectedType]];
    
    [self quitEditingStatus];
    [self transitionToCurrentEventStatus];
}

- (IBAction)finishCurrentEvent:(id)sender
{
    [[SPTEventStore sharedStore] finishCurrentEvent];
    
    [self quitCurrentEventStatus];
    [self transitionToNoEventStatus];
}

- (void)valueDidChangeInTypeSelectView:(SPTEventTypeSelectView *)selector
{
    SPTEventType type = [self.typeSelector currentSelectedType];
    
    NSString *placeholder;
    switch (type) {
        case SPTEventTypeNone:
            placeholder = @"";
            break;
        case SPTEventTypeWork:
            placeholder = @"Working";
            break;
        case SPTEventTypeDining:
            placeholder = @"Dining";
            break;
        case SPTEventTypeFun:
            placeholder = @"Playing";
            break;
        case SPTEventTypeSleep:
            placeholder = @"Sleeping";
            break;
        case SPTEventTypeWorkout:
            placeholder = @"Workout";
            break;
        case SPTEventTypePersonal:
            placeholder = @"Personal issue";
            break;
        case SPTEventTypeRead:
            placeholder = @"Reading";
            break;
        case SPTEventTypeTransport:
            placeholder = @"Transportation";
            break;
        case SPTEventTypeHome:
            placeholder = @"Stay at home";
            break;
        default:
            placeholder = @"";
            break;
    }
    self.eventTitleField.placeholder = placeholder;
    
    [self updateDoneButtonEnabledStatus];
}

#pragma mark - UI Status Transitions

- (void)loadWithoutCurrentEvent
{
    self.currentEventTitleLabel.hidden = YES;
    self.currentEventFinishButton.hidden = YES;
}

- (void)loadWithCurrentEvent
{
    // Change text of titleLabel
    CGRect frame = CGRectMake(15, 90, 290, 44);
    [self.titleLabel setFrame:frame];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0];
    self.titleLabel.textColor = [SPTColor labelColorLight];
    self.titleLabel.text = @"Focus on";
    NSLog(@"Original TitleLabel Frame: %f, %f, %f, %f", self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    // Hide addEventButton
    self.addEventButton.hidden = YES;
    
    // Show currentEventTitleLabel
    self.currentEventTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.currentEventTitleLabel.text = [[SPTEventStore sharedStore] currentEvent].title;
    self.currentEventTitleLabel.hidden = NO;
    self.currentEventTitleLabel.numberOfLines = 3;
    [self.currentEventTitleLabel sizeToFit];
    CGRect newFrame = CGRectMake(self.currentEventTitleLabel.frame.origin.x,
                                 self.currentEventTitleLabel.frame.origin.y,
                                 290,
                                 self.currentEventTitleLabel.frame.size.height);
    self.currentEventTitleLabel.frame = newFrame;
    
    NSLog(@"Loaded Current event Frame: %f, %f, %f, %f", self.currentEventTitleLabel.frame.origin.x, self.currentEventTitleLabel.frame.origin.y, self.currentEventTitleLabel.frame.size.width, self.currentEventTitleLabel.frame.size.height);
    
    // Show timerLabel (according to currentEventTitleLabel's bound)
    CGRect labelFrame = self.currentEventTitleLabel.frame;
    self.currentEventTimer.frame = CGRectMake(self.currentEventTimer.frame.origin.x,
                                              labelFrame.origin.y + labelFrame.size.height + 10.0,
                                              self.currentEventTimer.frame.size.width,
                                              self.currentEventTimer.frame.size.height);
    // Set time using current event's time interval
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[[SPTEventStore sharedStore] currentEvent].beginDate];
    [self.currentEventTimer setStopWatchTime:interval];
    self.currentEventTimer.hidden = NO;
    [self.currentEventTimer start];
    
    // Show finishEventButton (according to currentEventTitleLabel's bound)
    self.currentEventFinishButton.frame = CGRectMake(self.currentEventFinishButton.frame.origin.x,
                                                     self.currentEventTimer.frame.origin.y + self.currentEventTimer.frame.size.height + 20.0,
                                                     self.currentEventFinishButton.frame.size.width,
                                                     self.currentEventFinishButton.frame.size.height);
    self.currentEventFinishButton.hidden = NO;
}


- (void)transitionToEditingStatus
{
    // Move titleLabel
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = CGRectMake(15, 20, 290, 44);
                         [self.titleLabel setFrame:frame];
                         self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0];
                         self.titleLabel.textColor = [SPTColor labelColorLight];
                     }
                     completion:NULL];
    
    // Show cancel and done button
    self.cancelButton.hidden = NO;
    self.doneButton.hidden = NO;
    self.eventTitleField.hidden = NO;
    [self.eventTitleField becomeFirstResponder];
    self.typeSelector.hidden = NO;
    
    // Hide addEventButton
    self.addEventButton.hidden = YES;
    
    // Hide myRecordButton
    self.myRecordButton.hidden = YES;
    
    [self updateDoneButtonEnabledStatus];
}

- (void)quitEditingStatus
{
    // Hide cancel and done button
    self.cancelButton.hidden = YES;
    self.doneButton.hidden = YES;
    
    // Hide currentEventField, resign first responder and clear content
    [self.eventTitleField resignFirstResponder];
    self.eventTitleField.hidden = YES;
    self.eventTitleField.placeholder = @"";
    self.eventTitleField.text = @"";
    
    // Hide typeSelector and RESET
    self.typeSelector.hidden = YES;
    [self.typeSelector reset];
}

- (void)transitionToCurrentEventStatus
{
    // Move titleLabel and change text
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = CGRectMake(15, 90, 290, 44);
                         [self.titleLabel setFrame:frame];
                         self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0];
                         self.titleLabel.textColor = [SPTColor labelColorLight];
                         self.titleLabel.text = @"Focus on";
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Animated TitleLabel Frame: %f, %f, %f, %f", self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
                     }];
    
    // Show currentEventTitleLabel and resolve sizeToFit issue
    self.currentEventTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.currentEventTitleLabel.text = [[SPTEventStore sharedStore] currentEvent].title;
    self.currentEventTitleLabel.hidden = NO;
    self.currentEventTitleLabel.numberOfLines = 3;
    [self.currentEventTitleLabel sizeToFit];
    CGRect newFrame = CGRectMake(self.currentEventTitleLabel.frame.origin.x,
                                 self.currentEventTitleLabel.frame.origin.y,
                                 290,
                                 self.currentEventTitleLabel.frame.size.height);
    self.currentEventTitleLabel.frame = newFrame;
    
    // Show timerLabel (according to currentEventTitleLabel's bound)
    CGRect labelFrame = self.currentEventTitleLabel.frame;
    self.currentEventTimer.frame = CGRectMake(self.currentEventTimer.frame.origin.x,
                                              labelFrame.origin.y + labelFrame.size.height + 10.0,
                                              self.currentEventTimer.frame.size.width,
                                              self.currentEventTimer.frame.size.height);
    self.currentEventTimer.hidden = NO;
    [self.currentEventTimer reset];
    [self.currentEventTimer start];
    
    // Show currentEventFinishButton (according to currentEventTitleLabel's bound)
    self.currentEventFinishButton.frame = CGRectMake(self.currentEventFinishButton.frame.origin.x,
                                                     self.currentEventTimer.frame.origin.y + self.currentEventTimer.frame.size.height + 20.0,
                                                     self.currentEventFinishButton.frame.size.width,
                                                     self.currentEventFinishButton.frame.size.height);
    self.currentEventFinishButton.hidden = NO;
    
    // Show myRecordButton
    self.myRecordButton.hidden = NO;
}

- (void)quitCurrentEventStatus
{
    // Hide currentEventTitleLabel
    self.currentEventTitleLabel.hidden = YES;
    
    // Hide currentEventFinishButton
    self.currentEventFinishButton.hidden = YES;
    
    // Hide currentEventTimer and reset
    [self.currentEventTimer reset];
    self.currentEventTimer.hidden = YES;
}

- (void)transitionToNoEventStatus
{
    // Move titleLabel and change text
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = CGRectMake(15, 110, 290, 44);
                         [self.titleLabel setFrame:frame];
                         self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0];
                         self.titleLabel.textColor = [SPTColor labelColorDark];
                         self.titleLabel.text = @"What are you doing now?";
                     }
                     completion:NULL];
    
    // Show addEventButton
    self.addEventButton.hidden = NO;
    
    // Show myRecordButton
    self.myRecordButton.hidden = NO;
}

#pragma mark - Text Field and Done Button

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Text Field should change char");
    if (textField == self.eventTitleField) {
        NSUInteger length = textField.text.length + string.length - range.length;
        if (length > 0 || self.eventTitleField.placeholder.length > 0) {
            self.doneButton.enabled = YES;
        } else {
            self.doneButton.enabled = NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addEventDone:self.doneButton];
    return YES;
}

- (void)updateDoneButtonEnabledStatus
{
    if (self.eventTitleField.text.length > 0 || self.eventTitleField.placeholder.length > 0) {
        self.doneButton.enabled = YES;
    } else {
        self.doneButton.enabled = NO;
    }
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
