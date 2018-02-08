//
//  IMBHelper.m
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBHelper.h"
#import "IMBSoftwareInfo.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "RegexKitLite.h"
#import "NSString+Category.h"

@implementation IMBHelper

+ (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if (string == nil || [string isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

+ (id)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err != nil) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSString *jsonStr = nil;
    if (dic != nil) {
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
            jsonStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
            NSLog(@"jsonStr:%@",jsonStr);
        }
    }
    return jsonStr;
}

+ (NSString *)getBackupServerSupportPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *homeDocumentsPath = [[[manager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path];
    NSString *appTempPath = [[homeDocumentsPath stringByAppendingPathComponent:@"com.iMobie.AirBackupHelper"] stringByAppendingPathComponent:@"AirBackupHelper"];
    if (![manager fileExistsAtPath:appTempPath]) {
        [manager createDirectoryAtPath:appTempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return appTempPath;
}

+ (NSString *)getBackupServerSupportConfigPath {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [[self getBackupServerSupportPath] stringByAppendingPathComponent:@"Config"];
    if (![fm fileExistsAtPath:path]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+(NSString*)getAppSupportPath{
    NSString *appTempPath;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *identifier = [bundle bundleIdentifier];
    NSString *appName = [[bundle infoDictionary] objectForKey:@"CFBundleName"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *homeDocumentsPath = [[[manager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path];
    appTempPath =[[homeDocumentsPath stringByAppendingPathComponent:identifier] stringByAppendingPathComponent:appName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:appTempPath]) {
        [fileManager createDirectoryAtPath:appTempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return appTempPath;
}

+(BOOL)isInternetAvail {
    return [self checkSiteAvail:CustomLocalizedString(@"google.com", nil)];
}
+(BOOL)checkSiteAvail:(NSString*)urlStr {
    const char *hostName = [urlStr cStringUsingEncoding:NSASCIIStringEncoding];
    SCNetworkReachabilityRef target;
    SCNetworkConnectionFlags flags = 0;
    target = SCNetworkReachabilityCreateWithName(NULL, hostName);
    SCNetworkReachabilityGetFlags(target, &flags);
    NSLog(@"flag %d", flags);
    CFRelease(target);
    return (flags == kSCNetworkFlagsReachable) || (flags == (kSCNetworkFlagsReachable | kSCNetworkFlagsTransientConnection)) ;
}

+ (BOOL)checkInternetAvailble {
    BOOL isFromServer = NO;
    [self getDateTimeFromService:&isFromServer];
    return isFromServer;
}

+ (NSDate*)getDateTimeFromService:(BOOL*)isFromServer {
    NSString *retvalue = [self pingDomain:@"http://imobie.us.179.gppnetwork.com/"];
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    if (retvalue) {
        soft.domainNetwork = @"http://imobie.us.179.gppnetwork.com/";
    }else{
        retvalue = [self pingDomain:@"http://imobie-001-site1.mywindowshosting.com/"];
        if (retvalue) {
            soft.domainNetwork = @"http://imobie-001-site1.mywindowshosting.com/";
        }else
        {
            retvalue = [self pingDomain:@"http://cal.imobie.us/"];
            if (retvalue) {
                soft.domainNetwork = @"http://cal.imobie.us/";
            }else{
                retvalue = [self pingDomain:@"http://imobie.us/"];
                if (retvalue) {
                    soft.domainNetwork = @"http://imobie.us/";
                }else{
                    retvalue = [self pingDomain:@"http://143.95.78.61/"];
                    if (retvalue) {
                        soft.domainNetwork = @"http://143.95.78.61/";
                    }
                }
            }
        }
    }
    NSDate *localDatetime = nil;
    if (retvalue != nil && ![retvalue isEqualToString:@""]) {
        *isFromServer = YES;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
        NSDate *greenwishTime = [dateFormatter dateFromString:retvalue];
        [dateFormatter release];
        dateFormatter = nil;
        localDatetime = [self greenwishTime2LocalTime:greenwishTime];
    } else {
        *isFromServer = NO;
    }
    return localDatetime;
}

+ (NSString *)pingDomain:(NSString *)networkDomain
{
    NSString *netPath = [networkDomain stringByAppendingString:@"USERREGWEBS.asmx"];
    NSURL *url = [NSURL URLWithString:netPath];
    NSString *nameSpace = @"http://tempuri.org/";
    WSMethodInvocationRef mySoapRef = WSMethodInvocationCreate((CFURLRef)url, (CFStringRef)@"GetServerDateTime", kWSSOAP2001Protocol);
    
    NSDictionary *reqHeaders = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@%@", nameSpace, @"GetServerDateTime"] forKey:@"SOAPAction"];
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
    //    [result objectForKey:(id)kWSHTTPResponseMessage];
    NSDictionary *resultDir = [result objectForKey:@"/Result"];
    NSArray *keyArr = resultDir.allKeys;
    NSString *retvalue = nil;
    for (NSString *key in keyArr) {
        retvalue = [resultDir valueForKey:key];
    }
    return retvalue;
    
}

+ (NSDate*)greenwishTime2LocalTime:(NSDate*)greenwishTime {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [greenwishTime dateByAddingTimeInterval:interval];
    return localeDate;
}

+ (NSString *)getHashByWebservice:(NSURL*)url nameSpace:(NSString*)nameSpace methodName:(NSString*)methodName sha1:(NSString *)sha1 sha2:(NSString *)sha2 {
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

+ (NSURL *)getHashWebserviceUrl {
    //NSURL *url = [NSURL URLWithString:@"http://dl.imobie.com/verifyonline/webservice/wsdlsoap/service.php?wsdl"];
    //NSURL *url = [NSURL URLWithString:@"http://192.168.0.122:8080/webservice/wsdlsoap/service.php?wsdl"];
    //    NSURL *url = [NSURL URLWithString:@"http://192.168.0.109:8080/verifyonline/webservice/wsdlsoap/service.php?wsdl"];
    //NSURL *url = [NSURL URLWithString:@"http://dl.imobie.com:80/verifyonline/php/validationservice.php"];
    NSURL *url = [NSURL URLWithString:@"http://67.225.249.166:80/verifyonline/php/validationservice.php"];
    
    return url;
}

+ (NSString *)getHashWebserviceNameSpace {
    NSString *nameSpace = @"urn:imobie_validation";
    return nameSpace;
}

+(NSDate*)getDateTimeFromTimeStamp1970:(long)timeStamp{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *originDate = nil;

    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
    originDate = [dateFormatter dateFromString:@"01/01/1970 00:00:00"];
    NSDate *returnDate = [NSDate dateWithTimeInterval:timeStamp sinceDate:originDate];
    [dateFormatter release];
    return returnDate;
}

+ (NSString*) resourcePathOfAppDir:(NSString*)resourceName ofType:type {
    NSString *appDirectory = [self getAppSupportPath];
    
    NSString *resourcePath = [[appDirectory stringByAppendingPathComponent:resourceName] stringByAppendingPathExtension:type];
    
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    if (![sharedFM fileExistsAtPath:resourcePath]) {
        NSString *bundelPath = [[NSBundle mainBundle] pathForResource:resourceName ofType:type];
        [sharedFM copyItemAtPath:bundelPath toPath:resourcePath error:nil];
    }
    
    return resourcePath;
}

+(NSString*)getAppRootPath {
    NSString *rootPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"Root"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:rootPath]) {
        [fileManager createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return rootPath;
}

+(NSString*)getAppTempPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"tmp"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}
+(NSString*)getSerialNumberPath:(NSString *)serialNumber {
    NSString *tmpPath = [[self getBackupPath] stringByAppendingPathComponent:serialNumber];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}
+(NSString*)getBackupPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"Backup"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}
+(NSString*)getSaveFileIconPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"SaveFileIcon"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

//如果file已经存在，则生成别名
+(NSString*)getFilePathAlias:(NSString*)filePath {
    NSString *newPath = filePath;
    NSFileManager *fm = [NSFileManager defaultManager];
    int i = 1;
    NSString *filePathWithOutExt = [filePath stringByDeletingPathExtension];
    NSString *fileExtension = [filePath pathExtension];
    while ([fm fileExistsAtPath:newPath]) {
        newPath = [NSString stringWithFormat:@"%@(%d).%@",filePathWithOutExt,i++,fileExtension];
    }
    return newPath;
}


//计算text的size
+ (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize {
    NSRect textBounds = NSMakeRect(0, 0, 0, 0);
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [paragraphStyle setAlignment:NSCenterTextAlignment];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSFont fontWithName:@"Helvetica Neue" size:fontSize], NSFontAttributeName,
                                    paragraphStyle, NSParagraphStyleAttributeName,
                                    nil];
        NSSize textSize = [as.string sizeWithAttributes:attributes];
        textBounds = NSMakeRect(0, 0, textSize.width, textSize.height);
        [as release];
    }
    return textBounds;
}

//+(NSString *)switchChooseViewControolerType:(ChooseViewType) chooseType{
//    switch (chooseType) {
//        case 0:
//            return @"disConntectViewController";
//            break;
//        case 1:
//            return @"ChooseFileViewController";
//            break;
//        case 2:
//            return @"AnalysingViewController";
//            break;
//        case 3:
//            return @"ScanDeviceViewController";
//            break;
//        case 4:
//            return @"RootPromptViewController";
//            break;
//        case 5:
//            return @"RootingViewController";
//            break;
//        case 6:
//            return @"RootFailViewController";
//            break;
//        case 7:
//            return @"TransferViewController";
//            break;
//        default:
//            return @"";
//            break;
//    }
//}

+(NSString*)getTimeAutoShowHourString:(long)totalLength {
    if (totalLength < 1000) {
        return @"--";
    }
    int hours = (int)(totalLength / 3600000 );
    int remain = totalLength % 3600000;
    int minutes = (int)(remain / 60000);
    int seconds = (remain % 60000) / 1000;
    NSString *timeStr = @"";
    if (hours > 0) {
        timeStr = [NSString stringWithFormat:@"%02d:%02d:%02d", hours,minutes, seconds] ;
    } else {
        timeStr = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds] ;
    }
    
    
    return timeStr;
}

+ (NSString *)longToDateString:(long)timeStamp withMode:(int)mode {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    if (mode == 0 || mode == 1 || mode == 6) {
        [dateFormatter setDateFormat:[IMBSoftWareInfo singleton].systemDateFormatter];
    } else if (mode == 2) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
    } else if (mode == 3) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm a",[IMBSoftWareInfo singleton].systemDateFormatter]];
    }else if (mode == 4) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"EEEE %@",[IMBSoftWareInfo singleton].systemDateFormatter]];
    }else if (mode == 7){
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ ",[IMBSoftWareInfo singleton].systemDateFormatter]];
    }
    NSDate *date = [self getDateTimeFromTimeStamp2001:(uint)timeStamp];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

+(NSDate*)getDateTimeFromTimeStamp2001:(long)timeStamp{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    NSDate *originDate = nil;
    if ([[IMBSoftWareInfo singleton].systemDateFormatter isEqualToString:@"MM/dd/yyyy"]) {
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        originDate = [dateFormatter dateFromString:@"01/01/2001 00:00:00"];
        if(originDate == nil || originDate == NULL) {
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
            originDate = [dateFormatter dateFromString:@"01/01/2001 00:00:00"];
        }
        
    }else {
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        originDate = [dateFormatter dateFromString:@"2001/01/01 00:00:00"];
        if(originDate == nil || originDate == NULL) {
            [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
            originDate = [dateFormatter dateFromString:@"2001/01/01 00:00:00"];
        }
    }
    NSDate *returnDate = [NSDate dateWithTimeInterval:(uint)timeStamp sinceDate:originDate];
    [dateFormatter release];
    return returnDate;
}

+ (NSString *)longToHourDateString:(long)timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
    NSDate *date = [self getDateTimeFromTimeStamp2001:(uint)timeStamp];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

+ (NSString *)isaddMosaicTextStr:(NSString *)text{
    if (text != nil) {
        int length = (int)text.length;//[self convertToInt:text];
        if (length > 4) {
            NSString *frontText = [text substringWithRange:NSMakeRange(0, 4)];
            NSInteger endLength = length - 4;
            for (int i = 0;i <endLength ; i++) {
                frontText = [frontText stringByAppendingString:@"●"];
            }
            return frontText;
        }else{
            return text;
        }
    }
    return nil;
}

+ (NSString *)isConverTextStr:(NSString *)text{
    if (text != nil) {
        int length = (int)text.length;//[self convertToInt:text];
        if (length > 16) {
            NSString *frontText = [self isaddMosaicTextStr:[text substringWithRange:NSMakeRange(0, 16)]];
            return frontText;
        }else{
            NSString *frontText = [self isaddMosaicTextStr:text];
            return frontText;
        }
    }
    return nil;
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

+ (NSString *)longToDateStringFrom1904:(long)timeStamp withMode:(int)mode {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    if (mode == 0 || mode == 1 || mode == 6) {
        [dateFormatter setDateFormat:[IMBSoftWareInfo singleton].systemDateFormatter];
    } else if (mode == 2) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss a",[IMBSoftWareInfo singleton].systemDateFormatter]];
    } else if (mode == 3) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm a",[IMBSoftWareInfo singleton].systemDateFormatter]];
    } else if (mode == 4){
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
    }else if (mode == 7){
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ ",[IMBSoftWareInfo singleton].systemDateFormatter]];
    }
    NSDate *date = [self getDateTimeFromTimeStamp1904:(uint)timeStamp timeOffset:0];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
    
}

+(NSDate*)getDateTimeFromTimeStamp1904:(long long)times timeOffset:(int64_t)offset {
    NSDate *returnDate = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
    NSDate *originDate;
    if (times != 3130000000) {
        if ([[IMBSoftWareInfo singleton].systemDateFormatter isEqualToString:@"MM/dd/yyyy"]) {
            originDate = [dateFormatter dateFromString:@"01/01/1904 00:00:00"];
        }else {
            originDate = [dateFormatter dateFromString:@"1904/01/01 00:00:00"];
        }
        returnDate = [NSDate dateWithTimeInterval:(double)(times + offset) sinceDate:originDate];
    }else{
        if ([[IMBSoftWareInfo singleton].systemDateFormatter isEqualToString:@"MM/dd/yyyy"]) {
            originDate = [dateFormatter dateFromString:@"01/01/1904 00:00:00"];
        }else {
            originDate = [dateFormatter dateFromString:@"1904/01/01 00:00:00"];
        }
        returnDate = [NSDate dateWithTimeInterval:0 sinceDate:originDate];
    }
    [dateFormatter release];
    return returnDate;
}

+ (NSDate *)dateFromString2001 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    NSDate *date = nil;
    if ([[IMBSoftWareInfo singleton].systemDateFormatter isEqualToString:@"MM/dd/yyyy"]) {
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        date = [dateFormatter dateFromString:@"01/01/2001 00:00:00"];
        if(date == nil || date == NULL) {
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
            date = [dateFormatter dateFromString:@"01/01/2001 00:00:00"];
        }
    }else {
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        date = [dateFormatter dateFromString:@"2001/01/01 00:00:00"];
        if(date == nil || date == NULL) {
            [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
            date = [dateFormatter dateFromString:@"2001/01/01 00:00:00"];
        }
    }
    //    NSLog(@"%@", date);
    [dateFormatter release];
    return date;
}

+ (NSString *)longToDateStringFrom1970:(long)timeStamp withMode:(int)mode {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (mode == 0 || mode == 1) {
        [dateFormatter setDateFormat:[IMBSoftWareInfo singleton].systemDateFormatter];
    } else if (mode == 2) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss a",[IMBSoftWareInfo singleton].systemDateFormatter]];
    } else if (mode == 3) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm a",[IMBSoftWareInfo singleton].systemDateFormatter]];
    } else if (mode == 4){
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
    }else if (mode == 5){
        if ([[IMBSoftWareInfo singleton].systemDateFormatter isEqualToString:@"MM/dd/yyyy"]) {
            [dateFormatter setDateFormat:@"MMddyyyyHHmmss"];
        }else {
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        }
        
    }else if (mode == 6){
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"HH:mm:ss"]];
    }else if (mode == 7){
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ ",[IMBSoftWareInfo singleton].systemDateFormatter]];
    }else if (mode == 8){
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        //        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm",[IMBSoftwareInfo singleton].systemDateFormatter]];
    }
    NSDate *date = [self getDateTimeFromTimeStamp1970:(uint)timeStamp timeOffset:0];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

