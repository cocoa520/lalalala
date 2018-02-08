//
//  IMBSoftWareInfo.m
//  iMobieTrans
//
//  Created by zhang yang on 13-6-23.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBSoftWareInfo.h"
#import "RegexKitLite.h"
#import "NSString+Category.h"
#import "IMBiTunes.h"
#import "IMBDeviceInfo.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "OperationLImitation.h"
@implementation IMBSoftWareInfo
@synthesize isFirstRun = _isFirstRun;
@synthesize firstRunDateTime = _firstRunDateTime;
@synthesize firstRunDate = _firstRunDate;
@synthesize resProductName = _resProductName;
@synthesize buildDate = _buildDate;
@synthesize isNeedRegister = _isNeedRegister;
@synthesize isRegistered = _isRegistered;
@synthesize isSupportApp = _isSupportApp;
@synthesize isSupportConverter = _isSupportConverter;
@synthesize isSupportIOS = _isSupportIOS;
@synthesize isSupportIPod = _isSupportIPod;
@synthesize isSupportiTunesLib = _isSupportiTunesLib;
@synthesize isSupportJailbreak = _isSupportJailbreak;
@synthesize isSupportMedia = _isSupportMedia;
@synthesize isSupportMultiDevice = _isSupportMultiDevice;
@synthesize isSupportWifi = _isSupportWifi;
@synthesize privateKey = _privateKey;
@synthesize productLimitType = _productLimitType;
@synthesize limitType = _limitType;
@synthesize limitItemCount = _limitItemCount;
@synthesize limitDay = _limitDay;
@synthesize serverArray = _serverArray;
@synthesize serverKey = _serverKey;
@synthesize productName = _productName;
@synthesize registeredCode = _registeredCode;
@synthesize registeredDate = _registeredDate;
@synthesize version = _version;
@synthesize iwizardToMacFolder = _iwizardToMacFolder;
@synthesize newversion = _newversion;
@synthesize mustUpdate = _mustUpdate;
@synthesize mustUpdateVersion = _mustUpdateVersion;
@synthesize mustUpdateBuild = _mustUpdateBuild;
@synthesize mustUpdateURL = _mustUpdateURL;
@synthesize skipedVersion = _skipedVersion;
@synthesize chooseLanguageType = _chooseLanguageType;
@synthesize iTunesVersion = _iTunesVersion;
@synthesize isCopySyncPlistFile = _isCopySyncPlistFile;
@synthesize domainNetwork = _domainNetwork;
@synthesize activitylimiteDate = _activitylimiteDate;
@synthesize activityURL = _activityURL;
@synthesize isFamily = _isFamily;
@synthesize activationCode = _activationCode;
@synthesize verificationCount = _verificationCount;
@synthesize verifyLicense = _verifyLicense;
@synthesize RegisteredStatus = _RegisteredStatus;
@synthesize rigisterErrorCode = _rigisterErrorCode;
@synthesize curUseSkin = _curUseSkin;
@synthesize isIllegal = _isIllegal;
@synthesize isIronsrc = _isIronsrc;
@synthesize systemDateFormatter = _systemDateFormatter;
@synthesize deviceArray = _deviceArray;
@synthesize activityInfo = _activityInfo;
@synthesize isLoadGuideView = _isLoadGuideView;
@synthesize isNOAdvertisement = _isNOAdvertisement;
@synthesize iosMoverDiscountUrl = _iosMoverDiscountUrl;
@synthesize isNoYouToBePhoto = _isNoYouToBePhoto;
@synthesize isKeepPhotoDate = _isKeepPhotoDate;
@synthesize isStartUpAirBackup = _isStartUpAirBackup;
@synthesize selectModular = _selectModular;
@synthesize buyId = _buyId;

+ (IMBSoftWareInfo*) singleton {
    static IMBSoftWareInfo *_singleton = nil;
	@synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBSoftWareInfo alloc] init];
		}
	}
	return _singleton;
}

- (void)setCurUseSkin:(NSString *)curUseSkin {
    if (_curUseSkin != nil) {
        [_curUseSkin release];
        _curUseSkin = nil;
    }
    _curUseSkin = [curUseSkin retain];
}

