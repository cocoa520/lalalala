//
//  IMBVerifyProduct.m
//  PhoneClean3.0
//
//  Created by Pallas on 6/25/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBVerifyProduct.h"
#import "IMBSoftWareInfo.h"
#import "TempHelper.h"
#import "StringHelper.h"
#import "DateHelper.h"
@implementation IMBVerifyProduct
@synthesize appName = _appName;
@synthesize licnese = _licnese;
@synthesize version = _version;
@synthesize regDateTime = _regDateTime;
@synthesize activeType = _activeType;
@synthesize lincenseType = _lincenseType;
@synthesize activeQuota = _activeQuota;
@synthesize duration = _duration;
@synthesize timeLimitation = _timeLimitation;
@synthesize versionLimitation = _versionLimitation;
@synthesize maxVersion = _maxVersion;
@synthesize lastActiveTime = _lastActiveTime;
@synthesize valid = _valid;
@synthesize errorCode = _errorCode;

- (id)init {
    self = [super init];
    if (self) {
        nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
        fm = [NSFileManager defaultManager];
        NSString *regFolderPath = [[TempHelper getAppSupportPath] stringByAppendingPathComponent:@"iMobieConfig"];
        if (![fm fileExistsAtPath:regFolderPath]) {
            [fm createDirectoryAtPath:regFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        regFilePath = [[regFolderPath stringByAppendingPathComponent:@"ConfigReg.plist"] retain];
        _activeType = ActivateLocal;
        _lincenseType = Paid;
        _activeQuota = 1;
        _duration = UmlimitedDateTime;
        _timeLimitation = NO;
        _versionLimitation = NO;
        _maxVersion = @"";
        _lastActiveTime = @"";
        _valid = NO;
        _errorCode = @"";
    }
    return self;
}

- (void)dealloc {
    if (regFilePath != nil) {
        [regFilePath retain];
        regFilePath = nil;
    }
    if (_licnese != nil) {
        [_licnese release];
        _licnese = nil;
    }
    if (_regDateTime != nil) {
        [_regDateTime release];
        _regDateTime = nil;
    }
    if (_version != nil) {
        [_version release];
        _version = nil;
    }
    [super dealloc];
}

+ (IMBVerifyProduct*)singleton {
    static IMBVerifyProduct *_singleton = nil;
    @synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBVerifyProduct alloc] init];
		}
	}
	return _singleton;
}

- (void)applicationWillTerminate:(NSNotification*)notification {
    [nc removeObserver:self name:NSApplicationWillTerminateNotification object:nil];
    [self dealloc];
}

- (BOOL)readActiveInfo:(NSString *)productVersion {
    if ([fm fileExistsAtPath:regFilePath]) {
        NSDictionary *regDic = [NSDictionary dictionaryWithContentsOfFile:regFilePath];
        if (regDic != nil && [[regDic allKeys] count] > 0) {
            NSArray *allKey = [regDic allKeys];
            if ([allKey containsObject:@"AppName"]) {
                _appName = [regDic objectForKey:@"AppName"];
            } else {
                _appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
            }
            if ([allKey containsObject:@"VersionNumber"]) {
                _version = [[regDic objectForKey:@"VersionNumber"] retain];
            } else {
                NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
                _version = [[NSString stringWithFormat:@"%@.%@", shortVersion, version] retain];
            }
            if ([allKey containsObject:@"SerialNumber"]) {
                _licnese = [[regDic objectForKey:@"SerialNumber"] retain];
            } else {
                _licnese = @"";
            }
            if ([allKey containsObject:@"RegDateTime"]) {
                _regDateTime = [[regDic objectForKey:@"RegDateTime"] retain];
            } else {
                _regDateTime = @"";
            }
            
            if (![StringHelper stringIsNilOrEmpty:_licnese]) {
                KeyStateStruct *ks = [self verifyProductLicense:_licnese];
                if (ks->valid) {
                    if (ks->activiate == 0) {
                        _activeType = ActivateOnLine;
                    } else {
                        _activeType = ActivateLocal;
                    }
                    if (ks->license == 0) {
                        _lincenseType = Paid;
                    } else if (ks->license == 1) {
                        _lincenseType = NFR;
                    } else if (ks->license == 2) {
                        _lincenseType = Giveaway;
                    } else {
                        _lincenseType = Paid;
                    }
                    _activeQuota = ks->quota + 1;
                    switch (ks->duration) {
                        case 0:
                            _duration = OneDay;
                            break;
                        case 1:
                            _duration = SevenDays;
                            break;
                        case 2:
                            _duration = FifteenDays;
                            break;
                        case 3:
                            _duration = ThirtyDays;
                            break;
                        case 4:
                            _duration = SixMouths;
                            break;
                        case 5:
                            _duration = OneYear;
                            break;
                        case 6:
                            _duration = TwoYears;
                            break;
                        case 7:
                            _duration = ThreeYears;
                            break;
                        case 8:
                            _duration = UmlimitedDateTime;
                            break;
                        default:
                            _duration = UmlimitedDateTime;
                            break;
                    }
                    _timeLimitation = (BOOL)ks->timelimitation;
                    _versionLimitation = (BOOL)ks->versiolimitation;
                    NSString *version = [NSString stringWithFormat:@"%d.%d.%d", ks->version1, ks->version2, ks->version3];
                    _maxVersion = version;
                    NSString *dtStr = [NSString stringWithFormat:@"%d-%d-%d", ks->year, ks->month, ks->day];
                    _lastActiveTime = dtStr;
                    _valid = ks->valid;
                    
                    //验证
                    if (ks->versiolimitation == 0 && _valid) {
                        NSString *version = [NSString stringWithFormat:@"%d.%d.%d", ks->version1, ks->version2, ks->version3];
                        if ([productVersion compare:version] == NSOrderedDescending) {//验证失败
                            //                            [fm removeItemAtPath:regFilePath error:nil];
                            _valid = NO;
                        }
                    }
                }
            }
        }
    }
    return _valid;
}

