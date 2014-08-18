//
//  SPTEventTypeSelectView.h
//  SimpleTime
//
//  Created by Lumi on 14-8-17.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPTEvent.h"

@class SPTEventTypeSelectView;
@class SPTEventTypeSelectItem;

@protocol SPTEventTypeSelectViewDelegate <NSObject>
@optional
- (void)valueDidChangeInTypeSelectView:(SPTEventTypeSelectView *)selector;
@end

@interface SPTEventTypeSelectView : UIView

@property (nonatomic, weak) id <SPTEventTypeSelectViewDelegate> delegate;
@property (nonatomic, weak) SPTEventTypeSelectItem *currentSelectedItem;

- (SPTEventType)currentSelectedType;
- (void)reset;

+ (float)width;
+ (float)height;
+ (float)marginLeft;

@end
