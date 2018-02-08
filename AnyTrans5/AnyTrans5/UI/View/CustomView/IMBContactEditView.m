//
//  IMBContactEditView.m
//  AnyTrans
//
//  Created by m on 17/7/31.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBContactEditView.h"
#import "StringHelper.h"
#import "IMBWhiteView.h"
#import "IMBPopupKindButton.h"
#import "IMBPopupKindButtonCell.h"
#import "NoteTextGrowthField.h"
#import "MediaHelper.h"
#import "TempHelper.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
@implementation IMBContactEditView
@synthesize saveBlock = _saveBlock;
@synthesize isiCloudView = _isiCloudView;


- (id)initWithSuperView:(NSView *)superView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    if (self = [super init]) {
        [self setFrameSize:NSMakeSize(superView.bounds.size.width,superView.bounds.size.height )];
        _superView = superView;
        _baseFiledView = [[IMBFilpedView alloc] initWithFrame:NSMakeRect(0, 40, superView.bounds.size.width, 0)];
        [_baseFiledView setAutoresizingMask:NSViewMaxXMargin|NSViewWidthSizable];
        _phoneFiledView = [[IMBFilpedView alloc] initWithFrame:NSMakeRect(0, 0, superView.bounds.size.width, 0)];
        [_phoneFiledView setAutoresizingMask:NSViewMaxXMargin|NSViewWidthSizable];
        _emailFiledView = [[IMBFilpedView alloc] initWithFrame:NSMakeRect(0, 0, superView.bounds.size.width, 0)];
        [_emailFiledView setAutoresizingMask:NSViewMaxXMargin|NSViewWidthSizable];
        _relateNameFiledView = [[IMBFilpedView alloc] initWithFrame:NSMakeRect(0, 0, superView.bounds.size.width, 0)];
        [_relateNameFiledView setAutoresizingMask:NSViewMaxXMargin|NSViewWidthSizable];
        _urlFiledView = [[IMBFilpedView alloc] initWithFrame:NSMakeRect(0, 0, superView.bounds.size.width, 0)];
        [_urlFiledView setAutoresizingMask:NSViewMaxXMargin|NSViewWidthSizable];
        _dateFiledView = [[IMBFilpedView alloc] initWithFrame:NSMakeRect(0, 0, superView.bounds.size.width, 0)];
        _IMFiledView = [[IMBFilpedView alloc] initWithFrame:NSMakeRect(0, 0, superView.bounds.size.width, 0)];
        [_IMFiledView setAutoresizingMask:NSViewMaxXMargin|NSViewWidthSizable];
        _addressFiledView = [[IMBFilpedView alloc] initWithFrame:NSMakeRect(0, 0, superView.bounds.size.width, 0)];
        [_addressFiledView setAutoresizingMask:NSViewMaxXMargin|NSViewWidthSizable];
        _noteFiledView = [[IMBFilpedView alloc] initWithFrame:NSMakeRect(0, 0, superView.bounds.size.width, 0)];
        [_noteFiledView setAutoresizingMask:NSViewMaxXMargin|NSViewWidthSizable];
    }
    return self;
}

- (void)saveContact:(id)sender {
    if (_isiCloudView) {
        _iCloudContactEntity.image = _iConData;
        _iCloudContactEntity.imageX = 0;
        _iCloudContactEntity.imageY = 0;
        _iCloudContactEntity.imageW = 200;
        _iCloudContactEntity.imageH = 200;
        
        _iCloudContactEntity.firstName = _firstNameFiled.stringValue?_firstNameFiled.stringValue:@"";
        _iCloudContactEntity.firstNameYomi = _phoneticFirstNameFiled.stringValue?_phoneticFirstNameFiled.stringValue:@"";
        _iCloudContactEntity.middleName = _middleNameFiled.stringValue?_middleNameFiled.stringValue:@"";
        _iCloudContactEntity.lastName = _lastNameFiled.stringValue?_lastNameFiled.stringValue:@"";
        _iCloudContactEntity.lastNameYomi = _phoneticLastNameFiled.stringValue?_phoneticLastNameFiled.stringValue:@"";
        _iCloudContactEntity.suffix = _suffixFiled.stringValue?_suffixFiled.stringValue:@"";
        _iCloudContactEntity.nickname = _nickNameFiled.stringValue?_nickNameFiled.stringValue:@"";
        _iCloudContactEntity.jobTitle = _jobTitleFiled.stringValue?_jobTitleFiled.stringValue:@"";
        _iCloudContactEntity.department = _departmentFiled.stringValue?_departmentFiled.stringValue:@"";
        _iCloudContactEntity.companyName = _companyFiled.stringValue?_companyFiled.stringValue:@"";
        
        _contactID = _iCloudContactEntity.contactId;
        _entityID = _iCloudContactEntity.entityID;
        
        if (_iCloudContactEntity.phoneNumberArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_iCloudContactEntity.phoneNumberArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
        }
        NSMutableArray *phoneAry = [[NSMutableArray alloc] init];
        int i = 0;
        for (NSView *view in _phoneFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactKeyValueEntity *entity = [[IMBContactKeyValueEntity alloc] init];
                entity.contactCategory = Contact_PhoneNumber;
                entity.entityID = @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.label = normalView.popTitle.stringValue;
                entity.value = normalView.textFiled.stringValue;
                [phoneAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_iCloudContactEntity.phoneNumberArray removeAllObjects];
        [_iCloudContactEntity.phoneNumberArray addObjectsFromArray:phoneAry];
        [phoneAry release], phoneAry = nil;
        
        
        if (_iCloudContactEntity.emailAddressArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_iCloudContactEntity.emailAddressArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
        }
        NSMutableArray *emailAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _emailFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactKeyValueEntity *entity = [[IMBContactKeyValueEntity alloc] init];
                entity.contactCategory = Contact_EmailAddressNumber;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.label = normalView.popTitle.stringValue;
                entity.value = normalView.textFiled.stringValue;
                [emailAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_iCloudContactEntity.emailAddressArray removeAllObjects];
        [_iCloudContactEntity.emailAddressArray addObjectsFromArray:emailAry];
        [emailAry release], emailAry = nil;
        
        
        if (_iCloudContactEntity.urlArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_iCloudContactEntity.urlArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
        }
        NSMutableArray *urlAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _urlFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactKeyValueEntity *entity = [[IMBContactKeyValueEntity alloc] init];
                entity.contactCategory = Contact_URL;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.label = normalView.popTitle.stringValue;
                entity.value = normalView.textFiled.stringValue;
                [urlAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_iCloudContactEntity.urlArray removeAllObjects];
        [_iCloudContactEntity.urlArray addObjectsFromArray:urlAry];
        [urlAry release], urlAry = nil;
        
        if (_iCloudContactEntity.dateArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_iCloudContactEntity.dateArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
        }
        NSMutableArray *dateAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _dateFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactKeyValueEntity *entity = [[IMBContactKeyValueEntity alloc] init];
                entity.contactCategory = Contact_Date;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.label = normalView.popTitle.stringValue;
                entity.value = normalView.datePicker.dateValue;
                [dateAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_iCloudContactEntity.dateArray removeAllObjects];
        [_iCloudContactEntity.dateArray addObjectsFromArray:dateAry];
        [dateAry release], dateAry = nil;
        
        
        if (_iCloudContactEntity.relatedNameArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_iCloudContactEntity.relatedNameArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
        }
        NSMutableArray *relateNameAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _relateNameFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactKeyValueEntity *entity = [[IMBContactKeyValueEntity alloc] init];
                entity.contactCategory = Contact_RelatedName;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.label = normalView.popTitle.stringValue;
                entity.value = normalView.textFiled.stringValue;
                [relateNameAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_iCloudContactEntity.relatedNameArray removeAllObjects];
        [_iCloudContactEntity.relatedNameArray addObjectsFromArray:relateNameAry];
        [relateNameAry release], relateNameAry = nil;
        
        if (_iCloudContactEntity.IMArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_iCloudContactEntity.IMArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
        }
        NSMutableArray *IMAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _IMFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactIMEntity *entity = [[IMBContactIMEntity alloc] init];
                entity.contactCategory = Contact_IM;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.label = normalView.popTitle.stringValue;
                entity.user = normalView.textFiled.stringValue;
                [IMAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_iCloudContactEntity.IMArray removeAllObjects];
        [_iCloudContactEntity.IMArray addObjectsFromArray:IMAry];
        [IMAry release], IMAry = nil;
        
        if (_iCloudContactEntity.addressArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_iCloudContactEntity.addressArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
        }
        NSMutableArray *addressAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _addressFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactAddresslView class]]) {
                IMBContactAddresslView *normalView = (IMBContactAddresslView *)view;
                IMBContactAddressEntity *entity = [[IMBContactAddressEntity alloc] init];
                entity.contactCategory = Contact_StreetAddress;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.label = normalView.popTitle.stringValue;
                entity.street = normalView.streetTextFiled.stringValue;
                entity.city = normalView.cityTextFiled.stringValue;
                entity.state = normalView.stateTextFiled.stringValue;
                entity.postalCode = normalView.postalCodeTextFiled.stringValue;
                entity.country = normalView.countryTextFiled.stringValue;
                [addressAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_iCloudContactEntity.addressArray removeAllObjects];
        [_iCloudContactEntity.addressArray addObjectsFromArray:addressAry];
        [addressAry release], addressAry = nil;
        
        for (NSView *view in _noteFiledView.subviews) {
            if ([view isKindOfClass:[NoteTextGrowthField class]]) {
                NoteTextGrowthField *text = (NoteTextGrowthField *)view;
                _iCloudContactEntity.notes = text.stringValue;
            }
        }
        IMBMyDrawCommonly *btn = (IMBMyDrawCommonly *)sender;
        _saveBlock(btn,_iCloudContactEntity);
    }else {
        _contactEntity.firstName = _firstNameFiled.stringValue?_firstNameFiled.stringValue:@"";
        _contactEntity.firstNameYomi = _phoneticFirstNameFiled.stringValue?_phoneticFirstNameFiled.stringValue:@"";
        _contactEntity.middleName = _middleNameFiled.stringValue?_middleNameFiled.stringValue:@"";
        _contactEntity.lastName = _lastNameFiled.stringValue?_lastNameFiled.stringValue:@"";
        _contactEntity.lastNameYomi = _phoneticLastNameFiled.stringValue?_phoneticLastNameFiled.stringValue:@"";
        _contactEntity.suffix = _suffixFiled.stringValue?_suffixFiled.stringValue:@"";
         _contactEntity.nickname = _nickNameFiled.stringValue?_nickNameFiled.stringValue:@"";
         _contactEntity.jobTitle = _jobTitleFiled.stringValue?_jobTitleFiled.stringValue:@"";
         _contactEntity.department = _departmentFiled.stringValue?_departmentFiled.stringValue:@"";
         _contactEntity.companyName = _companyFiled.stringValue?_companyFiled.stringValue:@"";
        _contactEntity.image = _iConData;
        
        _contactID = _contactEntity.contactId;
        _entityID = _contactEntity.entityID;
        
        if (_contactEntity.phoneNumberArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_contactEntity.phoneNumberArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
        }else {
            _contactID = _contactEntity.contactId;
            _entityID = _contactEntity.entityID;
        }
        NSMutableArray *phoneAry = [[NSMutableArray alloc] init];
        int i = 0;
        for (NSView *view in _phoneFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactKeyValueEntity *entity = [[IMBContactKeyValueEntity alloc] init];
                entity.contactCategory = Contact_PhoneNumber;
                entity.entityID = @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.type = normalView.popTitle.stringValue;
                entity.value = normalView.textFiled.stringValue;
                [phoneAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_contactEntity.phoneNumberArray removeAllObjects];
        [_contactEntity.phoneNumberArray addObjectsFromArray:phoneAry];
        [phoneAry release], phoneAry = nil;
        
        NSString *type = nil;
        if (_contactEntity.emailAddressArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_contactEntity.emailAddressArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
            type = preEntity.type?preEntity.type:@"other";
        }else {
            _contactID = nil;
            _entityID = _contactEntity.entityID;
            type = @"other";
        }
        NSMutableArray *emailAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _emailFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactKeyValueEntity *entity = [[IMBContactKeyValueEntity alloc] init];
                entity.contactCategory = Contact_EmailAddressNumber;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.type = normalView.popTitle.stringValue;
                entity.value = normalView.textFiled.stringValue;
                [emailAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_contactEntity.emailAddressArray removeAllObjects];
        [_contactEntity.emailAddressArray addObjectsFromArray:emailAry];
        [emailAry release], emailAry = nil;
        
        
        if (_contactEntity.urlArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_contactEntity.urlArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
            type = preEntity.type?preEntity.type:@"other";
        }else {
            _contactID = nil;
            _entityID = 0;
            type = @"other";
        }
        NSMutableArray *urlAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _urlFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactKeyValueEntity *entity = [[IMBContactKeyValueEntity alloc] init];
                entity.contactCategory = Contact_URL;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.type = type;
                entity.label = normalView.popTitle.stringValue;
                entity.value = normalView.textFiled.stringValue;
                [urlAry addObject:entity];
                [entity release], entity = nil;
                i ++;
            }
            
        }
        [_contactEntity.urlArray removeAllObjects];
        [_contactEntity.urlArray addObjectsFromArray:urlAry];
        [urlAry release], urlAry = nil;
        
        if (_contactEntity.dateArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_contactEntity.dateArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
        }else {
            _contactID = nil;
            _entityID = _contactEntity.entityID;
        }
        NSMutableArray *dateAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _dateFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactKeyValueEntity *entity = [[IMBContactKeyValueEntity alloc] init];
                entity.contactCategory = Contact_Date;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.type = normalView.popTitle.stringValue;
                entity.value = normalView.datePicker.dateValue;
                [dateAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_contactEntity.dateArray removeAllObjects];
        [_contactEntity.dateArray addObjectsFromArray:dateAry];
        [dateAry release], dateAry = nil;
        
        
        if (_contactEntity.relatedNameArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_contactEntity.relatedNameArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
        }else {
            _contactID = nil;
            _entityID = _contactEntity.entityID;
        }
        NSMutableArray *relateNameAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _relateNameFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactKeyValueEntity *entity = [[IMBContactKeyValueEntity alloc] init];
                entity.contactCategory = Contact_RelatedName;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.type = normalView.popTitle.stringValue;
                entity.value = normalView.textFiled.stringValue;
                [relateNameAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_contactEntity.relatedNameArray removeAllObjects];
        [_contactEntity.relatedNameArray addObjectsFromArray:relateNameAry];
        [relateNameAry release], relateNameAry = nil;
        
        NSString *server = nil;
        if (_contactEntity.IMArray.count > 0) {
            IMBContactIMEntity *preEntity = [_contactEntity.IMArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
            type = preEntity.type?preEntity.type:@"other";
            server = preEntity.service?preEntity.service:@"AIM";
        }else {
            _contactID = nil;
            _entityID = _contactEntity.entityID;
            server = @"AIM";
            type = @"other";
        }
        NSMutableArray *IMAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _IMFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactNormalView class]]) {
                IMBContactNormalView *normalView = (IMBContactNormalView *)view;
                IMBContactIMEntity *entity = [[IMBContactIMEntity alloc] init];
                entity.contactCategory = Contact_IM;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.label = normalView.popTitle.stringValue;
                entity.type = type;
                entity.service = server?server:normalView.popTitle.stringValue;
                entity.user = normalView.textFiled.stringValue;
                [IMAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_contactEntity.IMArray removeAllObjects];
        [_contactEntity.IMArray addObjectsFromArray:IMAry];
        [IMAry release], IMAry = nil;
        
        if (_contactEntity.addressArray.count > 0) {
            IMBContactKeyValueEntity *preEntity = [_contactEntity.addressArray objectAtIndex:0];
            _contactID = preEntity.contactId;
            _entityID = preEntity.entityID;
        }else {
            _contactID = _contactEntity.contactId;
            _entityID = _contactEntity.entityID;
        }
        NSMutableArray *addressAry = [[NSMutableArray alloc] init];
        i = 0;
        for (NSView *view in _addressFiledView.subviews) {
            if ([view isKindOfClass:[IMBContactAddresslView class]]) {
                IMBContactAddresslView *normalView = (IMBContactAddresslView *)view;
                IMBContactAddressEntity *entity = [[IMBContactAddressEntity alloc] init];
                entity.contactCategory = Contact_StreetAddress;
                entity.entityID =  @([_entityID intValue] +i);
                entity.contactId = _contactID;
                entity.type = normalView.popTitle.stringValue;
                entity.street = normalView.streetTextFiled.stringValue;
                entity.city = normalView.cityTextFiled.stringValue;
                entity.state = normalView.stateTextFiled.stringValue;
                entity.postalCode = normalView.postalCodeTextFiled.stringValue;
                entity.country = normalView.countryTextFiled.stringValue;
                [addressAry addObject:entity];
                [entity release], entity = nil;
            }
            i ++;
        }
        [_contactEntity.addressArray removeAllObjects];
        [_contactEntity.addressArray addObjectsFromArray:addressAry];
        [addressAry release], addressAry = nil;
        
        for (NSView *view in _noteFiledView.subviews) {
            if ([view isKindOfClass:[NoteTextGrowthField class]]) {
                NoteTextGrowthField *text = (NoteTextGrowthField *)view;
                _contactEntity.notes = text.stringValue;
            }
        }
        IMBMyDrawCommonly *btn = (IMBMyDrawCommonly *)sender;
        _saveBlock(btn,_contactEntity);
    }
}

