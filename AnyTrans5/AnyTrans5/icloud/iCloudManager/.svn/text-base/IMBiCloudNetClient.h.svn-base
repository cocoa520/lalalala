//
//  IMBiCloudNetClient.h
//  iCloudPanel
//
//  Created by iMobie on 12/27/16.
//  Copyright (c) 2016 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBDownloadService.h"
#import "IMBLogManager.h"


@interface IMBMediaStorageUsageEntity : NSObject {
    NSString *_displayColor;
    NSString *_displayLabel;
    NSString *_mediaKey;
    long long _usageInBytes;
}

@property (nonatomic, retain) NSString *displayColor;
@property (nonatomic, retain) NSString *displayLabel;
@property (nonatomic, retain) NSString *mediaKey;
@property (nonatomic, assign) long long usageInBytes;

@end

@interface IMBiCloudLoginInfoEntity : NSObject {
    NSString *_aDsID;
    NSString *_appleId;
    NSString *_dsid;
    NSString *_fullName;
    NSString *_languageCode;
    NSString *_locale;
    BOOL _locked;
    NSString *_primaryEmail;
    BOOL _primaryEmailVerified;
    int _statusCode;
    int _hasICloudQualifyingDevice;
    NSString *_timeZone;
    BOOL _isLoadFinish;
    
    BOOL _almostFull;//容量是否满了；
    BOOL _haveMaxQuotaTier;//是否有最大配额层
    BOOL _overQuota;//是否超过容量；
    BOOL _paidQuota;//是否购买容量；
    long long _commerceStorageInBytes;//商业存储字容量
    long long _compStorageInBytes;//在计算机存储的字节
    long long _totalStorageInBytes;//总容量
    long long _usedStorageInBytes;//使用容量
    IMBMediaStorageUsageEntity *_photoStorage;
    IMBMediaStorageUsageEntity *_backupStorage;
    IMBMediaStorageUsageEntity *_docsStorage;
    IMBMediaStorageUsageEntity *_mailStorage;
}

@property (nonatomic, retain) NSString *aDsID;
@property (nonatomic, retain) NSString *appleId;
@property (nonatomic, retain) NSString *dsid;
@property (nonatomic, readwrite, retain) NSString *fullName;
@property (nonatomic, retain) NSString *languageCode;
@property (nonatomic, retain) NSString *locale;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, retain) NSString *primaryEmail;
@property (nonatomic, assign) BOOL primaryEmailVerified;
@property (nonatomic, assign) int statusCode;
@property (nonatomic, assign) int hasICloudQualifyingDevice;
@property (nonatomic, retain) NSString *timeZone;
@property (nonatomic, assign) BOOL isLoadFinish;

@property (nonatomic, assign) BOOL almostFull;//容量是否满了；
@property (nonatomic, assign) BOOL haveMaxQuotaTier;//是否有最大配额层
@property (nonatomic, assign) BOOL overQuota;//是否超过容量；
@property (nonatomic, assign) BOOL paidQuota;//是否购买容量；
@property (nonatomic, assign) long long commerceStorageInBytes;//商业存储字容量
@property (nonatomic, assign) long long compStorageInBytes;//在计算机存储的字节
@property (nonatomic, assign) long long totalStorageInBytes;//总容量
@property (nonatomic, assign) long long usedStorageInBytes;//使用容量
@property (nonatomic, retain) IMBMediaStorageUsageEntity *photoStorage;
@property (nonatomic, retain) IMBMediaStorageUsageEntity *backupStorage;
@property (nonatomic, retain) IMBMediaStorageUsageEntity *docsStorage;
@property (nonatomic, retain) IMBMediaStorageUsageEntity *mailStorage;

@end

/*----------该实体保存的是iCloud的登录信息---------*/
@interface IMBiCloudNetLoginInfo : NSObject {
@private
    NSString *_appleID;             //登陆的apple ID；
    NSString *_password;            //登录密码；
    BOOL _loginStatus;              //登录状态；
    NSMutableArray *_cookieList;    //cookie数组；
    NSMutableDictionary *_loginDic;        //返回的登录后的信息；
    IMBiCloudLoginInfoEntity *_loginInfoEntity;
    NSImage *_headImage;
}

@property (nonatomic, readwrite, retain) NSString *appleID;
@property (nonatomic, readwrite, retain) NSString *password;
@property (nonatomic, readwrite, retain) NSMutableArray *cookieList;
@property (nonatomic, readwrite, retain) NSDictionary *loginDic;
@property (nonatomic, readwrite) BOOL loginStatus;
@property (nonatomic, readwrite, retain) IMBiCloudLoginInfoEntity *loginInfoEntity;
@property (nonatomic, readwrite, retain) NSImage *headImage;

@end

@interface IMBiCloudNetClient : NSObject {
    IMBiCloudNetLoginInfo *_loginInfo;             //登录信息；
    NSNotificationCenter *nc;
    IMBDownloadService *_downloadService;
    NSThread *_keepAliveThread;
    IMBLogManager *_logHandle;
    NSDictionary *_firstDic;
}

@property (nonatomic, retain) IMBDownloadService *downloadService;
@property (nonatomic, readwrite, retain)  IMBiCloudNetLoginInfo *loginInfo;

/*
    登陆iCloud账号.
*/
- (BOOL)iCloudLoginWithAppleID:(NSString*)appleID withPassword:(NSString*)password WithSessiontoken:(NSString *)sessiontoken;

/*
 iCloud账号是否加了双重验证
 */