+(NSDate*)getDateTimeFromTimeStamp1970:(long)times timeOffset:(int64_t)offset {
    NSDate *returnDate = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *originDate;
    if (times != 3130000000) {
        originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
        if (originDate == nil || originDate == NULL) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
             originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
        }
        returnDate = [NSDate dateWithTimeInterval:(double)(times + offset) sinceDate:originDate];
    }else{
        originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
        if (originDate == nil || originDate == NULL) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
        }
        returnDate = [NSDate dateWithTimeInterval:0 sinceDate:originDate];
    }
    [dateFormatter release];
    return returnDate;
}

//创建图片
+ (NSData *)createThumbnail:(NSImage *)sourceImage withWidth:(int)scalWidth withHeight:(int)scalHeight {
    NSImage *cropImage = nil;
    NSData *scalingImageData = nil;
    if (sourceImage != nil) {
        if (sourceImage.size.width > sourceImage.size.height && sourceImage.size.height > 0) {
            int h = sourceImage.size.height;
            if (h > 200) {//创建缩略图的宽度不大于200；
                h = 200;
            }
            //按高裁剪
            cropImage = [self cutImageForSize:sourceImage width:h height:h type:@"H"];
        }else if (sourceImage.size.height >= sourceImage.size.width && sourceImage.size.width > 0){
            int w = sourceImage.size.width;
            if (w > 200) {//创建缩略图的宽度不大于200；
                w = 200;
            }
            //按宽裁剪
            cropImage = [self cutImageForSize:sourceImage width:w height:w type:@"W"];
        }
    }
    if (cropImage != nil) {
        //等比例压缩图片
        scalingImageData = [self suchAsScalingImage:cropImage width:scalWidth height:scalHeight];
    }
    
    return scalingImageData;
}

