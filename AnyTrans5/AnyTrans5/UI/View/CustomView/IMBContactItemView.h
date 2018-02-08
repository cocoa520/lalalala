//
//  IMBContactItemView.h
//  NewMacTestApp
//
//  Created by iMobie on 6/25/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBTextField.h"
#import "IMBPopupButton.h"
#import "HoverButton.h"
#import "IMBDatePicker.h"

@interface IMBContactItemView : NSView<InternalLayoutChange>{
    BOOL _isEditing;
    id _delegate;
    CGFloat compHeight;
    BOOL _isEmpty;
    HoverButton *_deleteBtn;

}

@property (nonatomic,assign,readwrite,setter = setIsEditing:,getter = isEditing) BOOL isEditing;
@property (nonatomic,assign) BOOL isEmpty;
@property (nonatomic,assign) id delegate;
- (void)setIsEditing:(BOOL)isEditing;
- (void)setEmptyValue;
@end
