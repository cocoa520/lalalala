//
//  IMBiCloudNetClient.m
//  iCloudPanel
//
//  Created by iMobie on 12/27/16.
//  Copyright (c) 2016 iMobie. All rights reserved.
//

#import "IMBiCloudNetClient.h"
#import "IMBiCloudHeader.h"
#import "TempHelper.h"
#import "IMBHttpWebResponseUtility.h"
#import "DateHelper.h"
#import "CommonDefine.h"


@implementation IMBMediaStorageUsageEntity
@synthesize displayColor = _displayColor;
@synthesize displayLabel = _displayLabel;
@synthesize mediaKey = _mediaKey;
@synthesize usageInBytes = _usageInBytes;

- (id)init {
    if (self = [super init]) {
        _displayColor = @"";
        _displayLabel = @"";
        _mediaKey = @"";
        _usageInBytes = 0;
    }
    return self;
}

@end

@implementation IMBiCloudLoginInfoEntity
@synthesize aDsID = _aDsID;
@synthesize appleId = _appleId;
@synthesize dsid = _dsid;
@synthesize fullName = _fullName;
@synthesize languageCode = _languageCode;
@synthesize locale = _locale;
@synthesize locked = _locked;
@synthesize primaryEmail = _primaryEmail;
@synthesize primaryEmailVerified = _primaryEmailVerified;
@synthesize statusCode = _statusCode;
@synthesize hasICloudQualifyingDevice = _hasICloudQualifyingDevice;
@synthesize timeZone = _timeZone;
@synthesize isLoadFinish = _isLoadFinish;
@synthesize almostFull = _almostFull;
@synthesize haveMaxQuotaTier = _haveMaxQuotaTier;
@synthesize overQuota = _overQuota;
@synthesize paidQuota = _paidQuota;
@synthesize commerceStorageInBytes = _commerceStorageInBytes;
@synthesize compStorageInBytes = _compStorageInBytes;
@synthesize totalStorageInBytes = _totalStorageInBytes;
@synthesize usedStorageInBytes = _usedStorageInBytes;
@synthesize photoStorage = _photoStorage;
@synthesize backupStorage = _backupStorage;
@synthesize docsStorage = _docsStorage;
@synthesize mailStorage = _mailStorage;

