//
//  OneDriveAPI.h
//  DriveSync
//
//  Created by 罗磊 on 2017/12/5.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YTKNetwork/YTKNetwork.h>
#import "HTTPApiConst.h"

@interface BaseDriveAPI : YTKRequest
{
    /**
     *  登录属性
     */
    NSString *_userEmail;       ///<登录邮箱
    NSString *_userPassword;    ///<登录密码
    
    /**
     *  数据操作属性
     */
    NSString *_driveID;         ///<驱动器ID，不同ID代表不同的云服务
    NSString *_userLogintoken;  ///<用户登录令牌，用于获取驱动器ID和刷新过期令牌
    NSString *_accestoken;      ///<访问令牌
    NSString *_folderOrfileID;  ///<需要操作的文件或者目录的ID，有的云盘也可能是相对路径
    NSString *_parent;          ///<需要在哪个父目录下操作
    NSString *_folderName;      ///<创建文件夹的名字
    NSString *_fileName;        ///<上传的文件名称
    NSString *_newName;         ///<需要修改的新名字
    NSString *_newParentIDOrPath; ///<需要移动到的目标父目录id或者路径
    uint64_t _uploadFileSize;   ///<上传的文件大小
    uint64_t _uploadRangeStart; ///<上传的文件块的范围开始值
    uint64_t _uploadRangeEnd;   ///<上传的文件块的范围结束值
    BOOL _isFolder;             ///<是否为文件夹
    
    /**
     * 从本地刷新令牌相关属性
     */
    NSString *_clientID;        ///<客户端ID
    NSString *_redirect_uri;    ///<重定向url
    NSString *_clientSecret;    ///<客户端密匙
    NSString *_refreshToken;    ///<刷新令牌
}

@property (nonatomic, assign) BOOL isFolder;

/**
 *  登录
 *
 *  @param email    用户邮箱
 *  @param password 用户密码
 *
 *  @return 实例对象
 */
- (instancetype)initWithEmail:(NSString *)email withPassword:(NSString *)password;

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
 *  初始化方法
 *
 *  @param folderID       需要操作的文件或者目录的ID，有的云盘也可能是相对路径
 *  @param accessToken    访问令牌
 *
 *  @return 返回自己
 */
- (id)initWithItemID:(NSString *)folderID accessToken:(NSString *)accessToken;

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
 *  <#Description#> 移动初始化方法
 * @param folderOrfileID 要移动项的id或者路径
 *  @param newParentIDOrPath 新的父路径或者id
 *  @param accessToken       访问令牌
 *  @param parent      原父目录
 *  @return 返回自己
 */
- (id)initWithItemID:(NSString *)folderOrfileID newParentIDOrPath:(NSString *)newParentIDOrPath  parent:(NSString *)parent accessToken:(NSString *)accessToken;
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
 *  @param refreshToken 刷新令牌
 *
 *  @return 返回自己
 */
- (id)initWithClientID:(NSString *)clientID redirectUri:(NSString *)redirectUri clientSecret:(NSString *)clientSecret

          refreshToken:(NSString *)refreshToken;

@end