- (BOOL)activeProduct:(NSString *)license {
    if ([self verifyProductLicense:license]->valid) {
        // todo写入注册文件中
        if (![fm fileExistsAtPath:regFilePath]) {
            [fm removeItemAtPath:regFilePath error:nil];
        }
        NSMutableDictionary *regDic = [[NSMutableDictionary alloc] init];
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        [regDic setObject:appName forKey:@"AppName"];
        NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString *fullVersion = [NSString stringWithFormat:@"%@.%@", shortVersion, version];
        [regDic setObject:fullVersion forKey:@"VersionNumber"];
        [regDic setObject:license forKey:@"SerialNumber"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        [formatter release];
        [regDic setObject:dateStr forKey:@"RegDateTime"];
        [regDic writeToFile:regFilePath atomically:YES];
        [regDic release];
        return YES;
    } else {
        // 通知注册的页面注册码无效
//        [nc postNotificationName:NOTIFY_REGISTER_LICENSE_INVALID object:nil userInfo:nil];
        return NO;
    }
}

- (KeyStateStruct *)verifyProductLicense:(NSString *)license {
    
   //判断是否是Phonetrans Pro或Podtrans Pro
   //进行三种注册码的验证
   //  Anytrans:'A' 'T'  PhoneTrans: 'P' 'E'  PodTrans: ‘P’ ‘O’
    KeyStateStruct *ks=nil;
    if ([license hasPrefix:@"VQ"]) {//iOS和Android通用注册码
        ks = [IMBVerifyActivate verify:license id1:'F' id2:'B'];
    }else if ([license hasPrefix:@"JK"]){//德语合作版本注册码
        ks = [IMBVerifyActivate verify:license id1:'A' id2:'E'];
    }else {
        ks = [IMBVerifyActivate verify:license id1:'A' id2:'T'];
    }
    return ks;
}

- (BOOL)onlineActivate:(KeyStateStruct *)ks withLicense:(NSString *)license withActivationCode:(NSString **)activationCode {
    BOOL result = NO;
    NSDate *localDate = [NSDate date];
    int localtime = [localDate timeIntervalSince1970];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    int integer = (int)[timeZone secondsFromGMT];
    localtime = localtime - integer;
    NSDate *localDate1 = [DateHelper dateFrom1970:localtime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:localDate1];
    [formatter release];
    
    NSString *endTimeStr = [NSString stringWithFormat:@"%d-%d-%d",ks->year,ks->month,ks->day];
    NSURL *url = [TempHelper getHashWebserviceUrl];
    NSString *nameSpace = [TempHelper getHashWebserviceNameSpace];
    NSString *productVersionStr = [NSString stringWithFormat:@"%d.%d.%d",ks->version1,ks->version2,ks->version3];
    BOOL timeLimitation = NO;
    if (ks->timelimitation == 0) {
        timeLimitation = YES;
    }
    BOOL versionlimitation = NO;
    if (ks->versiolimitation == 0) {
        versionlimitation = YES;
    }
    
    int quota = [self allowActiveCount:ks->quota];
    
    NSString *machineCode = [[IMBHWInfo singleton] platformSerialNumber];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:license, @"licence", [NSNumber numberWithInt:quota], @"allowactivecount", [NSNumber numberWithInt:ks->activiate], @"activatetype", [NSNumber numberWithInt:ks->license], @"licensetype", endTimeStr, @"allowlastactivedate", productVersionStr, @"productversion", [NSNumber numberWithInt:ks->duration], @"duedate", machineCode, @"machinecode", [NSNumber numberWithBool:timeLimitation], @"timelimitation", [NSNumber numberWithBool:versionlimitation], @"versionlimitation", dateStr, @"localtime", @"AnyTrans", @"productname", @"Family", @"producttype", @"Mac", @"runtime", nil];
    NSString *str = [TempHelper dictionaryToJson:dic];
    //验证注册码
    NSString *valStr = [self getHashByWebservice:url nameSpace:nameSpace methodName:@"Activate_lience" sha1:str sha2:nil];
    [dic release];
    
    //    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"service back value:%@",valStr]];
    if (valStr == nil) {
        valStr = @"006";//返回的为null
    }
    _errorCode = valStr;
    
    if ([valStr hasPrefix:@"000&"]) {
        result = YES;
        *activationCode = [valStr stringByReplacingOccurrencesOfString:@"000&" withString:@""];
    }else {
        result = NO;
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:Activate_OnLine], @"RegisteredStatus", valStr, @"FailedStatus", nil];
//        [nc postNotificationName:NOTIFY_REGISTER_LICENSE_INVALID object:nil userInfo:userInfo];
//        [nc postNotificationName:NOTIFY_REGISTER_ONLINE object:nil userInfo:userInfo];
    }
    return result;
}


