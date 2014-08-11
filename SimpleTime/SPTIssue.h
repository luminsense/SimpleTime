//
//  SPTIssue.h
//  SimpleTime
//
//  Created by Lumi on 14-8-12.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPTIssue : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSDate *timeCreated;
@property (nonatomic, strong) NSDate *timeEnded;
@property (nonatomic, assign) BOOL isFinished;

- (instancetype)initWithDescription:(NSString *)description;


@end
