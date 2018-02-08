//
//  IMBContactEntity.h
//  iMobieTrans
//
//  Created by ZHANGYANG on 2/23/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
#import "IMBBaseEntity.h"

#define RECORD_ENTITY_NAME @"com.apple.syncservices.RecordEntityName"
#define RECORD_DISPLAY_AS_COMPANY @"display as company"
#define RECORD_FIRST_NAME @"first name"
#define RECORD_FIRST_NAME_YOMI @"first name yomi"
#define RECORD_MIDDLE_NAME @"middle name"
#define RECORD_LAST_NAME @"last name"
#define RECORD_LAST_NAME_YOMI @"last name yomi"
#define RECORD_NICK_NAME @"nickname"
#define RECORD_BIRTHDAY @"birthday"
#define RECORD_COMPANY_NAME @"company name"
#define RECORD_DEPARTMENT @"department"
#define RECORD_JOB_NAME @"job title"
#define RECORD_SUFFIX @"suffix"
#define RECORD_TITLE @"title"    //prefix
#define RECORD_NOTES @"notes"
#define RECORD_IMAGE @"image"



#define DOMAIN_CONTACT @"com.apple.contacts.Contact"
#define DOMAIN_DATE @"com.apple.contacts.Date"
#define DOMAIN_URL @"com.apple.contacts.URL"
#define DOMAIN_STREET_ADDRESS @"com.apple.contacts.Street Address"
#define DOMAIN_PHONE_NUMBER @"com.apple.contacts.Phone Number"
#define DOMAIN_EMAIL_ADDRESS @"com.apple.contacts.Email Address"
#define DOMAIN_RELATED_NAME @"com.apple.contacts.Related Name"
#define DOMAIN_IM @"com.apple.contacts.IM"

#define ITEM_CONTACT_KEY @"contact"
#define ITEM_LABEL_KEY @"label"
#define ITEM_TYPE_KEY @"type"
#define ITEM_VALUE_KEY @"value"

#define ITEM_CITY_KEY @"city"
#define ITEM_COUNTRY_KEY @"country"
#define ITEM_COUNTRY_CODE_KEY @"country code"
#define ITEM_POSTAL_CODE_KEY @"postal code"
#define ITEM_STATE_KEY @"state"
#define ITEM_STREET_KEY @"street"

#define ITEM_SERVICE_KEY @"service"
#define ITEM_USER_KEY @"user"



//phoneNumberArray,
//Email Address Array
//RelatedNameArray
//URLArray
//DateArray
//typedef enum {
//	Contact_PhoneNumber    = 3,
//    Contact_EmailAddressNumber    = 4,
//    Contact_RelatedName    = 23,
//    Contact_IM    = 13,
//    Contact_URL    = 22,
//    Contact_Date    = 12,
//    Contact_StreetAddress = 5,
//}
//ContactCategoryEnum;


//TODO还需要定义Home，Work等type 常量。
#define TYPE_MOBILE  @"mobile"
#define TYPE_HOME  @"home"
#define TYPE_WORK  @"work"
#define TYPE_MAIN  @"main"
#define TYPE_HOMEFAX  @"home Fax"
#define TYPE_WORKFAX  @"work Fax"
#define TYPE_OTHERFAX  @"other Fax"
#define TYPE_PAGER  @"pager"
#define TYPE_OTHER  @"other"
#define TYPE_CUSTOM_TAG  @"add custom tag"
#define TYPE_HOMEPAGE  @"home page"



@interface IMBContactBaseEntity : IMBBaseEntity
{
    ContactCategoryEnum _contactCategory;
    NSString *_contactId;//如73等
    NSNumber *_entityID;//id 如10
    BOOL _isCustomLabel;
    BOOL _isEmpty;
    NSString *_type;
}
@property (nonatomic) BOOL isCustomLabel;
@property (nonatomic) ContactCategoryEnum contactCategory;
@property (nonatomic,retain) NSString *contactId;
@property (nonatomic,retain) NSNumber *entityID;
@property (nonatomic,readwrite,getter = isEmpty) BOOL isEmpty;
@property (nonatomic,retain) NSString *type;
- (NSDictionary *)objectToDic;
//dic为单个字段的dictionary
- (void)dicToObject:(NSDictionary *)dic;
- (BOOL)isEmpty;
@end

//phoneNumberArray,
//Email Address Array
//RelatedNameArray
//URLArray
//DateArray

@interface IMBContactKeyValueEntity : IMBContactBaseEntity {
    