- (void)setLineWhiteViewInSuperView:(NSView *)superView {
    IMBWhiteView *whiteView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(140, superView.frame.size.height-10, _superView.frame.size.width - 160, 1)];
    [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [whiteView setAutoresizingMask: NSViewMaxXMargin|NSViewWidthSizable];
    [superView addSubview:whiteView];
    [whiteView release];
}

- (void)setContactEntity:(IMBContactEntity *)contactEntity {
    if (_contactEntity != nil) {
        [_contactEntity release];
        _contactEntity = nil;
    }
    _contactEntity = [contactEntity retain];
    @autoreleasepool {
        [self initDoneAndCancelButton];
        [self initNormalInforView];
        [self initPhoneView];
        [self initEmailView];
        [self initRelateNameView];
        [self initUrlView];
        [self initDateView];
        [self initIMView];
        [self initAddressView];
        [self initNoteView];
        [self initAddPopBtn];
    }
}

- (void)setiCloudContactEntity:(IMBiCloudContactEntity *)iCloudContactEntity {
    if (_iCloudContactEntity != nil) {
        [_iCloudContactEntity release];
        _iCloudContactEntity = nil;
    }
    _iCloudContactEntity = [iCloudContactEntity retain];
    @autoreleasepool {
        [self initDoneAndCancelButton];
        [self initNormalInforView];
        [self initPhoneView];
        [self initEmailView];
        [self initRelateNameView];
        [self initUrlView];
        [self initDateView];
        [self initIMView];
        [self initAddressView];
        [self initNoteView];
        [self initAddPopBtn];
    }
}

