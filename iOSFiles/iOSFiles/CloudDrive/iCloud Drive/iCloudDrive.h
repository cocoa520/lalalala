//
//  iCloudDrive.h
//  DriveSync
//
//  Created by 罗磊 on 2018/1/17.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDrive.h"

@interface iCloudDrive : BaseDrive
{
    NSString *_appleID;    ///<账号
    NSString *_password;   ///<密码
    NSString *_clientID;    ///<客户端ID 登录时 随机生成的
    
    NSString *_userName;   ///<账户名 昵称等
    NSString *_dsid;       ///<每个账户的唯一id
    NSMutableDictionary *_cookie;  ///<cookie
    NSString *_iCloudDriveUrl;    ///<iCloud Drive的基路径
    NSString *_pushUrl;           ///<心跳url，保持会话激活，防止会话失效
    NSString *_iCloudDriveDocwsUrl;  ///<文档url 主要用于下载和上传
    NSString *_accountUrl;
    NSString *_proxyDest;          ///<注销的时候需要 proxyDest=p60-setup
    
    NSString *_xappleSessionID;   ///< 二次验证和重新请求安全码需要用到
    NSString *_scnt;              ///< 二次验证和重新请求安全码需要用到
    BOOL _stopHearBeat;
    dispatch_queue_t _queue;
    
    
   
    long long _totalStorageInBytes;
    long long _usedStorageInBytes;
}
@property (nonatomic,assign) long long totalStorageInBytes;
@property (nonatomic,assign) long long usedStorageInBytes;
@property (nonatomic,retain)NSString *userName;
@property (nonatomic,retain)NSMutableDictionary *cookie;

/**
 *  Description 通过appleid和密码进行icloud drive登录
 *
 *  @param appleID  用户名
 *  @param password 密码
 *  @param rememberMe 是否记住此次登录 下次就不需要输入用户名和密码了
 */
- (void)loginAppleID:(NSString *)appleID password:(NSString *)password rememberMe:(BOOL)rememberMe;

/**
 *  Description 如果用户选择记住密码 会将cookie保存到本地 第二次可以直接通过cookie登录
 *
 *  @param cookie 保存到本地的cookie
 */
- (void)loginWithCookie:(NSMutableDictionary *)cookie;

/**
 *  Description 如果用户账户有2fa,需要调用此方法进行安全码验证
 *
 *  @param securityCode 安全码
 *  @param rememberMe 是否记住此次登录 下次就不需要输入用户名和密码了
 */
- (void)verifySecurityCode:(NSString *)securityCode rememberMe:(BOOL)rememberMe;

/**
 *  Description 如果用户没有收到安全码，则调用此方法，可以重新发送获取安全码请求
 */
- (void)resendGetSecurity;

/**
 *  Description 如果用户没有收到安全码，则调用此方法，可以重新通过短信的方式发送获取安全码请求
 */
- (void)resendGetSMSSecurity;

/**
 *  Description  删除指定的文件或者目
 *  @param success 成功回调block
 *  @param fail    失败回调block
 *
 *  @param fileOrFolderIDs 一个字典数组  字典为
 *  eg: @{@"etag" : @"oz",@"drivewsid" : @"FOLDER::com.apple.CloudDocs::B661E364-426F-4EAF-A2FE-2BAB5BA7CA96"}
 */
- (void)deleteFilesOrFolders:(NSArray *)fileOrFolderIDs success:(Callback)success fail:(Callback)fail;

/**
 *  Description 重命名
 *   
 *  @param item    重名项  eg:
 *                            @{
 *                            @"drivewsid": @"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB",
 *                            @"etag": @"pi",
 *                            @"name": @"hhh22"
 *                            }
 *
 *
 *  @param success 成功回调block
 *  @param fail    失败回调block
 */
- (void)reName:(NSDictionary *)item  success:(Callback)success fail:(Callback)fail;
/**
 *  Description 移动
 *
 *  @param newParent 新的父目录id
 *  @param items      移动项的dic数组  eg
 *                               @{@"drivewsid":@"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB",
 *                               @"etag":@"pp",
 *                               @"clientId":@"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB"}
 *
 *
 *  @param success   成功回调block
 *  @param fail      失败回调block
 */
- (void)moveToNewParent:(NSString *)newParent itemDic:(NSArray *)items success:(Callback)success fail:(Callback)fail;


/**
 *  Description 获取icloud 空间大小
 *
 *  @param success 成功回调block
 *  @param fail    失败回调block
 */
- (void)getUsedStorage:(NSString *)usedStorage success:(Callback)success fail:(Callback)fail;

@end
