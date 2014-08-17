//
//  SPTEventTypeSelectItem.m
//  SimpleTime
//
//  Created by Lumi on 14-8-17.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTEventTypeSelectItem.h"

@interface SPTEventTypeSelectItem ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *pressedImage;
@property (nonatomic, strong) UIImage *selectedImage;
@end

@implementation SPTEventTypeSelectItem

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame eventType:SPTEventTypeNone selected:NO];
}

- (instancetype)initWithFrame:(CGRect)frame eventType:(SPTEventType)type selected:(BOOL)selected
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.selected = selected;
        selected ? [self selectItem] : [self resetItem];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image pressedImage:(UIImage *)pressedImage selectedImage:(UIImage *)selectedImage selected:(BOOL)selected
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        self.pressedImage = pressedImage;
        self.selectedImage = selectedImage;
        self.selected = selected;
        selected ? [self selectItem] : [self resetItem];
    }
    return self;
}

- (void)resetItem
{
    self.layer.contents = (id)self.image.CGImage;
    self.isSelected = NO;
}

- (void)selectItem
{
    self.layer.contents = (id)self.selectedImage.CGImage;
    self.isSelected = YES;
    [self setNeedsDisplay];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.selected) {
        self.layer.contents = (id)self.pressedImage.CGImage;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if (!self.isSelected) {
        if ([self pointIsInsideView:touchPoint]) {
            [self selectItem];
            [self.delegate didSelectItem:self];
        } else {
            [self resetItem];
        }
    } else {
        [self selectItem];
    }
}

+ (float)itemWidth
{
    return 50.0;
}

#pragma mark - Private Methods

- (BOOL)pointIsInsideView:(CGPoint)point
{
    if (point.x >= 0 && point.x <= [SPTEventTypeSelectItem itemWidth] && point.y >= 0 && point.y <= [SPTEventTypeSelectItem itemWidth]) {
        return YES;
    } else {
        return NO;
    }
}

@end
