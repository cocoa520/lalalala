//
//  OneDriveAPI.h
//  DriveSync
//
//  Created by 罗磊 on 2017/12/5.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<YTKNetwork/YTKNetwork.h>)
#import <YTKNetwork/YTKNetwork.h>
#else
#import "YTKNetwork.h"
#endif
#import "HTTPApiConst.h"

@interface BaseDriveAPI : YTKRequest
{
    /**
     *  登录属性
     */
    NSString *_userEmail;               ///<注册、登录邮箱
    NSString *_userPassword;            ///<注册、登录密码
    NSString *_userConfirmPassword;     ///<注册再次输入密码
    NSString *_userG2FCode;             ///<登录需要Google二次验证
    NSString *_userLoginCode;           ///<第三方登录验证code
    
    /**
     *  数据操作属性
     */
    NSString *_driveID;                 ///<驱动器ID，不同ID代表不同的云服务
    NSString *_driveName;               ///<驱动器名称
    NSString *_driveNewName;            ///<驱动器新名称
    NSString *_userLogintoken;          ///<用户登录令牌，用于获取驱动器ID和刷新过期令牌
    NSString *_accestoken;              ///<访问令牌
    NSString *_userAccountID;           ///<用户账号信息ID号
    NSString *_folderOrfileID;          ///<需要操作的文件或者目录的ID，有的云盘也可能是相对路径
    NSString *_fileAbsolutePath;        ///<Dropbox完整路径
    NSString *_albumID;                 ///<GooglePhoto相册ID
    NSString *_parent;                  ///<需要在哪个父目录下操作
    NSString *_folderName;              ///<创建文件夹的名字
    NSString *_fileName;                ///<上传的文件名称
    NSString *_fileSize;                ///<文件大小
    NSString *_newName;                 ///<需要修改的新名字
    NSString *_fileExtension;           ///<文件后缀
    NSString *_newParentDriveIDOrPath;  ///<需要复制到的目标父目录id或者路径，OneDrive需要
    NSString *_newParentIDOrPath;       ///<需要移动到的目标父目录id或者路径
    NSString *_uploadSessionID;         ///<上传的文件SessionID
    NSString *_uploadUrl;               ///<上传的文件块的SeesionURL
    NSString *_searchName;              ///<搜索名称
    NSString *_searchPageLimit;         ///<搜索限制条数
    NSString *_searchPageIndex;         ///<搜索第几页
    
    /**
     *  分享、收藏
     */
    NSString *_collectionID;            ///<收藏文件或文件夹ID
    NSString *_shareID;                 ///<分享ID
    NSString *_collectionShareID;       ///<收藏分享的ID
    int _maxDownload;                   ///<最大下载数量
    NSString *_shareExpireAt;           ///<分享到期时间
    NSString *_sharePassword;           ///<分享密码
    
    /**
     *  离线任务
     */
    NSString *_offlineTaskID;           ///<离线任务ID
    NSString *_offlineName;             ///<离线任务名称
    NSString *_targetDriveID;           ///<离线任务目标驱动器ID
    NSArray *_sourceFolderOrFileID;     ///<离线任务源文件路径ID
    NSString *_targetFolderOrFileID;    ///<离线任务目标文件路径ID
    NSString *_offlineType;             ///<离线任务任务类型
    NSString *_offlineMode;             ///<离线任务传输模式
    NSString *_offlineScope;            ///<离线任务传输范围
    NSString *_offlineConflict;         ///<离线任务冲突处理
    NSString *_offlineFrequency;        ///<离线任务执行频率
    NSString *_offlineExecuteTime;      ///<离线任务时间
    
    int _pageLimit;                     ///<每页显示多少条
    int _pageIndex;                     ///<第几页
    
    uint64_t _uploadFileSize;           ///<上传的文件大小
    uint64_t _uploadRangeStart;         ///<上传的文件块的范围开始值
    uint64_t _uploadRangeEnd;           ///<上传的文件块的范围结束值
    
