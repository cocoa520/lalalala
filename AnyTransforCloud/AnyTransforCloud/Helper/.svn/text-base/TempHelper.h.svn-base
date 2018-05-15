//
//  TempHelper.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
#import "BaseDrive.h"
#import "IMBCloudEntity.h"
@interface TempHelper : NSObject

+ (NSString*)getAppSupportPath;
+ (NSString*)getAppTempPath;
+ (NSString*)getAppDownloadDefaultPath;
+ (NSString*)getAppDownloadCachePath;
+ (NSString*)getAppIpswPath;
+ (NSString*)getAppSkinPath;
+ (NSString*)getAppiMobieConfigPath;
+ (NSString*)resourcePathOfAppDir:(NSString*)resourceName ofType:type;
+ (NSString*)getSystemLastNumberString;
+ (NSString*)getPhotoSqliteConfigPath:(NSString *)path;
/**
 *  获取图片
 *  @param FileTypeEnum
 *  @return NSImage
 */
+ (NSImage *)loadFileImage:(FileTypeEnum )type;
/**
 *  获取传输图片
 *  @param FileTypeEnum
 *  @return NSImage
 */
+ (NSImage *)loadFileTransferImage:(FileTypeEnum )type;

/**
 *  获取文件类型
 *  @param extension 后缀
 *  @return FileTypeEnum
 */
+ (FileTypeEnum)getFileFormatWithExtension:(NSString *)extension;
/**
 *  设置云盘的默认图标
 *
 *  @param drive       对应云盘
 *  @param cloudEntity 绑定实体
 */
+ (void)setDriveDefultImage:(BaseDrive *)drive CloudEntity:(IMBCloudEntity *)cloudEntity;
/**
 *  获取组合后的名字
 *
 *  @param type      云盘类型
 *  @param driveName 云盘账户名字
 *
 *  @return 返回组合后的名字
 */
+ (NSString *)getCloudName:(NSString *)type DriveName:(NSString *)driveName;

/**
 *  获取显示云的图标
 *
 *  @param type 云盘类型
 *
 *  @return 返回云显示图片
 */
+ (NSImage *)getCloudImage:(NSString *)type;

/**
 *  先剪切在压缩
 *
 *  @param sourceImage      要缩放的图片
 *  @param scalWidth  宽
 *  @param scalHeight 高
 *
 *  @return NSData
 */
+ (NSData *)createHeadThumbnail:(NSImage *)sourceImage withWidth:(int)scalWidth withHeight:(int)scalHeight;

/**
 *  //如果file已经存在，则生成别名
 *
 *  @param filePath
 *
 *  @return
 */
+(NSString*)getFilePathAlias:(NSString*)filePath withary:(NSMutableArray *)ary WithIsFolder:(BOOL)isFolder;

/**
 *  判断名字是否存在数组中
 *
 *  @param ary      数据源数组
 *  @param fileName 文件名
 *  @param index    从第几个开始比较
 *
 *  @return YES，存在；
 */
+ (BOOL)filePathExists:(NSArray *)ary FileName:(NSString *)fileName Index:(int)index WithIsFolder:(BOOL)isFolder;

/**
 *  获取授权云的图标
 *
 *  @param cloudEnum 云类型
 *
 *  @return 授权云图标
 */
+ (NSImage *)getAuthorizateCloudImage:(CategoryCloudNameEnum)cloudEnum;

/**
 *  等比例缩放图片
 *
 *  @param image  要缩放的图片
 *  @param lenght 缩放的大小
 *
 *  @return NSData
 */
+ (NSData *)scalingImage:(NSImage *)image withLenght:(int)lenght;
@end