- (void)initDoneAndCancelButton{
    NSString *doneStr = CustomLocalizedString(@"contact_id_92", nil);
    NSRect doneRect = [StringHelper calcuTextBounds:doneStr fontSize:13];
    int w = 80;
    if (doneRect.size.width > 80) {
        w = doneRect.size.width + 10;
    }
    IMBMyDrawCommonly *doneButton = [[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(_superView.bounds.size.width -w - 20,20 , w, 20)];
    doneButton.tag = 101;
    //设置按钮样式
    [doneButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [doneButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [doneButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [doneButton setTitleName:doneStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [doneButton setTarget:self];
    [doneButton setAction:@selector(saveContact:)];
    
    NSString *cancelStr = CustomLocalizedString(@"Calendar_id_12", nil);
    NSRect cancelRect = [StringHelper calcuTextBounds:cancelStr fontSize:13];
    int w2 = 80;
    if (cancelRect.size.width > 80) {
        w2 = cancelRect.size.width + 10;
    }
    IMBMyDrawCommonly *cancelButton = [[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(_superView.bounds.size.width -w - 20 - w2 - 20, 20, w2, doneButton.frame.size.height)];
    cancelButton.tag = 102;
    //设置按钮样式
    [cancelButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [cancelButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [cancelButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [cancelButton setTitleName:cancelStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [cancelButton setTarget:self];
    [cancelButton setAction:@selector(saveContact:)];
    
    [doneButton setAutoresizingMask:YES];
    [doneButton setAutoresizingMask:NSViewMinXMargin|NSViewMaxYMargin];
    [cancelButton setAutoresizingMask:YES];
    [cancelButton setAutoresizingMask:NSViewMinXMargin|NSViewMaxYMargin];
    [self addSubview:cancelButton];
    [self addSubview:doneButton];
    [cancelButton release], cancelButton = nil;
    [doneButton release], doneButton = nil;
}

- (void)initNormalInforView {
    _iconImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(50, 0, 62, 62)];
    [_iconImageView setWantsLayer:YES];
    [_iconImageView.layer setCornerRadius:31];
    NSImage *iconImage = nil;
    if (_contactEntity.image != nil) {
        if (_isiCloudView) {
            iconImage = [[NSImage alloc] initWithData:_iCloudContactEntity.image];
            _iConData = _iCloudContactEntity.image;
        }else {
            iconImage = [[NSImage alloc] initWithData:_contactEntity.image];
            _iConData = _contactEntity.image;
        }
        
    }else{
        iconImage = [StringHelper imageNamed:@"contact_show"];
    }
    [_iconImageView setImage:iconImage];
    [_baseFiledView addSubview:_iconImageView];
    [_iconImageView setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
    
    _baseInforHeight = 10;
    
    NSString *modifyStr = CustomLocalizedString(@"contact_id_96", nil);
    NSRect modifyRect = [StringHelper calcuTextBounds:modifyStr fontSize:13];

    IMBMyDrawCommonly *modifyButton = [[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(50 + (62-modifyRect.size.width - 24) / 2.0, 72 ,modifyRect.size.width + 24 , 20)];
    //设置按钮样式
    [modifyButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [modifyButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [modifyButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [modifyButton setTitleName:modifyStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    modifyButton.tag = 103;
    [modifyButton setTarget:self];
    [modifyButton setAction:@selector(modifyIcon:)];
    [_baseFiledView addSubview:modifyButton];
    
    //first Name
    _firstNameFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140, _baseInforHeight, 160, 22)];
    [_firstNameFiled setHasCornerBorder:YES];
    [_firstNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_firstNameFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *firstAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_1", nil)] autorelease];
    [firstAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, firstAs.string.length)];
    [firstAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, firstAs.string.length)];
    [firstAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, firstAs.string.length)];
    [_firstNameFiled.cell setPlaceholderAttributedString:firstAs];
    [_firstNameFiled.cell setLineBreakMode:NSLineBreakByClipping];
    [_baseFiledView addSubview:_firstNameFiled];
    if (_isiCloudView) {
        if (![StringHelper stringIsNilOrEmpty:_iCloudContactEntity.firstName]) {
            [_firstNameFiled.cell setStringValue:_iCloudContactEntity.firstName];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_contactEntity.firstName]) {
            [_firstNameFiled.cell setStringValue:_contactEntity.firstName];
        }
    }
    
    _baseInforHeight += 30;
    
    //phonetic first Name
    _phoneticFirstNameFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140, _baseInforHeight, 160, 22)];
    [_phoneticFirstNameFiled setHasCornerBorder:YES];
    [_phoneticFirstNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_phoneticFirstNameFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *phoneticFirstAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_86", nil)] autorelease];
    [phoneticFirstAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, phoneticFirstAs.string.length)];
    [phoneticFirstAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, phoneticFirstAs.string.length)];
    [phoneticFirstAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, phoneticFirstAs.string.length)];
    [_phoneticFirstNameFiled.cell setPlaceholderAttributedString:phoneticFirstAs];
    [_phoneticFirstNameFiled.cell setLineBreakMode:NSLineBreakByClipping];
    if (_isiCloudView) {
        if (![StringHelper stringIsNilOrEmpty:_iCloudContactEntity.firstNameYomi]) {
            [_baseFiledView addSubview:_phoneticFirstNameFiled];
            [_phoneticFirstNameFiled.cell setStringValue:_iCloudContactEntity.firstNameYomi];
            _baseInforHeight += 30;
        }else {
            [_phoneticFirstNameFiled setHidden:YES];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_contactEntity.firstNameYomi]) {
            [_baseFiledView addSubview:_phoneticFirstNameFiled];
            [_phoneticFirstNameFiled.cell setStringValue:_contactEntity.firstNameYomi];
            _baseInforHeight += 30;
        }else {
            [_phoneticFirstNameFiled setHidden:YES];
        }
    }
    
    
    //middle Name
    _middleNameFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140, _baseInforHeight, 160, 22)];
    [_middleNameFiled setHasCornerBorder:YES];
    [_middleNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_middleNameFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *middleAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_82", nil)] autorelease];
    [middleAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, middleAs.string.length)];
    [middleAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, middleAs.string.length)];
    [middleAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, middleAs.string.length)];
    [middleAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, middleAs.string.length)];
    [middleAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, middleAs.string.length)];
    [_middleNameFiled.cell setPlaceholderAttributedString:middleAs];
    [_middleNameFiled.cell setLineBreakMode:NSLineBreakByClipping];
    if (_isiCloudView) {
        if (![StringHelper stringIsNilOrEmpty:_iCloudContactEntity.middleName]) {
            [_baseFiledView addSubview:_middleNameFiled];
            [_middleNameFiled.cell setStringValue:_iCloudContactEntity.middleName];
            _baseInforHeight += 30;
        }else {
            [_middleNameFiled setHidden:YES];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_contactEntity.middleName]) {
            [_baseFiledView addSubview:_middleNameFiled];
            [_middleNameFiled.cell setStringValue:_contactEntity.middleName];
            _baseInforHeight += 30;
        }else {
            [_middleNameFiled setHidden:YES];
        }
    }

    //last Name
    _lastNameFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140, _baseInforHeight, 160, 22)];
    [_lastNameFiled setHasCornerBorder:YES];
    NSMutableAttributedString *lastAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_2", nil)] autorelease];
    [lastAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, lastAs.string.length)];
    [lastAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, lastAs.string.length)];
    [lastAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, lastAs.string.length)];
    [lastAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, lastAs.string.length)];
    [lastAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, lastAs.string.length)];
    [_lastNameFiled.cell setPlaceholderAttributedString:lastAs];
    [_lastNameFiled.cell setLineBreakMode:NSLineBreakByClipping];
    [_lastNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_lastNameFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [_baseFiledView addSubview:_lastNameFiled];
    if (_isiCloudView) {
        if (![StringHelper stringIsNilOrEmpty:_iCloudContactEntity.lastName]) {
            [_lastNameFiled setStringValue:_iCloudContactEntity.lastName];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_contactEntity.lastName]) {
            [_lastNameFiled setStringValue:_contactEntity.lastName];
        }
    }
    
    _baseInforHeight += 30;
    
    //phonetic last Name
    _phoneticLastNameFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
    [_phoneticLastNameFiled setHasCornerBorder:YES];
    [_phoneticLastNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_phoneticLastNameFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *phoneticLastNameAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_87", nil)] autorelease];
    [phoneticLastNameAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, phoneticLastNameAs.string.length)];
    [phoneticLastNameAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, phoneticLastNameAs.string.length)];
    [phoneticLastNameAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, phoneticLastNameAs.string.length)];
    [_phoneticLastNameFiled.cell setPlaceholderAttributedString:phoneticLastNameAs];
    [_phoneticLastNameFiled.cell setLineBreakMode:NSLineBreakByClipping];
    if (_isiCloudView) {
        if (![StringHelper stringIsNilOrEmpty:_iCloudContactEntity.lastNameYomi]) {
            [_baseFiledView addSubview:_phoneticLastNameFiled];
            [_phoneticLastNameFiled setStringValue:_iCloudContactEntity.lastNameYomi];
            _baseInforHeight += 30;
        }else {
            [_phoneticLastNameFiled setHidden:YES];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_contactEntity.lastNameYomi]) {
            [_baseFiledView addSubview:_phoneticLastNameFiled];
            [_phoneticLastNameFiled setStringValue:_contactEntity.lastNameYomi];
            _baseInforHeight += 30;
        }else {
            [_phoneticLastNameFiled setHidden:YES];
        }
    }
    
    
    //suffix
    _suffixFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
    [_suffixFiled setHasCornerBorder:YES];
    [_suffixFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_suffixFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *suffixAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_88", nil)] autorelease];
    [suffixAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, suffixAs.string.length)];
    [suffixAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, suffixAs.string.length)];
    [suffixAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, suffixAs.string.length)];
    [_suffixFiled.cell setPlaceholderAttributedString:suffixAs];
    [_suffixFiled.cell setLineBreakMode:NSLineBreakByClipping];
    if (_isiCloudView) {
        if (![StringHelper stringIsNilOrEmpty:_iCloudContactEntity.suffix]) {
            [_baseFiledView addSubview:_suffixFiled];
            [_suffixFiled setStringValue:_iCloudContactEntity.suffix];
            _baseInforHeight += 30;
        }else {
            [_suffixFiled setHidden:YES];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_contactEntity.suffix]) {
            [_baseFiledView addSubview:_suffixFiled];
            [_suffixFiled setStringValue:_contactEntity.suffix];
            _baseInforHeight += 30;
        }else {
            [_suffixFiled setHidden:YES];
        }
    }
    
    
    //nick Name
    _nickNameFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
    [_nickNameFiled setHasCornerBorder:YES];
    [_nickNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_nickNameFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *nickNameAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_85", nil)] autorelease];
    [nickNameAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, nickNameAs.string.length)];
    [nickNameAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, nickNameAs.string.length)];
    [nickNameAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, nickNameAs.string.length)];
    [_nickNameFiled.cell setPlaceholderAttributedString:nickNameAs];
    [_nickNameFiled.cell setLineBreakMode:NSLineBreakByClipping];
    if (_isiCloudView) {
        if (![StringHelper stringIsNilOrEmpty:_iCloudContactEntity.nickname]) {
            [_baseFiledView addSubview:_nickNameFiled];
            [_nickNameFiled setStringValue:_iCloudContactEntity.nickname];
            _baseInforHeight += 30;
        }else {
            [_nickNameFiled setHidden:YES];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_contactEntity.nickname]) {
            [_baseFiledView addSubview:_nickNameFiled];
            [_nickNameFiled setStringValue:_contactEntity.nickname];
            _baseInforHeight += 30;
        }else {
            [_nickNameFiled setHidden:YES];
        }
    }
  
    //job Title
    _jobTitleFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
    [_jobTitleFiled setHasCornerBorder:YES];
    [_jobTitleFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_jobTitleFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *jobTitleAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_83", nil)] autorelease];
    [jobTitleAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, jobTitleAs.string.length)];
    [jobTitleAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, jobTitleAs.string.length)];
    [jobTitleAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, jobTitleAs.string.length)];
    [_jobTitleFiled.cell setPlaceholderAttributedString:jobTitleAs];
    [_jobTitleFiled.cell setLineBreakMode:NSLineBreakByClipping];
    if (_isiCloudView) {
        if (![StringHelper stringIsNilOrEmpty:_iCloudContactEntity.jobTitle]) {
            [_baseFiledView addSubview:_jobTitleFiled];
            [_jobTitleFiled setStringValue:_iCloudContactEntity.jobTitle];
            _baseInforHeight += 30;
        }else {
            [_jobTitleFiled setHidden:YES];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_contactEntity.jobTitle]) {
            [_baseFiledView addSubview:_jobTitleFiled];
            [_jobTitleFiled setStringValue:_contactEntity.jobTitle];
            _baseInforHeight += 30;
        }else {
            [_jobTitleFiled setHidden:YES];
        }
    }
    
    
    //department
    _departmentFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
    [_departmentFiled setHasCornerBorder:YES];
    [_departmentFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_departmentFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *departmentAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_84", nil)] autorelease];
    [departmentAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, departmentAs.string.length)];
    [departmentAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, departmentAs.string.length)];
    [departmentAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, departmentAs.string.length)];
    [_departmentFiled.cell setPlaceholderAttributedString:departmentAs];
    [_departmentFiled.cell setLineBreakMode:NSLineBreakByClipping];
    if (_isiCloudView) {
        if (![StringHelper stringIsNilOrEmpty:_iCloudContactEntity.department]) {
            [_baseFiledView addSubview:_departmentFiled];
            [_departmentFiled setStringValue:_iCloudContactEntity.department];
            _baseInforHeight += 30;
        }else {
            [_departmentFiled setHidden:YES];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_contactEntity.department]) {
            [_baseFiledView addSubview:_departmentFiled];
            [_departmentFiled setStringValue:_contactEntity.department];
            _baseInforHeight += 30;
        }else {
            [_departmentFiled setHidden:YES];
        }
    }
    
    //company
    _companyFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
    [_companyFiled setHasCornerBorder:YES];
    [_companyFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_companyFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *companyAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_3", nil)] autorelease];
    [companyAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, companyAs.string.length)];
    [companyAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, companyAs.string.length)];
    [companyAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, companyAs.string.length)];
    [_companyFiled.cell setPlaceholderAttributedString:companyAs];
    [_companyFiled.cell setLineBreakMode:NSLineBreakByClipping];
    [_baseFiledView addSubview:_companyFiled];
    if (_isiCloudView) {
        if (![StringHelper stringIsNilOrEmpty:_iCloudContactEntity.companyName]) {
            [_companyFiled setStringValue:_iCloudContactEntity.companyName];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_contactEntity.companyName]) {
            [_companyFiled setStringValue:_contactEntity.companyName];
        }
    }
    _baseInforHeight += 35;
    [self addSubview:_baseFiledView];
    [_baseFiledView setFrameSize:NSMakeSize(_superView.bounds.size.width, _baseInforHeight)];
    [self setLineWhiteViewInSuperView:_baseFiledView];
}

- (void)initPhoneView {
    [_phoneFiledView setFrame:NSMakeRect(0, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height, _superView.frame.size.width, 0)];
    [self addSubview:_phoneFiledView];
    if (_isiCloudView) {
        if (_iCloudContactEntity.phoneNumberArray.count > 0) {
            for (int i = 0;i < _iCloudContactEntity.phoneNumberArray.count; i ++) {
                IMBContactKeyValueEntity *entity = [_iCloudContactEntity.phoneNumberArray objectAtIndex:i];
                IMBContactNormalView *phoneView  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_PhoneNumber];
                phoneView.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.label]) {
                    [phoneView.popTitle setStringValue:entity.label];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.value]) {
                    [phoneView.textFiled setStringValue:entity.value];
                }
                [_phoneFiledView addSubview:phoneView];
                [phoneView setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [phoneView release], phoneView = nil;
            }
            [_phoneFiledView setFrameSize:NSMakeSize(_superView.frame.size.width, _iCloudContactEntity.phoneNumberArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_phoneFiledView];
        }
    }else {
        if (_contactEntity.phoneNumberArray.count > 0) {
            for (int i = 0;i < _contactEntity.phoneNumberArray.count; i ++) {
                IMBContactKeyValueEntity *entity = [_contactEntity.phoneNumberArray objectAtIndex:i];
                IMBContactNormalView *phoneView  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_PhoneNumber];
                phoneView.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.type]) {
                    [phoneView.popTitle setStringValue:entity.type];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.value]) {
                    [phoneView.textFiled setStringValue:entity.value];
                }
                [_phoneFiledView addSubview:phoneView];
                [phoneView setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [phoneView release], phoneView = nil;
            }
            [_phoneFiledView setFrameSize:NSMakeSize(_superView.frame.size.width, _contactEntity.phoneNumberArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_phoneFiledView];
        }
    }
}

