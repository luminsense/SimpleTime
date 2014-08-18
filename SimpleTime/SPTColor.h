//
//  SPTColor.h
//  SimpleTime
//
//  Created by Lumi on 14-8-18.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SPTEvent.h"

@interface SPTColor : NSObject

+ (UIColor *)labelColorLight;
+ (UIColor *)labelColorDark;
+ (UIColor *)mainColor;

+ (UIColor *)colorForEventType:(SPTEventType)type;

@end
