//
//  SPTEventCell.h
//  SimpleTime
//
//  Created by Lumi on 14-8-21.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTEventCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *eventTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventBeginTimeLabel;

@end