- (void)initEmailView {
    [_emailFiledView setFrame:NSMakeRect(0, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height, _superView.frame.size.width, 0)];
    [self addSubview:_emailFiledView];
    if (_isiCloudView) {
        if (_iCloudContactEntity.emailAddressArray.count > 0) {
            for (int i = 0;i < _iCloudContactEntity.emailAddressArray.count; i ++) {
                IMBContactKeyValueEntity *entity = [_iCloudContactEntity.emailAddressArray objectAtIndex:i];
                IMBContactNormalView *emailView  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_EmailAddressNumber];
                emailView.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.label]) {
                    [emailView.popTitle setStringValue:entity.label];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.value]) {
                    [emailView.textFiled setStringValue:entity.value];
                }
                [_emailFiledView addSubview:emailView];
                [emailView setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [emailView release], emailView = nil;
            }
            [_emailFiledView setFrameSize:NSMakeSize(_superView.frame.size.width, _iCloudContactEntity.emailAddressArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_emailFiledView];
        }
    }else {
        if (_contactEntity.emailAddressArray.count > 0) {
            for (int i = 0;i < _contactEntity.emailAddressArray.count; i ++) {
                IMBContactKeyValueEntity *entity = [_contactEntity.emailAddressArray objectAtIndex:i];
                IMBContactNormalView *emailView  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_EmailAddressNumber];
                emailView.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.type]) {
                    [emailView.popTitle setStringValue:entity.type];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.value]) {
                    [emailView.textFiled setStringValue:entity.value];
                }
                [_emailFiledView addSubview:emailView];
                [emailView setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [emailView release], emailView = nil;
            }
            [_emailFiledView setFrameSize:NSMakeSize(_superView.frame.size.width, _contactEntity.emailAddressArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_emailFiledView];
        }
    }
}

- (void)initRelateNameView {
    [_relateNameFiledView setFrame:NSMakeRect(0, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height, _superView.frame.size.width, 0)];
    [self addSubview:_relateNameFiledView];
    if (_isiCloudView) {
        if (_iCloudContactEntity.relatedNameArray.count > 0) {
            for (int i = 0;i < _iCloudContactEntity.relatedNameArray.count; i ++) {
                IMBContactKeyValueEntity *entity = [_iCloudContactEntity.relatedNameArray objectAtIndex:i];
                IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_RelatedName];
                view.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.label]) {
                    [view.popTitle setStringValue:entity.label];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.value]) {
                    [view.textFiled setStringValue:entity.value];
                }
                [_relateNameFiledView addSubview:view];
                [view setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [view release], view = nil;
            }
            [_relateNameFiledView setFrameSize:NSMakeSize( _superView.frame.size.width,_iCloudContactEntity.relatedNameArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_relateNameFiledView];
        }
    }else {
        if (_contactEntity.relatedNameArray.count > 0) {
            for (int i = 0;i < _contactEntity.relatedNameArray.count; i ++) {
                IMBContactKeyValueEntity *entity = [_contactEntity.relatedNameArray objectAtIndex:i];
                IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_RelatedName];
                view.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.type]) {
                    [view.popTitle setStringValue:entity.type];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.value]) {
                    [view.textFiled setStringValue:entity.value];
                }
                [_relateNameFiledView addSubview:view];
                [view setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [view release], view = nil;
            }
            [_relateNameFiledView setFrameSize:NSMakeSize( _superView.frame.size.width,_contactEntity.relatedNameArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_relateNameFiledView];
        }
    }
}

- (void)initUrlView {
    [_urlFiledView setFrame:NSMakeRect(0, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height + _relateNameFiledView.bounds.size.height, _superView.frame.size.width, 0)];
    [self addSubview:_urlFiledView];
    if (_isiCloudView) {
        if (_iCloudContactEntity.urlArray.count > 0) {
            for (int i = 0;i < _iCloudContactEntity.urlArray.count; i ++) {
                IMBContactKeyValueEntity *entity = [_iCloudContactEntity.urlArray objectAtIndex:i];
                IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_URL];
                view.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.label]) {
                    [view.popTitle setStringValue:entity.label];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.value]) {
                    [view.textFiled setStringValue:entity.value];
                }
                [_urlFiledView addSubview:view];
                [view setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [view release], view = nil;
            }
            [_urlFiledView setFrameSize:NSMakeSize( _superView.frame.size.width,_iCloudContactEntity.urlArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_urlFiledView];
        }
    }else {
        if (_contactEntity.urlArray.count > 0) {
            for (int i = 0;i < _contactEntity.urlArray.count; i ++) {
                IMBContactKeyValueEntity *entity = [_contactEntity.urlArray objectAtIndex:i];
                IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_URL];
                view.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.type]) {
                    [view.popTitle setStringValue:entity.type];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.value]) {
                    [view.textFiled setStringValue:entity.value];
                }
                [_urlFiledView addSubview:view];
                [view setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [view release], view = nil;
            }
            [_urlFiledView setFrameSize:NSMakeSize( _superView.frame.size.width,_contactEntity.urlArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_urlFiledView];
        }
    }
}

- (void)initDateView {
    [_dateFiledView setFrame:NSMakeRect(0, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height, _superView.frame.size.width, 0)];
    [self addSubview:_dateFiledView];
    if (_isiCloudView) {
        if (_iCloudContactEntity.dateArray.count > 0) {
            for (int i = 0;i < _iCloudContactEntity.dateArray.count; i ++) {
                IMBContactKeyValueEntity *entity = [_iCloudContactEntity.dateArray objectAtIndex:i];
                IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_Date];
                view.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.label]) {
                    [view.popTitle setStringValue:entity.label];
                }
                if (entity.value > 0) {
                    [view.datePicker setDateValue:entity.value];
                }
                [_dateFiledView addSubview:view];
                [view setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [view release], view = nil;
            }
            [_dateFiledView setFrameSize:NSMakeSize( _superView.frame.size.width,_iCloudContactEntity.dateArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_dateFiledView];
        }
    }else {
        if (_contactEntity.dateArray.count > 0) {
            for (int i = 0;i < _contactEntity.dateArray.count; i ++) {
                IMBContactKeyValueEntity *entity = [_contactEntity.dateArray objectAtIndex:i];
                IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_Date];
                view.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.type]) {
                    [view.popTitle setStringValue:entity.type];
                }
                if (entity.value > 0) {
                    [view.datePicker setDateValue:entity.value];
                }
                [_dateFiledView addSubview:view];
                [view setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [view release], view = nil;
            }
            [_dateFiledView setFrameSize:NSMakeSize( _superView.frame.size.width,_contactEntity.dateArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_dateFiledView];
        }
    }
}

- (void)initIMView {
    [_IMFiledView setFrame:NSMakeRect(0, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height, _superView.frame.size.width, 0)];
    [self addSubview:_IMFiledView];
    if (_isiCloudView) {
        if (_iCloudContactEntity.IMArray.count > 0) {
            for (int i = 0;i < _iCloudContactEntity.IMArray.count; i ++) {
                IMBContactIMEntity *entity = [_iCloudContactEntity.IMArray objectAtIndex:i];
                IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_IM];
                view.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.label]) {
                    [view.popTitle setStringValue:entity.label];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.user]) {
                    [view.textFiled setStringValue:entity.user];
                }
                [_IMFiledView addSubview:view];
                [view setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [view release], view = nil;
            }
            [_IMFiledView setFrameSize:NSMakeSize( _superView.frame.size.width,_iCloudContactEntity.IMArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_IMFiledView];
        }
    }else {
        if (_contactEntity.IMArray.count > 0) {
            for (int i = 0;i < _contactEntity.IMArray.count; i ++) {
                IMBContactIMEntity *entity = [_contactEntity.IMArray objectAtIndex:i];
                IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_IM];
                view.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.label]) {
                    [view.popTitle setStringValue:entity.label];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.user]) {
                    [view.textFiled setStringValue:entity.user];
                }
                [_IMFiledView addSubview:view];
                [view setFrame:NSMakeRect(0, i * 30, _superView.frame.size.width, 30)];
                [view release], view = nil;
            }
            [_IMFiledView setFrameSize:NSMakeSize( _superView.frame.size.width,_contactEntity.IMArray.count * 30 + 10)];
            [self setLineWhiteViewInSuperView:_IMFiledView];
        }
    }
}

- (void)initAddressView {
    [_addressFiledView setFrame:NSMakeRect(0, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height, _superView.frame.size.width, 0)];
     [self addSubview:_addressFiledView];
    if (_isiCloudView) {
        if (_iCloudContactEntity.addressArray.count > 0) {
            for (int i = 0;i < _iCloudContactEntity.addressArray.count; i ++) {
                IMBContactAddressEntity *entity = [_iCloudContactEntity.addressArray objectAtIndex:i];
                IMBContactAddresslView *view  = [[IMBContactAddresslView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 160) withCategory:Contact_StreetAddress];
                view.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.label]) {
                    [view.popTitle setStringValue:entity.label];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.street]) {
                    [view.streetTextFiled setStringValue:entity.street];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.city]) {
                    [view.cityTextFiled setStringValue:entity.city];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.state]) {
                    [view.stateTextFiled setStringValue:entity.state];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.postalCode]) {
                    [view.postalCodeTextFiled setStringValue:entity.postalCode];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.country]) {
                    [view.countryTextFiled setStringValue:entity.country];
                }
                [_addressFiledView addSubview:view];
                [view setFrame:NSMakeRect(0, i * 160, _superView.frame.size.width, 160)];
                [view release], view = nil;
            }
            [_addressFiledView setFrameSize:NSMakeSize( _superView.frame.size.width,_iCloudContactEntity.addressArray.count * 160 + 10)];
            [self setLineWhiteViewInSuperView:_addressFiledView];
        }
    }else {
        if (_contactEntity.addressArray.count > 0) {
            for (int i = 0;i < _contactEntity.addressArray.count; i ++) {
                IMBContactAddressEntity *entity = [_contactEntity.addressArray objectAtIndex:i];
                IMBContactAddresslView *view  = [[IMBContactAddresslView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 160) withCategory:Contact_StreetAddress];
                view.delegate = self;
                if (![StringHelper stringIsNilOrEmpty:entity.type]) {
                    [view.popTitle setStringValue:entity.type];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.street]) {
                    [view.streetTextFiled setStringValue:entity.street];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.city]) {
                    [view.cityTextFiled setStringValue:entity.city];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.state]) {
                    [view.stateTextFiled setStringValue:entity.state];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.postalCode]) {
                    [view.postalCodeTextFiled setStringValue:entity.postalCode];
                }
                if (![StringHelper stringIsNilOrEmpty:entity.country]) {
                    [view.countryTextFiled setStringValue:entity.country];
                }
                [_addressFiledView addSubview:view];
                [view setFrame:NSMakeRect(0, i * 160, _superView.frame.size.width, 160)];
                [view release], view = nil;
            }
            [_addressFiledView setFrameSize:NSMakeSize( _superView.frame.size.width,_contactEntity.addressArray.count * 160 + 10)];
            [self setLineWhiteViewInSuperView:_addressFiledView];
        }
    }
}

- (void)initNoteView {
    NSTextField *noteTitle = [[NSTextField alloc] initWithFrame:NSMakeRect(30, 5, 100, 20)];
    noteTitle.tag = 104;
    [noteTitle setDrawsBackground:NO];
    [noteTitle setEditable:NO];
    [noteTitle setSelectable:NO];
    [noteTitle setBordered:NO];
    [noteTitle setAlignment:NSRightTextAlignment];
    [noteTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [noteTitle setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [noteTitle setStringValue:CustomLocalizedString(@"contact_id_91", nil)];
    [_noteFiledView addSubview:noteTitle];
    
    NoteTextGrowthField *note = [[NoteTextGrowthField alloc] initWithFrame:NSMakeRect(140, 5, _superView.frame.size.width - 160, 20)];
    [note.cell setDrawsBackground:NO];
    [note setDrawsBackground:NO];
    [note setIsFillet:YES];
    [note setNeedsDisplay:YES];
    if (_isiCloudView) {
        if (![StringHelper stringIsNilOrEmpty:_iCloudContactEntity.notes]) {
            [note setStringValue:_iCloudContactEntity.notes];
        }else {
            [note setStringValue:@""];
        }
    }else {
        if (![StringHelper stringIsNilOrEmpty:_contactEntity.notes]) {
            [note setStringValue:_contactEntity.notes];
        }else {
            [note setStringValue:@""];
        }
    }
    [note setAutoresizingMask: NSViewMaxXMargin|NSViewWidthSizable];
    [note setFontSize:13];
    
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:4.0];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:note.stringValue];
    NSRange range = NSMakeRange(0, as.length);
    [as addAttribute:NSParagraphStyleAttributeName value:textParagraph range:range];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:range];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:range];
    [note setAttributedStringValue:as];
    [as release], as = nil;

    [note addObserver:self forKeyPath:@"editAttributedString" options:NSKeyValueObservingOptionNew context:nil];
    
    [note setIsEditing:NO];
    [note.cell setSelectable:NO];
    
    [note setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [note setCanBeEditing:YES];
    [_noteFiledView setFrame:NSMakeRect(0, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height, _superView.frame.size.width, note.lastIntrinsicSize.height + 40)];

    [_noteFiledView addSubview:note];
    [self addSubview:_noteFiledView];
    [self setLineWhiteViewInSuperView:_noteFiledView];
}

