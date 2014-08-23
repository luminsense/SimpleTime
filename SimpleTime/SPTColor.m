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
    return [UIColor colorWithRed:34.0/255.0 green:143.0/255.0 blue:189.0/255.0 alpha:1];
}

+ (UIColor *)pieChartBackgroundColor
{
    return [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
}

+ (UIColor *)waterColorLight
{
    return [UIColor colorWithRed:232.0/255.0 green:248.0/255.0 blue:255.0/255.0 alpha:1];
}

+ (UIColor *)waterColorDark
{
    return [UIColor colorWithRed:205.0/255.0 green:239.0/255.0 blue:255.0/255.0 alpha:1];
}

+ (UIColor *)dayPickerActiveDayColor
{
    return [UIColor blackColor];
}

+ (UIColor *)dayPickerActiveDayNameColor
{
    return [UIColor lightGrayColor];
}

+ (UIColor *)dayPickerInactiveDayColor
{
    return [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
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
        case SPTEventTypeStudy:
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
        case SPTEventTypeDining:
            color = [UIColor purpleColor];
            break;
        case SPTEventTypeRead:
            color = [UIColor magentaColor];
            break;
        case SPTEventTypeTransport:
            color = [UIColor yellowColor];
            break;
        case SPTEventTypeRelax:
            color = [UIColor darkGrayColor];
            break;
        default:
            color = [UIColor clearColor];
            break;
    }
    
    return color;
}

@end