    NSString *_label;//special 可以为空
    id _value;//value 如 13403046050special
}

@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *label;//special 可以为空
@property (nonatomic,retain) id value;//value 如 13403046050special
@property (nonatomic,retain) NSString *contactId;
@property (nonatomic) ContactCategoryEnum contactCategory;
@property (nonatomic,retain) NSNumber *entityID;
@end

//AddressEntity
@interface IMBContactAddressEntity : IMBContactBaseEntity {
    
    NSString *_country;
    NSString *_postalCode;
    NSString *_addrstate;//
    NSString *_street;
    NSString *_state;
    NSString *_countryCode;
    NSString *_city;
    NSString *_label;
}
@property (nonatomic,retain) NSString *label;
@property (nonatomic,retain) NSString *country;
@property (nonatomic,retain) NSString *postalCode;
@property (nonatomic,retain) NSString *state;
@property (nonatomic,retain) NSString *street;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *countryCode;
@property (nonatomic,retain) NSString *contactId;
@property (nonatomic) ContactCategoryEnum contactCategory;
@property (nonatomic,retain) NSNumber *entityID;

@end

//IM的Entity分类
@interface IMBContactIMEntity : IMBContactBaseEntity {
    
    NSString *_service;//googletalk
    NSString *_label;//
    NSString *_user;//如 303212h-google
    //也可把13/74/0作为key
}

@property (nonatomic,retain) NSString *service;

@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain,readwrite,setter = setLabel:) NSString *label;//special 可以为空
@property (nonatomic,retain) NSString *user;
@property (nonatomic,retain) NSString *contactId;
@property (nonatomic) ContactCategoryEnum contactCategory;
@property (nonatomic,retain) NSNumber *entityID;

- (void)setLabel:(NSString *)label;

@end

@interface IMBContactEntity : IMBContactBaseEntity<NSMutableCopying> {
    NSString *_firstName;
    NSString *_lastName;
    NSString *_displayAsCompany;
    NSData *_image;
    NSString *_jobTitle;
    NSString *_companyName;
    NSString *_department;
    NSDate *_birthday;
    NSString *_nickname;
    NSString *_notes;
    NSString *_middleName;
    NSString *_firstNameYomi;
    NSString *_lastNameYomi;
    NSString *_suffix;
    NSString *_title;
    NSString *_fullName;
    NSMutableArray *_phoneNumberArray;
    NSMutableArray *_emailAddressArray;
    NSMutableArray *_relatedNameArray;
    NSMutableArray *_urlArray;
    NSMutableArray *_dateArray;
    NSMutableArray *_addressArray;
    NSMutableArray *_IMArray;
    
    NSString *_allName;
}

@property (nonatomic, readwrite, retain) NSString *allName;
@property (nonatomic, readwrite, retain) NSString *firstName;
@property (nonatomic, readwrite, retain) NSString *lastName;
@property (nonatomic, readwrite, retain) NSString *fullName;
@property (nonatomic, readwrite, retain) NSString *displayAsCompany;
@property (nonatomic, readwrite, retain) NSData *image;
@property (nonatomic, readwrite, retain) NSString *jobTitle;
@property (nonatomic, readwrite, retain) NSString *companyName;
@property (nonatomic, readwrite, retain) NSString *department;
@property (nonatomic, readwrite, retain) NSDate *birthday;
@property (nonatomic, readwrite, retain) NSString *nickname;
@property (nonatomic, readwrite, retain) NSString *notes;
@property (nonatomic, readwrite, retain) NSString *middleName;
@property (nonatomic, readwrite, retain) NSString *firstNameYomi;
@property (nonatomic, readwrite, retain) NSString *lastNameYomi;
@property (nonatomic, readwrite, retain) NSString *suffix;
@property (nonatomic, readwrite, retain) NSString *title;
@property (nonatomic, readwrite, retain) NSString *contactId;
@property (nonatomic) ContactCategoryEnum contactCategory;
@property (nonatomic, readwrite, retain) NSNumber *entityID;


@property (nonatomic,strong) NSMutableArray *phoneNumberArray;
@property (nonatomic,strong) NSMutableArray *emailAddressArray;
@property (nonatomic,strong) NSMutableArray *relatedNameArray;
@property (nonatomic,strong) NSMutableArray *urlArray;
@property (nonatomic,strong) NSMutableArray *dateArray;
@property (nonatomic,strong) NSMutableArray *addressArray;
@property (nonatomic,strong) NSMutableArray *IMArray;


@end