//裁剪图片
+ (NSImage *) cutImageForSize:(NSImage *)image width:(int)cutWidth height:(int)cutHeight type:(NSString *)cutType{
    int toWidth = cutWidth;
    int toHeight = cutHeight;
    int x,y,ow,oh = 0;
    if ([cutType isEqualToString: @"H"]) {
        x = (image.size.width - toHeight) / 2;
        y = (image.size.height - toHeight) / 2;
        //        ow = image.size.height;
        //        oh = image.size.height * toHeight / toWidth;
        ow = toWidth;
        oh = toHeight;
    }else{
        x = (image.size.width - toWidth) / 2;
        y = (image.size.height - toWidth) / 2;
        //        ow = image.size.width;
        //        oh = image.size.width * toHeight / toWidth;
        ow = toWidth;
        oh = toHeight;
        
    }
    NSImage *targetImage = [[[NSImage alloc] initWithSize:NSMakeSize(ow, oh)] autorelease];
    [targetImage lockFocus];
    NSRectFill(NSMakeRect(0, 0, ow, oh));
    [image drawInRect:NSMakeRect(0, 0, toWidth, toHeight) fromRect:NSMakeRect(x, y, ow, oh) operation:NSCompositeSourceOver fraction:1.0];
    [targetImage unlockFocus];
    
    return targetImage;
}

