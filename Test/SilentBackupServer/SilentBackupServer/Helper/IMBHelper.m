//
//  IMBHelper.m
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBHelper.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "NSString+Category.h"
#import <sys/sysctl.h>
#import <sys/stat.h>

@implementation IMBHelper

+ (KeyStateStruct *)verifyProductLicense:(NSString *)license {
    KeyStateStruct *ks=nil;
    ks = [IMBVerifyActivate verify:license id1:'A' id2:'T'];
    return ks;
}

+ (BOOL)timeLitme:(long long)time backupDay:(int)backupDay {
    BOOL ret = NO;
    long long intervalTime = backupDay * 86400;
    long long curTime = [[NSDate date] timeIntervalSince1970];
    if (curTime >= time + intervalTime) {
        ret = YES;
    }
    return ret;
}

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

+ (NSString *)getAnyTransSupportPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *homeDocumentsPath = [[[manager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path];
    NSString *appTempPath = [[homeDocumentsPath stringByAppendingPathComponent:@"com.iMobie.AnyTrans"] stringByAppendingPathComponent:@"AnyTrans"];
    if (![manager fileExistsAtPath:appTempPath]) {
        [manager createDirectoryAtPath:appTempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return appTempPath;
}

+ (NSString *)getAnyTransConfigPath:(NSString *)component {
    NSString *configPath = [[self getAnyTransSupportPath] stringByAppendingPathComponent:component];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:configPath]) {
        [fileManager createDirectoryAtPath:configPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return configPath;
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
    return [self checkSiteAvail:@"google.com"];
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
//    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
//    if (retvalue) {
//        soft.domainNetwork = @"http://imobie.us.179.gppnetwork.com/";
//    }else{
//        retvalue = [self pingDomain:@"http://imobie-001-site1.mywindowshosting.com/"];
//        if (retvalue) {
//            soft.domainNetwork = @"http://imobie-001-site1.mywindowshosting.com/";
//        }else
//        {
//            retvalue = [self pingDomain:@"http://cal.imobie.us/"];
//            if (retvalue) {
//                soft.domainNetwork = @"http://cal.imobie.us/";
//            }else{
//                retvalue = [self pingDomain:@"http://imobie.us/"];
//                if (retvalue) {
//                    soft.domainNetwork = @"http://imobie.us/";
//                }else{
//                    retvalue = [self pingDomain:@"http://143.95.78.61/"];
//                    if (retvalue) {
//                        soft.domainNetwork = @"http://143.95.78.61/";
//                    }
//                }
//            }
//        }
//    }
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

+ (NSString *)pingDomain:(NSString *)networkDomain {
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

    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
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

+(NSString*)getAppConfigPath {
    NSString *rootPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"Config"];
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

//备份文件路径
+ (NSString *)getBackupFolderPath {
    NSString *libraryPath = [self getLibraryPath];
    NSString *backupFolderPath = [NSString stringWithFormat:@"%@/Application Support/MobileSync/Backup",libraryPath];
    return backupFolderPath;
}

+ (NSString *)getLibraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = nil;
    if ([paths count]>0) {
        libraryPath = [paths objectAtIndex:0];
    }
    return libraryPath;
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

+ (BOOL)killProcessByProcessName:(NSString *)name {
    BOOL ret = NO;
    NSArray *allProc = [self runningProcessesWithProcessName:name];
    if (allProc != nil && allProc.count > 0) {
        ret = YES;
        for (NSDictionary *dic in allProc) {
            NSArray *allKey = dic.allKeys;
            if (allKey != nil && allKey.count > 0) {
                if ([allKey containsObject:@"ProcessID"]) {
                    int pid = [[dic objectForKey:@"ProcessID"] intValue];
                    if (pid > 0) {
                        kill(pid, SIGKILL);
                    }
                }
            }
        }
    }
    return ret;
}

+ (NSArray *)runningProcessesWithProcessName:(NSString *)pname {
    NSString *filterKey = nil;
    if (![self stringIsNilOrEmpty:pname]) {
        if ([pname length] > 16) {
            filterKey = [pname substringToIndex:16];
        } else {
            filterKey = pname;
        }
    }
    
    //指定名字参数,按照顺序第一个元素指定本请求定向到内核的哪个子系统,第二个及其后元素依次细化指定该系统的某个部分.
    //CTL_KERN，KERN_PROC,KERN_PROC_ALL 正在运行的所有进程
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL ,0};
    
    u_int miblen = 4;
    //值结果参数:函数被调用时,size指向的值指定该缓冲区的大小;函数返回时,该值给出内核存放在该缓冲区中的数据量;如果这个缓冲不够大,函数就返回ENOMEM错误.
    size_t size;
    // 返回0，成功；返回-1，失败
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    do
    {
        size += size / 10;
        newprocess = realloc(process, size);
        if (!newprocess)
        {
            if (process)
            {
                free(process);
                process = NULL;
            }
            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0)
    {
        if (size % sizeof(struct kinfo_proc) == 0)
        {
            unsigned long nprocess = size / sizeof(struct kinfo_proc);
            if (nprocess)
            {
                NSMutableArray * array = [[NSMutableArray alloc] init];
                for (int i = (int)nprocess - 1; i >= 0; i--)
                {
                    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    NSString * proc_CPU = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_estcpu];
                    double t = [[NSDate date] timeIntervalSince1970] - process[i].kp_proc.p_un.__p_starttime.tv_sec;
                    NSString * proc_useTiem = [[NSString alloc] initWithFormat:@"%f",t];
                    
                    BOOL needAdd = NO;
                    if (![self stringIsNilOrEmpty:filterKey]) {
                        if ([processName rangeOfString:filterKey].length > 0) {
                            needAdd = YES;
                        }
                    } else {
                        needAdd = YES;
                    }
                    
                    if (needAdd) {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        [dic setValue:processID forKey:@"ProcessID"];
                        [dic setValue:processName forKey:@"ProcessName"];
                        [dic setValue:proc_CPU forKey:@"ProcessCPU"];
                        [dic setValue:proc_useTiem forKey:@"ProcessUseTime"];
                        [array addObject:dic];
                        [dic release];
                    }
                    [processID release];
                    [processName release];
                    [proc_CPU release];
                    [proc_useTiem release];
                    
                    [pool release];
                }
                
                free(process);
                process = NULL;
                return array;
            }
        }
    }
    return nil;
}

+ (int64_t)getFolderSize:(NSString *)backupFolderPath {
    int64_t folderSize = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:backupFolderPath]) {
        [self recursionFolder:backupFolderPath folderSize:&folderSize];
    }
    return folderSize;
}

+ (void)recursionFolder:(NSString *)folderPath folderSize:(int64_t *)folderSize {
    NSArray *tempArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                *folderSize += [self fileSizeAtPath:fullPath];
            }
            else {
                [self recursionFolder:fullPath folderSize:folderSize];
            }
        }
    }
}

+ (long long)fileSizeAtPath:(NSString*)filePath {
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
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

+ (BOOL)appIsRunningWithBundleIdentifier:(NSString*)bundleIdentifier {
    BOOL appIsRunning = NO;
    if (bundleIdentifier.length == 0 || bundleIdentifier == NULL) {
        return appIsRunning;
    }
    @autoreleasepool {
        NSArray *arr = [[NSWorkspace sharedWorkspace] runningApplications];
        for (NSRunningApplication *app in arr) {
            if ([[app bundleIdentifier] isEqualToString:bundleIdentifier]) {
                appIsRunning = YES;
                break;
            }
        }
    }
    return appIsRunning;
}

+ (NSString *)cutOffString:(NSString *)string {
    NSString *retString = string;
    if (string && string.length > 15) {
        retString = [string substringToIndex:15];
        retString = [retString stringByAppendingString:@"..."];
    }
    return retString;
}

@end