- (id)init {
    if (self = [super init]) {
        _aDsID = @"";
        _appleId = @"";
        _dsid = @"";
        _fullName = nil;
        _languageCode = @"";
        _locked = NO;
        _locale = @"";
        _primaryEmail = @"";
        _primaryEmailVerified = NO;
        _statusCode = 0;
        _timeZone = @"";
        _almostFull = NO;
        _haveMaxQuotaTier = NO;
        _overQuota = NO;
        _paidQuota = NO;
        _commerceStorageInBytes = 0;
        _compStorageInBytes = 0;
        _totalStorageInBytes = 0;
        _usedStorageInBytes = 0;
        _hasICloudQualifyingDevice = 0;
        _isLoadFinish = NO;
        _photoStorage = [[IMBMediaStorageUsageEntity alloc] init];
        _backupStorage = [[IMBMediaStorageUsageEntity alloc] init];
        _docsStorage = [[IMBMediaStorageUsageEntity alloc] init];
        _mailStorage = [[IMBMediaStorageUsageEntity alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_fullName) {
        [_fullName release];
        _fullName = nil;
    }
    [_photoStorage release],_photoStorage = nil;
    [_backupStorage release],_backupStorage = nil;
    [_docsStorage release],_docsStorage = nil;
    [_mailStorage release],_mailStorage = nil;
    [super dealloc];
}

@end

@implementation IMBiCloudNetLoginInfo
@synthesize appleID = _appleID;
@synthesize password = _password;
@synthesize loginStatus = _loginStatus;
@synthesize loginDic = _loginDic;
@synthesize cookieList = _cookieList;
@synthesize loginInfoEntity = _loginInfoEntity;
@synthesize headImage = _headImage;

- (id)init
{
    self = [super init];
    if (self) {
        _appleID = @"";
        _password = @"";
        _loginStatus = NO;
        _loginDic = nil;
        _headImage = nil;
        _cookieList = [[NSMutableArray alloc] init];
        _loginInfoEntity = [[IMBiCloudLoginInfoEntity alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_cookieList != nil) {
        [_cookieList release];
        _cookieList = nil;
    }
    if (_loginDic != nil) {
        [_loginDic release];
        _loginDic = nil;
    }
    if (_loginInfoEntity != nil) {
        [_loginInfoEntity release];
        _loginInfoEntity = nil;
    }
    [super dealloc];
}

@end


#import "IMBNotificationDefine.h"
@implementation IMBiCloudNetClient
@synthesize loginInfo = _loginInfo;
@synthesize downloadService = _downloadService;
- (id)init
{
    self = [super init];
    if (self) {
        _loginInfo = [[IMBiCloudNetLoginInfo alloc] init];
        nc = [NSNotificationCenter defaultCenter];
        _logHandle = [IMBLogManager singleton];
    }
    return self;
}
- (void)dealloc
{
    if (_loginInfo != nil) {
        [_loginInfo release];
        _loginInfo = nil;
    }
    if (_downloadService != nil) {
        [_downloadService release];
        _downloadService = nil;
    }
    if (_firstDic != nil) {
        [_firstDic release];
        _firstDic = nil;
    }
    [super dealloc];
}

//账号是否加了双重验证
- (NSDictionary *)verifiAccountHasTwoStepAuthenticationWithAppleID:(NSString*)appleID withPassword:(NSString*)password {
    //删除cookie历史记录
    [self deleteCookieStorage];

    //构建header
    NSMutableDictionary *firstAuthHeaders = [[NSMutableDictionary alloc] init];
    [firstAuthHeaders setObject:@"application/json" forKey:@"Content-Type"];
    [firstAuthHeaders setObject:@"application/json, text/javascript, */*; q=0.01" forKey:@"Accept"];
    [firstAuthHeaders setObject:@"83545bf919730e51dbfba24e7e8a78d2" forKey:@"X-Apple-Widget-Key"];
    //构建postData
    NSDictionary *loginDic = [NSDictionary dictionaryWithObjectsAndKeys:appleID, @"accountName",password, @"password",@(YES), @"rememberMe",[NSArray array],@"trustTokens", nil];
    NSString *loginStr = [TempHelper dictionaryToJson:loginDic];
    NSData *loginData = [loginStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary *firstDic = [self postWithData:loginData withHeaders:firstAuthHeaders withHost:@"https://idmsa.apple.com" withPath:@"/appleauth/auth/signin" withCookieArray:nil];
    if (_firstDic != nil) {
        [_firstDic release];
        _firstDic = nil;
    }
    _firstDic = [[NSMutableDictionary alloc] initWithDictionary:firstDic];
    return firstDic;
}


- (NSDictionary *)verifiTwoStepAuthentication:(NSString *)password withFirstDic:(NSDictionary *)firstDic {
    NSString *sessionId = nil;
    NSString *scnt = nil;
    NSString *sessiontoken = nil;
    if ([firstDic.allKeys containsObject:@"headerdic"]) {
        NSDictionary *headerDic = [firstDic objectForKey:@"headerdic"];
        if ([headerDic.allKeys containsObject:@"X-Apple-ID-Session-Id"]) {
            sessionId = [headerDic objectForKey:@"X-Apple-ID-Session-Id"];
        }
        if ([headerDic.allKeys containsObject:@"scnt"]) {
            scnt = [headerDic objectForKey:@"scnt"];
        }
        if ([headerDic.allKeys containsObject:@"X-Apple-Session-Token"]) {
            sessiontoken = [headerDic objectForKey:@"X-Apple-Session-Token"];
        }
    }

    //构建header
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"application/json" forKey:@"Content-Type"];
    [authHeaders setObject:@"application/json" forKey:@"Accept"];
    [authHeaders setObject:scnt forKey:@"scnt"];
    [authHeaders setObject:sessionId forKey:@"X-Apple-ID-Session-Id"];
    [authHeaders setObject:@"83545bf919730e51dbfba24e7e8a78d2" forKey:@"X-Apple-Widget-Key"];
    //构建postData
    NSDictionary *loginDic = [NSDictionary dictionaryWithObjectsAndKeys:@{@"code":password}, @"securityCode", nil];
    NSString *loginStr = [TempHelper dictionaryToJson:loginDic];
    NSData *loginData = [loginStr dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *dic = [self postWithData:loginData withHeaders:authHeaders withHost:@"https://idmsa.apple.com" withPath:@"/appleauth/auth/verify/trusteddevice/securitycode" withCookieArray:nil];
    return dic;
}

//登陆iCloud账号；
- (BOOL)iCloudLoginWithAppleID:(NSString*)appleID withPassword:(NSString*)password WithSessiontoken:(NSString *)sessiontoken {
    BOOL retVal = NO;
    NSData *retData = nil;
    long statusCode = 0;

//    if ((!hasDoubleVerifi && statusCode == 200)|| (hasDoubleVerifi && doubleLoginStatusCode == 204) ) {
        //构建header
        NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
        [authHeaders setObject:@"text/plain" forKey:@"Content-Type"];
        [authHeaders setObject:@"*/*" forKey:@"Accept"];
        [authHeaders setObject:@"https://www.icloud.com" forKey:@"Origin"];
        [authHeaders setObject:@"https://www.icloud.com/" forKey:@"Refer"];
        //构建postData
        NSDictionary *loginDic = [NSDictionary dictionaryWithObjectsAndKeys:sessiontoken, @"dsWebAuthToken",@(YES), @"extended_login", nil];
        NSString *loginStr = [TempHelper dictionaryToJson:loginDic];
        NSData *loginData = [loginStr dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSDictionary *dic = [self postWithData:loginData withHeaders:authHeaders withHost:@"https://setup.icloud.com" withPath:@"/setup/ws/1/accountLogin?clientBuildNumber=17HHotfix8&clientId=2EE5B2EE-281C-48C0-9CA3-17FBDFFBCC90&clientMasteringNumber=17HHotfix8" withCookieArray:nil];
        if ([dic.allKeys containsObject:@"data"]) {
            retData = [dic objectForKey:@"data"];
        }
        if ([dic.allKeys containsObject:@"statusCode"]) {
            statusCode = [[dic objectForKey:@"statusCode"] longValue];
        }
        
         NSString *retValStr = [[[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding] autorelease];
        
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [_loginInfo.cookieList addObjectsFromArray:[cookieStorage cookies]];
        _loginInfo.loginDic = [[NSMutableDictionary alloc] initWithDictionary:[TempHelper dictionaryWithJsonString:retValStr]];
        
         [_logHandle writeInfoLog:[NSString stringWithFormat:@"login post return value2:%@",retValStr]];
//    }
    

    if ([self isLoginSuccess]) {
        retVal = YES;
        _loginInfo.loginStatus = YES;
        _loginInfo.appleID = appleID;
        _loginInfo.password = password;
        
        if ([[_loginInfo.loginDic allKeys] containsObject:@"dsInfo"]) {
            NSDictionary *infoDic = [_loginInfo.loginDic objectForKey:@"dsInfo"];
            if (infoDic != nil) {
                if ([infoDic.allKeys containsObject:@"aDsID"]) {
                    _loginInfo.loginInfoEntity.aDsID = [infoDic objectForKey:@"aDsID"];
                }
                if ([infoDic.allKeys containsObject:@"dsid"]) {
                    _loginInfo.loginInfoEntity.dsid = [infoDic objectForKey:@"dsid"];
                }
                if ([infoDic.allKeys containsObject:@"appleId"]) {
                    _loginInfo.loginInfoEntity.appleId = [infoDic objectForKey:@"appleId"];
                }
                if ([infoDic.allKeys containsObject:@"fullName"]) {
                    _loginInfo.loginInfoEntity.fullName = [infoDic objectForKey:@"fullName"];
                }
                if ([infoDic.allKeys containsObject:@"languageCode"]) {
                    _loginInfo.loginInfoEntity.languageCode = [infoDic objectForKey:@"languageCode"];
                }
                if ([infoDic.allKeys containsObject:@"locale"]) {
                    _loginInfo.loginInfoEntity.locale = [infoDic objectForKey:@"locale"];
                }
                if ([infoDic.allKeys containsObject:@"locked"]) {
                    _loginInfo.loginInfoEntity.locked = [[infoDic objectForKey:@"locked"] boolValue];
                }
                if ([infoDic.allKeys containsObject:@"primaryEmail"]) {
                    _loginInfo.loginInfoEntity.primaryEmail = [infoDic objectForKey:@"primaryEmail"];
                }
                if ([infoDic.allKeys containsObject:@"primaryEmailVerified"]) {
                    _loginInfo.loginInfoEntity.primaryEmailVerified = [[infoDic objectForKey:@"primaryEmailVerified"] boolValue];
                }
                if ([infoDic.allKeys containsObject:@"statusCode"]) {
                    _loginInfo.loginInfoEntity.statusCode = [[infoDic objectForKey:@"statusCode"] intValue];
                }
                if ([infoDic.allKeys containsObject:@"hasICloudQualifyingDevice"]) {
                    _loginInfo.loginInfoEntity.hasICloudQualifyingDevice = [[infoDic objectForKey:@"hasICloudQualifyingDevice"] intValue];
                }
                [self getStrogeDetail];
                
                [self getAccountDetail];
            }
        }
    }else {
        if (_loginInfo.loginDic != nil) {
            if ([_loginInfo.loginDic.allKeys containsObject:@"error"]) {
                //抛出错误
                @throw [NSException exceptionWithName:@"LOGIN_ERROR" reason:[_loginInfo.loginDic objectForKey:@"error"] userInfo:_loginInfo.loginDic];
            }
        }
    }
    return retVal;
}


- (NSDictionary *)postWithData:(NSData*)body withHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withCookieArray:(NSMutableArray **)cookieArray {
    NSDictionary *dic = nil;
    NSData *retData = nil;
    NSString *url = [NSString stringWithFormat:@"%@%@", host, path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:[host stringByReplacingOccurrencesOfString:@"https://" withString:@""] forHTTPHeaderField:@"Host"];
    [urlRequest setHTTPBody:body];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            [urlRequest addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error] ;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    //获取cookie数组
    if (urlResponse != nil && cookieArray != nil) {
        NSDictionary *dic = [urlResponse allHeaderFields];
        if (cookieArray != NULL) {
            [*cookieArray addObjectsFromArray:[NSHTTPCookie cookiesWithResponseHeaderFields:dic forURL:[NSURL URLWithString:url]]];
            
        }
    }
    
    if (responseData != nil && [responseData length] > 0 && error == nil){
        retData = [NSData dataWithData:responseData];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }

    dic = @{@"data":retData ? retData : [NSNull null],@"statusCode":[NSNumber numberWithLong:urlResponse.statusCode]?[NSNumber numberWithLong:urlResponse.statusCode]:@(0),@"headerdic":[urlResponse allHeaderFields]?[urlResponse allHeaderFields]:@{}};
    return dic;
}


- (NSDictionary *)putWithData:(NSData*)body withHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withCookieArray:(NSMutableArray **)cookieArray {
    NSDictionary *dic = nil;
    NSData *retData = nil;
    NSString *url = [NSString stringWithFormat:@"%@%@", host, path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"PUT"];
    [urlRequest addValue:[host stringByReplacingOccurrencesOfString:@"https://" withString:@""] forHTTPHeaderField:@"Host"];
    [urlRequest setHTTPBody:body];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            [urlRequest addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error] ;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    //获取cookie数组
    if (urlResponse != nil && cookieArray != nil) {
        NSDictionary *dic = [urlResponse allHeaderFields];
        if (cookieArray != NULL) {
            [*cookieArray addObjectsFromArray:[NSHTTPCookie cookiesWithResponseHeaderFields:dic forURL:[NSURL URLWithString:url]]];
            
        }
    }
    
    if (responseData != nil && [responseData length] > 0 && error == nil){
        retData = [NSData dataWithData:responseData];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }
    
    dic = @{@"data":retData ? retData : [NSNull null],@"statusCode":[NSNumber numberWithLong:urlResponse.statusCode] ? [NSNumber numberWithLong:urlResponse.statusCode] : @(0),@"headerdic":[urlResponse allHeaderFields] ? [urlResponse allHeaderFields] : [NSDictionary dictionary]};
    return dic;
}

//发送双重验证密码（用户没有收到，手动点击）
- (int)sentTwoStepAuthenticationMessage {
    NSString *sessionId = nil;
    NSString *scnt = nil;
    if ([_firstDic.allKeys containsObject:@"headerdic"]) {
        NSDictionary *headerDic = [_firstDic objectForKey:@"headerdic"];
        if ([headerDic.allKeys containsObject:@"X-Apple-ID-Session-Id"]) {
            sessionId = [headerDic objectForKey:@"X-Apple-ID-Session-Id"];
        }
        if ([headerDic.allKeys containsObject:@"scnt"]) {
            scnt = [headerDic objectForKey:@"scnt"];
        }
    }
    
    //构建header
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"application/json" forKey:@"Accept"];
    [authHeaders setObject:@"application/json" forKey:@"Content-Type"];
    [authHeaders setObject:scnt forKey:@"scnt"];
    [authHeaders setObject:@"https://idmsa.apple.com" forKey:@"Origin"];
    [authHeaders setObject:sessionId forKey:@"X-Apple-ID-Session-Id"];
    [authHeaders setObject:@"83545bf919730e51dbfba24e7e8a78d2" forKey:@"X-Apple-Widget-Key"];
    
    NSDictionary *loginDic = @{@"phoneNumber":@{@"id":@(1)},@"mode":@"sms"};
    NSString *loginStr = [TempHelper dictionaryToJson:loginDic];
    NSData *loginData = [loginStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [self putWithData:loginData withHeaders:authHeaders withHost:@"https://idmsa.apple.com" withPath:@"/appleauth/auth/verify/phone" withCookieArray:nil];
    int statusCode = 0;
    if ([dic.allKeys containsObject:@"statusCode"]) {
         statusCode = [[dic objectForKey:@"statusCode"] intValue];
        //响应码为200:表示发送message成功
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"resent message statusCode:%d",statusCode]];
    }
    return statusCode;
}

- (int)sentTwoStepAuthenticationCode {
    NSString *sessionId = nil;
    NSString *scnt = nil;
    if ([_firstDic.allKeys containsObject:@"headerdic"]) {
        NSDictionary *headerDic = [_firstDic objectForKey:@"headerdic"];
        if ([headerDic.allKeys containsObject:@"X-Apple-ID-Session-Id"]) {
            sessionId = [headerDic objectForKey:@"X-Apple-ID-Session-Id"];
        }
        if ([headerDic.allKeys containsObject:@"scnt"]) {
            scnt = [headerDic objectForKey:@"scnt"];
        }
    }
    
    //构建header
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"application/json, text/javascript, */*; q=0.01" forKey:@"Accept"];
    [authHeaders setObject:scnt forKey:@"scnt"];
    [authHeaders setObject:sessionId forKey:@"X-Apple-ID-Session-Id"];
    [authHeaders setObject:@"83545bf919730e51dbfba24e7e8a78d2" forKey:@"X-Apple-Widget-Key"];
    
    NSDictionary *dic = [self putWithData:nil withHeaders:authHeaders withHost:@"https://idmsa.apple.com" withPath:@"/appleauth/auth/verify/trusteddevice/securitycode" withCookieArray:nil];
    int statusCode = 0;
    if ([dic.allKeys containsObject:@"statusCode"]) {
         statusCode = [[dic objectForKey:@"statusCode"] intValue];
        //响应码为202:表示成功再次发送安全码
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"resent code statusCode:%d",statusCode]];
    }
    return statusCode;
}

//退出iCloud账号；
- (void)logoutiCould {
//    [_logHandle writeInfoLog:@"logout iCloud"];
    _loginInfo.loginStatus = NO;
    [self stopKeepAliveThread];
    [self deleteCookieStorage];
}

 //删除cookie历史记录
- (void)deleteCookieStorage {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *httpCookie in [cookieStorage cookies]) {
        [cookieStorage deleteCookie:httpCookie];
    }
}

//设置cookie
- (void)setCookiesStorage {
    [self deleteCookieStorage];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    if (_loginInfo.cookieList != nil) {
        for (NSHTTPCookie *httpCookie in _loginInfo.cookieList) {
            [cookieStorage setCookie:httpCookie];
        }
    }
}

//请求账号容量信息
- (void)getStrogeDetail {
    if (!_loginInfo.loginStatus) {
        return;
    }
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    
    NSString *hostStr = ICLOUD_LOGIN_URL;
    NSString *pathStr = [NSString stringWithFormat:@"/setup/ws/1/storageUsageInfo?clientBuildNumber=17AHotfix1&clientMasteringNumber=17AHotfix1&dsid=%@",_loginInfo.loginInfoEntity.dsid];
    NSData *retData = [IMBHttpWebResponseUtility postWithData:nil withHeaders:authHeaders withHost:hostStr withPath:pathStr withCookieArray:nil];
    NSString *retValStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    NSDictionary *retDic = [TempHelper dictionaryWithJsonString:retValStr];
    if (retDic != nil) {
        if ([retDic.allKeys containsObject:@"quotaStatus"]) {
            NSDictionary *quotaDic = [retDic objectForKey:@"quotaStatus"];
            if ([quotaDic.allKeys containsObject:@"almost-full"]) {
                _loginInfo.loginInfoEntity.almostFull = [[quotaDic objectForKey:@"almost-full"] boolValue];
            }
            if ([quotaDic.allKeys containsObject:@"haveMaxQuotaTier"]) {
                _loginInfo.loginInfoEntity.haveMaxQuotaTier = [[quotaDic objectForKey:@"haveMaxQuotaTier"] boolValue];
            }
            if ([quotaDic.allKeys containsObject:@"overQuota"]) {
                _loginInfo.loginInfoEntity.overQuota = [[quotaDic objectForKey:@"overQuota"] boolValue];
            }
            if ([quotaDic.allKeys containsObject:@"paidQuota"]) {
                _loginInfo.loginInfoEntity.paidQuota = [[quotaDic objectForKey:@"paidQuota"] boolValue];
            }
        }
        if ([retDic.allKeys containsObject:@"storageUsageByMedia"]) {
            NSArray *storageArr = [retDic objectForKey:@"storageUsageByMedia"];
            for (NSDictionary *mediaDic in storageArr) {
                NSString *mediaKey = @"";
                if ([mediaDic.allKeys containsObject:@"mediaKey"]) {
                    mediaKey = [mediaDic objectForKey:@"mediaKey"];
                }
                IMBMediaStorageUsageEntity *entity = nil;
                if ([mediaKey isEqualToString:@"photos"]) {
                    entity = _loginInfo.loginInfoEntity.photoStorage;
                }else if ([mediaKey isEqualToString:@"backup"]) {
                    entity = _loginInfo.loginInfoEntity.backupStorage;
                }else if ([mediaKey isEqualToString:@"docs"]) {
                    entity = _loginInfo.loginInfoEntity.docsStorage;
                }else if ([mediaKey isEqualToString:@"mail"]) {
                    entity = _loginInfo.loginInfoEntity.mailStorage;
                }
                if (entity != nil) {
                    entity.mediaKey = mediaKey;
                    if ([mediaDic.allKeys containsObject:@"usageInBytes"]) {
                        entity.usageInBytes = [[mediaDic objectForKey:@"usageInBytes"] longLongValue];
                    }
                    if ([mediaDic.allKeys containsObject:@"displayColor"]) {
                        entity.displayColor = [mediaDic objectForKey:@"displayColor"];
                    }
                    if ([mediaDic.allKeys containsObject:@"displayLabel"]) {
                        entity.displayLabel = [mediaDic objectForKey:@"displayLabel"];
                    }
                }
            }
        }
        if ([retDic.allKeys containsObject:@"storageUsageInfo"]) {
            NSDictionary *storageDic = [retDic objectForKey:@"storageUsageInfo"];
            if ([storageDic.allKeys containsObject:@"commerceStorageInBytes"]) {
                _loginInfo.loginInfoEntity.commerceStorageInBytes = [[storageDic objectForKey:@"commerceStorageInBytes"] longLongValue];
            }
            if ([storageDic.allKeys containsObject:@"compStorageInBytes"]) {
                _loginInfo.loginInfoEntity.compStorageInBytes = [[storageDic objectForKey:@"compStorageInBytes"] longLongValue];
            }
            if ([storageDic.allKeys containsObject:@"totalStorageInBytes"]) {
                _loginInfo.loginInfoEntity.totalStorageInBytes = [[storageDic objectForKey:@"totalStorageInBytes"] longLongValue];
            }
            if ([storageDic.allKeys containsObject:@"usedStorageInBytes"]) {
                _loginInfo.loginInfoEntity.usedStorageInBytes = [[storageDic objectForKey:@"usedStorageInBytes"] longLongValue];
            }
        }
    }
}

//请求账号信息
- (void)getAccountDetail {
    if (!_loginInfo.loginStatus) {
        return;
    }
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    
    NSString *hostStr = [self getContentHostUrl:@"contacts"];
    if ([TempHelper stringIsNilOrEmpty:hostStr]) {
        NSLog(@"host string is nil");
        return;
    }
//    NSString *hostStr = ICLOUD_LOGIN_URL;
    NSString *pathStr = [NSString stringWithFormat:@"/co/mecard/?clientBuildNumber=17AHotfix1&clientMasteringNumber=17AHotfix1&dsid=%@",_loginInfo.loginInfoEntity.dsid];
    NSString *retValStr = [IMBHttpWebResponseUtility getWithHeadersiCloudDrive:authHeaders withHost:hostStr withPath:pathStr];
    NSDictionary *retDic = [TempHelper dictionaryWithJsonString:retValStr];
    if (retDic != nil) {
        if ([retDic.allKeys containsObject:@"contacts"]) {
            NSArray *array = [retDic objectForKey:@"contacts"];
            if (array.count > 0) {
                NSDictionary *dic = [array objectAtIndex:0];
                if ([dic.allKeys containsObject:@"photo"]) {
                    NSDictionary *photoDic = [dic objectForKey:@"photo"];
                    if ([photoDic.allKeys containsObject:@"url"]) {
                        NSString *photoUrl = [photoDic objectForKey:@"url"];
                        if (![TempHelper stringIsNilOrEmpty:photoUrl]) {
                            NSData *photoData = [self getiCloudNoteAttachmentUrl:photoUrl];
                            if (photoData != nil) {
                                NSImage *image = [[NSImage alloc] initWithData:photoData];
                                int x = 0;
                                int y = 0;
                                int w = image.size.width;
                                int h = image.size.height;
                                if ([photoDic.allKeys containsObject:@"crop"]) {
                                    NSDictionary *cropDic = [photoDic objectForKey:@"crop"];
                                    if ([cropDic.allKeys containsObject:@"x"]) {
                                        x = [[cropDic objectForKey:@"x"] intValue];
                                    }
                                    if ([cropDic.allKeys containsObject:@"y"]) {
                                        y = [[cropDic objectForKey:@"y"] intValue];
                                    }
                                    if ([cropDic.allKeys containsObject:@"height"]) {
                                        w = [[cropDic objectForKey:@"height"] intValue];
                                    }
                                    if ([cropDic.allKeys containsObject:@"width"]) {
                                        h = [[cropDic objectForKey:@"width"] intValue];
                                    }
                                }
                                NSImage *cropImage = [TempHelper cutImageForSize:image width:w height:h x:x y:y];
                                
                                if (cropImage != nil) {
                                    NSData *imageData = [TempHelper scalingImage:cropImage withLenght:32];
                                    if (imageData != nil) {
                                        NSImage *thumb = [[NSImage alloc] initWithData:imageData];
                                        NSImage *image1 = [TempHelper cutImageWithImage:thumb border:32];
                                        _loginInfo.headImage = image1;
                                        [thumb release];
                                    }
                                }
                                [image release];
                            }
                        }
                    }
                }
            }
        }else if ([retDic.allKeys containsObject:@"reason"]) {
            id obj = [retDic objectForKey:@"reason"];
            NSString *appleWebauthTokenStr = nil;
            if (obj && [obj isKindOfClass:[NSString class]]) {
                appleWebauthTokenStr = (NSString *)obj;
                if ([appleWebauthTokenStr isEqualToString:@"Missing X-APPLE-WEBAUTH-TOKEN cookie"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_APPLE_ID_PROTECTED_TWO_STEP_AUTHENTICATION_FAILURE object:nil userInfo:nil];
                }
            }
        }else {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"head image detail:%@",retValStr]];
        }
    }
}