//裁剪图片(此处是先将图片缩放到剪切的最小尺寸，再裁剪)
+ (NSImage *)scaleCutImageForSize:(NSImage *)image width:(int)cutWidth height:(int)cutHeight type:(NSString *)cutType{
    float scalWidth = 0;
    float scalHeight = 0;
    if (image.size.width / cutWidth > image.size.height / cutHeight) {//
        scalWidth = image.size.width * 1.0 / (image.size.height / cutHeight);
        scalHeight = cutHeight;
    }else {
        scalWidth = cutWidth;
        scalHeight = image.size.height * 1.0 / (image.size.width / cutWidth);
    }
  
    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(scalWidth, scalHeight)];
    [scalingimage lockFocus];
    NSRectFill(NSMakeRect(0, 0, scalWidth, scalHeight));
    [[NSGraphicsContext currentContext]setImageInterpolation:NSImageInterpolationHigh];
    [image drawInRect:NSMakeRect(0, 0, scalWidth, scalHeight) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    NSData *tempdata = nil;
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, scalWidth, scalHeight)];
    tempdata = [bitmap representationUsingType:NSPNGFileType properties:nil];
    [bitmap release];
    [scalingimage unlockFocus];
    [scalingimage release];
    
    NSImage *newImage = [[NSImage alloc] initWithData:tempdata];
    
    int toWidth = cutWidth;
    int toHeight = cutHeight;
    int x,y,ow,oh = 0;
    if ([cutType isEqualToString: @"H"]) {
        x = (newImage.size.width - toHeight) / 2;
        y = (newImage.size.height - toHeight) / 2;
        //        ow = image.size.height;
        //        oh = image.size.height * toHeight / toWidth;
        ow = toWidth;
        oh = toHeight;
    }else{
        x = (newImage.size.width - toWidth) / 2;
        y = (newImage.size.height - toWidth) / 2;
        //        ow = image.size.width;
        //        oh = image.size.width * toHeight / toWidth;
        ow = toWidth;
        oh = toHeight;
        
    }
    NSImage *targetImage = [[[NSImage alloc] initWithSize:NSMakeSize(ow, oh)] autorelease];
    [targetImage lockFocus];
    NSRectFill(NSMakeRect(0, 0, ow, oh));
    [newImage drawInRect:NSMakeRect(0, 0, toWidth, toHeight) fromRect:NSMakeRect(x, y, ow, oh) operation:NSCompositeSourceOver fraction:1.0];
    [targetImage unlockFocus];
    [newImage autorelease];
    return targetImage;
}

//创建头像图片
+ (NSData *)createHeadThumbnail:(NSImage *)sourceImage withWidth:(int)scalWidth withHeight:(int)scalHeight {
    NSImage *cropImage = nil;
    NSData *scalingImageData = nil;
    if (sourceImage != nil) {
        if (sourceImage.size.width > sourceImage.size.height && sourceImage.size.height > 0) {
            int h = sourceImage.size.height;
            if (h > 800) {//创建缩略图的宽度不大于200；
                h = 800;
            }
            //按高裁剪
            cropImage = [self cutImageForSize:sourceImage width:h height:h type:@"H"];
        }else if (sourceImage.size.height >= sourceImage.size.width && sourceImage.size.width > 0){
            int w = sourceImage.size.width;
            if (w > 800) {//创建缩略图的宽度不大于200；
                w = 800;
            }
            //按宽裁剪
            cropImage = [self cutImageForSize:sourceImage width:w height:w type:@"W"];
        }
    }
    if (cropImage != nil) {
        //等比例压缩图片
        scalingImageData = [self suchAsScalingImage:cropImage width:scalWidth height:scalHeight];
    }
    
    return scalingImageData;
}