- (id)init {
    self = [super init];
    if (self) {
        _isIllegal = NO;
        //判断是家庭版本还是普通版本 YES为家庭版本
        _isFamily = NO;
        //合作伙伴的定制版，YES为定制版
        _isIronsrc = NO;
        //没有广告的版本，YES为无广告版本
        _isNOAdvertisement = NO;
        //NO是包含YouTube图片的版本，YES不是；
        _isNoYouToBePhoto = NO;
        
        self.domainNetwork = @"http://imobie.us.179.gppnetwork.com/";//@"http://cal.imobie.us/";//默认
        _isCopySyncPlistFile = YES;
        _productName = @"AnyTrans";
        _resProductName = @"AnyTrans";
        _buildDate = @"20180103";

        _buyId = 1;
        _selectModular = @"";
        _activityInfo = [[IMBActivityInfo alloc] init];
        
//        [[NSUserDefaults standardUserDefaults] setObject:@"blackSkin" forKey:@"customColor"];
        _deviceArray = [[NSMutableArray alloc] init];
        [self checkSystemDateFormatter];
        //获取当前使用皮肤
        NSString *curSkin = [[NSUserDefaults standardUserDefaults] objectForKey:@"customColor"];
        NSString *skinPlistPath = [[NSBundle mainBundle] pathForResource:curSkin ofType:@"plist"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if (skinPlistPath == nil || ![fm fileExistsAtPath:skinPlistPath]) {
            [self setCurUseSkin:@"whiteSkin"];//默认设置为圣诞节皮肤   whiteSkin
            [[NSUserDefaults standardUserDefaults] setObject:@"whiteSkin" forKey:@"customColor"];
            NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
            NSString *curSkinPath = [[resourcePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:_curUseSkin];
            if ([[NSFileManager defaultManager] fileExistsAtPath:curSkinPath]) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
                    [[NSFileManager defaultManager] removeItemAtPath:resourcePath error:nil];
                }
                [[NSFileManager defaultManager] moveItemAtPath:curSkinPath toPath:resourcePath error:nil];
            }else {
                [[IMBLogManager singleton] writeInfoLog:@"write skin isn't exist"];
            }
        }else {
            if ([StringHelper stringIsNilOrEmpty:curSkin]) {
                [self setCurUseSkin:@"whiteSkin"];
            } else {
                [self setCurUseSkin:curSkin];
            }
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _activitylimiteDate = [[dateFormatter dateFromString:@"2015-11-24 08:00:00"] retain];
        [dateFormatter release];
        self.iTunesVersion = [self getiTunesVersion];
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"iTunes Version:%@",self.iTunesVersion]];
        if ([StringHelper stringIsNilOrEmpty:_iTunesVersion]) {
            self.iTunesVersion = @"11.3";
        }
        self.privateKey = PrivateSecretKey;
        _serverArray = [[NSMutableArray alloc] init];
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        _version = [appVersion retain];
        
        isEditRegFile = NO;
        NSString *path = [TempHelper resourcePathOfAppDir:@"IMBSoftware-Info" ofType:@"plist"];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSArray *allKeys = dic.allKeys;
        if ([allKeys containsObject:@"ProductName"]) {
            _productName = [[dic objectForKey:@"ProductName"] retain];
        }
        if ([allKeys containsObject:@"IosMoverDiscountUrl"]) {
            _iosMoverDiscountUrl = [[dic objectForKey:@"IosMoverDiscountUrl"] retain];
        }
        
        _isRegistered = [[dic objectForKey:@"IsRegistered"] boolValue];
        _registerCodeArray = [[NSMutableArray arrayWithObjects:
                               @"7XNB-N8D4-WPXJ-Q3CY",
                               nil] retain];
        //iwizard导出的folder
        if ([allKeys containsObject:@"iWizardToMacFolder"]) {
            _iwizardToMacFolder = [[dic objectForKey:@"iWizardToMacFolder"] retain];
        }
        
        if ([allKeys containsObject:@"RegisteredCode"]) {
            _registeredCode = [[dic objectForKey:@"RegisteredCode"] retain];
        }
        
        if ([allKeys containsObject:@"StartUpAirBackup"]) {
            _isStartUpAirBackup = [[dic objectForKey:@"StartUpAirBackup"] boolValue];
        }
        
        if ([allKeys containsObject:@"RegisteredDate"]) {
            _registeredDate = [[dic objectForKey:@"RegisteredDate"] retain];
        }
        if ([allKeys containsObject:@"verificationCount"]) {
            [self setVerificationCount:[[dic objectForKey:@"verificationCount"] intValue]];
        }else {
            _verificationCount = 0;
        }
        
        if ([allKeys containsObject:@"MustUpdate"]) {
            _mustUpdate = [(NSNumber*)[dic objectForKey:@"MustUpdate"] boolValue];
        }
        
        if ([allKeys containsObject:@"NewVersion"]) {
            _newversion = [[dic objectForKey:@"NewVersion"] retain];
        }
        if ([allKeys containsObject:@"RegisteredStatus"]) {
            _RegisteredStatus = [[dic objectForKey:@"RegisteredStatus"] intValue];
        }else {
            _RegisteredStatus = Activate_NO;
        }
        
        if ([allKeys containsObject:@"config"]) {
            NSMutableDictionary *confDic = [[dic objectForKey:@"config"] retain];
            NSArray *subAllKeys = confDic.allKeys;
            if (subAllKeys != nil && subAllKeys.count > 0) {
                if ([subAllKeys containsObject:@"server"]) {
                    NSMutableArray *tmpServerArray = [confDic objectForKey:@"server"];
                    if (tmpServerArray != nil && tmpServerArray.count > 0) {
                        for (NSString *servUrl in tmpServerArray) {
                            [self.serverArray addObject:[servUrl AES256DecryptWithKey:self.privateKey]];
                        }
                    }
                }
                if ([subAllKeys containsObject:@"serverkey"]) {
                    self.serverKey = (NSString*)[confDic objectForKey:@"serverkey"];
                }
            }
        }
        // 检查软件是否是第一次运行,并且记录第一次运行的时间
        BOOL isfirst = YES;
        id notfirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"notfirst_launch"];
        if (notfirst != nil) {
            if ([notfirst isKindOfClass:[NSNumber class]]) {
                isfirst = [notfirst boolValue];
            }
        }
        if (isfirst) {
            NSDate *standDate = nil;
            if (standDate == nil) {
                standDate = [NSDate date];
            }
            [self setFirstRunDateTime:standDate];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyyMMdd"];
            NSString *longDateTimeStr = [df stringFromDate:standDate];
            [df setDateFormat:@"yyyyMMdd"];
            [self setFirstRunDate:[df dateFromString:longDateTimeStr]];
            [df release];
            df = nil;
            [self setIsFirstRun:YES];
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"notfirst_launch"];
        } else {
            [self setIsFirstRun:NO];
            if ([allKeys containsObject:@"FirstRunDate"]) {
                NSString *dateStr = (NSString*)[dic objectForKey:@"FirstRunDate"];
                if (![StringHelper stringIsNilOrEmpty:dateStr]) {
                    dateStr = [dateStr AES256DecryptWithKey:self.privateKey];
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    [df setDateFormat:@"yyyyMMdd"];
                    NSDate *date = [df dateFromString:dateStr];
                    if (date == nil) {
                        NSArray *rangs = [dateStr componentsSeparatedByString:@" "];
                        NSString *shortDateStr = nil;
                        if (rangs != nil && rangs.count > 0) {
                            shortDateStr = [rangs firstObject];
                        }
                        [df setDateFormat:@"yyyyMMdd"];
                        [self setFirstRunDate:[df dateFromString:shortDateStr]];
                    } else {
                        [self setFirstRunDateTime:date];
                        [df setDateFormat:@"yyyyMMdd"];
                        NSString *shortDate = [df stringFromDate:self.firstRunDateTime];
                        [self setFirstRunDate:[df dateFromString:shortDate]];
                    }
                    [df release];
                    df = nil;
                }
            } else {
                NSDate *standDate = nil;
                if (standDate == nil) {
                    standDate = [NSDate date];
                }
                [self setFirstRunDateTime:standDate];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyyMMdd"];
                NSString *shortDate = [df stringFromDate:standDate];
                [self setFirstRunDate:[df dateFromString:shortDate]];
                [df release];
                df = nil;
            }
        }
        [dic release];
        dic = nil;
        [self save];
        
        //其他信息暂时不用
        _isSupportApp = YES;
        _isSupportIOS = YES;
        _isSupportIPod = YES;
        _isSupportJailbreak = YES;
        _isSupportMedia = YES;
        _isSupportWifi = NO;
        _isSupportMultiDevice = YES;
        _isSupportiTunesLib = YES;
        _isSupportConverter = YES;
        _iTunesSupportMaxVersion = @"13.9.9.99";
        _iTunesSupportMinVersion = @"9.0.0";
        _iosSupportMaxVersion = @"11.9.9";
        _isNeedRegister = YES;
        _verifyLicense = [IMBVerifyProduct singleton];
    }
    
    return self;
}

