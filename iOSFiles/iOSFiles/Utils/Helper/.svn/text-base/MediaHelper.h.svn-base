//
//  MediaHelper.h
//  AnyTrans
//
//  Created by iMobie on 7/22/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "IMBCommonEnum.h"
@class IMBNewTrack;
@class IMBTrack;
#define IsStringNilOrEmpty(A) (A) ==nil || (A.length) == 0

@interface MediaHelper : NSObject

+ (BOOL)stringIsNilOrEmpty:(NSString*)string;
+ (NSString*)getDirectory:(NSString*)filePath;
+ (NSString*)getFileTypeDescription:(NSString*)extension;
+(NSString*)getiPodPathToStandardPath:(NSString*)path;
+(NSString*)getStandardPathToiPodPath:(NSString*)path;
+ (NSData*)intToITunesSDFormat:(int)value;

+(BOOL)isInternetAvail;
+ (NSURL *)getHashWebserviceUri;
+ (NSString *)getHashWebserviceNameSpace;
+ (void)getHashByWebservice:(NSURL*)url nameSpace:(NSString*)nameSpace methodName:(NSString*)methodName sha1:(NSString*)sha1 uuid:(NSString*)uuid signature:(uint8_t[])signature isSuccess:(BOOL *)isSuccess;

+ (NSDictionary *)copyRemoteMediaLibrayFromRemote:(NSDictionary *)remote ToLocal:(NSDictionary *)local WithIpod:(IMBiPod *)ipod;

+ (NSComparisonResult)compareVersion:(NSString *)oldVersion newVersion:(NSString *)newVersion;
+ (NSString*)getSupportFile:(CategoryNodesEnum)selectNode supportVideo:(BOOL)supportVideo withiPod:(IMBiPod *)ipod;
+ (NSString*)getSupportFileTypeArray:(CategoryNodesEnum)selectNode supportVideo:(BOOL)isSupportVideo supportConvert:(BOOL)isSupportConvert withiPod:(IMBiPod *)ipod;
+ (NSMutableArray *)filterSupportArrayWithIpod:(IMBiPod *)ipod isSingleImport:(BOOL)isSingleImport;
+ (NSString*)getRandomBookName;
+ (void)getEpubopfInfo:(NSString *)opfPath inDic:(NSMutableDictionary *)infoDic;
+ (void)getEpubDetailInfo:(NSString *)opfPath inDic:(NSMutableDictionary *)infoDic;
+ (NSString *)createPhotoUUID:(NSString *)UUIDValue;
+ (NSData *)My16NSStringToNSData:(NSString *)string;
+ (NSString *)getAppCachePathInIpod:(IMBiPod *)ipod;
+ (IMBNewTrack*)analyCreateTrack:(NSString*)filePath selectCategory:(CategoryNodesEnum)selectCategory;
+ (IMBNewTrack*)createBlankTrack:(NSString*)filePath selectCategory:(CategoryNodesEnum)selectCategory;
+ (IMBNewTrack*)createTrackByIMBTrack:(IMBTrack*)track containRatingAndPlayCount:(BOOL)containRatingAndPlayCount;
+ (NSString *)getMediaArtwork:(NSString *)filePath;
//获取cig
+ (NSData*) cigFromWebserviceWithPath:(NSString*)plistPath withUUID:(NSString*)UUID withGrappaData:(NSData*)grappaData isSuccess:(BOOL *)isSuccess;
+ (NSString *)getFileDataMd5Hash:(NSData *)data;
+ (void)killiTunes;
//获取文件大小
+ (long long)getFileLength:(NSString*)filePath;
@end