- (void)initAddPopBtn {
    _kindButton = [[NSPopUpButton alloc]initWithFrame:NSMakeRect(20, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height + _noteFiledView.bounds.size.height, 16, 16)];
    [_kindButton setCell:[[IMBPopupKindButtonCell alloc] init]];
    [_kindButton.cell setArrowPosition:NSPopUpNoArrow];
    [_kindButton setTarget:self];
    [_kindButton setAction:@selector(addNewContent:)];
    [_kindButton removeAllItems];
    [_kindButton setBordered:NO];
    [_kindButton addItemsWithTitles:[NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_82", nil),CustomLocalizedString(@"contact_id_83", nil),CustomLocalizedString(@"contact_id_84", nil),CustomLocalizedString(@"contact_id_85", nil),CustomLocalizedString(@"contact_id_86", nil),CustomLocalizedString(@"contact_id_87", nil),CustomLocalizedString(@"contact_id_88", nil),CustomLocalizedString(@"contact_id_41", nil),CustomLocalizedString(@"contact_id_42", nil),CustomLocalizedString(@"contact_id_43", nil),CustomLocalizedString(@"contact_id_81", nil),CustomLocalizedString(@"contact_id_47", nil),CustomLocalizedString(@"contact_id_44", nil),CustomLocalizedString(@"contact_id_58", nil), nil]];
    [self addSubview:_kindButton];
    
    _addTextFiled = [[NSTextField alloc] initWithFrame:NSMakeRect(40, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height + _noteFiledView.bounds.size.height - 2, 300 , 20)];
    _addTextFiled.tag = 105;
    [_addTextFiled setDrawsBackground:NO];
    [_addTextFiled setEditable:NO];
    [_addTextFiled setSelectable:NO];
    [_addTextFiled setBordered:NO];
    [_addTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_addTextFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [_addTextFiled setStringValue:CustomLocalizedString(@"contact_id_62", nil)];
    [self addSubview:_addTextFiled];
    
    [self setFrameSize:NSMakeSize(_superView.bounds.size.width, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height + _noteFiledView.bounds.size.height + 30)];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
     if ([keyPath isEqualToString:@"editAttributedString"]) {
         NoteTextGrowthField *note =  (NoteTextGrowthField *)object;
         [_noteFiledView setFrame:NSMakeRect(0, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height, _superView.frame.size.width, note.lastIntrinsicSize.height + 40)];
         for (NSView *view in _noteFiledView.subviews) {
             if ([view isKindOfClass:[IMBWhiteView class]]) {
                 [view setFrame:NSMakeRect(140, _noteFiledView.frame.size.height-10, _superView.frame.size.width - 160, 1)];
             }
         }
     }
    [_kindButton setFrame:NSMakeRect(20, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height + _noteFiledView.bounds.size.height, 16, 16)];
    
     [_addTextFiled setFrame:NSMakeRect(50, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height + _noteFiledView.bounds.size.height - 2, 300 , 20)];
    [self setFrameSize:NSMakeSize(_superView.bounds.size.width, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height + _noteFiledView.bounds.size.height + 30)];
}

- (void)addNewContent:(id)sender {
    NSPopUpButton *kindButton = (NSPopUpButton *)sender;
    NSString *title = kindButton.selectedItem.title;
    if ([title isEqualToString:CustomLocalizedString(@"contact_id_82", nil)]) {
        if ([_baseFiledView.subviews containsObject:_middleNameFiled] ) {
            return;
        }else {
            [_middleNameFiled setHidden:NO];
            [_baseFiledView addSubview:_middleNameFiled];
        }
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_83", nil)]) {
        if ([_baseFiledView.subviews containsObject:_jobTitleFiled]) {
            return;
        }else {
            [_jobTitleFiled setHidden:NO];
            [_baseFiledView addSubview:_jobTitleFiled];
        }
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_84", nil)]) {
        if ([_baseFiledView.subviews containsObject:_departmentFiled] ) {
            return;
        }else {
            [_departmentFiled setHidden:NO];
            [_baseFiledView addSubview:_departmentFiled];
        }
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_85", nil)]) {
        if ([_baseFiledView.subviews containsObject:_nickNameFiled] ) {
            return;
        }else {
            [_nickNameFiled setHidden:NO];
            [_baseFiledView addSubview:_nickNameFiled];
        }
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_86", nil)]) {
        if ([_baseFiledView.subviews containsObject:_phoneticFirstNameFiled] ) {
            return;
        }else {
            [_phoneticFirstNameFiled setHidden:NO];
            [_baseFiledView addSubview:_phoneticFirstNameFiled];
        }
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_87", nil)]) {
        if ([_baseFiledView.subviews containsObject:_phoneticLastNameFiled] ) {
            return;
        }else {
            [_phoneticLastNameFiled setHidden:NO];
            [_baseFiledView addSubview:_phoneticLastNameFiled];
        }
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_88", nil)]) {
        if ([_baseFiledView.subviews containsObject:_suffixFiled] ) {
            return;
        }else {
            [_suffixFiled setHidden:NO];
            [_baseFiledView addSubview:_suffixFiled];
        }
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_41", nil)]) {
        if (_phoneFiledView.subviews.count == 0) {
            [self setLineWhiteViewInSuperView:_phoneFiledView];
        }
        IMBContactNormalView *phoneView  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_PhoneNumber];
        phoneView.delegate = self;
        [phoneView.popTitle setStringValue:CustomLocalizedString(@"contact_id_40", nil)];
        [phoneView.textFiled setStringValue:@""];
        [_phoneFiledView addSubview:phoneView];
        [phoneView release], phoneView = nil;

    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_42", nil)]) {
        if (_emailFiledView.subviews.count == 0) {
            [self setLineWhiteViewInSuperView:_emailFiledView];
        }
        IMBContactNormalView *emailView  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_EmailAddressNumber];
        emailView.delegate = self;
        [emailView.popTitle setStringValue:CustomLocalizedString(@"contact_id_5", nil)];
        [emailView.textFiled setStringValue:@""];
        [_emailFiledView addSubview:emailView];
        [emailView release], emailView = nil;
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_43", nil)]) {
        if (_urlFiledView.subviews.count == 0) {
            [self setLineWhiteViewInSuperView:_urlFiledView];
        }
        IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_URL];
        view.delegate = self;
        [view.popTitle setStringValue:CustomLocalizedString(@"contact_id_14", nil)];
        [view.textFiled setStringValue:@""];
        [_urlFiledView addSubview:view];
        [view release], view = nil;
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_81", nil)]) {
        if (_addressFiledView.subviews.count == 0) {
            [self setLineWhiteViewInSuperView:_addressFiledView];
        }
        IMBContactAddresslView *view  = [[IMBContactAddresslView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 160) withCategory:Contact_StreetAddress];
        view.delegate = self;
        [view.popTitle setStringValue:CustomLocalizedString(@"contact_id_5", nil)];
        [view.streetTextFiled setStringValue:@""];
        [view.cityTextFiled setStringValue:@""];
        [view.stateTextFiled setStringValue:@""];
        [view.postalCodeTextFiled setStringValue:@""];
        [view.countryTextFiled setStringValue:@""];
        [_addressFiledView addSubview:view];
        [view release], view = nil;
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_47", nil)]) {
        if (_dateFiledView.subviews.count == 0) {
            [self setLineWhiteViewInSuperView:_dateFiledView];
        }
        IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_Date];
        view.delegate = self;
        [view.popTitle setStringValue:CustomLocalizedString(@"contact_id_38", nil)];
        [view.datePicker setDateValue:[NSDate date]];
        [_dateFiledView addSubview:view];
        [view release], view = nil;
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_44", nil)]) {
        if (_relateNameFiledView.subviews.count == 0) {
            [self setLineWhiteViewInSuperView:_relateNameFiledView];
        }
        IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_RelatedName];
        view.delegate = self;
        [view.popTitle setStringValue:CustomLocalizedString(@"contact_id_17", nil)];
        [view.textFiled setStringValue:@""];
        [_relateNameFiledView addSubview:view];
        [view release], view = nil;
    }else if ([title isEqualToString:CustomLocalizedString(@"contact_id_58", nil)]) {
        if (_IMFiledView.subviews.count == 0) {
            [self setLineWhiteViewInSuperView:_IMFiledView];
        }
        IMBContactNormalView *view  = [[IMBContactNormalView alloc] initWithFrame:NSMakeRect(0, 0, _superView.frame.size.width, 30) withCategory:Contact_IM];
        view.delegate = self;
        [view.popTitle setStringValue:CustomLocalizedString(@"contact_id_28", nil)];
        [view.textFiled setStringValue:@""];
        [_IMFiledView addSubview:view];
        [view release], view = nil;
    }
    [self reloadNornmalView];
    [self reloadFrame];
}