- (void)checkSystemDateFormatter {
    if (_chooseLanguageType == GermanLanguage || _chooseLanguageType == FrenchLanguage || _chooseLanguageType == SpanishLanguage ||  _chooseLanguageType == ArabLanguage) {
        _systemDateFormatter = @"dd/MM/yyyy";
    }else if (_chooseLanguageType == JapaneseLanguage || _chooseLanguageType == ChinaLanguage) {
        _systemDateFormatter = @"yyyy/MM/dd";
    }else {
        _systemDateFormatter = @"MM/dd/yyyy";
    }
}

- (void)setChooseLanguageType:(LanguageTypeEnum)chooseLanguageType {
    _chooseLanguageType = chooseLanguageType;
    [self checkSystemDateFormatter];
}

-(NSString*)getiTunesVersion {
    NSTask *versionTask = [[NSTask alloc] init];
    versionTask.launchPath = @"/usr/bin/defaults";
    versionTask.arguments = @[@"read", @"/Applications/iTunes.app/Contents/version.plist", @"CFBundleShortVersionString"];
    NSPipe *versionPipe = [NSPipe pipe];
    [versionTask setStandardOutput:versionPipe];
    [versionTask setStandardInput:[NSPipe pipe]];
    [versionTask launch];
    NSData *versionData = [[[versionTask standardOutput] fileHandleForReading] availableData];
    NSString *version = nil;
    if (versionData != nil && versionData.length > 0) {
        version = [[[NSString alloc] initWithData:versionData encoding:NSUTF8StringEncoding] autorelease];
        if (version != nil && version.length >= 1 && [version hasSuffix:@"\n"]) {
            version = [version substringToIndex:version.length - 1];
        }
    }
    return version;
}