    BOOL _isFolder;                     ///<是否为文件夹
    
    /**
     * 从本地刷新令牌相关属性
     */
    NSString *_clientID;        ///<客户端ID
    NSString *_redirect_uri;    ///<重定向url
    NSString *_clientSecret;    ///<客户端密匙
    NSString *_refreshToken;    ///<刷新令牌
    /**
     *  iCloud Drive所需属性
     */
    NSString *_iCloudDriveUrl;
    NSMutableDictionary *_cookie;  ///<cookie
    NSString *_dsid;  ///<iCloudDrive唯一标志
    
    NSArray *_multipleFilesOrFolder;                ///<多文件或文件夹数组
    NSMutableArray *_multipleNewFilesOrFolder;      ///<多文件或文件夹新数组
    NSString *_multipleFilesOrFolderAsyncJobID;     ///<多文件或文件夹异步任务检查ID
}

@property (nonatomic, assign) BOOL isFolder;
/**
 *  注册
 *
 *  @param email                注册邮箱
 *  @param password             注册密码
 *  @param confirmPassword      注册重复密码
 *
 *  @return 实例对象
 */

- (instancetype)initWithEmail:(NSString *)email withPassword:(NSString *)password withConfirmPassword:(NSString *)confirmPassword;

/**
 *  登录
 *
 *  @param email                用户邮箱
 *  @param password             用户密码
 *
 *  @return 实例对象
 */
- (instancetype)initWithEmail:(NSString *)email withPassword:(NSString *)password;

/**
 *  登录
 *
 *  @param email                用户邮箱
 *  @param password             用户密码
 *  @param g2fCode              用户Google登录二次验证
 *
 *  @return 实例对象
 */
- (instancetype)initWithEmail:(NSString *)email withPassword:(NSString *)password withGoogle2FCode:(NSString *)g2fCode;

/**
 *  第三方登录
 *
 *  @param userLoginCode        第三方登录成功后传入的Code
 *
 *  @return 实例对象
 */
- (instancetype)initWithUserLoginCode:(NSString *)userLoginCode;

/**
 *  获取所有驱动器ID
 *
 *  @param userLogintoken 用户登录获取的token
 *
 *  @return 实例对象
 */
- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken;

/**
 *  获取当前驱动器ID的有效Token
 *
 *  @param userLogintoken 用户登录获取的token
 *  @param driveID        指定的驱动器ID
 *
 *  @return 实例对象
 */
- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken withDriveID:(NSString *)driveID;

/**
 *  追加新的驱动器、移除已有的驱动器
 *
 *  @param userLogintoken 用户登录获取的token
 *  @param driveName      指定添加的驱动器名称
 *
 *  @return 实例对象
 */
- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken withDriveName:(NSString *)driveName;

/**
 *  搜索指定云盘下的文件
 *
 *  @param userLogintoken   用户登录获取的token
 *  @param driveID          指定驱动器名称
 *  @param searchName       搜索名称
 *  @param limit            搜索条数
 *  @param pageIndex        搜索页数
 *
 *  @return 实例对象
 */
- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken
                           withDriveID:(NSString *)driveID
                        withSearchName:(NSString *)searchName
                       withSearchLimit:(NSString *)limit
                   withSearchPageIndex:(NSString *)pageIndex;

/**
 *  重命名驱动器
 *
 *  @param userLogintoken 用户登录获取的token
 *  @param driveID        当前驱动器ID
 *  @param driveNewName   当前驱动器新的名称
 *
 *  @return 实例对象
 */
- (instancetype)initWithUserLoginToken:(NSString *)userLogintoken withDriveID:(NSString *)driveID withDriveNewName:(NSString *)driveNewName;

/**
 *  用户账户信息ID号
 *
 *  @param userAccountID ID号
 *  @param accessToken    访问令牌
 *
 *  @return 实例对象
 */