- (void)reloadNornmalView {
    [_iconImageView setFrame:NSMakeRect(50, 0, 62, 62)];
    _baseInforHeight = 10;
    
    [_firstNameFiled setFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
    _baseInforHeight += 30;
    
    if (!_phoneticFirstNameFiled.isHidden) {
        [_phoneticFirstNameFiled setFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
        _baseInforHeight += 30;
    }
    
    if (!_middleNameFiled.isHidden) {
        [_middleNameFiled setFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
        _baseInforHeight += 30;
    }
    
    [_lastNameFiled setFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
    _baseInforHeight += 30;
    
    if (!_phoneticLastNameFiled.isHidden) {
        [_phoneticLastNameFiled setFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
        _baseInforHeight += 30;
    }
    
    if (!_suffixFiled.isHidden) {
        [_suffixFiled setFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
        _baseInforHeight += 30;
    }
    
    if (!_nickNameFiled.isHidden) {
        [_nickNameFiled setFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
        _baseInforHeight += 30;
    }
    
    if (!_jobTitleFiled.isHidden) {
        [_jobTitleFiled setFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
        _baseInforHeight += 30;
    }
    
    if (!_departmentFiled.isHidden) {
        [_departmentFiled setFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
        _baseInforHeight += 30;
    }
    
    [_companyFiled setFrame:NSMakeRect(140, _baseInforHeight, 160, 20)];
    _baseInforHeight += 35;
    
    [_baseFiledView setFrameSize:NSMakeSize(_superView.bounds.size.width, _baseInforHeight)];
    for (NSView *view  in _baseFiledView.subviews) {
        if ([view isKindOfClass:[IMBWhiteView class]]) {
            [view setFrame:NSMakeRect(140, _baseFiledView.frame.size.height-10, _superView.frame.size.width - 160, 1)];
            }
    }
}
             
- (void)reloadFrame {
 if (_phoneFiledView.subviews.count > 1) {
     [_phoneFiledView setFrame:NSMakeRect(0,  _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height, _superView.frame.size.width, (_phoneFiledView.subviews.count - 1) * 30 + 10)];
     int y = 0;
     for (int i = 0;i < _phoneFiledView.subviews.count; i ++) {
         NSView *phoneView  = [_phoneFiledView.subviews objectAtIndex:i];
         if ([phoneView isKindOfClass:[IMBContactNormalView class]]) {
             [phoneView setFrame:NSMakeRect(0, y * 30, _superView.frame.size.width, 30)];
             y ++;
         }else if ([phoneView isKindOfClass:[IMBWhiteView class]]) {
             [phoneView setFrame:NSMakeRect(140, _phoneFiledView.frame.size.height - 10, _superView.frame.size.width - 160, 1)];
         }
     }
 }else {
     if(_phoneFiledView.subviews.count > 0) {//移除分割线
         NSView *view = [_phoneFiledView.subviews objectAtIndex:0];
         [view removeFromSuperview];
     }
     [_phoneFiledView setFrameSize:NSMakeSize(_superView.frame.size.width, 0)];
 }
 
 if (_emailFiledView.subviews.count > 1) {
     [_emailFiledView setFrame:NSMakeRect(0,_baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height,_superView.frame.size.width, (_emailFiledView.subviews.count - 1) * 30 + 10)];
     int y = 0;
     for (int i = 0;i < _emailFiledView.subviews.count; i ++) {
         NSView *emailView  = [_emailFiledView.subviews objectAtIndex:i];
         if ([emailView isKindOfClass:[IMBContactNormalView class]]) {
             [emailView setFrame:NSMakeRect(0, y * 30, _superView.frame.size.width, 30)];
             y ++;
         }else if ([emailView isKindOfClass:[IMBWhiteView class]]) {
             [emailView setFrame:NSMakeRect(140, _emailFiledView.frame.size.height - 10, _superView.frame.size.width - 160, 1)];
         }
     }
 }else {
     if(_emailFiledView.subviews.count > 0) {
         NSView *view = [_emailFiledView.subviews objectAtIndex:0];
         [view removeFromSuperview];
     }
     [_emailFiledView setFrameSize:NSMakeSize(_superView.frame.size.width, 0)];
 }
 
 if (_relateNameFiledView.subviews.count > 1) {
     [_relateNameFiledView setFrame:NSMakeRect(0,_baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height,_superView.frame.size.width, (_relateNameFiledView.subviews.count - 1) * 30 + 10)];
     int y = 0;
     for (int i = 0;i < _relateNameFiledView.subviews.count; i ++) {
         NSView *relateNameView  = [_relateNameFiledView.subviews objectAtIndex:i];
         if ([relateNameView isKindOfClass:[IMBContactNormalView class]]) {
             [relateNameView setFrame:NSMakeRect(0, y * 30, _superView.frame.size.width, 30)];
             y ++;
         }else if ([relateNameView isKindOfClass:[IMBWhiteView class]]) {
             [relateNameView setFrame:NSMakeRect(140, _relateNameFiledView.frame.size.height - 10, _superView.frame.size.width - 160, 1)];
         }
     }
 }else {
     if(_relateNameFiledView.subviews.count > 0) {
         NSView *view = [_relateNameFiledView.subviews objectAtIndex:0];
         [view removeFromSuperview];
     }
     [_relateNameFiledView setFrameSize:NSMakeSize(_superView.frame.size.width, 0)];
 }
 
 if (_urlFiledView.subviews.count > 1) {
     [_urlFiledView setFrame:NSMakeRect(0,_baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height + _relateNameFiledView.bounds.size.height,_superView.frame.size.width, (_urlFiledView.subviews.count - 1) * 30 + 10)];
     int y = 0;
     for (int i = 0;i < _urlFiledView.subviews.count; i ++) {
         NSView *urlNameView  = [_urlFiledView.subviews objectAtIndex:i];
         if ([urlNameView isKindOfClass:[IMBContactNormalView class]]) {
             [urlNameView setFrame:NSMakeRect(0, y * 30, _superView.frame.size.width, 30)];
             y ++;
         }else if ([urlNameView isKindOfClass:[IMBWhiteView class]]) {
             [urlNameView setFrame:NSMakeRect(140, _urlFiledView.frame.size.height - 10, _superView.frame.size.width - 160, 1)];
         }
     }
 }else {
     if(_urlFiledView.subviews.count > 0) {
         NSView *view = [_urlFiledView.subviews objectAtIndex:0];
         [view removeFromSuperview];
     }
     [_urlFiledView setFrameSize:NSMakeSize(_superView.frame.size.width, 0)];
 }
 
 if (_dateFiledView.subviews.count > 1) {
     [_dateFiledView setFrame:NSMakeRect(0,_baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height + _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height,_superView.frame.size.width, (_dateFiledView.subviews.count - 1) * 30 + 10)];
     int y = 0;
     for (int i = 0;i < _dateFiledView.subviews.count; i ++) {
         NSView *view  = [_dateFiledView.subviews objectAtIndex:i];
         if ([view isKindOfClass:[IMBContactNormalView class]]) {
             [view setFrame:NSMakeRect(0, y * 30, _superView.frame.size.width, 30)];
             y ++;
         }else if ([view isKindOfClass:[IMBWhiteView class]]) {
             [view setFrame:NSMakeRect(140, _dateFiledView.frame.size.height - 10, _superView.frame.size.width - 160, 1)];
         }
     }
 }else {
     if(_dateFiledView.subviews.count > 0) {
         NSView *view = [_dateFiledView.subviews objectAtIndex:0];
         [view removeFromSuperview];
     }
     [_dateFiledView setFrameSize:NSMakeSize(_superView.frame.size.width, 0)];
 }
 
 if (_IMFiledView.subviews.count > 1) {
     [_IMFiledView setFrame:NSMakeRect(0,_baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height + _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height,_superView.frame.size.width, (_IMFiledView.subviews.count - 1) * 30 + 10)];
     int y = 0;
     for (int i = 0;i < _IMFiledView.subviews.count; i ++) {
         NSView *view  = [_IMFiledView.subviews objectAtIndex:i];
         if ([view isKindOfClass:[IMBContactNormalView class]]) {
             [view setFrame:NSMakeRect(0, y * 30, _superView.frame.size.width, 30)];
             y ++;
         }else if ([view isKindOfClass:[IMBWhiteView class]]) {
             [view setFrame:NSMakeRect(140, _IMFiledView.frame.size.height - 10, _superView.frame.size.width - 160, 1)];
         }
     }
 }else {
     if(_IMFiledView.subviews.count > 0) {
         NSView *view = [_IMFiledView.subviews objectAtIndex:0];
         [view removeFromSuperview];
     }
     [_IMFiledView setFrameSize:NSMakeSize(_superView.frame.size.width, 0)];
 }
 
 if (_addressFiledView.subviews.count > 1) {
     [_addressFiledView setFrame:NSMakeRect(0,_baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height + _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height,_superView.frame.size.width, (_addressFiledView.subviews.count - 1) * 160 + 10)];
     int y = 0;
     for (int i = 0;i < _addressFiledView.subviews.count; i ++) {
         NSView *view  = [_addressFiledView.subviews objectAtIndex:i];
         if ([view isKindOfClass:[IMBContactAddresslView class]]) {
             [view setFrame:NSMakeRect(0, y * 160, _superView.frame.size.width, 160)];
             y ++;
         }else if ([view isKindOfClass:[IMBWhiteView class]]) {
             [view setFrame:NSMakeRect(140, _addressFiledView.frame.size.height - 10, _superView.frame.size.width - 160, 1)];
         }
     }
 }else {
     if(_addressFiledView.subviews.count > 0) {
         NSView *view = [_addressFiledView.subviews objectAtIndex:0];
         [view removeFromSuperview];
     }
     [_addressFiledView setFrameSize:NSMakeSize(_superView.frame.size.width, 0)];
 }
 
    [_noteFiledView setFrame:NSMakeRect(0, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height, _superView.frame.size.width, 70)];
 
    [_kindButton setFrame:NSMakeRect(20, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height + _noteFiledView.bounds.size.height, 16, 16)];
    
    [_addTextFiled setFrame:NSMakeRect(50, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height + _noteFiledView.bounds.size.height - 2, 300 , 20)];
    
    [self setFrameSize:NSMakeSize(_superView.bounds.size.width, _baseFiledView.frame.origin.y +_baseFiledView.frame.size.height + _phoneFiledView.bounds.size.height + _emailFiledView.bounds.size.height+ _relateNameFiledView.bounds.size.height + _urlFiledView.bounds.size.height + _dateFiledView.bounds.size.height + _IMFiledView.bounds.size.height + _addressFiledView.bounds.size.height + _noteFiledView.bounds.size.height + 30)];
}

#pragma mark - 修改图片
- (void)modifyIcon:(id)sender {
    NSArray *supportFiles = [[MediaHelper getSupportFileTypeArray:Category_MyAlbums supportVideo:NO supportConvert:YES withiPod:nil] componentsSeparatedByString:@";"];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:supportFiles];
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSFileHandlingPanelOKButton) {
            NSString *path = [[openPanel URL] path];
            NSImage *imageName = [[NSImage alloc] initWithContentsOfFile:path];
            NSData *imageData = [TempHelper createThumbnail:imageName withWidth:200 withHeight:200];
            NSImage *image = [[[NSImage alloc] initWithData:imageData] autorelease];
            [_iconImageView setImage:image];
            _iConData = imageData;
            [imageName release];
        }
    }];
}

- (BOOL)isFlipped{
    return YES;
}

- (void)changeSkin:(NSNotification *)notification {
    IMBMyDrawCommonly *doneButton = [self viewWithTag:101];
    [doneButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [doneButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [doneButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [doneButton setTitleName:CustomLocalizedString(@"contact_id_92", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [doneButton setNeedsDisplay:YES];

    IMBMyDrawCommonly *cancelButton = [self viewWithTag:102];
    [cancelButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [cancelButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [cancelButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [cancelButton setTitleName:CustomLocalizedString(@"Calendar_id_12", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [cancelButton setNeedsDisplay:YES];
    
    IMBMyDrawCommonly *modifyButton = [self viewWithTag:103];
    NSString *modifyStr = CustomLocalizedString(@"contact_id_96", nil);
    [modifyButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [modifyButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [modifyButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [modifyButton setTitleName:modifyStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [modifyButton setNeedsDisplay:YES];
    
    NSMutableAttributedString *firstAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_1", nil)] autorelease];
    [firstAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, firstAs.string.length)];
    [firstAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, firstAs.string.length)];
    [firstAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, firstAs.string.length)];
    [_firstNameFiled.cell setPlaceholderAttributedString:firstAs];
    [_firstNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    NSMutableAttributedString *phoneticFirstAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_86", nil)] autorelease];
    [phoneticFirstAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, phoneticFirstAs.string.length)];
    [phoneticFirstAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, phoneticFirstAs.string.length)];
    [phoneticFirstAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, phoneticFirstAs.string.length)];
    [_phoneticFirstNameFiled.cell setPlaceholderAttributedString:phoneticFirstAs];
    [_phoneticFirstNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    NSMutableAttributedString *middleAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_82", nil)] autorelease];
    [middleAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, middleAs.string.length)];
    [middleAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, middleAs.string.length)];
    [middleAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, middleAs.string.length)];
    [_middleNameFiled.cell setPlaceholderAttributedString:middleAs];
    [_middleNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    NSMutableAttributedString *lastAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_2", nil)] autorelease];
    [lastAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, lastAs.string.length)];
    [lastAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, lastAs.string.length)];
    [lastAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, lastAs.string.length)];
    [_lastNameFiled.cell setPlaceholderAttributedString:lastAs];
    [_lastNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    NSMutableAttributedString *phoneticLastNameAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_87", nil)] autorelease];
    [phoneticLastNameAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, phoneticLastNameAs.string.length)];
    [_phoneticLastNameFiled.cell setPlaceholderAttributedString:phoneticLastNameAs];
    [phoneticLastNameAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, phoneticLastNameAs.string.length)];
    [phoneticLastNameAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, phoneticLastNameAs.string.length)];
    [_phoneticLastNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    NSMutableAttributedString *suffixAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_88", nil)] autorelease];
    [suffixAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, suffixAs.string.length)];
    [suffixAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, suffixAs.string.length)];
    [suffixAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, suffixAs.string.length)];
    [_suffixFiled.cell setPlaceholderAttributedString:suffixAs];
    [_suffixFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    NSMutableAttributedString *nickNameAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_85", nil)] autorelease];
    [nickNameAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, nickNameAs.string.length)];
    [nickNameAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, nickNameAs.string.length)];
    [nickNameAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, nickNameAs.string.length)];
    [_nickNameFiled.cell setPlaceholderAttributedString:nickNameAs];
    [_nickNameFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    NSMutableAttributedString *jobTitleAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_83", nil)] autorelease];
    [jobTitleAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, jobTitleAs.string.length)];
    [jobTitleAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, jobTitleAs.string.length)];
    [jobTitleAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, jobTitleAs.string.length)];
    [_jobTitleFiled.cell setPlaceholderAttributedString:jobTitleAs];
    [_jobTitleFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    NSMutableAttributedString *departmentAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_84", nil)] autorelease];
    [departmentAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, departmentAs.string.length)];
    [departmentAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, departmentAs.string.length)];
    [departmentAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, departmentAs.string.length)];
    [_departmentFiled.cell setPlaceholderAttributedString:departmentAs];
    [_departmentFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    NSMutableAttributedString *companyAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_3", nil)] autorelease];
    [companyAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, companyAs.string.length)];
    [companyAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, companyAs.string.length)];
    [companyAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, companyAs.string.length)];
    [_companyFiled.cell setPlaceholderAttributedString:companyAs];
    [_companyFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    for (NSView *view in _baseFiledView.subviews) {
        if ([view isKindOfClass:[IMBWhiteView class]]) {
            IMBWhiteView *whiteView = (IMBWhiteView *)view;
            [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            break;
        }
    }
    for (NSView *view in _phoneFiledView.subviews) {
        if ([view isKindOfClass:[IMBWhiteView class]]) {
            IMBWhiteView *whiteView = (IMBWhiteView *)view;
            [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            break;
        }
    }
    for (NSView *view in _emailFiledView.subviews) {
        if ([view isKindOfClass:[IMBWhiteView class]]) {
            IMBWhiteView *whiteView = (IMBWhiteView *)view;
            [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            break;
        }
    }
    for (NSView *view in _relateNameFiledView.subviews) {
        if ([view isKindOfClass:[IMBWhiteView class]]) {
            IMBWhiteView *whiteView = (IMBWhiteView *)view;
            [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            break;
        }
    }
    for (NSView *view in _urlFiledView.subviews) {
        if ([view isKindOfClass:[IMBWhiteView class]]) {
            IMBWhiteView *whiteView = (IMBWhiteView *)view;
            [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            break;
        }
    }
    for (NSView *view in _dateFiledView.subviews) {
        if ([view isKindOfClass:[IMBWhiteView class]]) {
            IMBWhiteView *whiteView = (IMBWhiteView *)view;
            [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            break;
        }
    }
    for (NSView *view in _IMFiledView.subviews) {
        if ([view isKindOfClass:[IMBWhiteView class]]) {
            IMBWhiteView *whiteView = (IMBWhiteView *)view;
            [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            break;
        }
    }
    for (NSView *view in _addressFiledView.subviews) {
        if ([view isKindOfClass:[IMBWhiteView class]]) {
            IMBWhiteView *whiteView = (IMBWhiteView *)view;
            [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            break;
        }
    }
    for (NSView *view in _noteFiledView.subviews) {
        if ([view isKindOfClass:[IMBWhiteView class]]) {
            IMBWhiteView *whiteView = (IMBWhiteView *)view;
            [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
            break;
        }
    }
    
    NSTextField *noteTitle = [self viewWithTag:104];
    [noteTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSTextField *addTextFiled = [self viewWithTag:105];
    [addTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

- (void)dealloc {
    if (_contactEntity != nil) {
        [_contactEntity release];
        _contactEntity = nil;
    }
    if (_iCloudContactEntity != nil) {
        [_iCloudContactEntity release];
        _iCloudContactEntity = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
 
}

@end

@implementation IMBContactNormalView
@synthesize textFiled = _textFiled;
@synthesize popBtn = _popBtn;
@synthesize delegate = _delegate;
@synthesize datePicker = _datePicker;
@synthesize popTitle = _popTitle;

- (id)initWithFrame:(NSRect)frameRect withCategory:(ContactCategoryEnum)category{
 if (self = [super initWithFrame:frameRect]) {
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
     _category = category;
     [self initSubView];
 }
 return self;
}

- (void)initSubView {
    _deleteBtn = [[HoverButton alloc] init];
    [_deleteBtn setBordered:NO];
    NSImage *image1 = [StringHelper imageNamed:@"contact_delete1"];
    NSImage *image2 = [StringHelper imageNamed:@"contact_delete2"];
    [_deleteBtn setFrame:NSMakeRect(20, 7, image1.size.width, image1.size.height)];
    [_deleteBtn setMouseExitImage:image1];
    [_deleteBtn setMouseDownImage:image2];
    [_deleteBtn setMouseEnteredImage:image1 mouseExitImage:image1 mouseDownImage:image2];
    [_deleteBtn setFrameSize:NSMakeSize(image1.size.width, image1.size.height)];
    [_deleteBtn setHidden:NO];
    [_deleteBtn setTarget:self];
    [_deleteBtn setAction:@selector(deleteAction)];
    [self addSubview:_deleteBtn];

    _popBtn = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(120, 5, 16, 20)];
    [_popBtn.cell setArrowPosition:NSPopUpNoArrow];
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 20)];
    [imageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [_popBtn addSubview:imageView];
    [imageView release], imageView = nil;
    [_popBtn setBordered:NO];
    [_popBtn setAlignment:NSRightTextAlignment];
    [_popBtn setTarget:self];
    [_popBtn setAction:@selector(choosePhoneType:)];
    [_popBtn removeAllItems];
    
    _popTitle = [[IMBPopTitleTextField alloc] initWithFrame:NSMakeRect(40, 5, 80, 20)];
    [_popTitle setEditable:NO];
    [_popTitle setBordered:NO];
//    [_popTitle setCell:[[IMBPopTextFieldCell alloc] init]];
    [_popTitle setDrawsBackground:NO];
    [_popTitle setAlignment:NSRightTextAlignment];
    [_popTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_popTitle setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [self addSubview:_popTitle];
 
 if (_category == Contact_PhoneNumber) {
     [_popBtn addItemsWithTitles:[NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_40", nil),CustomLocalizedString(@"contact_id_4", nil),CustomLocalizedString(@"contact_id_5", nil),CustomLocalizedString(@"contact_id_6", nil),CustomLocalizedString(@"contact_id_7", nil),CustomLocalizedString(@"contact_id_10", nil),CustomLocalizedString(@"contact_id_12", nil),CustomLocalizedString(@"contact_id_9", nil),CustomLocalizedString(@"contact_id_8", nil),CustomLocalizedString(@"contact_id_93", nil), nil]];
     NSMenuItem *item = [NSMenuItem separatorItem];
     [_popBtn.menu insertItem:item atIndex:9];
 }else if (_category == Contact_EmailAddressNumber) {
     [_popBtn addItemsWithTitles:[NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_5", nil),CustomLocalizedString(@"contact_id_6", nil),CustomLocalizedString(@"contact_id_8", nil),CustomLocalizedString(@"contact_id_93", nil), nil]];
     NSMenuItem *item = [NSMenuItem separatorItem];
     [_popBtn.menu insertItem:item atIndex:3];
 }else if (_category == Contact_RelatedName) {
     [_popBtn addItemsWithTitles:[NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_17", nil),CustomLocalizedString(@"contact_id_18", nil),CustomLocalizedString(@"contact_id_19", nil),CustomLocalizedString(@"contact_id_20", nil),CustomLocalizedString(@"contact_id_21", nil),CustomLocalizedString(@"contact_id_22", nil),CustomLocalizedString(@"contact_id_23", nil),CustomLocalizedString(@"contact_id_24", nil),CustomLocalizedString(@"contact_id_25", nil),CustomLocalizedString(@"contact_id_26", nil),CustomLocalizedString(@"contact_id_27", nil),CustomLocalizedString(@"contact_id_93", nil),nil]];
     NSMenuItem *item = [NSMenuItem separatorItem];
     [_popBtn.menu insertItem:item atIndex:11];
 }else if (_category == Contact_URL) {
     [_popBtn addItemsWithTitles:[NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_14", nil),CustomLocalizedString(@"contact_id_5", nil),CustomLocalizedString(@"contact_id_6", nil),CustomLocalizedString(@"contact_id_8", nil),CustomLocalizedString(@"contact_id_93", nil), nil]];
     NSMenuItem *item = [NSMenuItem separatorItem];
     [_popBtn.menu insertItem:item atIndex:4];
 }else if (_category == Contact_IM) {
     [_popBtn addItemsWithTitles:[NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_28", nil),CustomLocalizedString(@"contact_id_29", nil),CustomLocalizedString(@"contact_id_30", nil),CustomLocalizedString(@"contact_id_31", nil),CustomLocalizedString(@"contact_id_32", nil),CustomLocalizedString(@"contact_id_33", nil),CustomLocalizedString(@"contact_id_34", nil),CustomLocalizedString(@"contact_id_35", nil),CustomLocalizedString(@"contact_id_36", nil), CustomLocalizedString(@"contact_id_37", nil),nil]];
     NSMenuItem *item = [NSMenuItem separatorItem];
     [_popBtn.menu insertItem:item atIndex:4];
 }else if (_category == Contact_Date) {
     [_popBtn addItemsWithTitles:[NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_38", nil),CustomLocalizedString(@"contact_id_8", nil),CustomLocalizedString(@"contact_id_93", nil), nil]];
     NSMenuItem *item = [NSMenuItem separatorItem];
     [_popBtn.menu insertItem:item atIndex:2];
 }
 
 [self addSubview:_popBtn];
 if (_category == Contact_Date) {
     _datePicker = [[ASHDatePicker alloc] initWithFrame:NSMakeRect(140, 5, 180, 27)];
     [_datePicker setDrawsBackground:NO];
     [_datePicker setBordered:NO];
     [_datePicker setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
     _controller = [[ASHDatePickerController alloc] init];
     _datePicker.action = @selector(dateAction);
     _controller.datePicker.action = @selector(popoverDateAction);
     [_controller.datePicker bind:NSValueBinding toObject:_datePicker withKeyPath:@"dateValue" options:nil];
     _datePicker.popover = [[NSPopover alloc] init];
     _datePicker.popover.contentViewController = _controller;
     _datePicker.popover.behavior = NSPopoverBehaviorSemitransient;
     _datePicker.preferredPopoverEdge = NSMinYEdge;
     [self addSubview:_datePicker];
 }else {
     _textFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140,5, 160, 22)];
     [_textFiled setHasCornerBorder:YES];
     [_textFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
     [_textFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
     NSMutableAttributedString *as = nil;
     if (_category == Contact_PhoneNumber) {
         as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_41", nil)];
     }else if (_category == Contact_EmailAddressNumber) {
         as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_42", nil)];
     }else if (_category == Contact_RelatedName) {
         as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_44", nil)];
     }else if (_category == Contact_URL) {
         as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_43", nil)];
     }else if (_category == Contact_IM) {
         as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_46", nil)];
     }
     [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.string.length)];
     [as setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as.string.length)];
     [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.string.length)];
     [_textFiled.cell setPlaceholderAttributedString:as];
     [self addSubview:_textFiled];
 }
}

-(void)dateAction {
 _controller.datePicker.dateValue = _datePicker.dateValue;
}

- (void)popoverDateAction {
    _datePicker.dateValue = _controller.datePicker.dateValue;
    // Update bound value...
    NSDictionary *bindingInfo = [_datePicker infoForBinding:NSValueBinding];
    [[bindingInfo valueForKey:NSObservedObjectKey] setValue:_datePicker.dateValue
                                          forKeyPath:[bindingInfo valueForKey:NSObservedKeyPathKey]];
}

- (void)choosePhoneType:(id)sender {
    NSPopUpButton *button = (NSPopUpButton *)sender;
    NSString *title = button.selectedItem.title;
    if([title isEqualToString:CustomLocalizedString(@"contact_id_93", nil)]){
        [_popTitle setEditable:YES];
        [_popTitle setSelectable:YES];
        [_popTitle becomeFirstResponder];
//        [_popTitle.cell resetCursorRect:_popTitle.frame inView:self];
       NSText *text = [self.window fieldEditor:NO forObject:_popTitle];
        [(NSTextView *)text insertText:CustomLocalizedString(@"contact_id_93", nil)];
        [(NSTextView *)text updateInsertionPointStateAndRestartTimer:YES];
//        [(NSTextView *)text drawInsertionPointInRect:_popTitle.frame color:[NSColor yellowColor] turnedOn:YES];
    }else {
        [_popTitle setEditable:NO];
        [_popTitle setSelectable:NO];
        [_popTitle setStringValue:[_popBtn selectedItem].title];
    }
}

- (void)deleteAction {
    [self removeFromSuperview];
     if (_delegate != nil && [_delegate respondsToSelector:@selector(reloadFrame)]) {
         [_delegate reloadFrame];
     }
}

- (void)changeSkin:(NSNotification *)notification {
    for (NSView *view in _popBtn.subviews) {
        if ([view isKindOfClass:[NSImageView class]]) {
            NSImageView *imageView = (NSImageView *)view;
            [imageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
        }
    }
    NSMutableAttributedString *as = nil;
    if (_category == Contact_PhoneNumber) {
        as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_41", nil)];
    }else if (_category == Contact_EmailAddressNumber) {
        as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_42", nil)];
    }else if (_category == Contact_RelatedName) {
        as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_44", nil)];
    }else if (_category == Contact_URL) {
        as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_43", nil)];
    }else if (_category == Contact_IM) {
        as = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_46", nil)];
    }
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.string.length)];
    [as setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as.string.length)];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.string.length)];
    [_textFiled.cell setPlaceholderAttributedString:as];
    [_textFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_popTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

- (void)dealloc {
     if (_popBtn != nil) {
         [_popBtn release];
         _popBtn = nil;
     }
     if (_deleteBtn != nil) {
         [_deleteBtn release];
         _deleteBtn = nil;
     }
     if (_textFiled != nil) {
         [_textFiled release];
         _textFiled = nil;
     }
     if (_datePicker != nil) {
         [_datePicker release];
         _datePicker = nil;
     }
     if (_controller != nil) {
         [_controller release];
         _controller = nil;
     }
    if (_popTitle != nil) {
        [_popTitle release];
        _popTitle = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

@end

@implementation IMBContactAddresslView
@synthesize popBtn = _popBtn;
@synthesize popTitle = _popTitle;
@synthesize delegate = _delegate;
@synthesize streetTextFiled = _streetTextFiled;
@synthesize cityTextFiled = _cityTextFiled;
@synthesize stateTextFiled = _stateTextFiled;
@synthesize postalCodeTextFiled = _postalCodeTextFiled;
@synthesize countryTextFiled = _countryTextFiled;

- (id)initWithFrame:(NSRect)frameRect withCategory:(ContactCategoryEnum)category{
     if (self = [super initWithFrame:frameRect]) {
         _category = category;
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
         [self initSubView];
     }
     return self;
}

- (void)initSubView {
     _deleteBtn = [[HoverButton alloc] init];
     [_deleteBtn setBordered:NO];
     NSImage *image1 = [StringHelper imageNamed:@"contact_delete1"];
     NSImage *image2 = [StringHelper imageNamed:@"contact_delete2"];
     [_deleteBtn setFrame:NSMakeRect(20, 7, image1.size.width, image1.size.height)];
     [_deleteBtn setImage:image1];
     [_deleteBtn setMouseEnteredImage:image1 mouseExitImage:image1 mouseDownImage:image2];
     [_deleteBtn setFrameSize:NSMakeSize(image1.size.width, image1.size.height)];
     [_deleteBtn setHidden:NO];
     [_deleteBtn setTarget:self];
     [_deleteBtn setAction:@selector(deleteAction)];
     [self addSubview:_deleteBtn];
     
     _popBtn = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(120, 5, 16, 20)];
    [_popBtn.cell setArrowPosition:NSPopUpNoArrow];
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 20)];
    [imageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [_popBtn addSubview:imageView];
    [imageView release], imageView = nil;
     [_popBtn setBordered:NO];
     [_popBtn setAlignment:NSRightTextAlignment];
     [_popBtn setTarget:self];
     [_popBtn setAction:@selector(choosePhoneType:)];
     [_popBtn removeAllItems];
     [_popBtn addItemsWithTitles:[NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_5", nil),CustomLocalizedString(@"contact_id_6", nil),CustomLocalizedString(@"contact_id_8", nil),CustomLocalizedString(@"contact_id_93", nil),nil]];
     NSMenuItem *item = [NSMenuItem separatorItem];
     [_popBtn.menu insertItem:item atIndex:3];
     [self addSubview:_popBtn];
    
    _popTitle = [[IMBPopTitleTextField alloc] initWithFrame:NSMakeRect(40, 7, 80, 20)];
    [_popTitle setEditable:NO];
    [_popTitle setBordered:NO];
    [_popTitle setDrawsBackground:NO];
    [_popTitle setAlignment:NSRightTextAlignment];
    [_popTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_popTitle setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [self addSubview:_popTitle];
    
     _streetTextFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140,5, 160, 20)];
    [_streetTextFiled setHasCornerBorder:YES];
    [_streetTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_streetTextFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *streetAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_52", nil)] autorelease];
    [streetAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, streetAs.string.length)];
    [streetAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, streetAs.string.length)];
    [streetAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, streetAs.string.length)];
    [_streetTextFiled.cell setPlaceholderAttributedString:streetAs];
    
     [self addSubview:_streetTextFiled];
     
     _cityTextFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140,35, 160, 20)];
    [_cityTextFiled setHasCornerBorder:YES];
     [_cityTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
     [_cityTextFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *cityAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_53", nil)] autorelease];
    [cityAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, cityAs.string.length)];
    [cityAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, cityAs.string.length)];
    [cityAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cityAs.string.length)];
    [_cityTextFiled.cell setPlaceholderAttributedString:cityAs];
    [self addSubview:_cityTextFiled];
     
     _stateTextFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140,65, 160, 20)];
    [_stateTextFiled setHasCornerBorder:YES];
     [_stateTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
     [_stateTextFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *stateAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_50", nil)] autorelease];
    [stateAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, stateAs.string.length)];
    [stateAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, stateAs.string.length)];
    [stateAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, stateAs.string.length)];
    [_stateTextFiled.cell setPlaceholderAttributedString:stateAs];
     [self addSubview:_stateTextFiled];
     
     _postalCodeTextFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140,95, 160, 20)];
    [_postalCodeTextFiled setHasCornerBorder:YES];
     [_postalCodeTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
     [_postalCodeTextFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *postalCodeAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_51", nil)] autorelease];
    [postalCodeAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, postalCodeAs.string.length)];
    [postalCodeAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, postalCodeAs.string.length)];
    [postalCodeAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, postalCodeAs.string.length)];
    [_postalCodeTextFiled.cell setPlaceholderAttributedString:postalCodeAs];
     [self addSubview:_postalCodeTextFiled];
     
     _countryTextFiled = [[IMBContactTextField alloc] initWithFrame:NSMakeRect(140,125, 160, 20)];
    [_countryTextFiled setHasCornerBorder:YES];
     [_countryTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
     [_countryTextFiled setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSMutableAttributedString *countryAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_49", nil)] autorelease];
    [countryAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, countryAs.string.length)];
    [countryAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, countryAs.string.length)];
    [countryAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, countryAs.string.length)];
    [_countryTextFiled.cell setPlaceholderAttributedString:countryAs];
     [self addSubview:_countryTextFiled];
}

- (void)choosePhoneType:(id)sender {
     NSPopUpButton *button = (NSPopUpButton *)sender;
     NSString *title = button.selectedItem.title;
     if([title isEqualToString:CustomLocalizedString(@"contact_id_93", nil)]){
         [_popTitle setEditable:YES];
         [_popTitle setSelectable:YES];
         [_popTitle becomeFirstResponder];
         NSText *text = [self.window fieldEditor:NO forObject:_popTitle];
         [(NSTextView *)text insertText:CustomLocalizedString(@"contact_id_93", nil)];
         [(NSTextView *)text updateInsertionPointStateAndRestartTimer:YES];
     }else {
         [_popTitle setEditable:NO];
         [_popTitle setSelectable:NO];
         [_popTitle setStringValue:[_popBtn selectedItem].title];
     }
}

- (void)deleteAction {
     [self removeFromSuperview];
     if (_delegate != nil && [_delegate respondsToSelector:@selector(reloadFrame)]) {
         [_delegate reloadFrame];
     }
}

- (void)changeSkin:(NSNotification *)notification {
    for (NSView *view in _popBtn.subviews) {
        if ([view isKindOfClass:[NSImageView class]]) {
            NSImageView *imageView = (NSImageView *)view;
            [imageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
        }
    }
    NSMutableAttributedString *streetAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_52", nil)] autorelease];
    [streetAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, streetAs.string.length)];
    [streetAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, streetAs.string.length)];
    [streetAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, streetAs.string.length)];
    [_streetTextFiled.cell setPlaceholderAttributedString:streetAs];
    
    NSMutableAttributedString *cityAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_53", nil)] autorelease];
    [cityAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, cityAs.string.length)];
    [cityAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, cityAs.string.length)];
    [cityAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cityAs.string.length)];
    [_cityTextFiled.cell setPlaceholderAttributedString:cityAs];
    
    NSMutableAttributedString *stateAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_50", nil)] autorelease];
    [stateAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, stateAs.string.length)];
    [stateAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, stateAs.string.length)];
    [stateAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, stateAs.string.length)];
    [_stateTextFiled.cell setPlaceholderAttributedString:stateAs];
    
    NSMutableAttributedString *postalCodeAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_51", nil)] autorelease];
    [postalCodeAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, postalCodeAs.string.length)];
    [postalCodeAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, postalCodeAs.string.length)];
    [postalCodeAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, postalCodeAs.string.length)];
    [_postalCodeTextFiled.cell setPlaceholderAttributedString:postalCodeAs];
    
    NSMutableAttributedString *countryAs = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"contact_id_49", nil)] autorelease];
    [countryAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, countryAs.string.length)];
    [countryAs setAlignment:NSLeftTextAlignment range:NSMakeRange(0, countryAs.string.length)];
    [countryAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, countryAs.string.length)];
    [_countryTextFiled.cell setPlaceholderAttributedString:countryAs];
    
    [_streetTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_cityTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_stateTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_postalCodeTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_countryTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_popTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

- (void)dealloc {
    if (_popBtn != nil) {
         [_popBtn release];
         _popBtn = nil;
    }
    if (_deleteBtn != nil) {
        [_deleteBtn release];
        _deleteBtn = nil;
    }
    if (_streetTextFiled != nil) {
        [_streetTextFiled release];
        _streetTextFiled = nil;
    }
    if (_cityTextFiled != nil) {
        [_cityTextFiled release];
        _cityTextFiled = nil;
    }
    if (_stateTextFiled != nil) {
        [_stateTextFiled release];
        _stateTextFiled = nil;
    }
    if (_postalCodeTextFiled != nil) {
        [_postalCodeTextFiled release];
        _postalCodeTextFiled = nil;
    }
    if (_countryTextFiled != nil) {
        [_countryTextFiled release];
        _countryTextFiled = nil;
    }
    if (_popTitle != nil) {
        [_popTitle release];
        _popTitle = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
     [super dealloc];
}

@end


@implementation IMBContactTextField
@synthesize hasCornerBorder = _hasCornerBorder;
- (id)initWithFrame:(NSRect)frameRect {
    if (self == [super initWithFrame:frameRect]) {
        IMBContactTextCell *cell = [[IMBContactTextCell alloc] init];
        [cell setStringValue:@""];
        [self setCell:cell];
        [cell release];
    }
    return self;
}

- (void)setHasCornerBorder:(BOOL)hasCornerBorder {
    _hasCornerBorder = hasCornerBorder;
    if (_hasCornerBorder) {
        [self setDrawsBackground:NO];
        [self setBordered:NO];
        [self setEditable:YES];
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *roundRect = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [roundRect addClip];
    [[NSColor clearColor] set];
    [roundRect fill];
    [roundRect setLineWidth:2];
    [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
    [roundRect stroke];
}
@end

@implementation IMBContactTextCell

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    }
    return self;
}

- (NSText *)setUpFieldEditorAttributes:(NSText *)textObj{
    NSText *text = [super setUpFieldEditorAttributes:textObj];
    [(NSTextView*)text setInsertionPointColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    return text;

}

- (void)changeSkin:(NSNotification *)notification {
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}
@end

@implementation IMBPopTitleTextField
- (void)textDidEndEditing:(NSNotification *)notification{
    [self setStringValue:self.stringValue];
    [self performSelector:@selector(popTitleEndEdit) withObject:nil afterDelay:0.1];
}

- (void)popTitleEndEdit{
   
    [self setEditable:NO];
    [self setSelectable:NO];
    [self setNeedsDisplay:YES];
}
@end