- (NSString *)getHashByWebservice:(NSURL*)url nameSpace:(NSString*)nameSpace methodName:(NSString*)methodName sha1:(NSString *)sha1 sha2:(NSString *)sha2 {
    WSMethodInvocationRef mySoapRef = WSMethodInvocationCreate((CFURLRef)url, (CFStringRef)methodName, kWSSOAP2001Protocol);
    
    if (sha1 != nil && sha2 == nil) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:sha1, @"fileSha1", nil];
        NSArray *paramOrder = [NSArray arrayWithObjects:@"fileSha1", nil];
        WSMethodInvocationSetParameters(mySoapRef, (CFDictionaryRef)params, (CFArrayRef)paramOrder);
    }
    
    if (sha1 != nil && sha2 != nil) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:sha1, @"fileSha1", sha2, @"fileSha2", nil];
        NSArray *paramOrder = [NSArray arrayWithObjects:@"fileSha1", @"fileSha2", nil];
        WSMethodInvocationSetParameters(mySoapRef, (CFDictionaryRef)params, (CFArrayRef)paramOrder);
    }
    
    NSDictionary *reqHeaders = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@#validation# %@", nameSpace, methodName] forKey:@"SOAPAction"];
    WSMethodInvocationSetProperty(mySoapRef, kWSSOAPMethodNamespaceURI,
                                  (CFStringRef)nameSpace);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPExtraHeaders,
                                  (CFDictionaryRef)reqHeaders);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPFollowsRedirects,
                                  kCFBooleanTrue);
    // set debug props
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingHeaders,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingHeaders,
                                  kCFBooleanTrue);
    
    NSDictionary *result = (NSDictionary *)WSMethodInvocationInvoke(mySoapRef);
    // get HTTP response from SOAP request so we can see the status code
    //    CFHTTPMessageRef res = (CFHTTPMessageRef)[result objectForKey:(id)kWSHTTPResponseMessage];
    NSDictionary *resultDir = [result objectForKey:@"/Result"];
    NSLog(@"hash72 result: %@",[resultDir description]);
    NSArray *keyArr = [resultDir allKeys];
    NSString *hashStr = nil;
    for (NSString *key in keyArr) {
        hashStr = [resultDir valueForKey:key];
    }
    return hashStr;
}

- (int)allowActiveCount:(int)quota {
    int activeCount = 0;
    if (quota == 0) {
        activeCount = 1;
    }else if (quota == 1) {
        activeCount = 2;
    }else if (quota == 2) {
        activeCount = 3;
    }else if (quota == 3) {
        activeCount = 4;
    }else if (quota == 4) {
        activeCount = 5;
    }else if (quota == 5) {
        activeCount = 10;
    }else if (quota == 6) {
        activeCount = 30;
    }else if (quota == 7) {
        activeCount = 60;
    }else if (quota == 8) {
        activeCount = 100;
    }else if (quota == 9) {
        activeCount = INT_MAX;
    }else {
        activeCount = 0;
    }
    return activeCount;
}


- (BOOL)activeProduct:(KeyStateStruct *)ks withLicensn:(NSString *)license {
    if (ks->valid) {
        // todo写入注册文件中
        if (![fm fileExistsAtPath:regFilePath]) {
            [fm removeItemAtPath:regFilePath error:nil];
        }
        NSMutableDictionary *regDic = [[NSMutableDictionary alloc] init];
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        [regDic setObject:appName forKey:@"AppName"];
        NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString *fullVersion = [NSString stringWithFormat:@"%@.%@", shortVersion, version];
        [regDic setObject:fullVersion forKey:@"VersionNumber"];
        [regDic setObject:license forKey:@"SerialNumber"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        [formatter release];
        [regDic setObject:dateStr forKey:@"RegDateTime"];
        [regDic writeToFile:regFilePath atomically:YES];
        [regDic release];
        return YES;
    } else {
        return NO;
    }
}

@end
