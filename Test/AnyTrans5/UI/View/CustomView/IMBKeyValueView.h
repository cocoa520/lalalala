//
//  IMBKeyValueView.h
//  iMobieTrans
//
//  Created by iMobie on 5/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBTextField.h"
#import "IMBPopupButton.h"
#import "IMBContactEntity.h"
#import "IMBContactItemView.h"
#import "IMBDatePicker.h"

@interface IMBKeyValueView : IMBContactItemView<InternalLayoutChange>{
    NSString *_key;
    NSString *_valueObj;
    IMBTextField *_textFiled;
    IMBDatePicker *_datePicker;
    IMBPopupButton *_popupButton;
    NSArray *_labelArr;
    NSString *_type;
    IMBContactKeyValueEntity *_contactKeyValueEntity;
    BOOL _isDateType;
}

@property (nonatomic,retain,readwrite,setter = setKey:,getter = key) NSString *key;
@property (nonatomic,retain,readwrite,setter = setValueObj:,getter = valueObj) id valueObj;
@property (nonatomic,assign,readwrite,setter = setIsEditing:,getter = isEditing) BOOL isEditing;
@property (nonatomic,retain,readwrite,setter = setType:,getter = type) NSString *type;
@property (nonatomic,retain,readwrite,setter = setLablesArr:,getter = labelArr) NSArray *labelArr;
@property (nonatomic,assign) id delegate;
@property (nonatomic,setter = setIsDateType:) BOOL isDateType;
@property (nonatomic,retain) IMBContactKeyValueEntity *contactKeyValueEntity;

- (void)setIsEditing:(BOOL)isEditing;
- (void)setLabelArr:(NSArray *)labelArr;
- (void)setKey:(NSString *)key;
- (void)setType:(NSString *)type;
- (void)setValueObj:(id)valueObj;

- (NSString *)key;
- (id)valueObj;
- (BOOL)isEditing;
- (NSString *)type;
- (NSArray *)labelArr;
- (void)viewLayoutChanged;

@end
