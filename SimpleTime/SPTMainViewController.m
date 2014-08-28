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
#import "VWWWaterView.h"
#import "SPTHistoryViewController.h"

@interface SPTMainViewController () <SPTEventTypeSelectViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) VWWWaterView *topWaterView;
@property (strong, nonatomic) VWWWaterView *backWaterView;

// Components in No Event Status
@property (weak, nonatomic) IBOutlet UIButton *addEventButton;
@property (weak, nonatomic) IBOutlet UIButton *myRecordButton;
@property (nonatomic, strong) UILabel *titleLabel;

// Components in Current Event Status
@property (nonatomic, strong) UILabel *currentEventTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *currentEventFinishButton;
@property (nonatomic, strong) MZTimerLabel *currentEventTimer;

// Components in Creating Event Status
@property (weak, nonatomic) IBOutlet UITextField *eventTitleField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) SPTEventTypeSelectView *typeSelector;

@property (nonatomic, strong) UIView *fullScreenColorView;

@property (nonatomic) BOOL isFirstLoad;

@end

@implementation SPTMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isFirstLoad = YES;
    
    self.eventTitleField.delegate = self;
    
    // Load double-layer water effect
    self.topWaterView = [[VWWWaterView alloc] initWithFrame:self.view.bounds waterColor:[SPTColor waterColorDark]];
    self.topWaterView.speedVarity = 0.07;
    self.topWaterView.offset = 0;
    self.topWaterView.height = 8;
    [self.view addSubview:self.topWaterView];
    
    self.backWaterView = [[VWWWaterView alloc] initWithFrame:self.view.bounds waterColor:[SPTColor waterColorLight]];
    self.backWaterView.speed = 3;
    self.backWaterView.speedVarity = 0.12;
    self.backWaterView.offset = 10;
    self.backWaterView.height = 4;
    [self.view addSubview:self.backWaterView];
    
    // Add timer and update water effect
    [self updateWaterViewLinePointY];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateWaterViewLinePointY) userInfo:nil repeats:YES];
    
    float inset = 15.0;
    
    // Load type selector
    self.typeSelector = [[SPTEventTypeSelectView alloc] initWithFrame:CGRectMake(inset, 128, [SPTEventTypeSelectView width], [SPTEventTypeSelectView height])];
    self.typeSelector.delegate = self;
    [self.view addSubview:self.typeSelector];
    self.typeSelector.hidden = YES;
    
    // Load current event title label
    self.currentEventTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, 136, [UIScreen mainScreen].bounds.size.width - inset * 2, 44)];
    self.currentEventTitleLabel.textColor = [SPTColor labelColorDark];
    self.currentEventTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:36.0];
    self.currentEventTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.currentEventTitleLabel];
    
    // Load title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, 110, [UIScreen mainScreen].bounds.size.width - inset * 2, 44)];
    self.titleLabel.textColor = [SPTColor labelColorDark];
    self.titleLabel.text = @"What are you doing now?";
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    // TODO: Load highlight background image for buttons (after complete visual design)
    
    // Load MZTimer
    self.currentEventTimer = [[MZTimerLabel alloc] initWithFrame:CGRectMake(inset, 0, [UIScreen mainScreen].bounds.size.width - inset * 2, 44)];
    self.currentEventTimer.timerType = MZTimerLabelTypeStopWatch;
    self.currentEventTimer.timeLabel.backgroundColor = [UIColor clearColor];
    self.currentEventTimer.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    self.currentEventTimer.timeLabel.textColor = [SPTColor labelColorLight];
    self.currentEventTimer.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.currentEventTimer];
    self.currentEventTimer.hidden = YES;
    
    self.cancelButton.hidden = YES;
    self.doneButton.hidden = YES;
    self.eventTitleField.hidden = YES;
    
    // Load full screen color view
    self.fullScreenColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.fullScreenColorView.backgroundColor = [SPTColor mainColor];
    self.fullScreenColorView.hidden = YES;
    [self.view addSubview:self.fullScreenColorView];
    
    // self.currentEventTitleLabel.backgroundColor = [UIColor redColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.view sendSubviewToBack:self.topWaterView];
    [self.view sendSubviewToBack:self.backWaterView];
    
    // Update idle timer disabled status
    if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateCharging || [UIDevice currentDevice].batteryState == UIDeviceBatteryStateFull) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveBatteryStateDidChangeNotification:)
                                                 name:UIDeviceBatteryStateDidChangeNotification
                                               object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (self.isFirstLoad) {
        if ([[SPTEventStore sharedStore] hasCurrentEvent]) {
            [self loadWithCurrentEvent];
        } else {
            [self loadWithoutCurrentEvent];
        }
    }
    
    self.isFirstLoad = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveBatteryStateDidChangeNotification:(NSNotification *)note
{
    if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateCharging || [UIDevice currentDevice].batteryState == UIDeviceBatteryStateFull) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    } else if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateUnplugged) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
}

