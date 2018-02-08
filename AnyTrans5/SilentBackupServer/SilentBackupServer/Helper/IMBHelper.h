//
//  IMBHelper.h
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBVerifyActivate.h"
//#import "IMBCommonEnum.h"
@interface IMBHelper : NSObject
+ (BOOL)timeLitme:(long long)time backupDay:(int)backupDay;
+ (KeyStateStruct *)verifyProductLicense:(NSString *)license;
+ (id)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
+(NSString*)getAppSupportPath;
+ (NSString *)getAnyTransSupportPath;
+ (NSString *)getAnyTransConfigPath:(NSString *)component;
//备份文件路径
+ (NSString *)getBackupFolderPath;
+(BOOL)isInternetAvail;
+ (NSString *)getHashByWebservice:(NSURL*)url nameSpace:(NSString*)nameSpace methodName:(NSString*)methodName sha1:(NSString *)sha1 sha2:(NSString *)sha2 ;
+ (NSURL *)getHashWebserviceUrl ;
+ (NSString *)getHashWebserviceNameSpace;
+(NSDate*)getDateTimeFromTimeStamp1970:(long)timeStamp;
+ (NSString*) resourcePathOfAppDir:(NSString*)resourceName ofType:type;
+ (BOOL)stringIsNilOrEmpty:(NSString*)string;
+(NSString*)getAppConfigPath;
+(NSString*)getAppTempPath;
+(NSString*)getSerialNumberPath:(NSString *)serialNumber;
+(NSString*)getBackupPath;
+(NSString*)getSaveFileIconPath;
//如果file已经存在，则生成别名
+(NSString*)getFilePathAlias:(NSString*)filePath;
+(NSString*)getTimeAutoShowHourString:(long)totalLength;

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString;
+ (NSString *)stringCorrectFormat:(NSString *)fileName;
//替换号码中除去数字与+的其他字符
+ (NSString *)stringReplaceNumber:(NSString *)numberString;
//callhistoty 时间屏蔽
+ (NSString *)isaddCallHistoryDateMosaicTextStr:(NSString *)text;
//判断时间戳长度
+ (NSUInteger)getDateLength:(long long)date;

+ (BOOL)checkFileIsPicture:(NSString *)fileName;
+ (BOOL)checkFileIsTxtFile:(NSString *)fileName;
+ (BOOL)checkFileIsVideo:(NSString *)fileName;
+ (BOOL)checkFileIsaAudio:(NSString *)fileName;
+ (BOOL)checkFileIsBook:(NSString *)fileName;
+ (NSString *)isConverTextStr:(NSString *)text;
+ (BOOL)checkInternetAvailble;

+ (BOOL)killProcessByProcessName:(NSString *)name;
+ (int64_t)getFolderSize:(NSString *)backupFolderPath;
+ (NSString*)getFileSizeString:(long long)totalSize reserved:(int)decimalPoints;
+ (BOOL)appIsRunningWithBundleIdentifier:(NSString*)bundleIdentifier;
+ (NSString *)cutOffString:(NSString *)string;
@end

