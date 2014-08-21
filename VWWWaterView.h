//
//  VWWWaterView.h
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VWWWaterView : UIView

@property (nonatomic) float currentLinePointY;
@property (nonatomic) float offset;
@property (nonatomic) NSTimeInterval interval;
@property (nonatomic) float speed;
@property (nonatomic) float height;
@property (nonatomic) float speedVarity;

- (instancetype)initWithFrame:(CGRect)frame waterColor:(UIColor *)color;
@end
