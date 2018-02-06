//
//  IMBHelper.h
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
@interface IMBHelper : NSObject
+ (id)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
+(NSString*)getAppSupportPath;
//+(BOOL)isInternetAvail;
+ (NSString *)getHashByWebservice:(NSURL*)url nameSpace:(NSString*)nameSpace methodName:(NSString*)methodName sha1:(NSString *)sha1 sha2:(NSString *)sha2 ;
+ (NSURL *)getHashWebserviceUrl ;
+ (NSString *)getHashWebserviceNameSpace;
+(NSDate*)getDateTimeFromTimeStamp1970:(long)timeStamp;
+ (NSString*) resourcePathOfAppDir:(NSString*)resourceName ofType:type;
+ (BOOL)stringIsNilOrEmpty:(NSString*)string;
+(NSString*)getAppRootPath;
+(NSString*)getAppTempPath;
+(NSString*)getSerialNumberPath:(NSString *)serialNumber;
+(NSString*)getBackupPath;
+(NSString*)getSaveFileIconPath;
//如果file已经存在，则生成别名
+(NSString*)getFilePathAlias:(NSString*)filePath;
//计算text的size
+ (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize;
+(NSString*)getTimeAutoShowHourString:(long)totalLength;
+ (NSString *)longToDateString:(long)timeStamp withMode:(int)mode;
+ (NSString *)longToHourDateString:(long)timeStamp;
//检测删除数据是否需要加马赛克
+ (NSString *)isaddMosaicTextStr:(NSString *)text;
+ (NSString *)longToDateStringFrom1904:(long)timeStamp withMode:(int)mode;
+ (NSString *)longToDateStringFrom1970:(long)timeStamp withMode:(int)mode;
+ (NSDate *)dateFromString2001;

//创建图片
+ (NSData *)createThumbnail:(NSImage *)sourceImage withWidth:(int)scalWidth withHeight:(int)scalHeight;
//等比缩放图片
+ (NSData *) suchAsScalingImage:(NSImage *)image width:(int)scalWidth height:(int)scalHeight;
//创建头像图片
+ (NSData *)createHeadThumbnail:(NSImage *)sourceImage withWidth:(int)scalWidth withHeight:(int)scalHeight;
+ (NSImage *)cutImageWithImage:(NSImage *)image border:(int)border;
+ (NSImage *)iconForFile:(NSString *)filePath maxSize:(int)size;
+ (NSImage *)scaleCutImageForSize:(NSImage *)image width:(int)cutWidth height:(int)cutHeight type:(NSString *)cutType;
+(NSString*)getFileSizeString:(long long)totalSize reserved:(int)decimalPoints;
// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString;
+ (NSString *)stringCorrectFormat:(NSString *)fileName;
//替换号码中除去数字与+的其他字符
+ (NSString *)stringReplaceNumber:(NSString *)numberString;
//callhistoty 时间屏蔽
+ (NSString *)isaddCallHistoryDateMosaicTextStr:(NSString *)text;
//判断时间戳长度
+ (NSUInteger)getDateLength:(long long)date;

+ (void)compareOSXVersion:(NSTextField *)textfield;
//+(NSString *)switchChooseViewControolerType:(ChooseViewType) chooseType;
+ (BOOL)checkFileIsPicture:(NSString *)fileName;
+ (BOOL)checkFileIsTxtFile:(NSString *)fileName;
+ (BOOL)checkFileIsVideo:(NSString *)fileName;
+ (BOOL)checkFileIsaAudio:(NSString *)fileName;
+ (BOOL)checkFileIsBook:(NSString *)fileName;
+ (NSString *)isConverTextStr:(NSString *)text;
+ (NSString *)softInfoName;
+ (BOOL)checkInternetAvailble;
+ (NSString *)getBackupServerSupportPath;
+ (NSString *)getBackupServerSupportConfigPath;
+ (IPodFamilyEnum)family:(NSString *)productType;
@end