- (instancetype)initWithUserAccountID:(NSString *)userAccountID accessToken:(NSString *)accessToken;
/**
 *  初始化方法
 *
 *  @param folderID       需要操作的文件或者目录的ID，有的云盘也可能是相对路径
 *  @param accessToken    访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithItemID:(NSString *)folderID accessToken:(NSString *)accessToken;

/**
 *  初始化方法, 添加收藏、访问历史记录
 *
 *  @param driveID                      驱动器ID
 *  @param fileOrFolderID               文件/文件夹ID
 *  @param isFolder                     是否为文件夹
 *  @param albumID                      GooglePhoto相册ID
 *  @param userLoginToken               登录访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithDriveID:(NSString *)driveID
   withFileOrFolderID:(NSString *)fileOrFolderID
         withIsFolder:(BOOL)isFolder
          withAlbumID:(NSString *)albumID
       userLoginToken:(NSString *)userLoginToken;

/**
 *  初始化方法, 创建分享
 *
 *  @param driveID                      驱动器ID
 *  @param fileOrFolderID               文件/文件夹ID
 *  @param isFolder                     是否为文件夹
 *  @param maxDownload                  分享的最大下载数
 *  @param shareExpireAt                分享到期时间
 *  @param sharePassword                分享密码
 *  @param albumID                      GooglePhoto相册ID
 *  @param userLoginToken               登录访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithDriveID:(NSString *)driveID
   withFileOrFolderID:(NSString *)fileOrFolderID
         withIsFolder:(BOOL)isFolder
      withMaxDownload:(int)maxDownload
    withShareExpireAt:(NSString *)shareExpireAt
    withSharePassword:(NSString *)sharePassword
          withAlbumID:(NSString *)albumID
       userLoginToken:(NSString *)userLoginToken;

/**
 *  初始化方法, 获取收藏、访问文件记录、分享、收藏分享列表
 *
 *  @param limit            每页显示多少条
 *  @param pageIndex        显示第几页
 *  @param userLoginToken   登录访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithItemLimit:(int)limit withPageIndex:(int)pageIndex userLoginToken:(NSString *)userLoginToken;

/**
 *  初始化方法
 *
 *  @param collectionID     收藏、访问文件记录ID
 *  @param userLoginToken   登录访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithCollectionID:(NSString *)collectionID userLoginToken:(NSString *)userLoginToken;

/**
 *  初始化方法
 *
 *  @param shareID          分享ID
 *  @param userLoginToken   登录访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithShareID:(NSString *)shareID userLoginToken:(NSString *)userLoginToken;

/**
 *  初始化方法
 *
 *  @param collectionShareID        收藏分享ID
 *  @param userLoginToken           登录访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithCollectionShareID:(NSString *)collectionShareID userLoginToken:(NSString *)userLoginToken;

/**
 *  初始化方法
 *
 *  @param offlineTaskID            离线任务ID
 *  @param userLoginToken           登录访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithOfflineTaskID:(NSString *)offlineTaskID userLoginToken:(NSString *)userLoginToken;

/**
 *  初始化方法
 *
 *  @param offlineTaskName                  离线任务名称
 *  @param sourceDriveID                    离线任务源驱动器ID
 *  @param targetDriveID                    离线任务目标驱动器ID
 *  @param sourceFolderOrFileIDArray        离线任务源文件/文件夹ID
 *  @param targetFolderOrFileID             离线任务目标文件/文件夹ID
 *  @param type                             离线任务类型
 *  @param mode                             离线任务传输模式
 *  @param scope                            离线任务传输范围
 *  @param conflict                         离线任务冲突处理
 *  @param frequency                        离线任务执行频率
 *  @param executeTime                      离线任务时间
 *  @param userLoginToken                   登录访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithOfflineTaskName:(NSString *)offlineTaskName
            withSourceDriveID:(NSString *)sourceDriveID
            withTargetDriveID:(NSString *)targetDriveID
     withSourceFolderOrFileID:(NSArray *)sourceFolderOrFileIDArray
     withTargetFolderOrFileID:(NSString *)targetFolderOrFileID
                     withType:(NSString *)type
                     withMode:(NSString *)mode
                    withScope:(NSString *)scope
                 withConflict:(NSString *)conflict
                withFrequency:(NSString *)frequency
              withExecuteTime:(NSString *)executeTime
               userLoginToken:(NSString *)userLoginToken;

/**
 *  初始化方法
 *
 *  @param filesOrFoldersAry        需要操作的多文件或者目录的ID，有的云盘也可能是相对路径
 *  @param accessToken              访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithItemsID:(NSArray *)filesOrFoldersAry accessToken:(NSString *)accessToken;

/**
 *  初始化方法
 *
 *  @param asyncJobID               Dropbox多文件、文件夹操作异步任务检查ID
 *  @param accessToken              访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithItemsAsyncJobID:(NSString *)asyncJobID accessToken:(NSString *)accessToken;

/**
 *  初始化方法
 *
 *  @param folderID    需要操作的文件或者目录的ID，有的云盘也可能是相对路径
 *  @param accessToken 访问令牌
 *  @param isFolder    是否为文件夹
 *
 *  @return 返回类对象
 */