- (void)updateWaterViewLinePointY
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    [components setNanosecond:0];
    NSDate *startOfDay = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSTimeInterval secondsOfDay = 60 * 60 * 24;
    NSTimeInterval currentSecond = [[NSDate date] timeIntervalSinceDate:startOfDay];
    float newLintPointY = [UIScreen mainScreen].bounds.size.height * currentSecond / secondsOfDay;
    // float newLintPointY = 50.0;
    
    self.topWaterView.currentLinePointY = newLintPointY;
    self.backWaterView.currentLinePointY = newLintPointY - 8;
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
    NSString *title;
    if (self.eventTitleField.text.length > 0) {
        title = self.eventTitleField.text;
    } else if (self.eventTitleField.placeholder.length > 0) {
        title = self.eventTitleField.placeholder;
    } else {
        title = @"Default event";
    }
    
    // Add new event to store
    [[SPTEventStore sharedStore] addEventWithTitle:title eventType:[self.typeSelector currentSelectedType]];
    
    [self quitEditingStatus];
    [self transitionToCurrentEventStatus];
}

- (IBAction)finishCurrentEvent:(id)sender
{
    UIColor *color = [SPTColor colorForEventType:[[SPTEventStore sharedStore] currentEvent].eventTypeRaw];
    [[SPTEventStore sharedStore] finishCurrentEvent];
    [self quitCurrentEventStatusWithColor:color];
    // [self transitionToNoEventStatus];
}

- (IBAction)showHistory:(id)sender
{
    SPTHistoryViewController *history = [[SPTHistoryViewController alloc] init];
    //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:history];
    [self presentViewController:history animated:YES completion:NULL];
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
            placeholder = @"Work";
            break;
        case SPTEventTypeStudy:
            placeholder = @"Study";
            break;
        case SPTEventTypeFun:
            placeholder = @"Play";
            break;
        case SPTEventTypeSleep:
            placeholder = @"Sleep";
            break;
        case SPTEventTypeWorkout:
            placeholder = @"Workout";
            break;
        case SPTEventTypeDining:
            placeholder = @"Dining";
            break;
        case SPTEventTypeRead:
            placeholder = @"Reading";
            break;
        case SPTEventTypeTransport:
            placeholder = @"Transportation";
            break;
        case SPTEventTypeRelax:
            placeholder = @"Relax";
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
    
    // Hide addEventButton
    self.addEventButton.hidden = YES;
    
    // Show currentEventTitleLabel
    self.currentEventTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.currentEventTitleLabel.text = [[SPTEventStore sharedStore] currentEvent].title;
    self.currentEventTitleLabel.hidden = NO;
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        self.currentEventTitleLabel.numberOfLines = 1;
    } else {
        self.currentEventTitleLabel.numberOfLines = 3;
    }
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
    // Set time using current event's time interval
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[[SPTEventStore sharedStore] currentEvent].beginDate];
    [self.currentEventTimer setStopWatchTime:interval];
    self.currentEventTimer.hidden = NO;
    [self.currentEventTimer start];
    
    // Show finishEventButton (according to currentEventTitleLabel's bound)
    /*
    self.currentEventFinishButton.frame = CGRectMake(self.currentEventFinishButton.frame.origin.x,
                                                     self.currentEventTimer.frame.origin.y + self.currentEventTimer.frame.size.height + 20.0,
                                                     self.currentEventFinishButton.frame.size.width,
                                                     self.currentEventFinishButton.frame.size.height);
     */
    self.currentEventFinishButton.hidden = NO;
}


- (void)transitionToEditingStatus
{
    self.cancelButton.alpha = 0;
    self.doneButton.alpha = 0;
    self.typeSelector.alpha = 0;
    
    // Show cancel and done button
    self.cancelButton.hidden = NO;
    self.doneButton.hidden = NO;
    self.eventTitleField.hidden = NO;
    self.typeSelector.hidden = NO;
    [self.eventTitleField becomeFirstResponder];
    
    // Move titleLabel and hide water view
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
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.topWaterView.alpha = 0;
                         self.backWaterView.alpha = 0;
                         
                         self.cancelButton.alpha = 1;
                         self.doneButton.alpha = 1;
                         self.typeSelector.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
    
    // Hide addEventButton
    self.addEventButton.hidden = YES;
    
    // Hide myRecordButton
    self.myRecordButton.hidden = YES;
    
    [self updateDoneButtonEnabledStatus];
}

