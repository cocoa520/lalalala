//
//  IMBContactEditView.h
//  AnyTrans
//
//  Created by m on 17/7/31.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBMyDrawCommonly.h"
#import "IMBContactEntity.h"
#import "IMBFilpedView.h"
#import "HoverButton.h"
#import "IMBPopupButton.h"
#import "ASHDatePicker.h"
#import "IMBiCloudContactEntity.h"

@class IMBContactTextField;
@class IMBPopTitleTextField;
typedef void(^contactBlock) (IMBMyDrawCommonly *button,id contactEntity);
@interface IMBContactEditView : NSView<NSTextViewDelegate>
{
    //基本信息
    NSData *_iConData;
    NSImageView *_iconImageView;
    IMBContactTextField *_lastNameFiled;
    IMBContactTextField *_phoneticLastNameFiled;
    IMBContactTextField *_middleNameFiled;
    IMBContactTextField *_firstNameFiled;
    IMBContactTextField *_phoneticFirstNameFiled;
    IMBContactTextField *_suffixFiled;
    IMBContactTextField *_nickNameFiled;
    IMBContactTextField *_jobTitleFiled;
    IMBContactTextField *_departmentFiled;
    IMBContactTextField *_companyFiled;
    int _baseInforHeight;
    IMBFilpedView *_baseFiledView;
    
    //phoneNumber
    IMBFilpedView *_phoneFiledView;
    //email
    IMBFilpedView *_emailFiledView;
    //relateName
    IMBFilpedView *_relateNameFiledView;
    //url
    IMBFilpedView *_urlFiledView;
    //date
    IMBFilpedView *_dateFiledView;
    //IM
    IMBFilpedView *_IMFiledView;
    //address
    IMBFilpedView *_addressFiledView;
    //note
    IMBFilpedView *_noteFiledView;
    
    NSPopUpButton *_kindButton;
    NSTextField *_addTextFiled;
    
    contactBlock _saveBlock;
    NSView *_superView;
    IMBContactEntity *_contactEntity;
    IMBiCloudContactEntity *_iCloudContactEntity;
    BOOL _isiCloudView;
    
    NSString *_contactID;
    NSNumber *_entityID;
}
@property (nonatomic, copy)contactBlock saveBlock;
@property (nonatomic, assign) BOOL isiCloudView;
- (id)initWithSuperView:(NSView *)superView;
- (void)setContactEntity:(IMBContactEntity *)contactEntity;
- (void)setiCloudContactEntity:(IMBiCloudContactEntity *)iCloudContactEntity;
@end


@interface  IMBContactNormalView : NSView
{
    HoverButton *_deleteBtn;
    NSPopUpButton *_popBtn;
    IMBContactTextField *_textFiled;
    IMBPopTitleTextField *_popTitle;
    ASHDatePicker *_datePicker;
    ContactCategoryEnum  _category;
    id _delegate;
    ASHDatePickerController *_controller;
}
@property (nonatomic, retain) IMBContactTextField *textFiled;
@property (nonatomic, retain) NSTextField *popTitle;
@property (nonatomic, retain) NSPopUpButton *popBtn;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) ASHDatePicker *datePicker;
- (id)initWithFrame:(NSRect)frameRect withCategory:(ContactCategoryEnum)category;
@end


@interface  IMBContactAddresslView : IMBFilpedView
{
    HoverButton *_deleteBtn;
    NSPopUpButton *_popBtn;
    IMBPopTitleTextField *_popTitle;
    IMBContactTextField *_streetTextFiled;
    IMBContactTextField *_cityTextFiled;
    IMBContactTextField *_stateTextFiled;//州
    IMBContactTextField *_postalCodeTextFiled;//邮政编码
    IMBContactTextField *_countryTextFiled;
    ContactCategoryEnum  _category;
    id _delegate;
}
@property (nonatomic, retain) IMBContactTextField *streetTextFiled;
@property (nonatomic, retain) IMBContactTextField *cityTextFiled;
@property (nonatomic, retain) IMBContactTextField *stateTextFiled;
@property (nonatomic, retain) IMBContactTextField *postalCodeTextFiled;
@property (nonatomic, retain) IMBContactTextField *countryTextFiled;
@property (nonatomic, retain) NSPopUpButton *popBtn;
@property (nonatomic, retain) NSTextField *popTitle;
@property (nonatomic, assign) id delegate;
- (id)initWithFrame:(NSRect)frameRect withCategory:(ContactCategoryEnum)category;
@end


@interface IMBContactTextField : NSTextField
{
    BOOL _hasCornerBorder;
}
@property (nonatomic, assign) BOOL hasCornerBorder;
@end

@interface IMBContactTextCell: NSTextFieldCell

@end


@interface IMBPopTitleTextField : NSTextField

@end





