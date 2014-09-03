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
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
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

+ (UIColor *)separatorColor
{
    return [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1];
}

+ (UIColor *)colorForEventType:(SPTEventType)type
{
    UIColor *color;
    
    switch (type) {
        case SPTEventTypeNone:
            color = [SPTColor mainColor];
            break;
        case SPTEventTypeWork:
            color = [UIColor colorWithRed:6.0 / 255.0 green:185.0 / 255.0 blue:209.0 / 255.0 alpha:1];
            break;
        case SPTEventTypeStudy:
            color = [UIColor colorWithRed:103.0 / 255.0 green:149.0 / 255.0 blue:40.0 / 255.0 alpha:1];
            break;
        case SPTEventTypeFun:
            color = [UIColor colorWithRed:153.0 / 255.0 green:102.0 / 255.0 blue:204.0 / 255.0 alpha:1];
            break;
        case SPTEventTypeSleep:
            color = [UIColor colorWithRed:73.0 / 255.0 green:90.0 / 255.0 blue:128.0 / 255.0 alpha:1];
            break;
        case SPTEventTypeWorkout:
            color = [UIColor colorWithRed:235.0 / 255.0 green:85.0 / 255.0 blue:40.0 / 255.0 alpha:1];
            break;
        case SPTEventTypeDining:
            color = [UIColor colorWithRed:245.0 / 255.0 green:171.0 / 255.0 blue:0 / 255.0 alpha:1];
            break;
        case SPTEventTypeRead:
            color = [UIColor colorWithRed:60.0 / 255.0 green:179.0 / 255.0 blue:113.0 / 255.0 alpha:1];
            break;
        case SPTEventTypeTransport:
            color = [UIColor colorWithRed:116.0 / 255.0 green:149.0 / 255.0 blue:166.0 / 255.0 alpha:1];
            break;
        case SPTEventTypeRelax:
            color = [UIColor colorWithRed:222.0 / 255.0 green:166.0 / 255.0 blue:129.0 / 255.0 alpha:1];
            break;
        default:
            color = [UIColor clearColor];
            break;
    }
    
    return color;
}

@end