- (void)dealloc {
    if (_iosMoverDiscountUrl) {
        [_iosMoverDiscountUrl release];
        _iosMoverDiscountUrl = nil;
    }
    [_activityInfo release], _activityInfo = nil;
    if (_serverArray != nil) {
        [_serverArray release];
        _serverArray = nil;
    }
    [self setDeviceArray:nil];
    [_domainNetwork release],_domainNetwork = nil;
    [_activityURL release],_activityURL = nil;
    [_activitylimiteDate release],_activitylimiteDate = nil;
    if (_productName != nil) {
        [_productName release];
    }
    if (_buildDate != nil) {
        [_buildDate release];
    }
    if (_version != nil) {
        [_version release];
    }
    if (_registeredCode != nil) {
        [_registeredCode release];
    }
    if (_registeredDate != nil) {
        [_registeredDate release];
    }
    if (_iwizardToMacFolder != nil) {
        [_iwizardToMacFolder release];
    }
    if (_registerCodeArray != nil) {
        [_registerCodeArray release];
    }
    if (_iTunesVersion != nil) {
        [_iTunesVersion release];
        _iTunesVersion = nil;
    }
    
    [super dealloc];
}

// 只针对时间 YES表示过期、NO表示未过期
- (BOOL)checkProductExpired:(int*)remainDay {
    if (self.productLimitType == IMBLimit_Time_Counts) {
        if (self.firstRunDate == nil) {
            return YES;
        }
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:self.firstRunDate toDate:nowDate options:0];
        int days = (int)components.day;
        *remainDay = self.limitDay - days;
        if (*remainDay < 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        *remainDay = 0;
        return NO;
    }
}

// 得到剩余的传输项个数
- (int)getRemainItemCount {
    int remainCount = 0;
    if (self.productLimitType == IMBLimit_Counts) {
        remainCount = self.limitItemCount - _limitItemCountUsedCount;
    } else if (self.productLimitType == IMBLimit_Time_Counts) {
        NSString *dateKey = [self getCurrentDate];
        if ([_limitDayUsedCountDic.allKeys containsObject:dateKey]) {
            NSString *usedCountStr = [_limitDayUsedCountDic objectForKey:dateKey];
            usedCountStr = [usedCountStr AES256DecryptWithKey:self.privateKey];
            remainCount = self.limitItemCount - [usedCountStr intValue];
        } else {
            remainCount = self.limitItemCount - 0;
        }
    }
    return remainCount;
}

