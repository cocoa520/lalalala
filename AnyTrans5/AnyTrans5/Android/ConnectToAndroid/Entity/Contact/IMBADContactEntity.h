//
//  IMBContactEntity.h
//  
//
//  Created by JGehry on 2/17/17.
//
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"
#import "StringHelper.h"

@class IMBContactLabelValueEntity;

typedef NS_ENUM(NSInteger, MimeType) {
    email = 1,
    nickname = 3,
    phone = 5,
    name = 7,
};

@interface IMBADContactEntity : IMBBaseEntity {
 @private
    int _contactID;
    int _rawContactID;
    IMBContactLabelValueEntity *_contactName;
    IMBContactLabelValueEntity *_contactFirstName;
    IMBContactLabelValueEntity *_contactLastName;
    IMBContactLabelValueEntity *_contactPrefixName;
    IMBContactLabelValueEntity *_contactMiddleName;
    IMBContactLabelValueEntity *_contactSuffixName;
    IMBContactLabelValueEntity *_contactNickName;
    IMBContactLabelValueEntity *_contactPhone;
    IMBContactLabelValueEntity *_contactEmail;
    IMBContactLabelValueEntity *_contactMembership;
    IMBContactLabelValueEntity *_contactIsDelete;
    IMBContactLabelValueEntity *_companyName;
    IMBContactLabelValueEntity *_companyJob;
    
    NSData *_imageData;
    BOOL _isImage;
    IMBContactLabelValueEntity *_contactNote;
    IMBContactLabelValueEntity *_structuredName;
    NSMutableArray *_phoneData;
    NSMutableArray *_emailData;
    NSMutableArray *_websiteData;
    NSMutableArray *_imData;
    NSMutableArray *_addressData;
    NSMutableArray *_eventData;
    NSMutableArray *_relationData;
 @public
    NSString *_contactSortName;
}

/**
 *  contactID                    ID
 *  rawContactID;                raw ID
 *  contactName                  名称
 *  contactFirstName             姓氏
 *  contactLastName              名字
 *  contactPrefixName            名称前缀
 *  contactMiddleName            中间名
 *  contactSuffixName            名称后缀
 *  contactNickName              昵称
 *  contactPhone                 手机
 *  contactEmail                 邮箱
 *  contactMembership            所属群组
 *  contactIsDelete              是否已删除该联系人
 *
 *  contactMimetypeID            
 *  contactSortName              排序名称
 
 *  imageData                    联系人头像数据
 *  isImage                      判断是否有联系人头像
 *  contactNote                  联系人note
 *  structuredName               联系人全称
 *  phoneData                    电话号码数组
 *  emailData                    email数组
 *  websiteData                  网址数组
 *  imData                       即时通信账号数组
 *  addressData                  地址数组
 *  eventData                    事件数组
 *  relationData                 关联人数组
 *  companyName;
 *  companyJob;
 */
@property (nonatomic, readwrite) int contactID;
@property (nonatomic, readwrite) int rawContactID;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactName;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactFirstName;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactLastName;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactPrefixName;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactMiddleName;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactSuffixName;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactNickName;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactPhone;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactEmail;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactMembership;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactIsDelete;
@property (nonatomic, readwrite, retain) NSData *imageData;
@property (nonatomic, readwrite) BOOL isImage;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *contactNote;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *structuredName;
@property (nonatomic, readwrite, retain) NSMutableArray *phoneData;
@property (nonatomic, readwrite, retain) NSMutableArray *emailData;
@property (nonatomic, readwrite, retain) NSMutableArray *websiteData;
@property (nonatomic, readwrite, retain) NSMutableArray *imData;
@property (nonatomic, readwrite, retain) NSMutableArray *addressData;
@property (nonatomic, readwrite, retain) NSMutableArray *eventData;
@property (nonatomic, readwrite, retain) NSMutableArray *relationData;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *companyName;
@property (nonatomic, readwrite, retain) IMBContactLabelValueEntity *companyJob;

@property (nonatomic, readwrite, retain) NSString *contactSortName;

- (NSDictionary *)objectToDictionary:(IMBADContactEntity *)entity;
- (void)dictionaryToObject:(NSDictionary *)msgDic;

- (void)unifiedArrangementName:(BOOL)isDelete;

@end

@interface IMBContactLabelValueEntity : IMBBaseEntity {
    NSString *_lable;
    NSString *_value;
    int _lacleType;
}

/**
 *  label               标签
 *  value               值
 *  lacleType           标签id
 */

@property (nonatomic, readwrite, retain) NSString *lable;
@property (nonatomic, readwrite, retain) NSString *value;
@property (nonatomic, readwrite) int lacleType;

@end

@interface IMBContactMimeTypeEntity : NSObject {
    int _cid;
    NSString *_type;
}

@property (nonatomic, readwrite) int cid;
@property (nonatomic, readwrite, retain) NSString *type;

@end
