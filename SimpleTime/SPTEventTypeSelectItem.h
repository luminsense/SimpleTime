//
//  SPTEventTypeSelectItem.h
//  SimpleTime
//
//  Created by Lumi on 14-8-17.
//  Copyright (c) 2014年 LumiNg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPTEvent.h"

@class SPTEventTypeSelectItem;

@protocol SPTEventTypeSelectItemDelegate <NSObject>
@optional
- (void)didSelectItem:(SPTEventTypeSelectItem *)item;
@end

@interface SPTEventTypeSelectItem : UIControl

@property (nonatomic, weak) id <SPTEventTypeSelectItemDelegate> delegate;
@property (nonatomic) SPTEventType type;
@property (nonatomic) BOOL isSelected;

// Test init method
- (instancetype)initWithFrame:(CGRect)frame eventType:(SPTEventType)type selected:(BOOL)selected;

// Real world init method
- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
                 pressedImage:(UIImage *)pressedImage
                selectedImage:(UIImage *)selectedImage
                     selected:(BOOL)selected;

- (void)resetItem;
- (void)selectItem;

+ (float)itemWidth;

@end
