//
//  IMBAddressBookDataEntity.h
//  DataRecovery
//
//  Created by iMobie on 4/21/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBaseEntity.h"

@interface IMBAddressBookDataEntity : IMBBaseEntity {
@private
    NSString *_allName;
    int _rowid;
    NSString *_firstName;
    NSString *_middleName;
    NSString *_lastName;
    NSString *_displayName;
    NSString *_firstNameYomi;
    NSString *_middleNameYomi;
    NSString *_lastNameYomi;
    NSString *_nickName;
    NSString *_suffix;
    NSString *_prefix;
    NSString *_companyName;
    NSString *_department;
    NSString *_jobTitle;
    NSString *_notes;
    long _birthdayDate;
    long _creationDate;
    long _modificationDate;
    int _kind;
    NSImage *_image;
    
    NSString *_birthday;
    NSString *_firstSort;
    NSString *_lastSort;
    NSString *_compositeNameFallback;
    NSString *_externalIdentifier;
    NSString *_externalModificationTag;
    NSString *_externalUUID;
    int _storeID;
    NSData *_externalRepresentation;
    NSString *_firstSortSection;
    NSString *_lastSortSection;
    int _firstSortLanguageIndex;
    int _lastSortLanguageIndex;
    int _personLink;
    NSString *_imageURI;
    int _isPreferredName;

    NSString *_guid;
    NSString *_phonemeData;
    /*装表ABMultiValue下的数据,对象是IMBAddressBookMultDataEntity实体：
        property字段中： 3--电话号码一栏；
                        4--邮件地址一栏；
                        5--住宅地址一栏；
                        12--周年日期；
                        13--通讯软件号码；
                        22、44--网址URL；
                        23--相关联的联系人；
                        46--Twitter、Facebook...
        label字段中：    1--Mobile
                        2--iPhone
                        3--Anniversary
                        4--Home
                        5--HomePage
                        6--Other
                        7--HomeFAX 
                        8--WorkFAX 
                        9--Work 
                        10--Mother 
                        11--Main 
                        12--OtherFAX  
                        13--Pager(传呼）
                        14--Father
    */
    NSMutableArray *_contentArray;
    
    NSMutableArray *_numberArray;   //3--电话号码一栏
    NSMutableArray *_emailArray;    //4--邮件地址一栏
    NSMutableArray *_streetArray;   //5--住宅地址一栏
    NSMutableArray *_dateArray;     //12--周年日期
    NSMutableArray *_IMArray;       //13--通讯软件号码
    NSMutableArray *_URLArray;      //22--网址URL
    NSMutableArray *_relatedArray;  //23--相关联的联系人
    NSMutableArray *_specialURLArray;   //46--Twitter、Facebook...
    int _propertyID;
    NSData *_imageData;
}
@property (nonatomic, readwrite) int propertyID;
@property (nonatomic, readwrite, retain) NSData *imageData;
@property (nonatomic, readwrite, retain) NSString *birthday;
@property (nonatomic, readwrite, retain) NSString *firstSort;
@property (nonatomic, readwrite, retain) NSString *lastSort;
@property (nonatomic, readwrite, retain) NSString *compositeNameFallback;
@property (nonatomic, readwrite, retain) NSString *externalIdentifier;
@property (nonatomic, readwrite, retain) NSString *externalModificationTag;
@property (nonatomic, readwrite, retain) NSString *externalUUID;
@property (nonatomic, readwrite) int storeID;
@property (nonatomic, readwrite, retain) NSData *externalRepresentation;
@property (nonatomic, readwrite, retain) NSString *firstSortSection;
@property (nonatomic, readwrite, retain) NSString *lastSortSection;
@property (nonatomic, readwrite)int firstSortLanguageIndex;
@property (nonatomic, readwrite)int lastSortLanguageIndex;
@property (nonatomic, readwrite)int personLink;
@property (nonatomic, readwrite, retain) NSString *imageURI;
@property (nonatomic, readwrite)int isPreferredName;
@property (nonatomic, readwrite, retain) NSString *guid;
@property (nonatomic, readwrite, retain) NSString *phonemeData;


@property (nonatomic, readwrite) int rowid;
@property (nonatomic, readwrite) int kind;
@property (nonatomic, readwrite) long birthdayDate;
@property (nonatomic, readwrite) long creationDate;
@property (nonatomic, readwrite) long modificationDate;
@property (nonatomic, readwrite, retain) NSString *allName;
@property (nonatomic, readwrite, retain) NSString *displayName;
@property (nonatomic, readwrite, retain) NSString *firstName;
@property (nonatomic, readwrite, retain) NSString *middleName;
@property (nonatomic, readwrite, retain) NSString *lastName;
@property (nonatomic, readwrite, retain) NSString *firstNameYomi;
@property (nonatomic, readwrite, retain) NSString *middleNameYomi;
@property (nonatomic, readwrite, retain) NSString *lastNameYomi;
@property (nonatomic, readwrite, retain) NSString *nickName;
@property (nonatomic, readwrite, retain) NSString *suffix;
@property (nonatomic, readwrite, retain) NSString *prefix;
@property (nonatomic, readwrite, retain) NSString *companyName;
@property (nonatomic, readwrite, retain) NSString *department;
@property (nonatomic, readwrite, retain) NSString *jobTitle;
@property (nonatomic, readwrite, retain) NSString *notes;
@property (nonatomic, readwrite, retain) NSImage *image;
@property (nonatomic, readwrite, retain) NSMutableArray *contentArray;

@property (nonatomic, readwrite, retain) NSMutableArray *numberArray;
@property (nonatomic, readwrite, retain) NSMutableArray *emailArray;
@property (nonatomic, readwrite, retain) NSMutableArray *streetArray;
@property (nonatomic, readwrite, retain) NSMutableArray *dateArray;
@property (nonatomic, readwrite, retain) NSMutableArray *IMArray;
@property (nonatomic, readwrite, retain) NSMutableArray *URLArray;
@property (nonatomic, readwrite, retain) NSMutableArray *relatedArray;
@property (nonatomic, readwrite, retain) NSMutableArray *specialURLArray;

@end

@interface IMBAddressBookMultDataEntity : IMBBaseEntity {
@private
    NSString *_labelType;
    int _uid;
    int _recordID;
    int _property;
    int _identifier;
    int _label;
    NSString *_multValue;
    //装ABMultiValueEntry表中的数据,对象是IMBAddressBookDetailEntity
    NSMutableArray *_multiArray;
}

@property (nonatomic, readwrite) int uid;
@property (nonatomic, readwrite) int recordID;
@property (nonatomic, readwrite) int property;
@property (nonatomic, readwrite) int identifier;
@property (nonatomic, readwrite) int label;
@property (nonatomic, readwrite, retain) NSString *multValue;
@property (nonatomic, readwrite, retain) NSString *lableType;
@property (nonatomic, readwrite, retain) NSMutableArray *multiArray;

@end

@interface IMBAddressBookDetailEntity : IMBBaseEntity {
@private
    int _parentID;
    int _key;
    NSString *_detailValue;  //value值
   
    NSString *_entityType; //key对应的值
}

@property (nonatomic, readwrite) int parentID;
@property (nonatomic, readwrite) int key;
@property (nonatomic, readwrite, retain) NSString *detailValue;
@property (nonatomic, readwrite, retain) NSString *entityType;

@end