- (id)initWithItemID:(NSString *)folderID accessToken:(NSString *)accessToken withIsFolder:(BOOL)isFolder;

/**
 *  初始化方法
 *
 *  @param folderName  创建文件夹的名字
 *  @param parent      需要在哪个父目录下操作
 *  @param accessToken 访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithFolderName:(NSString *)folderName Parent:(NSString *)parent accessToken:(NSString *)accessToken;
/**
 *  Description 重命初始化方法
 *
 *  @param newName     新名字
 *  @param idOrPath    id或者路径
 *  @param accessToken 访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithNewName:(NSString *)newName idOrPath:(NSString *)idOrPath accessToken:(NSString *)accessToken;


/**
 *  移动初始化方法
 *  @param folderOrfileID 要移动项的id或者路径
 *  @param newParentIDOrPath 新的父路径或者id
 *  @param accessToken       访问令牌
 *  @param parent      原父目录
 *  @return 返回自己
 */
- (id)initWithItemID:(NSString *)folderOrfileID newParentIDOrPath:(NSString *)newParentIDOrPath  parent:(NSString *)parent accessToken:(NSString *)accessToken;

/**
 *  复制初始化方法
 *  @param folderOrfileID           要复制项的id或者路径
 *  @param newParentIDOrPath        新的父路径或者id
 *  @param newParentDriveID         原父目录DriveID
 *  @param accessToken              访问令牌
 *  @return 返回自己
 */
- (id)initWithItemID:(NSString *)folderOrfileID newParentIDOrPath:(NSString *)newParentIDOrPath newParentDriveID:(NSString *)newParentDriveID accessToken:(NSString *)accessToken;

/**
 *  移动初始化方法
 *  @param folderOrfileIDAry        要移动项的多id或者路径数组
 *  @param newParentIDOrPathAry     新的父路径或者多id数组
 *  @param accessToken              访问令牌
 *  @param parent                   原父目录
 *  @return 返回自己
 */
- (id)initWithItemsID:(NSArray *)folderOrfileIDAry newParentIDOrPath:(NSMutableArray *)newParentIDOrPathAry  parent:(NSString *)parent accessToken:(NSString *)accessToken;

