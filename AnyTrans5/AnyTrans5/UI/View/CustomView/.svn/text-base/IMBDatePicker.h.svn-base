//
//  IMBDatePicker.h
//  TestMyOwn
//
//  Created by iMobie on 7/1/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "IMBContactEntity.h"

@interface IMBDatePicker : NSDatePicker<NSDatePickerCellDelegate>
{
    BOOL _isEditing;
    CAShapeLayer *_shapeLayer;
    BOOL isAddShapeLayer;
    id _bindingEntity;
    NSString *_bindingEntityKeyPath;
    id _handleDelegate;
    BOOL _isEmpty;
    NSDate *originDate;
    BOOL  _needHourMin;
    BOOL _noShadow;
}
@property (nonatomic,retain,setter = setBindingEntity:) id bindingEntity;
@property (nonatomic,assign) id handleDelegate;
@property (nonatomic,retain) NSString *bindingEntityKeyPath;
@property (nonatomic,assign) BOOL isEmpty;
@property (nonatomic,assign) BOOL needHourMin;
@property (nonatomic, assign) BOOL noShadow;

- (void)setBindingEntity:(id)bindingEntity;

@end