- (void)quitEditingStatus
{
    [UIView animateWithDuration:1
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.topWaterView.alpha = 1;
                         self.backWaterView.alpha = 1;
                     }
                     completion:NULL];
    
    // Hide cancel and done button
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.cancelButton.alpha = 0;
                         self.doneButton.alpha = 0;
                         self.typeSelector.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         self.cancelButton.hidden = YES;
                         self.doneButton.hidden = YES;
                         self.typeSelector.hidden = YES;
                         [self.typeSelector reset];
                     }];
    
    
    // Hide currentEventField, resign first responder and clear content
    [self.eventTitleField resignFirstResponder];
    self.eventTitleField.hidden = YES;
    self.eventTitleField.placeholder = nil;
    self.eventTitleField.text = @"";
    self.eventTitleField.textAlignment = NSTextAlignmentCenter;
}

- (void)transitionToCurrentEventStatus
{
    // Show currentEventTitleLabel and resolve sizeToFit issue
    self.currentEventTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.currentEventTitleLabel.text = [[SPTEventStore sharedStore] currentEvent].title;
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        self.currentEventTitleLabel.numberOfLines = 1;
    } else {
        self.currentEventTitleLabel.numberOfLines = 3;
    }
    [self.currentEventTitleLabel sizeToFit];
    CGRect newFrame = CGRectMake(self.currentEventTitleLabel.frame.origin.x,
                                 self.currentEventTitleLabel.frame.origin.y,
                                 290,
                                 self.currentEventTitleLabel.frame.size.height);
    self.currentEventTitleLabel.frame = newFrame;
    self.currentEventTitleLabel.alpha = 0;
    self.currentEventTitleLabel.hidden = NO;
    
    // Show timerLabel (according to currentEventTitleLabel's bound)
    CGRect labelFrame = self.currentEventTitleLabel.frame;
    self.currentEventTimer.frame = CGRectMake(self.currentEventTimer.frame.origin.x,
                                              labelFrame.origin.y + labelFrame.size.height + 10.0,
                                              self.currentEventTimer.frame.size.width,
                                              self.currentEventTimer.frame.size.height);
    self.currentEventTimer.alpha = 0;
    self.currentEventTimer.hidden = NO;
    [self.currentEventTimer reset];
    [self.currentEventTimer start];
    
    self.currentEventFinishButton.alpha = 0;
    self.currentEventFinishButton.hidden = NO;
    
    self.myRecordButton.hidden = NO;
    self.myRecordButton.alpha = 0;
    
    // Move titleLabel and change text
    [UIView animateWithDuration:0.3
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
                     completion:NULL];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.currentEventFinishButton.alpha = 1;
                         self.currentEventTimer.alpha = 1;
                         self.currentEventTitleLabel.alpha = 1;
                         self.myRecordButton.alpha = 1;
                     } completion:NULL];
    
}

- (void)quitCurrentEventStatusWithColor:(UIColor *)color
{
    self.fullScreenColorView.alpha = 0;
    self.fullScreenColorView.hidden = NO;
    self.fullScreenColorView.backgroundColor = color;
    
    [self.currentEventTimer pause];
    self.currentEventFinishButton.hidden = YES;
    
    [self.view bringSubviewToFront:self.currentEventTitleLabel];
    [self.view bringSubviewToFront:self.currentEventTimer];
    
    self.currentEventTitleLabel.textColor = [UIColor whiteColor];
    self.currentEventTimer.textColor = [UIColor whiteColor];
    
    self.titleLabel.hidden = YES;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.fullScreenColorView.alpha = 1;
                     } completion:^(BOOL finished){
                         [self transitionToNoEventStatus];
                         [UIView animateWithDuration:0.3
                                               delay:0.4
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.fullScreenColorView.alpha = 0;
                                              self.currentEventTitleLabel.alpha = 0;
                                              self.currentEventTimer.alpha = 0;
                                          } completion:^(BOOL finished){
                                              self.fullScreenColorView.hidden = YES;
                                              
                                              self.currentEventTitleLabel.hidden = YES;
                                              self.currentEventTitleLabel.alpha = 1;
                                              self.currentEventTitleLabel.textColor = [UIColor blackColor];
                                              
                                              self.currentEventTimer.hidden = YES;
                                              [self.currentEventTimer reset];
                                              self.currentEventTimer.alpha = 1;
                                              self.currentEventTimer.textColor = [SPTColor labelColorLight];
                                          }];
                     }];
    
    
}

- (void)transitionToNoEventStatus
{
    self.addEventButton.hidden = NO;
    self.myRecordButton.hidden = NO;
    self.titleLabel.hidden = NO;
    self.addEventButton.alpha = 0;
    self.myRecordButton.alpha = 0;
    self.titleLabel.alpha = 0;
    
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
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.addEventButton.alpha = 1;
                         self.myRecordButton.alpha = 1;
                         self.titleLabel.alpha = 1;
                     }
                     completion:NULL];
}

#pragma mark - Text Field and Done Button

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