+ (NSImage *)iconForFile:(NSString *)filePath maxSize:(int)size {
    NSImage *nImage = nil;
    
    @autoreleasepool {
        NSImage *image = [[NSWorkspace sharedWorkspace] iconForFile:filePath];
        NSData *data = [image TIFFRepresentationUsingCompression:NSTIFFCompressionOldJPEG factor:0.2];
        NSArray *imageReps = [NSBitmapImageRep imageRepsWithData:data];
        if (imageReps.count > 0) {
            NSBitmapImageRep *bitRep = nil;
            for (NSBitmapImageRep *nbitRep in imageReps) {
                if (nbitRep.size.width <= size && nbitRep.size.height <= size) {
                    bitRep = nbitRep;
                    break;
                }
            }
            if (bitRep == nil && imageReps.count != 0) {
                bitRep = [imageReps objectAtIndex:0];
                [bitRep setSize:NSMakeSize(size, size)];
            }
            if (bitRep != nil) {
                NSData *tifData = [bitRep TIFFRepresentation];
                nImage = [[NSImage alloc] initWithData:tifData];
            }
        }
        
    }
    return nImage == nil ? nil : [nImage autorelease];
}

//裁剪成圆形图片
+ (NSImage *)cutImageWithImage:(NSImage *)image border:(int)border{
    
    NSImage *targetImage = [[[NSImage alloc] initWithSize:NSMakeSize(image.size.width, image.size.height)] autorelease];
    [targetImage lockFocus];

    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    //设置头像frame
    CGFloat iconX = 0;//border / 2;
    CGFloat iconY = 0;//border / 2;
    CGFloat iconW = image.size.width;
    CGFloat iconH = image.size.height;
    
    //绘制圆形头像范围
    CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
    
    //剪切可视范围
    CGContextClip(context);
    
    [image drawInRect:NSMakeRect(iconX, iconY, iconW, iconH) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];

    [targetImage unlockFocus];
    
    return targetImage;
}

//等比例压缩图片
+ (NSData *) suchAsScalingImage:(NSImage *)image width:(int)scalWidth height:(int)scalHeight{
    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(scalWidth, scalHeight)];
    [scalingimage lockFocus];
    NSRectFill(NSMakeRect(0, 0, scalWidth, scalHeight));
    [[NSGraphicsContext currentContext]setImageInterpolation:NSImageInterpolationHigh];
    [image drawInRect:NSMakeRect(0, 0, scalWidth, scalHeight) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    NSData *tempdata = nil;
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, scalWidth, scalHeight)];
    tempdata = [bitmap representationUsingType:NSPNGFileType properties:nil];
    [bitmap release];
    [scalingimage unlockFocus];
    [scalingimage release];
    
    return tempdata;
}

+(NSString*)getFileSizeString:(long long)totalSize reserved:(int)decimalPoints {
    double mbSize = (double)totalSize / 1048576;
    double kbSize = (double)totalSize / 1024;
    if (totalSize < 1024) {
        return [NSString stringWithFormat:@"%.0f%@", (double)totalSize,CustomLocalizedString(@"MSG_Size_B", nil)];
    } else {
        if (mbSize > 1024) {
            double gbSize = (double)totalSize / 1073741824;
            return [self Rounding:gbSize reserved:1 capacityUnit:CustomLocalizedString(@"MSG_Size_GB", nil)];
        } else if (kbSize > 1024) {
            return [self Rounding:mbSize reserved:decimalPoints capacityUnit:CustomLocalizedString(@"MSG_Size_MB", nil)];
        } else {
            return [self Rounding:kbSize reserved:decimalPoints capacityUnit:CustomLocalizedString(@"MSG_Size_KB", nil)];
        }
    }
}

+(NSString*)Rounding:(double)numberSize reserved:(int)decimalPoints capacityUnit:(NSString*)unit {
    switch (decimalPoints) {
        case 1:
            return [NSString stringWithFormat:@"%.1f %@", numberSize, unit];
            break;
            
        case 2:
            return [NSString stringWithFormat:@"%.2f %@", numberSize, unit];
            break;
            
        case 3:
            return [NSString stringWithFormat:@"%.3f %@", numberSize, unit];
            break;
            
        case 4:
            return [NSString stringWithFormat:@"%.4f %@", numberSize, unit];
            break;
            
        default:
            return [NSString stringWithFormat:@"%.2f %@", numberSize, unit];
            break;
    }
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString {
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        @autoreleasepool {
            if (i + 2 > hexString.length) {
                break;
            }
            unsigned int anInt;
            NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
            NSScanner * scanner = [NSScanner scannerWithString:hexCharStr];
            [scanner scanHexInt:&anInt];
            myBuffer[i / 2] = (char)anInt;
        }
    }
    
    //替换非法字符
    NSData *data = [NSData dataWithBytes:myBuffer length:strlen(myBuffer)];
    NSData *tarData = [self replaceNoUtf8:data];

    bzero(myBuffer, [hexString length] / 2 + 1);
    [tarData getBytes:myBuffer length:tarData.length];
    
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:NSUTF8StringEncoding];//[NSString stringWithUTF8String:[tarData bytes]];
    NSLog(@"------字符串=======%@",unicodeString);
    
    free(myBuffer);
    if (unicodeString == nil || [unicodeString isEqualToString:@"\n"] || [unicodeString isEqualToString:@"\r"] || [unicodeString isEqualToString:@"\t"] || [unicodeString isEqualToString:@"\r\n"] || [unicodeString isEqualToString:@" "]) {
        unicodeString = @"";
    }
    return unicodeString;
}

