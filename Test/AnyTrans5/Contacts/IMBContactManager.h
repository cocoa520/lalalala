//
//  IMBContactManager.h
//  ParseiPhoneInfoDemo
//
//  Created by Pallas on 4/15/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"
#import "FMDatabase.h"
#import "IMBIPod.h"
#import "IMBMobileSyncManager.h"
#import "IMBContactEntity.h"

#define ERROR_ICLOUND_NOT_OPEN @"error_iclound_not_open"
#define ERROR_INVALID_EXPORT_PATH @"error_invalid_export_path"
#define ERROR_EXPORT_ERROR @"error_export_error"

#define RECORD_ENTITY_NAME @"com.apple.syncservices.RecordEntityName"
#define RECORD_ENTITY_GROUP @"com.apple.contacts.Group"
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
#define RECORD_TITLE @"title"
#define RECORD_NOTES @"notes"
#define RECORD_IMAGE @"image"

#define DOMAIN_CONTACT @"com.apple.contacts.Contact"
#define DOMAIN_COMMON_CONTACT @"com.apple.Contacts"
#define DOMAIN_ANCHOR @"Contacts-Device-Anchor"
#define DOMAIN_DATE @"com.apple.contacts.Date"
#define DOMAIN_URL @"com.apple.contacts.URL"
#define DOMAIN_STREET_ADDRESS @"com.apple.contacts.Street Address"
#define DOMAIN_PHONE_NUMBER @"com.apple.contacts.Phone Number"
#define DOMAIN_EMAIL_ADDRESS @"com.apple.contacts.Email Address"
#define DOMAIN_RELATED_NAME @"com.apple.contacts.Related Name"
#define DOMAIN_IM @"com.apple.contacts.IM"
#define DOMAIN_MOBILE_SYNC @"com.apple.mobile.data_sync"

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


@interface IMBContactManager : IMBMobileSyncManager {
@private
    NSMutableArray *allDomains;
    AMDevice *deviceHandle;
    BOOL isValid;
    
    NSMutableDictionary *_allPersionDic;
    NSMutableDictionary *_allPersionDicFromSqlite;
    NSMutableDictionary *_similarDic;
    NSMutableDictionary *_redundancyDic;
    NSMutableArray *_allContactArray;
    NSMutableArray *_allContactArrayFromSqlite;
    NSMutableArray *_allContactBaseInfoArray;
    int increNum;
    
    NSFileManager *fm;
    
    NSString *addressBookFilePath;
    NSString *addressBookImagesFilePath;
    NSString *_exportPath;
    
    NSString *tmpAddressBookFilePath;
    NSString *tmpAddressBookImagesFilePath;
    FMDatabase *_addressBookConnection, *_addressBookImagesConnection;
}

@property (nonatomic, readwrite, retain) NSMutableDictionary *allPersionDic;
@property (nonatomic, readwrite, retain) NSMutableDictionary *allPersionDicFromSqlite;
@property (nonatomic ,readwrite, retain) NSMutableDictionary *similarDic;
@property (nonatomic, readwrite, retain) NSMutableDictionary *redundancyDic;
@property (nonatomic, readwrite, retain) NSMutableArray *allContactArray;
@property (nonatomic, readwrite, retain) NSMutableArray *allContactArrayFormSqlite;
@property (nonatomic, readwrite, retain) NSMutableArray *allContactBaseInfoArray;
@property (nonatomic, readwrite, retain) NSString *exportPath;
- (id)initWithAMDevice:(AMDevice*)device;


// 检查是否是有效的
+ (BOOL)checkContactValidWithIPod:(IMBiPod *)ipod;

// 查询出所有联系人的信息(不需要向界面公布)
- (void)queryAllContact;

// 插入联系人信息(不需要向界面公布)
- (BOOL)insertContact:(IMBContactEntity*)addContentEntity;
// 修改联系人(不需要向界面公布)
- (BOOL)modifyContact:(IMBContactBaseEntity*)modifiedEntity;

// 删除联系人(在这里不需要向界面公布)
- (BOOL)delContract:(NSArray*)delContactEntity;
//导出到Contacts软件
- (void)exportToContacts:(NSArray *)contactArray;
- (void)importContactVCF:(NSArray *)importPathArray;
#pragma mark - 通过数据库去获取联系人
// 得到联系人Sqlite数据库
- (void)getContactSqlitePathFileRelay;

- (FMDatabase *)getAddressBookConnection;

- (FMDatabase *)getAddressBookImageConnection;
// 查询出所有的联系人的信息（作为内部函数）
 - (void)queryAllPersionFromSqlite; 
// 根据联系人ID查询出联系人的信息（在此不需要对界面公布）
//- (NSMutableDictionary*)queryPersionFromSqliteByContactID:(int)contactID;
// 得到所有de联系人的基本信息（在此不需要对界面公布）
//- (NSMutableDictionary *)queryAllPersionBaseInfoFromSqlite;

#pragma mark - 查找相似的联系人及其有冗余数据的联系人
// 查询出相似联系人的信息
- (void)queryImilarContact;
// 查询出冗余的联系人
- (void)queryRedundancyItemInContact;

#pragma mark - 清理及其合并的函数段
- (NSMutableDictionary *)getMergeDic:(NSMutableDictionary*)imilarContact mainContactKey:(NSString*)mainContactKey;
// 合并联系人
- (void)mergerContact:(NSMutableDictionary*)imilarContact mergeDic:(NSMutableDictionary *)mergeDic;
// 清除联系人
- (void)clearContact:(NSString*)contactKey;

@end