//TODO:后面需要删掉；已经没有使用了
- (int) getRemainCnt:(NSString*)iPodKey WithTransferType:(IMBTransferType)transType {
    return 50;
}

- (int) getRemainCnt:(NSString*)iPodKey WithSrciPodKey:(NSString*)srciPodKey {
    return 50;
}

- (NSString*)getCurrentDateTime {
    // NSDate *standDate = [IMBHelper getDateTimeFromService:&isFromServer];
    NSDate *standDate = nil; //暂时 放一放
    if (standDate == nil) {
        standDate = [NSDate date];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *retDateTime = [df stringFromDate:standDate];
    [df release];
    df = nil;
    return retDateTime;
}

- (NSString*)getCurrentDate {
    // NSDate *standDate = [IMBHelper getDateTimeFromService:&isFromServer];
    NSDate *standDate = nil; //暂时 放一放
    if (standDate == nil) {
        standDate = [NSDate date];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *retDateTime = [df stringFromDate:standDate];
    [df release];
    df = nil;
    return retDateTime;
}

- (void)addLimitCount:(int)addCount {
    while (isEditRegFile) {
        usleep(500);
    }
    isEditRegFile = YES;
    NSString *path = [TempHelper resourcePathOfAppDir:@"IMBSoftware-Info" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (self.productLimitType == IMBLimit_Counts) {
        _limitItemCountUsedCount += addCount;
        [dic setObject:[NSNumber numberWithInt:_limitItemCountUsedCount] forKey:Limit_Count_Used];
    } else {
        NSString *dateKey = [self getCurrentDate];
        if ([_limitDayUsedCountDic.allKeys containsObject:dateKey]) {
            NSString *usedCountStr = [_limitDayUsedCountDic objectForKey:dateKey];
            usedCountStr = [usedCountStr AES256DecryptWithKey:self.privateKey];
            int usedCount =  [usedCountStr intValue];
            usedCount += addCount;
            [_limitDayUsedCountDic setObject:[[NSString stringWithFormat:@"%d", usedCount] AES256EncryptWithKey:self.privateKey] forKey:dateKey];
        } else {
            [_limitDayUsedCountDic setObject:[[NSString stringWithFormat:@"%d", addCount] AES256EncryptWithKey:self.privateKey] forKey:dateKey];
        }
        [dic setObject:_limitDayUsedCountDic forKey:Limit_Day_Count_Used];
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
    [dic writeToFile:path atomically:YES];
    isEditRegFile = NO;
}

- (BOOL)registerSoftware:(NSString*)registerCode {
    [self setRigisterErrorCode:@""];
    NSString *tmpRegisterCode = [registerCode.uppercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tmpRegisterCode = [tmpRegisterCode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tmpRegisterCode = [tmpRegisterCode stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    BOOL succeceed = NO;
//    for (NSString *registerCode in _registerCodeArray) {
//        succeceed =  [registerCode isEqualToString:tmpRegisterCode];
//        if (succeceed) {
//            break;
//        }
//    }
    succeceed = [self verifyActivateSoftware:tmpRegisterCode];
    
    if (succeceed) {
        self.isRegistered = TRUE;
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.registeredDate = [dateFormatter stringFromDate:date];
        [dateFormatter release];
        self.registeredCode = tmpRegisterCode;
        [self save];
        // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REGISTER_SUCCEED object:nil  userInfo:nil];
    }
    return succeceed;
}

- (BOOL)verifyActivateSoftware:(NSString *)licenseStr {
    BOOL result = NO;
    KeyStateStruct *ks = [_verifyLicense verifyProductLicense:licenseStr];
    if (!ks->valid) {
        _isIllegal = YES;
    }
    
    //验证是否有时间和版本限制
    if (ks->versiolimitation == 0 && ks->valid) {
        NSString *version = [NSString stringWithFormat:@"%d.%d.%d", ks->version1, ks->version2, ks->version3];
        if ([_version compare:version] == NSOrderedDescending) {
            [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"version limitation ver:%@",version]];
            ks->valid = NO;
            _isIllegal = YES;
        }
    }
    
    if (ks->activiate == 0 && ks->valid) {//在线激活
        [[IMBLogManager singleton] writeInfoLog:@"Online Activation!"];
        result = [self onlineVerifyActivateProduct:ks withLicensn:licenseStr];
    }else if (ks->activiate == 1) {//本地激活
        [[IMBLogManager singleton] writeInfoLog:@"Local Activation!"];
        result = [_verifyLicense activeProduct:ks withLicensn:licenseStr];
        if (result) {
            self.registeredCode = licenseStr;
            self.RegisteredStatus = Activate_Local;
            self.isRegistered = TRUE;
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
            self.registeredDate = [dateFormatter stringFromDate:date];
            [dateFormatter release];
            [self save];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REGISTER_SUCCEED object:nil userInfo:nil];
        }else {
            // 通知注册的页面注册码无效--->本地激活失败
//            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:Activate_Local], @"RegisteredStatus", nil];
            //            [nc postNotificationName:NOTIFY_REGISTER_LICENSE_INVALID object:nil userInfo:userInfo];
        }
    }else {
        // 通知注册的页面注册码无效--->注册码不可用
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:Activate_NO], @"RegisteredStatus", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REGISTER_LICENSE_INVALID object:nil userInfo:userInfo];
    }
    return result;
}

- (BOOL)onlineVerifyActivateProduct:(KeyStateStruct *)ks withLicensn:(NSString *)license {
    BOOL onlineResult = NO;
    if ([TempHelper isInternetAvail]) {//在线激活
        onlineResult = [self activationOnline:ks withLicense:license];
    }else {//临时激活
        [[IMBLogManager singleton] writeInfoLog:@"Temporary Activation!"];
        if (self.RegisteredStatus != Activate_Temporary || ![self.registeredCode isEqualToString:license]) {
            onlineResult = [_verifyLicense activeProduct:ks withLicensn:license];
            if (onlineResult) {
                self.registeredCode = license;
                self.RegisteredStatus = Activate_OnLine;
                self.isRegistered = TRUE;
                NSDate *date = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
                self.registeredDate = [dateFormatter stringFromDate:date];
                [dateFormatter release];
                [self save];
            }else {
                // 通知注册的页面注册码无效--->临时激活失败
//                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:Activate_Temporary], @"RegisteredStatus", nil];
                //                [nc postNotificationName:NOTIFY_REGISTER_LICENSE_INVALID object:nil userInfo:userInfo];
            }
        }else {
            // 通知注册的页面注册码无效--->已经临时激活成功一次了，不能在临时激活了
            [[IMBLogManager singleton] writeInfoLog:@"Temporary activation after failure, not connected to the network of online activation:1234"];
//            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:Activate_OnLine], @"RegisteredStatus", @"1234", @"FailedStatus", nil];
            //            [nc postNotificationName:NOTIFY_REGISTER_LICENSE_INVALID object:nil userInfo:userInfo];
        }
    }
    return onlineResult;
}

- (BOOL)activationOnline:(KeyStateStruct *)ks withLicense:(NSString *)license {
    BOOL onlineResult = NO;
    NSString *activationCode = nil;
    onlineResult = [_verifyLicense onlineActivate:ks withLicense:license withActivationCode:&activationCode];
    [self setRigisterErrorCode:_verifyLicense.errorCode];
    if (onlineResult) {
        self.registeredCode = license;
        self.activationCode = activationCode;
        self.RegisteredStatus = Activate_OnLine;
        self.isRegistered = TRUE;
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        self.registeredDate = [dateFormatter stringFromDate:date];
        [dateFormatter release];
        [self save];
    }
    return onlineResult;
}

+ (NSString *)isaddMosaicTextStr:(NSString *)text{
    int length = [self convertToInt:text];
    if (length > 7) {
        NSString *frontText = [text substringWithRange:NSMakeRange(0, 4)];
        NSInteger endLength = length - 4;
        for (int i = 0;i <endLength ; i++) {
            frontText = [frontText stringByAppendingString:@"●"];
        }
        return frontText;
    }
    return nil;
    
}

- (void)save {
    while (isEditRegFile) {
        usleep(500);
    }
    isEditRegFile = YES;
    NSString *path = [TempHelper resourcePathOfAppDir:@"IMBSoftware-Info" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSArray *allkeys = dic.allKeys;
    if (![StringHelper stringIsNilOrEmpty:_iwizardToMacFolder]) {
        [dic setValue:_iwizardToMacFolder forKey:@"iWizardToMacFolder"];
    }
    [dic setValue:_registeredDate forKey:@"RegisteredDate"];
    [dic setValue:_registeredCode forKey:@"RegisteredCode"];
    [dic setValue:[NSNumber numberWithInt:_RegisteredStatus] forKey:@"RegisteredStatus"];
    [dic setValue:[NSNumber numberWithInt:_isStartUpAirBackup] forKey:@"StartUpAirBackup"];
    [dic setValue:[NSNumber numberWithBool:_isRegistered] forKey:@"IsRegistered"];
    [dic setValue:[NSNumber numberWithBool:_mustUpdate] forKey:@"MustUpdate"];
    if (_newversion != nil) {
        [dic setValue:_newversion forKey:@"NewVersion"];
    }
    if (![StringHelper stringIsNilOrEmpty:self.serverKey] && (self.serverArray != nil && self.serverArray.count > 0)) {
        NSMutableDictionary *confDic = nil;
        NSMutableArray *tmpServerArray = nil;
        if (allkeys != nil && allkeys.count > 0) {
            if ([allkeys containsObject:@"config"]) {
                confDic = [[dic objectForKey:@"config"] retain];
                if (confDic != nil && confDic.allKeys.count > 0) {
                    if ([confDic.allKeys containsObject:@"server"]) {
                        tmpServerArray = [[confDic objectForKey:@"server"] retain];
                    } else {
                        tmpServerArray = [[NSMutableArray alloc] init];
                        [confDic setObject:tmpServerArray forKey:@"server"];
                    }
                }
            } else {
                confDic = [[NSMutableDictionary alloc] init];
                [dic setObject:confDic forKey:@"config"];
                tmpServerArray = [[NSMutableArray alloc] init];
                [confDic setObject:tmpServerArray forKey:@"server"];
            }
        }
        [confDic setObject:[self.serverKey AES256EncryptWithKey:self.privateKey] forKey:@"serverkey"];
        for (NSString *servUrl in self.serverArray) {
            [tmpServerArray removeAllObjects];
            [tmpServerArray addObject:[servUrl AES256EncryptWithKey:self.privateKey]];
        }
        [tmpServerArray release];
        tmpServerArray = nil;
        [confDic release];
        confDic = nil;
    }
    if (self.firstRunDateTime != nil) {
        if (![allkeys containsObject:@"FirstRunDate"]) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyyMMdd"];
            NSString *firstRunDateTime = [df stringFromDate:self.firstRunDateTime];
            [df release];
            df = nil;
            [dic setObject:[firstRunDateTime AES256EncryptWithKey:self.privateKey] forKey:@"FirstRunDate"];
        }
    }
    if([dic writeToFile:path atomically:YES]){
    }else{
    }
    [dic release];
    isEditRegFile = NO;
}

- (void)saveIosMoverUrl {
    while (isEditRegFile) {
        usleep(500);
    }
    isEditRegFile = YES;
    if (_iosMoverDiscountUrl) {
        NSString *path = [TempHelper resourcePathOfAppDir:@"IMBSoftware-Info" ofType:@"plist"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [dic setValue:_iosMoverDiscountUrl forKey:@"IosMoverDiscountUrl"];
        [dic writeToFile:path atomically:YES];
        [dic release];
    }
    isEditRegFile = NO;
}

- (NSString*) getProductTitle {
    if (!_isRegistered ) {
        return [NSString stringWithFormat:CustomLocalizedString(@"MainWindow_id_2", nil), self.productName];
    } else {
        return [NSString stringWithFormat:CustomLocalizedString(@"%@", nil), self.productName];
    }
}

+ (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
    
}

- (NSString*) defaultLanguage {
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSLog(@"language array des: %@", array);
    if (array && array.count > 0) {
        NSString *lang = [array objectAtIndex:0];
        return lang;
    }
    return @"en";
}

- (Boolean) checkMustUpdate {
    if (_mustUpdate && _newversion && ![_newversion isEqual: @""]) {
        
        if ([_version compare:_newversion options:NSNumericSearch] ==
            NSOrderedAscending) {
            return true;
        }
        
    }
    return false;
}

- (NSString*) ProductNameVersionBuildDateString{
    return [NSString stringWithFormat:@"%@ V%@.%@",_productName,_version,_buildDate];
}

@end