//替换非法字符
+ (NSData *)replaceNoUtf8:(NSData *)data
{
    char aa[] = {' ',' ',' ',' ',' ',' '};                      //utf8最多6个字符，当前方法未使用byte[]
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0) //判断第一个字节110
        {
            /*loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             if((buffer & 0xC0) == 0x80) //判断第二个字节10
             {
             loc++;
             continue;
             }
             loc--;*/
            int count = 1;
            BOOL success = [self replaceSingleNOUft8:md withIndex:loc withCount:count];
            if (success) {
                loc += (count + 1);
                continue;
            }
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0) //判断的第一个字节 1110
        {
            /*loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             if((buffer & 0xC0) == 0x80) //判断的第二个字节 10
             {
             loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             if((buffer & 0xC0) == 0x80) //判断的第三个字节 10
             {
             loc++;
             continue;
             }
             loc--;
             }
             loc--;*/
            int count = 2;
            BOOL success = [self replaceSingleNOUft8:md withIndex:loc withCount:count];
            if (success) {
                loc += (count + 1);
                continue;
            }
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }else if((buffer & 0xF8) == 0xF0) {
            /*loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             
             
             
             
             if((buffer & 0xC0) == 0x80) //判断的第二个字节 10
             {
             loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             if((buffer & 0xC0) == 0x80) //判断的第三个字节 10
             {
             loc++;
             if (loc >= [md length]) {
             break;
             }
             [md getBytes:&buffer range:NSMakeRange(loc, 1)];
             if((buffer & 0xC0) == 0x80) //判断的第四个字节 10
             {
             loc++;
             continue;
             }
             continue;
             }
             loc--;
             }
             loc--;*/
            int count = 3;
            BOOL success = [self replaceSingleNOUft8:md withIndex:loc withCount:count];
            if (success) {
                loc += (count + 1);
                continue;
            }
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }else if((buffer & 0xFC) == 0xF8) {
            int count = 4;
            BOOL success = [self replaceSingleNOUft8:md withIndex:loc withCount:count];
            if (success) {
                loc += (count + 1);
                continue;
            }
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }else if((buffer & 0xFE) == 0xFC) {
            int count = 5;
            BOOL success = [self replaceSingleNOUft8:md withIndex:loc withCount:count];
            if (success) {
                loc += (count + 1);
                continue;
            }
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}