/**
 *  初始化方法
 *
 *  @param folderOrfileID    要移动项的id或者路径
 *  @param newParentIDOrPath 新的父路径或者id
 *  @param name              移动或者重命名的文件名称加后缀（主要针对Box）
 *  @param accessToken       访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithItemID:(NSString *)folderOrfileID newParentIDOrPath:(NSString *)newParentIDOrPath name:(NSString *)name accessToken:(NSString *)accessToken;
/**
 *  初始化方法
 *
 *  @param fileName    上传的文件名称
 *  @param parent      需要在哪个父目录下操作
 *  @param accessToken 访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithFileName:(NSString *)fileName Parent:(NSString *)parent accessToken:(NSString *)accessToken;
/**
 *  初始化方法
 *
 *  @param fileName    上传的文件名称
 *  @param parent      需要在哪个父目录下操作
 *  @param fileSize    上传的文件大小
 *  @param start       range开始值
 *  @param end         range结束值
 *  @param accessToken 访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithFileName:(NSString *)fileName Parent:(NSString *)parent fileSize:(long long)fileSize fileStart:(long long)start fileEnd:(long long)end accessToken:(NSString *)accessToken;
/**
 *  初始化方法
 *
 *  @param fileName    上传的文件名称
 *  @param parent      需要在哪个父目录下操作
 *  @param filePath    待上传的本地文件路径
 *  @param offset      文件的偏移量
 *  @param sessionID   上传的文件SessionID
 *  @param accessToken 访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithFileName:(NSString *)fileName Parent:(NSString *)parent uploadFile:(NSString *)filePath offset:(uint64_t)offset sessionID:(NSString *)sessionID accessToken:(NSString *)accessToken;

/**
 *  初始化方法
 *
 *  @param fileName    上传的文件名称
 *  @param parent      需要在哪个父目录下操作
 *  @param offset      文件的偏移量
 *  @param sessionID   上传的文件SessionID
 *  @param accessToken 访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithFileName:(NSString *)fileName Parent:(NSString *)parent offset:(uint64_t)offset sessionID:(NSString *)sessionID accessToken:(NSString *)accessToken;

/**
 *  初始化方法
 *
 *  @param fileName    上传的文件名称
 *  @param fileSize    上传的文件大小
 *  @param parent      需要在哪个父目录下操作
 *  @param accessToken 访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithFileName:(NSString *)fileName fileSize:(long long)fileSize Parent:(NSString *)parent accessToken:(NSString *)accessToken;

/**
 *  初始化方法
 *
 *  @param fileSize    文件的总大小
 *  @param start       文件块的开始值
 *  @param end         文件块的结果值
 *  @param accessToken 访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithFileSize:(long )fileSize fileStart:(long long)start fileEnd:(long long)end accessToken:(NSString *)accessToken;
/**
 *  刷新访问令牌初始化方法
 *
 *  @param clientID     客户端ID
 *  @param redirectUri  重定向url
 *  @param clientSecret 客户端密匙
 *
 *  @return 返回自己
 */
- (id)initWithClientID:(NSString *)clientID redirectUri:(NSString *)redirectUri clientSecret:(NSString *)clientSecret;
/**
 *  初始化方法
 *
 *  @param uploadUrl   上传文件的url
 *  @param fileSize    文件的总大小
 *  @param start       文件块的开始值
 *  @param end         文件块的结果值
 *  @param accessToken 访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithUploadUrl:(NSString *)uploadUrl fileSize:(long long)fileSize fileStart:(long long)start fileEnd:(long long)end accessToken:(NSString *)accessToken;
/**
 *  初始化方法
 *
 *  @param clientID     客户端ID
 *  @param redirectUri  重定向Uri
 *  @param clientSecret 客户端密码
 *  @param refreshToken 刷新令牌
 *
 *  @return 返回自己
 */
- (id)initWithClientID:(NSString *)clientID redirectUri:(NSString *)redirectUri clientSecret:(NSString *)clientSecret refreshToken:(NSString *)refreshToken;
/**
 *  Description iCloudDriveAPI 初始化方法
 *
 *  @param folderID dirveid
 *  @param cookie   cookie
 *  @param url      基url
 *
 *  @return 返回自己
 */
- (id)initWithItemID:(NSString *)folderID cookie:(NSMutableDictionary *)cookie iCloudDriveURL:(NSString *)url;

/**
 *  Description 生成guid字符串
 *
 *  @return guid字符串
 */
+ (NSString *)createGUID;

/**
 *  Description 将中文和日文进行unicode编码
 *
 *  @param string 将要转码字符串
 *
 *  @return 转码之后字符串
 */
+ (NSString *)zhAndJpToUnicode:(NSString *)string;


@end
