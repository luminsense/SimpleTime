//
//  VWWWaterView.m
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import "VWWWaterView.h"

@interface VWWWaterView ()
{
    UIColor *_currentWaterColor;
    
    float a;
    float b;
    
    BOOL jia;
}
@end


@implementation VWWWaterView


- (instancetype)initWithFrame:(CGRect)frame waterColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        a = 1.5;
        b = 1;
        jia = NO;
        _offset = 0;
        _interval = 0.02;
        _speed = 4;
        _height = 8;
        _speedVarity = 0.1;
        
        _currentWaterColor = color;
        _currentLinePointY = 160;
        
        [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
    }
    return self;
}

/*
- (void)setCurrentLinePointY:(float)currentLinePointY
{
    // TODO: need to finish
    _currentLinePointY++;
}
 */

-(void)animateWave
{
    if (jia) {
        a += 0.01;
    }else{
        a -= 0.01;
    }
    
    
    if (a<=1) {
        jia = YES;
    }
    
    if (a>=1.5) {
        jia = NO;
    }
    
    
    b += self.speedVarity;
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    
    float y=_currentLinePointY;
    CGPathMoveToPoint(path, NULL, 0, y);
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    for(float x=0; x<=screenWidth; x++){
        y= a * sin( x / 180 * M_PI + self.speed * b /M_PI + self.offset) * self.height + _currentLinePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, 320, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}


@end
