//
//  SPTEventTypeSelectView.m
//  SimpleTime
//
//  Created by Lumi on 14-8-17.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import "SPTEventTypeSelectView.h"
#import "SPTEventTypeSelectItem.h"

@interface SPTEventTypeSelectView () <SPTEventTypeSelectItemDelegate>
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation SPTEventTypeSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        
        // Loading event type select items
        
        // Type: None
        UIImage *image = [UIImage imageNamed:@"eventTypeNone.png"];
        UIImage *pressedImage = [UIImage imageNamed:@"eventTypeNonePressed.png"];
        UIImage *selectedImage = [UIImage imageNamed:@"eventTypeNoneSelected.png"];
        [self createItemWithX:0 Y:0 image:image pressedImage:pressedImage selectedImage:selectedImage selected:YES];
        
        // Type: Work
        image = [UIImage imageNamed:@"eventTypeWork.png"];
        pressedImage = [UIImage imageNamed:@"eventTypeWorkPressed.png"];
        selectedImage = [UIImage imageNamed:@"eventTypeWorkSelected.png"];
        [self createItemWithX:60 Y:0 image:image pressedImage:pressedImage selectedImage:selectedImage selected:NO];
        
        // Type: Study
        image = [UIImage imageNamed:@"eventTypeStudy.png"];
        pressedImage = [UIImage imageNamed:@"eventTypeStudyPressed.png"];
        selectedImage = [UIImage imageNamed:@"eventTypeStudySelected.png"];
        [self createItemWithX:120 Y:0 image:image pressedImage:pressedImage selectedImage:selectedImage selected:NO];
        
        // Type: Fun
        image = [UIImage imageNamed:@"eventTypeFun.png"];
        pressedImage = [UIImage imageNamed:@"eventTypeFunPressed.png"];
        selectedImage = [UIImage imageNamed:@"eventTypeFunSelected.png"];
        [self createItemWithX:180 Y:0 image:image pressedImage:pressedImage selectedImage:selectedImage selected:NO];
        
        // Type: Sleep
        image = [UIImage imageNamed:@"eventTypeSleep.png"];
        pressedImage = [UIImage imageNamed:@"eventTypeSleepPressed.png"];
        selectedImage = [UIImage imageNamed:@"eventTypeSleepSelected.png"];
        [self createItemWithX:240 Y:0 image:image pressedImage:pressedImage selectedImage:selectedImage selected:NO];
        
        // Type: Workout
        image = [UIImage imageNamed:@"eventTypeWorkout.png"];
        pressedImage = [UIImage imageNamed:@"eventTypeWorkoutPressed.png"];
        selectedImage = [UIImage imageNamed:@"eventTypeWorkoutSelected.png"];
        [self createItemWithX:0 Y:60 image:image pressedImage:pressedImage selectedImage:selectedImage selected:NO];
        
        // Type: Dining
        image = [UIImage imageNamed:@"eventTypeDining.png"];
        pressedImage = [UIImage imageNamed:@"eventTypeDiningPressed.png"];
        selectedImage = [UIImage imageNamed:@"eventTypeDiningSelected.png"];
        [self createItemWithX:60 Y:60 image:image pressedImage:pressedImage selectedImage:selectedImage selected:NO];
        
        // Type: Read
        image = [UIImage imageNamed:@"eventTypeRead.png"];
        pressedImage = [UIImage imageNamed:@"eventTypeReadPressed.png"];
        selectedImage = [UIImage imageNamed:@"eventTypeReadSelected.png"];
        [self createItemWithX:120 Y:60 image:image pressedImage:pressedImage selectedImage:selectedImage selected:NO];
        
        // Type: Transport
        image = [UIImage imageNamed:@"eventTypeTransport.png"];
        pressedImage = [UIImage imageNamed:@"eventTypeTransportPressed.png"];
        selectedImage = [UIImage imageNamed:@"eventTypeTransportSelected.png"];
        [self createItemWithX:180 Y:60 image:image pressedImage:pressedImage selectedImage:selectedImage selected:NO];
        
        // Type: Relax
        image = [UIImage imageNamed:@"eventTypeRelax.png"];
        pressedImage = [UIImage imageNamed:@"eventTypeRelaxPressed.png"];
        selectedImage = [UIImage imageNamed:@"eventTypeRelaxSelected.png"];
        [self createItemWithX:240 Y:60 image:image pressedImage:pressedImage selectedImage:selectedImage selected:NO];
    }
    return self;
}

- (void)createItemWithX:(float)x
                      Y:(float)y
                  image:(UIImage *)image
           pressedImage:(UIImage *)pressedImage
          selectedImage:(UIImage *)selectedImage
               selected:(BOOL)selected
{
    CGRect frame = CGRectMake(x, y, [SPTEventTypeSelectItem itemWidth], [SPTEventTypeSelectItem itemWidth]);
    SPTEventTypeSelectItem *newItem = [[SPTEventTypeSelectItem alloc] initWithFrame:frame image:image pressedImage:pressedImage selectedImage:selectedImage selected:selected];
    newItem.delegate = self;
    [self.items addObject:newItem];
    [self addSubview:newItem];
    
    if (selected) {
        self.currentSelectedItem = newItem;
    }
}

- (void)didSelectItem:(SPTEventTypeSelectItem *)item
{
    self.currentSelectedItem = item;
    for (SPTEventTypeSelectItem *thisItem in self.items) {
        if (thisItem != item) {
            [thisItem resetItem];
        }
    }
    [self.delegate valueDidChangeInTypeSelectView:self];
}

- (SPTEventType)currentSelectedType
{
    NSInteger selectedIndex = [self.items indexOfObjectIdenticalTo:self.currentSelectedItem];
    return (SPTEventType)selectedIndex;
}

- (void)reset
{
    for (SPTEventTypeSelectItem *thisItem in self.items) {
        if ([self.items indexOfObject:thisItem] == 0) {
            [thisItem selectItem];
        } else {
            [thisItem resetItem];
        }
    }
}

+ (float)width
{
    return 290.0;
}

+ (float)height
{
    return 110.0;
}

+ (float)marginLeft
{
    return 15.0;
}

- (SPTEventType)eventTypeFromIndex:(NSInteger)index
{
    return (SPTEventType)index;
}

- (NSInteger)integerFromEventType:(SPTEventType)type
{
    return (NSInteger)type;
}


@end