//自动刷新web
- (void)startKeepAliveThread {
    [self stopKeepAliveThread];
    if (!_loginInfo.loginStatus) {
        //退出线程
        return;
    }
    
    _keepAliveThread = [[NSThread alloc] initWithTarget:self selector:@selector(refreshWebAuthUrl) object:nil];
    _keepAliveThread.threadPriority = 0.0;
    [_keepAliveThread start];
}

- (void)refreshWebAuthUrl {
    NSLog(@"ddddddddddddddddddddd");
    if (!_loginInfo.loginStatus) {
        return;
    }
    [self setCookiesStorage];
    //构建header
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Origin"];
    [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Referer"];
    [authHeaders setObject:@"text/plain" forKey:@"Content_Type"];
    
    NSString *refreshUrl = [self getContentHostUrl:@"push"];
    if ([TempHelper stringIsNilOrEmpty:refreshUrl]) {
        NSLog(@"host string is nil");
        return;
    }
    NSString *dsidStr = [self getDsidString];
    while (1) {
//        sleep(120);
        [NSThread sleepForTimeInterval:120];
        @try {
            NSString *retStr = [IMBHttpWebResponseUtility getWithHeadersiCloudDrive:authHeaders withHost:refreshUrl withPath:[NSString stringWithFormat:@"/refreshWebAuth?dsid=%@",dsidStr]];
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"refresh web ret:%@",retStr]];
//            if (retStr != nil) {
//                NSDictionary *retDic = [TempHelper dictionaryWithJsonString:retStr];
//                if ([retDic.allKeys containsObject:@"error"]) {
//                    int errorId = [[retDic objectForKey:@"error"] intValue];
//                    if (errorId == 2) {
//                        return;
//                    }
//                }
//            }
        }
        @catch (NSException *exception) {
            [self logoutiCould];
            break;
        }
        if (_keepAliveThread == nil) {
            break;
        }
        if (!_loginInfo.loginStatus) {
            break;
        }
    }
}

