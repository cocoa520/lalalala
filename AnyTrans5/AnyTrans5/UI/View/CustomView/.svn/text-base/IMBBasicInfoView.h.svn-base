//
//  IMBBasicInfoView.h
//  NewMacTestApp
//
//  Created by iMobie on 6/11/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBPopupButton.h"
#import "IMBTextField.h"
#import "IMBDatePicker.h"
#import "IMBContactEntity.h"
#import "IMBRoundImageView.h"
#import "IMBMyDrawCommonly.h"
@interface IMBBasicInfoView : NSView<InternalLayoutChange>{
    IMBTextField *_firstNameField;
    IMBTextField *_lastNameField;
    IMBTextField *_displayAsCompanyField;
    IMBRoundImageView *_imageField;
    IMBTextField *_jobTitleField;
    IMBTextField *_companyNameField;
    IMBTextField *_departmentField;
    //没有birthday
    IMBDatePicker *_birthDayPicker;
    IMBTextField *_nickNameField;
    IMBTextField *_notesField;
    IMBTextField *_middleNameField;
    IMBTextField *_lastNameYomiField;
    IMBTextField *_firstNameYomiField;
    IMBTextField *_suffixField;
    IMBTextField *_titleField;
    
    NSString *_firstName;
    NSString *_lastName;
    NSString *_displayAsCompany;
    NSData *_image;
    NSString *_jobTitle;
    NSString *_companyName;
    NSString *_department;
    NSDate *_birthday;
    NSString *_nickName;
    NSString *_notes;
    NSString *_middleName;
    NSString *_lastNameYomi;
    NSString *_firstNameYomi;
    NSString *_suffix;
    NSString *_title;
    
    BOOL _isEditing;
    id _delegate;
    CGFloat compareHeight;
    BOOL isEditingChanged;
    IMBContactEntity *_bindingEntity;
    IMBMyDrawCommonly *_changeImgBtn;
}
@property (nonatomic,retain,readwrite,setter = setFirstName:,getter = firstName) NSString *firstName;
@property (nonatomic,retain,readwrite,setter = setLastName:,getter = lastName) NSString *lastName;
@property (nonatomic,retain,readwrite,setter = setDisplayAsCompany:,getter = displayAsCompany) NSString *displayAsCompany;
@property (nonatomic,retain,readwrite,setter = setImage:,getter = image) NSData *image;
@property (nonatomic,retain,readwrite,setter = setJobTitle:,getter = jobTitle) NSString *jobTitle;
@property (nonatomic,retain,readwrite,setter = setCompanyName:,getter = companyName) NSString *companyName;
@property (nonatomic,retain,readwrite,setter = setDepartment:,getter = department) NSString *department;
@property (nonatomic,retain,readwrite,setter = setBirthday:,getter = birthday) NSDate *birthday;
@property (nonatomic,retain,readwrite,setter = setNickName:,getter = nickName) NSString *nickName;
@property (nonatomic,retain,readwrite,setter = setNotes:,getter = notes) NSString *notes;
@property (nonatomic,retain,readwrite,setter = setMiddleName:,getter = middleName) NSString *middleName;
@property (nonatomic,retain,readwrite,setter = setLastNameYomi:,getter = lastNameYomi) NSString *lastNameYomi;
@property (nonatomic,retain,readwrite,setter = setFirstNameYomi:,getter = firstNameYomi) NSString *firstNameYomi;
@property (nonatomic,retain,readwrite,setter = setSuffix:,getter = suffix) NSString *suffix;
@property (nonatomic,retain,readwrite,setter = setTitle:,getter = title) NSString *title;

@property (nonatomic,readwrite,setter = setIsEditing:) BOOL isEditing;
@property (nonatomic,assign) id delegate;
@property (nonatomic,retain) IMBContactEntity *bindingEntity;

- (void)setFirstName:(NSString *)firstName;
- (void)setLastName:(NSString *)lastName;
- (void)setDisplayAsCompany:(NSString *)displayAsCompany;
- (void)setImage:(NSData *)image;
- (void)setJobTitle:(NSString *)jobTitle;
- (void)setCompanyName:(NSString *)companyName;
- (void)setDepartment:(NSString *)department;
- (void)setBirthday:(NSDate *)birthday;
- (void)setNickName:(NSString *)nickName;
- (void)setNotes:(NSString *)notes;
- (void)setMiddleName:(NSString *)middleName;
- (void)setLastNameYomi:(NSString *)lastNameYomi;
- (void)setFirstNameYomi:(NSString *)firstNameYomi;
- (void)setSuffix:(NSString *)suffix;
- (void)setIsEditing:(BOOL)isEditing;
- (void)setTitle:(NSString *)title;
- (void)layoutSubViews;


- (NSString *)firstName;
- (NSString *)lastName;
- (NSString *)displayAsCompany;
- (NSData *)image;
- (NSString *)jobTitle;
- (NSString *)companyName;
- (NSString *)department;
- (NSDate *)birthday;
- (NSString *)nickName;
- (NSString *)notes;
- (NSString *)middleName;
- (NSString *)lastNameYomi;
- (NSString *)firstNameYomi;
- (NSString *)suffix;

@end