- (NSDictionary *)verifiAccountHasTwoStepAuthenticationWithAppleID:(NSString*)appleID withPassword:(NSString*)password;
/*
 验证双重验证的密码
 */
- (NSDictionary *)verifiTwoStepAuthentication:(NSString *)password withFirstDic:(NSDictionary *)firstDic;

/*
 发送双重验证密码；（用户没有收到，手动点击）
 */
- (void)sentTwoStepAuthenticationMessage;
/*
    退出iCloud账号.
*/
- (void)logoutiCould;

/*
    删除cookie历史记录
 */
- (void)deleteCookieStorage;

/*
    设置cookie
 */
- (void)setCookiesStorage;

/*
    请求账号容量信息
 */
- (void)getStrogeDetail;

/*
    自动刷新web
 */
- (void)startKeepAliveThread;

/*
    判断登录是否退出
 */
- (BOOL)judgeSessionIsInvalid;

/*
    获取infoName对应的内容，注：photos获取的是syncToken值.
    infoName-->指的是类型(photos、contact、notes、reminder、calendar).
    path-->在url链接上保存的地址.
*/
- (NSDictionary *)getInformationContent:(NSString *)infoName withPath:(NSString *)path;

/*
    获得iCloud Drive文件下载的url
    path-->在url链接上保存的地址
 */
- (NSDictionary *)getiCloudDriveUrl:(NSString *)path;

/*
    获得iCloud Note Attachment
    urlStr-->在url链接上保存的地址
 */
- (NSData *)getiCloudNoteAttachmentUrl:(NSString *)urlStr;

/*
    获得指定类型的详细内容 或 实现contact、notes、calendar、reminder的一些功能.
    infoName-->指的是类型(photos、contact、notes、reminder、calendar).
    path-->在url链接上保存的地址.
    postStr-->Post Data 数据
*/
- (NSDictionary *)postInformationContent:(NSString *)infoName withPath:(NSString *)path withPostStr:(NSString *)postStr;

/*
    获得iCloud Drive的详细内容.
    infoName-->指的是类型
    path-->在url链接上保存的地址.
    postStr-->Post Data 数据
 */
- (id)postiCloudDriveContent:(NSString *)infoName withPath:(NSString *)path withPostStr:(NSString *)postStr;

/*
    获得photos类型下的所有相册信息
    syncToken-->photos类型的同步令牌
*/
- (NSDictionary *)getiCloudPhotosAlbumInfo:(NSString *)syncToken;

/*
    获得对应图片信息
    syncToken-->photos类型的同步令牌
    postStr-->Post Data 数据:  @"{\"syncToken\":\"%@\",\"methodOverride\":\"GET\",\"clientIds\":\"[%@]\"}"
*/
- (NSDictionary *)getiCloudPhotosImageInfo:(NSString *)syncToken withPostStr:(NSString *)postStr;

/*
    获得指定图片的缩略图
    syncToken-->photos类型的同步令牌
    serverId-->图片的唯一标记
*/
- (NSData *)getiCloudPhotosThumbImage:(NSString *)syncToken withServerID:(NSString *)serverId;

/*
    获得指定图片的原始图
    syncToken-->photos类型的同步令牌
    serverId-->图片的唯一标记
*/
- (NSData *)getiCloudPhotosOriginalImage:(NSString *)syncToken withServerID:(NSString *)serverId;

/*
    上传图片到iCloud photos
    syncToken-->photos类型的同步令牌
    fileName-->图片名字
    fileData-->图片内容
    parentDirId-->相册节点
*/
- (void)uploadImageToiCloudPhoto:(NSString *)syncToken withFileName:(NSString *)fileName withFileData:(NSData *)fileData withParentDir:(NSString *)parentDirId;


/*
    下载文件的方法
    urlStr-->下载url
    path-->下载文件保存的路劲
    startBytes-->下载开始的字节
 */
- (void)downloadiCloudFile:(NSString *)urlStr withPath:(NSString *)path withStartBytes:(long long)startBytes;

/*
    上传文件的方法
    urlStr-->下载url
    filePath-->上传文件的路劲
    infoName-->指的是类型
    contentType-->上传文件的路劲
    isPhoto-->是否是上传到Photos
 */
- (BOOL)uploadFileToiCloud:(NSString *)urlStr withFilePath:(NSString *)filePath withInfoName:(NSString *)infoName withContentType:(NSString *)contentType  withIsPhoto:(BOOL)isPhoto;

/*
 上传文件的方法
    urlStr-->下载url
    fileData-->上传文件的数据
    infoName-->指的是类型
    fileName-->文件名字
 */
- (BOOL)uploadFileToiCloud:(NSString *)urlStr withPhotoData:(NSData *)fileData withInfoName:(NSString *)infoName withFileName:(NSString *)fileName;

/*  
    上传完后更新方法
    retDic——>上传后返回的dictionary
    documentID——>文件的唯一ID
    parentDirId——>父目录的id
    fileName——>上传的文件名
 */
- (NSDictionary *)updateFileAfterUpload:(NSDictionary *)retDic withRetDocumentID:(NSString *)documentID withParentDir:(NSString *)parentDirId withUploadFileName:(NSString *)fileName;

/*
    加密成base64
 */
- (NSString*)encode:(NSString *)part;

/*
    解密base64的字符串
 */
- (NSString*)decode:(NSString*)base64str;

/*
    获得取数据的网址
 */
- (NSString *)getContentHostUrl:(NSString *)category;

/*
    判断note是否为高版本
*/
- (BOOL)judgeNoteIsHigh;

@end
