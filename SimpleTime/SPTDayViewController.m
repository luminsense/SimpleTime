//
//  SPTDayViewController.m
//  SimpleTime
//
//  Created by Lumi on 14-8-12.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTDayViewController.h"
#import "SPTDay.h"
#import "SPTIssue.h"

@interface SPTDayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@end

@implementation SPTDayViewController

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
    [super viewWillAppear:animated];
    self.navigationItem.title = [self.day description];
    
    NSString *testLabelString = [[NSString alloc] initWithFormat:@"Content: "];
    for (SPTIssue *issue in self.day.issues) {
        testLabelString = [testLabelString stringByAppendingString:issue.description];
    }
    NSLog(@"Test Label String: %@", testLabelString);
    self.testLabel.text = testLabelString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