+(BOOL)replaceSingleNOUft8:(NSMutableData *)md withIndex:(int)curIndex withCount:(int)count {
    char buffer;
    for (int i=0; i<count; i++) {
        int nextIndex = curIndex + i + 1;
        if (nextIndex >= [md length]) {
            return NO;
        }
        [md getBytes:&buffer range:NSMakeRange(nextIndex, 1)];
        if((buffer & 0xC0) != 0x80) //判断字节是否是 10 开头
        {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)stringCorrectFormat:(NSString *)fileName {
    if ([IMBHelper stringIsNilOrEmpty:fileName])
    {
        return @"";
    }
    NSString *illegalPathString = [fileName stringByReplacingOccurrencesOfRegex:@"[\\\\\\?\\/\\*\\|<>:\\\"\a\b\f\n\r\t\v\0 ]" withString:@""];//Regex.Replace(fileName, @"[\\\\\\?\\/\\*\\|<>:\\\"\"\a\b\f\n\r\t\v\0 ]", "");
    //    if ([IMBHelper stringIsNilOrEmpty:illegalPathString]) {
    //        NSLog(@"is kong");
    //    }else {
    //        NSLog(@"isnot kong");
    //        NSString *string = [NSString stringWithString:illegalPathString];
    //        for (int i = 0; i < string.length; i++) {
    //            char pathChar = [string characterAtIndex:i];
    //            int charInt = (int)pathChar;
    //            if (charInt == 65533 || charInt == 127 || charInt == 124 || charInt == 5 || charInt == 32)
    //            {
    //                illegalPathString = [illegalPathString stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@""];
    //            }
    //        }
    //    }
    //     StringBuilder builder = new StringBuilder();
    //     try
    //     {
    //         char[] invalidChars = Path.GetInvalidFileNameChars();
    //         for (int i = 0; i < illegalPathString.Length; i++)
    //         {
    //             char pathChar = illegalPathString[i];
    //             int charInt = (int)pathChar;
    //             if (charInt == 65533 || charInt == 127 || charInt == 124 || charInt == 5)
    //             {
    //                 continue;
    //             }
    //             bool isAppend = true;
    //             foreach (var item in invalidChars)
    //             {
    //                 if (item == pathChar)
    //                 {
    //                     isAppend = false;
    //                     break;
    //                 }
    //             }
    //             if (isAppend)
    //             {
    //                 builder.Append(illegalPathString[i]);
    //             }
    //         }
    //     }
    //     catch (Exception ex)
    //     {
    //         SysLog.LogMessager.WriteInfo(String.Format("StackTrace:{0}---Message:{1}", ex.StackTrace, ex.Message));
    //     }
    //     string resultString = builder.ToString();
    //     if (!string.IsNullOrEmpty(resultString))
    //     {
    //         resultString = resultString.Replace("AUX", "");
    //         resultString = resultString.Replace("AUx", "");
    //         resultString = resultString.Replace("AuX", "");
    //         resultString = resultString.Replace("aUX", "");
    //         resultString = resultString.Replace("aUx", "");
    //         resultString = resultString.Replace("aux", "");
    //         resultString = resultString.Replace(",", "");
    //         resultString = resultString.Replace("$", "");
    //         resultString = resultString.Replace("&", "");
    //         resultString = resultString.Replace("{", "");
    //         resultString = resultString.Replace("}", "");
    //         resultString = resultString.Replace("(", "");
    //         resultString = resultString.Replace(")", "");
    //         resultString = resultString.Replace("#", "");
    //     }
    return illegalPathString;
}

//替换号码中除去数字与+的其他字符
+ (NSString *)stringReplaceNumber:(NSString *)numberString {
    if ([IMBHelper stringIsNilOrEmpty:numberString]) {
        return @"";
    }
    NSString *illegalPathString = [numberString stringByReplacingOccurrencesOfRegex:@"[^\\d+]*" withString:@""];
    return illegalPathString;
}

+ (NSString *)isaddCallHistoryDateMosaicTextStr:(NSString *)text{
    int length = [self convertToInt:text];
    if (length > 0) {
        NSString *frontText = @"";
        for (int i = 0;i <length ; i++) {
            frontText = [frontText stringByAppendingString:@"●"];
        }
        return frontText;
    }
    return nil;
    
}

+ (BOOL)checkFileIsPicture:(NSString *)fileName {
    BOOL checkResult = false;
    if (fileName != nil) {
        NSString *extensionName = [fileName pathExtension];
        extensionName = [extensionName lowercaseString];
        if ([extensionName isEqualToString:@"png"] || [extensionName isEqualToString:@"jpg"] || [extensionName isEqualToString:@"gif"] || [extensionName isEqualToString:@"bmp"] || [extensionName isEqualToString:@"tiff"]|| [extensionName isEqualToString:@"pcx"]|| [extensionName isEqualToString:@"tga"]|| [extensionName isEqualToString:@"exif"]|| [extensionName isEqualToString:@"fpx"]|| [extensionName isEqualToString:@"svg"]|| [extensionName isEqualToString:@"psd"]|| [extensionName isEqualToString:@"cdr"] || [extensionName isEqualToString:@"pcd"] || [extensionName isEqualToString:@"dxf"] || [extensionName isEqualToString:@"ufo"] || [extensionName isEqualToString:@"eps"] || [extensionName isEqualToString:@"raw"] || [extensionName isEqualToString:@"ai"]) {
            checkResult = true;
        }
    }
    return checkResult;
}

//判断时间戳长度
+ (NSUInteger)getDateLength:(long long)date {
    NSUInteger length = 10;
    NSString *dateStr = [NSString stringWithFormat:@"%lld",date];
    length = dateStr.length;
    return length;
}

+ (BOOL)checkFileIsTxtFile:(NSString *)fileName {
    BOOL checkResult = false;
    if (fileName != nil) {
        NSString *extensionName = [fileName pathExtension];
        extensionName = [extensionName lowercaseString];
        if ([extensionName isEqualToString:@"txt"] || [extensionName isEqualToString:@"plist"] || [extensionName isEqualToString:@"pdf"] || [extensionName isEqualToString:@"rtf"] || [extensionName isEqualToString:@"html"] || [extensionName isEqualToString:@"doc"]) {
            checkResult = true;
        }
    }
    return checkResult;
}

+ (BOOL)checkFileIsVideo:(NSString *)fileName {
    BOOL checkResult = false;
    if (fileName != nil) {
        NSString *ext = [[fileName pathExtension] lowercaseString];
        if ([ext isEqualToString:@"rm"] || [ext isEqualToString:@"mp4"] || [ext isEqualToString:@"m4v"] ||
            [ext isEqualToString:@"wmv"] || [ext isEqualToString:@"rmvb"] || [ext isEqualToString:@"mkv"] || [ext isEqualToString:@"avi"] || [ext isEqualToString:@"flv"] || [ext isEqualToString:@"m4r"]) {
            checkResult = true;
        }
    }
    return checkResult;
}

+ (BOOL)checkFileIsaAudio:(NSString *)fileName {
    BOOL checkResult = false;
    if (fileName != nil) {
        NSString *ext = [[fileName pathExtension] lowercaseString];
        if ([ext isEqualToString:@"mp3"] || [ext isEqualToString:@"m4a"] || [ext isEqualToString:@"wma"] ||
            [ext isEqualToString:@"wav"] || [ext isEqualToString:@"m4r"] || [ext isEqualToString:@"amr"] || [ext isEqualToString:@"m4b"]) {
            checkResult = true;
        }
    }
    return checkResult;
}

+ (BOOL)checkFileIsBook:(NSString *)fileName {
    BOOL checkResult = false;
    if (fileName != nil) {
        NSString *ext = [[fileName pathExtension] lowercaseString];
        if ([ext isEqualToString:@"pdf"] || [ext isEqualToString:@"epub"]) {
            checkResult = true;
        }
    }
    return checkResult;
}

+ (void)compareOSXVersion:(NSTextField *)textfield {
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *systemVersion = processInfo.operatingSystemVersionString;
    NSArray *array = [systemVersion componentsSeparatedByString:@" "];
    NSString *str = nil;
    if (array.count > 1) {
        str = [array objectAtIndex:1];
    }
    if (![IMBHelper stringIsNilOrEmpty:str]) {
        if ([str isVersionLessEqual:@"10.9"]) {
            [textfield setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:30]];
        }else{
            [textfield setFont:[NSFont fontWithName:@"Helvetica Neue Thin" size:30]];
        }
    }else {
        [textfield setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:30]];
    }
}

+ (NSString *)softInfoName {
    NSString *retStr = @"";
#if Android_Samsung
    retStr = [NSString stringWithFormat:CustomLocalizedString(@"Home_Guide_Title", nil),@"SAMSUNG"];
#elif Android_LG
    retStr = [NSString stringWithFormat:CustomLocalizedString(@"Home_Guide_Title", nil),@"LG"];
#elif Android_HTC
    retStr = [NSString stringWithFormat:CustomLocalizedString(@"Home_Guide_Title", nil),@"HTC"];
#elif Android_Huawei
    retStr = [NSString stringWithFormat:CustomLocalizedString(@"Home_Guide_Title", nil),@"HUAWEI"];
#elif Android_Sony
    retStr = [NSString stringWithFormat:CustomLocalizedString(@"Home_Guide_Title", nil),@"SONY"];
#elif Android_Motorola
    retStr = [NSString stringWithFormat:CustomLocalizedString(@"Home_Guide_Title", nil),@"Motorola"];
#elif Android_Google
    retStr = [NSString stringWithFormat:CustomLocalizedString(@"Home_Guide_Title", nil),@"Google"];
#else
    retStr = [NSString stringWithFormat:CustomLocalizedString(@"Home_Guide_Title", nil),@"SAMSUNG"];
#endif
    return retStr;
}

