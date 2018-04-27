//
//  IMBVerifyProduct.h
//  PhoneClean3.0
//
//  Created by Pallas on 6/25/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBVerifyActivate.h"
#import "IMBHWInfo.h"
typedef enum ActivateType {
    ActivateOnLine = 'aoln',
    ActivateLocal = 'alcl'
} ActivateTypeEnum;

typedef enum LicenseType {
    Paid = 'paid',
    NFR = 'nfrs',
    Giveaway ='gawy'
} LicenseTypeEnum;

typedef enum DurationType {
    OneDay = 'oned',
    SevenDays = 'svnd',
    FifteenDays = 'ffnd',
    ThirtyDays = 'thyd',
    SixMouths = 'sixm',
    OneYear = 'oney',
    TwoYears = 'twoy',
    ThreeYears = 'thry',
    UmlimitedDateTime = 'uldt'
} DurationTypeEnum;

@interface IMBVerifyProduct : NSObject {
@private
    NSString *regFilePath;
    
    NSString *_appName;
    NSString *_licnese;
    NSString *_version;
    NSString *_regDateTime;
    
    ActivateTypeEnum _activeType;
    LicenseTypeEnum _lincenseType;
    int _activeQuota;
    DurationTypeEnum _duration;
    BOOL _timeLimitation;
    BOOL _versionLimitation;
    NSString *_maxVersion;
    NSString *_lastActiveTime;
    BOOL _valid;
    
    NSNotificationCenter *nc;
    NSFileManager *fm;
    
    NSString *_errorCode;
}

@property (nonatomic, readwrite, retain) NSString *appName;
@property (nonatomic, readwrite, retain) NSString *licnese;
@property (nonatomic, readwrite, retain) NSString *version;
@property (nonatomic, readwrite, retain) NSString *regDateTime;

@property (nonatomic, readwrite) ActivateTypeEnum activeType;
@property (nonatomic, readwrite) LicenseTypeEnum lincenseType;
@property (nonatomic, readwrite) int activeQuota;
@property (nonatomic, readwrite) DurationTypeEnum duration;
@property (nonatomic, readwrite) BOOL timeLimitation;
@property (nonatomic, readwrite) BOOL versionLimitation;
@property (nonatomic, readwrite, retain) NSString *maxVersion;
@property (nonatomic, readwrite, retain) NSString *lastActiveTime;
@property (nonatomic, readwrite) BOOL valid;
@property (nonatomic, readwrite, retain) NSString *errorCode;

+ (IMBVerifyProduct*)singleton;

- (BOOL)readActiveInfo:(NSString *)productVersion;

- (BOOL)activeProduct:(NSString *)license;
- (BOOL)onlineActivate:(KeyStateStruct *)ks withLicense:(NSString *)license withActivationCode:(NSString **)activationCode;
- (KeyStateStruct *)verifyProductLicense:(NSString *)license;
- (BOOL)activeProduct:(KeyStateStruct *)ks withLicensn:(NSString *)license ;
@end
