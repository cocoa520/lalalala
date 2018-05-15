//
//  IMBSoftWareInfo.h
//  iMobieTrans
//
//  Created by zhang yang on 13-6-23.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum LanguageType {
    EnglishLanguage = 0,
    JapaneseLanguage = 1,
    FrenchLanguage = 2,
    GermanLanguage = 3,
    CzechLanguage = 4,
    HungaryLanguage = 5,
    SpanishLanguage = 6,
    ChinaLanguage = 7,
    ArabLanguage = 8,
} LanguageTypeEnum;

@interface IMBSoftWareInfo : NSObject {
    BOOL _isFirstRun;
    BOOL _isRegistered;
    NSString *_productName;
    NSString *_version;
    NSString *_buildDate;
    BOOL _mustUpdate;
    NSString *_registeredCode;
    NSString *_registeredDate;
    
    NSString *_systemDateFormatter;
    LanguageTypeEnum _chooseLanguageType;
}
@property (nonatomic, readwrite) BOOL isFirstRun;
@property (readonly,retain) NSString* productName;
@property (readonly,retain) NSString* version;
@property (readonly,retain) NSString* buildDate;
@property (assign) BOOL isRegistered;
@property (assign) BOOL mustUpdate;
@property (nonatomic,retain) NSString* registeredCode;
@property (nonatomic,retain) NSString* registeredDate;
@property (nonatomic, readwrite, retain) NSString *systemDateFormatter;
@property (nonatomic, readwrite) LanguageTypeEnum chooseLanguageType;

+ (IMBSoftWareInfo*)singleton;
@end