+ (IPodFamilyEnum)family:(NSString *)productType {
    IPodFamilyEnum family = iPod_Unknown;
    if ([productType isEqualToString:@"iPod1,1"]) {
        family = iPod_Touch_1;
    } else if ([productType isEqualToString:@"iPod2,1"]) {
        family = iPod_Touch_2;
    } else if ([productType isEqualToString:@"iPod3,1"]) {
        family = iPod_Touch_3;
    } else if ([productType isEqualToString:@"iPod4,1"]) {
        family = iPod_Touch_4;
    } else if ([productType isEqualToString:@"iPod5,1"]) {
        family = iPod_Touch_5;
    } else if ([productType isEqualToString:@"iPod7,1"]) {
        family = iPod_Touch_6;
    } else if ([productType isEqualToString:@"iPhone1,1"]) {
        family = iPhone;
    } else if ([productType isEqualToString:@"iPhone1,2"]) {
        family = iPhone_3G;
    } else if ([productType isEqualToString:@"iPhone2,1"]) {
        family = iPhone_3GS;
    } else if ([productType isEqualToString:@"iPhone3,1"] ||
               [productType isEqualToString:@"iPhone3,2"] ||
               [productType isEqualToString:@"iPhone3,3"]) {
        family = iPhone_4;
    } else if ([productType isEqualToString:@"iPhone4,1"]) {
        family = iPhone_4S;
    } else if ([productType isEqualToString:@"iPhone5,1"] ||
               [productType isEqualToString:@"iPhone5,2"]) {
        family = iPhone_5;
    } else if ([productType isEqualToString:@"iPhone5,3"] ||
               [productType isEqualToString:@"iPhone5,4"]) {
        family = iPhone_5C;
    } else if ([productType isEqualToString:@"iPhone6,1"] ||
               [productType isEqualToString:@"iPhone6,2"]) {
        family = iPhone_5S;
    } else if ([productType isEqualToString:@"iPhone7,2"]) {
        family = iPhone_6;
    } else if ([productType isEqualToString:@"iPhone7,1"]) {
        family = iPhone_6_Plus;
    } else if ([productType isEqualToString:@"iPhone8,1"]) {
        family = iPhone_6S;
    } else if ([productType isEqualToString:@"iPhone8,2"]) {
        family = iPhone_6S_Plus;
    } else if ([productType isEqualToString:@"iPhone8,4"]) {
        family = iPhone_SE;
    }else if ([productType isEqualToString:@"iPhone9,1"] ||
              [productType isEqualToString:@"iPhone9,3"]) {
        family = iPhone_7;
    }else if ([productType isEqualToString:@"iPhone9,2"] ||
              [productType isEqualToString:@"iPhone9,4"]) {
        family = iPhone_7_Plus;
    }else if ([productType isEqualToString:@"iPad1,1"]) {
        family = iPad_1;
    }else if ([productType isEqualToString:@"iPhone10,4"] ||
              [productType isEqualToString:@"iPhone10,1"]) {
        family = iPhone_8;
    }else if ([productType isEqualToString:@"iPhone10,2"] ||
              [productType isEqualToString:@"iPhone10,5"]) {
        family = iPhone_8_Plus;
    }else if ([productType isEqualToString:@"iPhone10,3"] ||
              [productType isEqualToString:@"iPhone10,6"]) {
        family = iPhone_X;
    } else if ([productType isEqualToString:@"iPad2,1"] ||
               [productType isEqualToString:@"iPad2,2"] ||
               [productType isEqualToString:@"iPad2,3"] ||
               [productType isEqualToString:@"iPad2,4"]) {
        family = iPad_2;
    } else if ([productType isEqualToString:@"iPad3,1"] ||
               [productType isEqualToString:@"iPad3,2"] ||
               [productType isEqualToString:@"iPad3,3"]) {
        family = The_New_iPad;
    } else if ([productType isEqualToString:@"iPad3,4"]) {
        family = iPad_4;
    } else if ([productType isEqualToString:@"iPad4,1"] ||
               [productType isEqualToString:@"iPad4,2"] ||
               [productType isEqualToString:@"iPad4,3"]) {
        family = iPad_Air;
    } else if ([productType isEqualToString:@"iPad5,3"] ||
               [productType isEqualToString:@"iPad5,4"]) {
        family = iPad_Air2;
    } else if ([productType isEqualToString:@"iPad6,3"] ||
               [productType isEqualToString:@"iPad6,4"]||
               [productType isEqualToString:@"iPad6,7"]||
               [productType isEqualToString:@"iPad6,8"]) {
        family = iPad_Pro;
    }else if ([productType isEqualToString:@"iPad2,5"] ||
              [productType isEqualToString:@"iPad2,6"] ||
              [productType isEqualToString:@"iPad2,7"]) {
        family = iPad_mini;
    } else if ([productType isEqualToString:@"iPad4,4"] ||
               [productType isEqualToString:@"iPad4,5"]) {
        family = iPad_mini_2;
    } else if ([productType isEqualToString:@"iPad4,7"] ||
               [productType isEqualToString:@"iPad4,8"] ||
               [productType isEqualToString:@"iPad4,9"]) {
        family = iPad_mini_3;
    } else if ([productType isEqualToString:@"iPad5,1"] ||
               [productType isEqualToString:@"iPad5,2"]) {
        family = iPad_mini_4;
    }else if ([productType isEqualToString:@"iPad7,1"] ||
              [productType isEqualToString:@"iPad7,2"] ||
              [productType isEqualToString:@"iPad7,3"] ||
              [productType isEqualToString:@"iPad7,4"]) {
        family = iPad_Pro;
    }else if ([productType isEqualToString:@"iPad6,11"] ||
              [productType isEqualToString:@"iPad6,12"]) {
        family = iPad_5;
    }
    return family;
}

@end

