//
//  SPTColor.m
//  SimpleTime
//
//  Created by Lumi on 14-8-18.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTColor.h"

@implementation SPTColor

+ (UIColor *)labelColorLight
{
    return [UIColor lightGrayColor];
}

+ (UIColor *)labelColorDark
{
    return [UIColor blackColor];
}

+ (UIColor *)mainColor
{
    return [UIColor colorWithRed:64/255 green:220/255 blue:82/255 alpha:1];
}

+ (UIColor *)pieChartBackgroundColor
{
    return [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
}

+ (UIColor *)colorForEventType:(SPTEventType)type
{
    UIColor *color;
    
    switch (type) {
        case SPTEventTypeNone:
            color = [UIColor grayColor];
            break;
        case SPTEventTypeWork:
            color = [UIColor blueColor];
            break;
        case SPTEventTypeDining:
            color = [UIColor orangeColor];
            break;
        case SPTEventTypeFun:
            color = [UIColor cyanColor];
            break;
        case SPTEventTypeSleep:
            color = [UIColor blackColor];
            break;
        case SPTEventTypeWorkout:
            color = [UIColor redColor];
            break;
        case SPTEventTypePersonal:
            color = [UIColor purpleColor];
            break;
        case SPTEventTypeRead:
            color = [UIColor magentaColor];
            break;
        case SPTEventTypeTransport:
            color = [UIColor yellowColor];
            break;
        case SPTEventTypeHome:
            color = [UIColor darkGrayColor];
            break;
        default:
            color = [UIColor clearColor];
            break;
    }
    
    return color;
}

@end