//取消自动刷新；
- (void)stopKeepAliveThread {
    if (_keepAliveThread == nil) {
        return;
    }
    [_keepAliveThread cancel];
    if (_keepAliveThread != nil) {
        [_keepAliveThread release];
        _keepAliveThread = nil;
    }
}

//判断登录是否退出
- (BOOL)judgeSessionIsInvalid {
    if (!_loginInfo.loginStatus) {
        return NO;
    }
    [self setCookiesStorage];
    //构建header
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Origin"];
    [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Referer"];
    [authHeaders setObject:@"text/plain" forKey:@"Content_Type"];
    
    NSString *refreshUrl = [self getContentHostUrl:@"push"];
    if ([TempHelper stringIsNilOrEmpty:refreshUrl]) {
        NSLog(@"host string is nil");
        return NO;
    }
    NSString *dsidStr = [self getDsidString];
    NSString *retStr = [IMBHttpWebResponseUtility getWithHeadersiCloudDrive:authHeaders withHost:refreshUrl withPath:[NSString stringWithFormat:@"/refreshWebAuth?dsid=%@",dsidStr]];
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"refresh web ret:%@",retStr]];
    if (retStr != nil) {
        NSDictionary *retDic = [TempHelper dictionaryWithJsonString:retStr];
        if ([retDic.allKeys containsObject:@"error"]) {
            int errorId = [[retDic objectForKey:@"error"] intValue];
            if (errorId == 2) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 获取photos、notes、contact、calendar、remindr、iCloud Drive方法
- (NSDictionary *)getInformationContent:(NSString *)infoName withPath:(NSString *)path {
//    if (!_loginInfo.loginStatus) {
//        return nil;
//    }
    //设置cookie
    [self setCookiesStorage];
    
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Origin"];
    [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Referer"];
    [authHeaders setObject:@"text/plain" forKey:@"Content-Type"];
    NSString *hostStr = [self getContentHostUrl:infoName];
    if (hostStr == nil || [hostStr isEqualToString:@""]) {
        NSLog(@"host string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_HOST_ERROR" reason:@"host string is nil" userInfo:nil];
        return nil;
    }
    NSString *dsidStr = [self getDsidString];
    if (dsidStr == nil || [dsidStr isEqualToString:@""]) {
        NSLog(@"dsid string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_DISD_ERROR" reason:@"dsid string is nil" userInfo:nil];
        return nil;
    }
    NSString *retStr1 = [IMBHttpWebResponseUtility getWithHeaders:authHeaders withHost:[hostStr stringByReplacingOccurrencesOfString:@"https://" withString:@""] withPath:[NSString stringWithFormat:path,dsidStr] withSSL:YES];//contacts
    
    NSLog(@"retStr1:%@\n",retStr1);
    NSDictionary *retDic1 = [TempHelper dictionaryWithJsonString:retStr1];
    
    return retDic1;
}
- (NSDictionary *)getiCloudDriveUrl:(NSString *)path {
    if (!_loginInfo.loginStatus) {
        return nil;
    }
    //设置cookie
    [self setCookiesStorage];
    
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    //获得host url
    NSString *hostStr = [self getContentHostUrl:@"docws"];
    if ([TempHelper stringIsNilOrEmpty:hostStr]) {
        NSLog(@"host string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_HOST_ERROR" reason:@"host string is nil" userInfo:nil];
        return nil;
    }
    
    //请求数据  @"/ws/com.apple.CloudDocs/download/by_id?document_id=63567696-1A2E-4DF9-B5EE-2E8985D2FB50&token=AQAAAABU0bZ8GK5faobaGbn61dGvn4LrePyGUYM~(这个是"X-APPLE-WEBAUTH-VALIDATE"字段取出的值,没有token=AQAAAABU0bZ8GK5faobaGbn61dGvn4LrePyGUYM~也能获取到
    NSString *retStr = [IMBHttpWebResponseUtility getWithHeadersiCloudDrive:authHeaders withHost:hostStr withPath:path];
    NSLog(@"retStr:%@\n",retStr);
    NSDictionary *ret = [TempHelper dictionaryWithJsonString:retStr];
    return ret;
}
- (NSData *)getiCloudNoteAttachmentUrl:(NSString *)urlStr {
    if (!_loginInfo.loginStatus) {
        return nil;
    }
    if (!urlStr) {
        return nil;
    }
    //设置cookie
    [self setCookiesStorage];
    
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"${f}" withString:@"dd"];
    //获得host url
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *hostStr = [@"https://" stringByAppendingString:[url host]];
    if ([TempHelper stringIsNilOrEmpty:hostStr]) {
        NSLog(@"host string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_HOST_ERROR" reason:@"host string is nil" userInfo:nil];
        return nil;
    }
    
    NSData *retData = [IMBHttpWebResponseUtility getBytesWithHeaders:authHeaders withHost:[url host] withPath:[urlStr stringByReplacingOccurrencesOfString:hostStr withString:@""] withSSL:YES];
    return retData;
}
- (NSDictionary *)postInformationContent:(NSString *)infoName withPath:(NSString *)path withPostStr:(NSString *)postStr {
//    if (!_loginInfo.loginStatus) {
//        return nil;
//    }
    //设置cookie
    [self setCookiesStorage];
    
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    
    NSString *hostStr = [self getContentHostUrl:infoName];
    if (hostStr == nil || [hostStr isEqualToString:@""]) {
        NSLog(@"host string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_HOST_ERROR" reason:@"host string is nil" userInfo:nil];
        return nil;
    }
    NSString *dsidStr = [self getDsidString];
    if (dsidStr == nil || [dsidStr isEqualToString:@""]) {
        NSLog(@"dsid string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_DISD_ERROR" reason:@"dsid string is nil" userInfo:nil];
        return nil;
    }
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *retData = [IMBHttpWebResponseUtility postWithData:postData withHeaders:authHeaders withHost:hostStr withPath:[NSString stringWithFormat:path,dsidStr] withCookieArray:nil];
    NSString *retValStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    
    NSLog(@"retValStr:%@\n",retValStr);
    NSDictionary *retDic = [TempHelper dictionaryWithJsonString:retValStr];
    [retValStr release];
    return retDic;
}
- (id)postiCloudDriveContent:(NSString *)infoName withPath:(NSString *)path withPostStr:(NSString *)postStr {
    if (!_loginInfo.loginStatus) {
        return nil;
    }
    //设置cookie
    [self setCookiesStorage];
    
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    
    NSString *hostStr = [self getContentHostUrl:infoName];
    if (hostStr == nil || [hostStr isEqualToString:@""]) {
        NSLog(@"host string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_HOST_ERROR" reason:@"host string is nil" userInfo:nil];
        return nil;
    }
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *retData = [IMBHttpWebResponseUtility postWithData:postData withHeaders:authHeaders withHost:hostStr withPath:path withCookieArray:nil];
    NSString *retValStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    
    NSLog(@"retValStr:%@\n",retValStr);
    id retDic = [TempHelper dictionaryWithJsonString:retValStr];
    [retValStr release];
    return retDic;
}

#pragma photos
- (NSDictionary *)getiCloudPhotosAlbumInfo:(NSString *)syncToken {
    if (!_loginInfo.loginStatus) {
        return nil;
    }
    //设置cookie
    [self setCookiesStorage];
    
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    
    NSString *hostStr = [self getContentHostUrl:@"photos"];
    if (hostStr == nil || [hostStr isEqualToString:@""]) {
        NSLog(@"host string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_HOST_ERROR" reason:@"host string is nil" userInfo:nil];
        return nil;
    }
    NSString *dsidStr = [self getDsidString];
    if (dsidStr == nil || [dsidStr isEqualToString:@""]) {
        NSLog(@"dsid string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_DISD_ERROR" reason:@"dsid string is nil" userInfo:nil];
        return nil;
    }
    
    NSString *retStr = [IMBHttpWebResponseUtility getWithHeaders:authHeaders withHost:[hostStr stringByReplacingOccurrencesOfString:@"https://" withString:@""] withPath:[NSString stringWithFormat:@"/ph/folders?syncToken=%@&disd=%@",syncToken,dsidStr] withSSL:YES];
    
    NSLog(@"retStr:%@\n",retStr);
    NSDictionary *retDic = [TempHelper dictionaryWithJsonString:retStr];
    return retDic;
}
- (NSDictionary *)getiCloudPhotosImageInfo:(NSString *)syncToken withPostStr:(NSString *)postStr {
    if (!_loginInfo.loginStatus) {
        return nil;
    }
    //设置cookie
    [self setCookiesStorage];
    
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    
    NSString *hostStr = [self getContentHostUrl:@"photos"];
    if (hostStr == nil || [hostStr isEqualToString:@""]) {
        NSLog(@"host string is nil");
        @throw [NSException exceptionWithName:@"GET_HOST_ERROR" reason:@"host string is nil" userInfo:nil];
        return nil;
    }
    NSString *dsidStr = [self getDsidString];
    if (dsidStr == nil || [dsidStr isEqualToString:@""]) {
        NSLog(@"dsid string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_DISD_ERROR" reason:@"dsid string is nil" userInfo:nil];
        return nil;
    }
    NSData *retData = [IMBHttpWebResponseUtility postWithData:[postStr dataUsingEncoding:NSUTF8StringEncoding] withHeaders:authHeaders withHost:hostStr withPath:[NSString stringWithFormat:@"/ph/assets?dsid=%@",dsidStr] withCookieArray:nil];
    NSString *retValStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    id retDic = [TempHelper dictionaryWithJsonString:retValStr];
    NSLog(@"retDic:%@",retDic);
    [retValStr release];
    return retDic;
}
- (NSData *)getiCloudPhotosThumbImage:(NSString *)syncToken withServerID:(NSString *)serverId {
    if (!_loginInfo.loginStatus) {
        return nil;
    }
    //设置cookie
    [self setCookiesStorage];
    
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    
    NSString *hostStr = [self getContentHostUrl:@"photos"];
    if (hostStr == nil || [hostStr isEqualToString:@""]) {
        NSLog(@"host string is nil");
        return nil;
    }
    NSString *dsidStr = [self getDsidString];
    if (dsidStr == nil || [dsidStr isEqualToString:@""]) {
        NSLog(@"dsid string is nil");
        return nil;
    }
    
    NSData *retData = [IMBHttpWebResponseUtility getBytesWithHeaders:authHeaders withHost:hostStr withPath:[NSString stringWithFormat:@"/ph/derivative?syncToken=%@&dsid=%@&serverId=%@&boundingBox=512",syncToken,dsidStr,serverId] withSSL:YES];
    return retData;
}
- (NSData *)getiCloudPhotosOriginalImage:(NSString *)syncToken withServerID:(NSString *)serverId {
    if (!_loginInfo.loginStatus) {
        return nil;
    }
    //设置cookie
    [self setCookiesStorage];
    
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    [authHeaders setObject:@"keep-alive" forKey:@"Connection"];
    
    NSString *hostStr = [self getContentHostUrl:@"photos"];
    if (hostStr == nil || [hostStr isEqualToString:@""]) {
        NSLog(@"host string is nil");
        return nil;
    }
    NSString *dsidStr = [self getDsidString];
    if (dsidStr == nil || [dsidStr isEqualToString:@""]) {
        NSLog(@"dsid string is nil");
        return nil;
    }

    NSData *retData = [IMBHttpWebResponseUtility getBytesWithHeaders:authHeaders withHost:hostStr withPath:[NSString stringWithFormat:@"/ph/download?syncToken=%@&dsid=%@&clientId=11&serverId=%@",syncToken,dsidStr,serverId] withSSL:YES];
    
    //测试
    NSString *path = [NSString stringWithFormat:@"/Users/dingming/Desktop/iCloud研究/download/%@.jpg",serverId];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [fm createFileAtPath:path contents:nil attributes:nil];
    }
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle writeData:retData];
    
    return retData;
}
- (void)uploadImageToiCloudPhoto:(NSString *)syncToken withFileName:(NSString *)fileName withFileData:(NSData *)fileData withParentDir:(NSString *)parentDirId {
    if (!_loginInfo.loginStatus) {
        return;
    }
    //设置cookie
    [self setCookiesStorage];
    
    NSString *hostStr = [self getContentHostUrl:@"photosupload"];
    if (hostStr == nil || [hostStr isEqualToString:@""]) {
        NSLog(@"host string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_HOST_ERROR" reason:@"host string is nil" userInfo:nil];
        return;
    }
    NSString *dsidStr = [self getDsidString];
    if (dsidStr == nil || [dsidStr isEqualToString:@""]) {
        NSLog(@"dsid string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_DISD_ERROR" reason:@"dsid string is nil" userInfo:nil];
        return;
    }
    
    NSMutableData* resultData = [NSMutableData data];
    
    [resultData appendData:[[NSString stringWithFormat:@"%@\r\n",PHOTO_FENG] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *uploadPostStr = [NSString stringWithFormat:IMAGE_CONTENT,@"files",fileName,@"image/jpeg"];
    [resultData appendData:[uploadPostStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [resultData appendData:fileData];
    
    [resultData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [resultData appendData:[[NSString stringWithFormat:@"%@\r\n",PHOTO_FENG] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *str1 = [NSString stringWithFormat:PHOTO_END,@"lastModifiedDates",@"1355135752118"];
    [resultData appendData:[str1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    [resultData appendData:[[NSString stringWithFormat:@"%@\r\n",PHOTO_FENG] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *str2 = [NSString stringWithFormat:PHOTO_END,@"timezoneOffset",@"-480"];
    [resultData appendData:[str2 dataUsingEncoding:NSUTF8StringEncoding]];
    
    [resultData appendData:[[NSString stringWithFormat:@"%@--\r\n",PHOTO_FENG] dataUsingEncoding:NSUTF8StringEncoding]];

    //错误：string:{"files":[],"errors":[{"name":"3.jpg","cause":"Exif","type":"image/jpeg"}],"status":"EXIF Failure"}
    
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Origin"];
    [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Referer"];
    [authHeaders setObject:PHOTO_CONTENT_TYPE forKey:@"Content-Type"];
    [authHeaders setObject:@"*/*" forKey:@"Accept"];
    [authHeaders setObject:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.93 Safari/537.36" forKey:@"User-Agent"];
    
    NSData *retData = [IMBHttpWebResponseUtility postWithData:resultData withHeaders:authHeaders withHost:hostStr withPath:[NSString stringWithFormat:@"/ph/upload?clientBuildNumber=16GProject74&dsid=%@&syncToken=%@&folderId=%@",dsidStr,syncToken,parentDirId] withCookieArray:nil];
    NSString *retValStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    id retDic = [TempHelper dictionaryWithJsonString:retValStr];
    
//    IMBDownloadService *downloadService = [[IMBDownloadService alloc] init];
//    [downloadService uploadWithData:resultData withHeaders:authHeaders1 withHost:hostStr withPath:[NSString stringWithFormat:@"/ph/upload?clientBuildNumber=16GProject74&dsid=%@&syncToken=%@&folderId=%@",dsidStr,syncToken,parentDirId] progress:^(float pro) {
//        NSLog(@"pro:%f",pro);
//        
//    }];
}

#pragma download modle
- (void)downloadiCloudFile:(NSString *)urlStr withPath:(NSString *)path withStartBytes:(long long)startBytes {
    if (!_loginInfo.loginStatus) {
        return;
    }
    //设置cookie
    [self setCookiesStorage];
    
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *hostStr = [@"https://" stringByAppendingString:[url host]];
    
    NSString *rangeStr = [NSString stringWithFormat:@"bytes=%lld-",startBytes];
    
    if (_downloadService != nil) {
        [_downloadService release];
        _downloadService = nil;
    }
    _downloadService = [[IMBDownloadService alloc] initWithPath:path];
    [_downloadService downloadWithHeaders:authHeaders withHost:hostStr withPath:[urlStr stringByReplacingOccurrencesOfString:hostStr withString:@""] withRange:rangeStr progress:^(float pro) {
        NSLog(@"progress:%f",pro);
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:pro], @"progress", nil];
        [nc postNotificationName:@"ShowProgress" object:nil userInfo:dic];
    }];
}

#pragma update modle
- (BOOL)uploadFileToiCloud:(NSString *)urlStr withFilePath:(NSString *)filePath withInfoName:(NSString *)infoName withContentType:(NSString *)contentType  withIsPhoto:(BOOL)isPhoto {
    if (!_loginInfo.loginStatus) {
        return NO;
    }
    //设置cookie
    [self setCookiesStorage];
    
    NSString *hostStr = @"";
    NSString *path = @"";
    NSMutableData* resultData = [NSMutableData data];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    if (isPhoto) {
        hostStr = [self getContentHostUrl:infoName];
        if (hostStr == nil || [hostStr isEqualToString:@""]) {
            NSLog(@"host string is nil");
            //抛出错误
            @throw [NSException exceptionWithName:@"GET_HOST_ERROR" reason:@"host string is nil" userInfo:nil];
            return NO;
        }
        NSString *dsidStr = [self getDsidString];
        if (dsidStr == nil || [dsidStr isEqualToString:@""]) {
            NSLog(@"dsid string is nil");
            //抛出错误
            @throw [NSException exceptionWithName:@"GET_DISD_ERROR" reason:@"dsid string is nil" userInfo:nil];
            return NO;
        }
        
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        int time = zone.secondsFromGMT;
        int min = time / 60;
        long long lastDate = [DateHelper getTimeStampFrom1970Date:[NSDate date] withTimezone:zone] * 1000;
        path = [NSString stringWithFormat:urlStr,[filePath lastPathComponent],dsidStr,lastDate,-min];
    }else {
        NSURL *url = [NSURL URLWithString:urlStr];
        hostStr = [@"https://" stringByAppendingString:[url host]];
        path = [urlStr stringByReplacingOccurrencesOfString:hostStr withString:@""];
        
        [resultData appendData:[[NSString stringWithFormat:@"%@\r\n", MULTIPART] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *uploadPostStr = [NSString stringWithFormat:IMAGE_CONTENT,@"files",[filePath lastPathComponent],contentType];
        [resultData appendData:[uploadPostStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        [resultData appendData:fileData];
        
        [resultData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [resultData appendData:[[NSString stringWithFormat:@"%@--\r\n", MULTIPART] dataUsingEncoding:NSUTF8StringEncoding]];
//    //查看postdata是否正确
//    NSString *path1 = @"/Users/imobie/Desktop/ii/临时/download5.txt";
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if (![fm fileExistsAtPath:path1]) {
//        [fm createFileAtPath:path1 contents:nil attributes:nil];
//    }
//    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path1];
//    [handle writeData:resultData];
    }

    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    if (isPhoto) {
        [authHeaders setObject:@"https://www.icloud.com" forKey:@"Origin"];
        [authHeaders setObject:@"https://www.icloud.com" forKey:@"Referer"];
        [authHeaders setObject:@"*/*" forKey:@"Accept"];
        [authHeaders setObject:@"Mozilla/5.0 (Windows NT 10.0; WOW64; rv:51.0) Gecko/20100101 Firefox/51.0" forKey:@"User-Agent"];
        [authHeaders setObject:@"image/jpeg" forKey:@"Content-Type"];
        [authHeaders setObject:[NSString stringWithFormat:@"%lu",(unsigned long)fileData.length] forKey:@"Content-Length"];
        
        //构建cookie string
        NSString *cookieStr = @"";
        int i = 0;
        for (NSHTTPCookie *cookie in _loginInfo.cookieList) {
            cookieStr = [[[cookieStr stringByAppendingString:cookie.name] stringByAppendingString:@"="] stringByAppendingString:cookie.value];
            i ++;
            if (i < _loginInfo.cookieList.count) {
                cookieStr = [cookieStr stringByAppendingString:@";"];
            }
        }
        [authHeaders setObject:cookieStr forKey:@"Cookie"];
        
        if (_downloadService != nil) {
            [_downloadService release];
            _downloadService = nil;
        }
        _downloadService = [[IMBDownloadService alloc] initWithUpload];
        [_downloadService uploadWithDataFromPhoto:filePath withHeaders:authHeaders withHost:hostStr withPath:path progress:^(float pro) {
            NSLog(@"pro:%f",pro);
        }];
        [authHeaders release];
        return _downloadService.isSuccess;
    }else {
        [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Origin"];
        [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Referer"];
        [authHeaders setObject:CONTENT_TYPE forKey:@"Content-Type"];
        [authHeaders setObject:@"*/*" forKey:@"Accept"];
        [authHeaders setObject:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.93 Safari/537.36" forKey:@"User-Agent"];
        
        if (_downloadService != nil) {
            [_downloadService release];
            _downloadService = nil;
        }
        _downloadService = [[IMBDownloadService alloc] initWithUpload];
        [_downloadService uploadWithData:resultData withHeaders:authHeaders withHost:hostStr withPath:path progress:^(float pro) {
            NSLog(@"pro:%f",pro);
        }];
        [authHeaders release];
    }
    return YES;
}

- (BOOL)uploadFileToiCloud:(NSString *)urlStr withPhotoData:(NSData *)fileData withInfoName:(NSString *)infoName withFileName:(NSString *)fileName {
    if (!_loginInfo.loginStatus) {
        return NO;
    }
    //设置cookie
    [self setCookiesStorage];
    
    NSString *hostStr = @"";
    NSString *path = @"";

    hostStr = [self getContentHostUrl:infoName];
    if (hostStr == nil || [hostStr isEqualToString:@""]) {
        NSLog(@"host string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_HOST_ERROR" reason:@"host string is nil" userInfo:nil];
        return NO;
    }
    NSString *dsidStr = [self getDsidString];
    if (dsidStr == nil || [dsidStr isEqualToString:@""]) {
        NSLog(@"dsid string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_DISD_ERROR" reason:@"dsid string is nil" userInfo:nil];
        return NO;
    }
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    int time = zone.secondsFromGMT;
    int min = time / 60;
    long long lastDate = [DateHelper getTimeStampFrom1970Date:[NSDate date] withTimezone:zone] * 1000;
    path = [NSString stringWithFormat:urlStr,fileName,dsidStr,lastDate,-min];
    
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"https://www.icloud.com" forKey:@"Origin"];
    [authHeaders setObject:@"https://www.icloud.com" forKey:@"Referer"];
    [authHeaders setObject:@"*/*" forKey:@"Accept"];
    [authHeaders setObject:@"Mozilla/5.0 (Windows NT 10.0; WOW64; rv:51.0) Gecko/20100101 Firefox/51.0" forKey:@"User-Agent"];
    [authHeaders setObject:@"image/jpeg" forKey:@"Content-Type"];
    [authHeaders setObject:[NSString stringWithFormat:@"%lu",(unsigned long)fileData.length] forKey:@"Content-Length"];
    
    //构建cookie string
    NSString *cookieStr = @"";
    int i = 0;
    for (NSHTTPCookie *cookie in _loginInfo.cookieList) {
        cookieStr = [[[cookieStr stringByAppendingString:cookie.name] stringByAppendingString:@"="] stringByAppendingString:cookie.value];
        i ++;
        if (i < _loginInfo.cookieList.count) {
            cookieStr = [cookieStr stringByAppendingString:@";"];
        }
    }
    [authHeaders setObject:cookieStr forKey:@"Cookie"];

    if (_downloadService != nil) {
        [_downloadService release];
        _downloadService = nil;
    }
    _downloadService = [[IMBDownloadService alloc] initWithUpload];
    [_downloadService uploadWithData:fileData withHeaders:authHeaders withHost:hostStr withPath:path progress:^(float pro) {
        NSLog(@"pro:%f",pro);
    }];
    [authHeaders release];
    
    return YES;
}

- (NSDictionary *)updateFileAfterUpload:(NSDictionary *)retDic withRetDocumentID:(NSString *)documentID withParentDir:(NSString *)parentDirId withUploadFileName:(NSString *)fileName {
    if (!_loginInfo.loginStatus) {
        return nil;
    }
    //设置cookie
    [self setCookiesStorage];
    
    //构建header
    NSMutableDictionary *authHeaders = [self createHeader];
    NSString *hostStr = [self getContentHostUrl:@"docws"];
    if (hostStr == nil || [hostStr isEqualToString:@""]) {
        NSLog(@"host string is nil");
        //抛出错误
        @throw [NSException exceptionWithName:@"GET_DISD_ERROR" reason:@"dsid string is nil" userInfo:nil];
        return nil;
    }
    
    NSString *retValStr2 = nil;
    if (retDic != nil) {
        if ([retDic.allKeys containsObject:@"singleFile"]) {
            NSString *updatePostStr = [self structureUpdatePostData:retDic withParentDirectory:parentDirId withFileName:fileName withUploadFileId:documentID];
            NSData *updatePostData = [updatePostStr dataUsingEncoding:NSUTF8StringEncoding];
            NSData *retData2 = [IMBHttpWebResponseUtility postWithData:updatePostData withHeaders:authHeaders withHost:hostStr withPath:@"/ws/com.apple.CloudDocs/update/documents" withCookieArray:nil];
            retValStr2 = [[NSString alloc] initWithData:retData2 encoding:NSUTF8StringEncoding];
            NSLog(@"retvakstr2:%@",retValStr2);
        }
    }
    return [TempHelper dictionaryWithJsonString:retValStr2];
}

//构建上传后更新的post Data
- (NSString *)structureUpdatePostData:(NSDictionary *)retDic withParentDirectory:(NSString *)parentDirId withFileName:(NSString *)fileName withUploadFileId:(NSString *)uploadFileId {
    if (!_loginInfo.loginStatus) {
        return nil;
    }
    //设置cookie
    [self setCookiesStorage];
    
    NSString *postStr =@"";
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    if (retDic != nil) {
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
        if ([retDic.allKeys containsObject:@"singleFile"]) {
            NSDictionary *singleDic = [retDic objectForKey:@"singleFile"];
            NSArray *keyArr = singleDic.allKeys;
            if (keyArr != nil && keyArr.count > 0) {
                if ([keyArr containsObject:@"wrappingKey"]) {
                    [dataDic setValue:[singleDic objectForKey:@"wrappingKey"] forKey:@"wrapping_key"];
                }
                if ([keyArr containsObject:@"fileChecksum"]) {
                    [dataDic setValue:[singleDic objectForKey:@"fileChecksum"] forKey:@"signature"];
                }
                if ([keyArr containsObject:@"receipt"]) {
                    [dataDic setValue:[singleDic objectForKey:@"receipt"] forKey:@"receipt"];
                }
                if ([keyArr containsObject:@"referenceChecksum"]) {
                    [dataDic setValue:[singleDic objectForKey:@"referenceChecksum"] forKey:@"reference_signature"];
                }
                if ([keyArr containsObject:@"size"]) {
                    [dataDic setValue:[singleDic objectForKey:@"size"] forKey:@"size"];
                }
            }
        }
        if (dataDic != nil) {
            [postDic setValue:dataDic forKey:@"data"];
        }
        [dataDic release];
        dataDic = nil;
        
        NSMutableDictionary *pathDic = [[NSMutableDictionary alloc] init];
        if (![TempHelper stringIsNilOrEmpty:parentDirId]) {
            [pathDic setValue:parentDirId forKey:@"starting_document_id"];
        }
        if (![TempHelper stringIsNilOrEmpty:fileName]) {
            [pathDic setValue:fileName forKey:@"path"];
        }
        if (pathDic != nil) {
            [postDic setValue:pathDic forKey:@"path"];
        }
        [pathDic release];
        pathDic = nil;
        
        if (![TempHelper stringIsNilOrEmpty:uploadFileId]) {
            [postDic setValue:uploadFileId forKey:@"document_id"];
        }
        
        [postDic setValue:@"add_file" forKey:@"command"];
        [postDic setValue:[NSNumber numberWithBool:true] forKey:@"allow_conflict"];
        
        NSDictionary *flagDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:true], @"is_writable", [NSNumber numberWithBool:false], @"is_executable", [NSNumber numberWithBool:false], @"is_hidden", nil];
        [postDic setValue:flagDic forKey:@"file_flags"];
        
        //当前时间
        NSDate *localDate = [NSDate date];
        long long duration = [localDate timeIntervalSince1970];
        NSString *durationStr = [NSString stringWithFormat:@"%lld000",duration];
        long long timeDur = [durationStr longLongValue];
        [postDic setValue:[NSNumber numberWithLongLong:timeDur] forKey:@"mtime"];
    }
    
    if (postDic != nil) {
        postStr = [TempHelper dictionaryToJson:postDic];
    }
    return postStr;
}

#pragma mark - 公共方法
//判断登录是否成功
- (BOOL)isLoginSuccess {
    BOOL ret = NO;
    if (_loginInfo.loginDic != nil && _loginInfo.cookieList != nil) {
        if ([_loginInfo.loginDic.allKeys containsObject:@"dsInfo"]) {
            NSDictionary *subDic = [_loginInfo.loginDic objectForKey:@"dsInfo"];
            if ([subDic.allKeys containsObject:@"statusCode"]) {
                int statusCode = [[subDic objectForKey:@"statusCode"] intValue];
                if (statusCode == 2) {
                    ret = YES;
                }else if (statusCode == 4/*新注册的账号*/)  {
                    //提示用户是新账号需要到iCloud.com激活
                    ret = YES;
                }
            }
        }
    }
    return ret;
}
//判断note是否为高版本
- (BOOL)judgeNoteIsHigh {
    BOOL ret = NO;
    if (_loginInfo.loginDic != nil) {
        NSArray *keyArray = [_loginInfo.loginDic allKeys];
        if ([keyArray containsObject:@"appsOrder"]) {
            NSArray *array = [_loginInfo.loginDic objectForKey:@"appsOrder"];
            if (array != nil) {
                if ([array containsObject:@"notes2"]) {
                    ret = YES;
                }
            }
        }
    }
    return ret;
}
//获得取数据的网址
- (NSString *)getContentHostUrl:(NSString *)category {
    NSString *hostStr = @"";
    if (_loginInfo.loginDic != nil) {
        NSArray *keyArray = [_loginInfo.loginDic allKeys];
        if ([keyArray containsObject:@"webservices"]) {
            NSDictionary *webDic = [_loginInfo.loginDic objectForKey:@"webservices"];
            if ([[webDic allKeys] containsObject:category]) {
                NSDictionary *contentDic = [webDic objectForKey:category];
                if ([[contentDic allKeys] containsObject:@"url"]) {
                    hostStr = [contentDic objectForKey:@"url"];
                }
            }
        }
    }
    return hostStr;
}
//获得dsid的值
- (NSString *)getDsidString {
    NSString *dsidStr = @"";
    if (_loginInfo.loginDic != nil) {
        if ([[_loginInfo.loginDic allKeys] containsObject:@"dsInfo"]) {
            NSDictionary *dsinfoDic = [_loginInfo.loginDic objectForKey:@"dsInfo"];
            if ([[dsinfoDic allKeys] containsObject:@"dsid"]) {
                dsidStr = [dsinfoDic objectForKey:@"dsid"];
            }
        }
    }
    return dsidStr;
}
//构建header
- (NSMutableDictionary *)createHeader {
    NSMutableDictionary *authHeaders = [[[NSMutableDictionary alloc] init] autorelease];
    [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Origin"];
    [authHeaders setObject:ICLOUD_HOME_URL forKey:@"Referer"];
    [authHeaders setObject:@"*/*" forKey:@"Accept"];
    [authHeaders setObject:@"text/plain" forKey:@"Content-Type"];
    [authHeaders setObject:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.93 Safari/537.36" forKey:@"User-Agent"];
    
    //构建cookie string
    NSString *cookieStr = @"";
    int i = 0;
    for (NSHTTPCookie *cookie in _loginInfo.cookieList) {
        cookieStr = [[[cookieStr stringByAppendingString:cookie.name] stringByAppendingString:@"="] stringByAppendingString:cookie.value];
        i ++;
        if (i < _loginInfo.cookieList.count) {
            cookieStr = [cookieStr stringByAppendingString:@";"];
        }
    }
    [authHeaders setObject:cookieStr forKey:@"Cookie"];
    
    return authHeaders;
}
//加密成base64
- (NSString*)encode:(NSString *)part {
    return [IMBHttpWebResponseUtility encode:part];
}
//解密base64的字符串
- (NSString*)decode:(NSString*)base64str {
    return [IMBHttpWebResponseUtility decode:base64str];
}

//- (void)recevieDoubleVerificationPSD:(NSNotification *)noti {
//    NSDictionary *dic = noti.userInfo;
//    int result = [[dic objectForKey:@"result"] intValue];
//    
//    if (result == 0) {
//        _result = 0;
//    }else {
//        _result = 1;
//    }
//    _endRunloop = YES;
//}

@end
