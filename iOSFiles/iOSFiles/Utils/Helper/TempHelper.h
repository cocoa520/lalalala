//
//  TempHelper.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempHelper : NSObject

+(NSString*)getAppSupportPath;
+(NSString*)getAppTempPath;
+(NSString*)getAppDownloadDefaultPath;
+(NSString*)getAppDownloadCachePath;
+(NSString*)getAppIpswPath;
+(NSString*)getAppSkinPath;
+(NSString*)getAppiMobieConfigPath ;
+ (NSString *)getBackupFolderPath;
+(NSString *)currentSelectionLanguage;
//自定义维度，用于事件跟踪
+ (NSMutableDictionary *)customDimension;
+ (void)customViewType:(ChooseLoginModelEnum)loginEnum withCategoryEnum:(CategoryNodesEnum)categoryEnum;
+ (NSMutableDictionary*)getPlistFileDir:(NSString*)Path;
+ (BOOL)stringIsNilOrEmpty:(NSString*)string;
+ (NSString *)getSoftwareBackupFolderPath:(NSString *)name withUuid:(NSString *)uuid;
//图片压缩
+ (NSData *)scalingImage:(NSImage *)image withLenght:(int)lenght;
//创建图片
+ (NSData *)createThumbnail:(NSImage *)sourceImage withWidth:(int)scalWidth withHeight:(int)scalHeight;
//裁剪图片(此处是先将图片缩放到剪切的最小尺寸，再裁剪)
+ (NSData *)scaleCutImage:(NSImage *)image width:(int)cutWidth height:(int)cutHeight type:(NSString *)cutType;
+ (int)getDeviceVersionNumber:(NSString *)version ;
//如果file已经存在，则生成别名
+(NSString*)getFilePathAlias:(NSString*)filePath;
+ (NSString*)getRandomFileName:(int)length;
+ (NSString *)getAppCachePathInPath:(NSString *)path;
+ (NSData *)createHeadThumbnail:(NSImage *)sourceImage withWidth:(int)scalWidth withHeight:(int)scalHeight;
+ (NSImage *) cutImageForSize:(NSImage *)image width:(int)cutWidth height:(int)cutHeight x:(int)x y:(int)y;
+ (NSImage *)cutImageWithImage:(NSImage *)image border:(int)border;
//计算text的size
+ (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize;
+ (NSURL *)getHashWebserviceUrl;
+ (NSString *)getHashWebserviceNameSpace;
+ (BOOL)unTarFile:(NSString*)filePath unTarPath:(NSString*)unTarPath toDestFolder:toDestFolder;
+ (BOOL)checkInternetAvailble ;
+ (NSString*)getiCloudLocalPath;
//获取当前任务所占用的内存(单位:MB)
+ (double)usedMemory;
+ (NSString*) resourcePathOfAppDir:(NSString*)resourceName ofType:type;
+ (NSString*)replaceSpecialChar:(NSString*)validateString;
+ (id)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
//创建导出路径
+ (NSString *)createCategoryPath:(NSString *)path withString:(NSString *)category;
+ (NSString *)createExportPath:(NSString *)path;
+ (NSString *)getFolderPathAlias:(NSString *)folderPath;
+(BOOL)isInternetAvail;
+ (NSString *)getLibraryPath;
+ (NSDate*)greenwishTime2LocalTime:(NSDate*)greenwishTime;
+ (NSString *)getCurrentTimeStamp;
+ (NSString *)pingDomain:(NSString *)networkDomain;
+ (NSString *)checkiCloudInternetAvailble;
+(BOOL)connectedToNetwork;
+ (BOOL)runApp:(NSString*)appName;
+ (void)exoprtPdfWithPath:(NSString *)path withcontrol:(id)control withmakeSizew:(int )width withhigh:(int )high;
+ (NSMutableAttributedString *)setSingleTextAttributedString:(NSString *)string withFont:(NSFont *)font withColor:(NSColor *)color;
+ (BOOL)isDirectory:(NSString *)filePath;
+ (NSImage *)loadFileImage:(NSString *)extension;
+ (NSImage *)loadTransferFileImage:(NSString *)extension;
@end
