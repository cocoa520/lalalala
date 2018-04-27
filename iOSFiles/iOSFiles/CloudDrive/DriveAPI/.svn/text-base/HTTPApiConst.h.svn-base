//
//  HTTPApiConst.h
//  DriveSync
//
//  Created by 罗磊 on 2017/12/5.
//  Copyright © 2017年 imobie. All rights reserved.
//

#ifndef HTTPApiConst_h
#define HTTPApiConst_h


#endif /* HTTPApiConst_h */
/**
 *  用户登录及授权相关常亮配置
 */
/**
 *  登录访问终结点
 */
static NSString *const WebEndPointURL = @"https://drive.fuhanwen.cn/api";
/**
 *  登录
 */
static NSString *const WebLoginEndPointURL = @"auth/login";
/**
 *  获取驱动器ID
 */
static NSString *const WebDriveListIDEndPointURL = @"drive";
/**
 *  令牌刷新
 */
static NSString *const WebRefreshEndPointURL = @"drive/%@/refresh";
/**
 *  云服务授权终结点
 */
static NSString *const CloudStorageEndPointURL = @"https://drive.fuhanwen.cn/api/drive/bind";
/**
 *  Google Drive 授权
 */
static NSString *const GoogleDriveCSEndPointURL = @"google";
/**
 *  One Drive 授权
 */
static NSString *const OneDriveCSEndPointURL = @"onedrive";
/**
 *  Dropbox 授权
 */
static NSString *const DropboxCSEndPointURL = @"dropbox";
/**
 *  Box 授权
 */
static NSString *const BoxCSEndPointURL = @"box";

/**
 *  OneDrive相关常量配置
 */

/**
 *  获通过刷新令牌获取新的访问令牌
 */
static NSString *const OneDriveRefreshEndPointURL = @"https://login.microsoftonline.com";
static NSString *const OneDriveRefreshAccessToken = @"common/oauth2/v2.0/token";

/**
 *  api访问终结点
 */
static NSString *const OneDriveEndPointURL = @"https://graph.microsoft.com/v1.0";
/**
 *  获取文件列表有关路径
 */
static NSString *const OneDriveRootChildrenPath = @"me/drive/root/children";
static NSString *const OneDriveChildrenPath = @"me/drive/items/%@/children";
/**
 *  创建文件夹路径
 */
static NSString *const OneDriveCreateFolderPath = @"me/drive/items/%@/children";
/**
 *  重命名
 */
static NSString *const OneDriveReNamePath = @"me/drive/items/%@";
/**
 *  删除文件
 */
static NSString *const OneDriveDeleteFilePath = @"me/drive/items/%@";
/**
 *  下载文件
 */
static NSString *const OneDriveDownloadFilePath = @"me/drive/items/%@/content";
/**
 *  上传文件
 */
static NSString *const OneDriveUploadFilePath = @"me/drive/items/%@:/%@:/content";
/**
 *  上传单个大于50MB的文件
 */
static NSString *const OneDriveUploadBigFileCreateSession = @"me/drive/items/%@:/%@:/createUploadSession";
//static NSString *const OneDriveUploadBigFileCreateSession = @"/drive/items/%@:/%@:/createUploadSession";
/**
 *  进度常量key
 */
static NSString *const ProgressUserInfoStartTimeKey = @"ProgressUserInfoStartTimeKey";
static NSString *const ProgressUserInfoOffsetKey = @"ProgressUserInfoOffsetKey";

/**
 *  Dropbox相关常量配置
 */
/**
 *  api访问终结点
 */
static NSString *const DropboxAPIBaseURL = @"https://api.dropboxapi.com";
static NSString *const DropboxContentBaseURL = @"https://content.dropboxapi.com";
static NSString *const DropboxRenameBaseURL = @"https://www.dropbox.com";
/**
 *  获取用户信息
 */
static NSString *const DropboxGetCurrentAccount = @"2/users/get_current_account";
/**
 *  获取用户使用云盘空间
 */
static NSString *const DropboxGetSpaceUsage = @"2/users/get_space_usage";
/**
 *  获取文件列表有关路径
 */
static NSString *const DropboxGetListPath = @"2/files/list_folder";
/**
 *  创建文件夹路径
 */
static NSString *const DropboxCreateFolderPath = @"2/files/create_folder_v2";
/**
 *  删除文件夹及文件
 */
static NSString *const DropboxDeleteFolderAndFilePath = @"2/files/delete_v2";
/**
 *  删除多文件夹及文件
 */
static NSString *const DropboxDeleteMultipleFolderAndFilePath = @"2/files/delete_batch";
/**
 *  检查删除多文件夹及文件状态
 */
static NSString *const DropboxDeleteMultipleFolderAndFilePathCheck = @"2/files/delete_batch/check";
/**
 *  下载文件
 */
static NSString *const DropboxDownloadFilePath = @"2/files/download";
/**
 *  上传小于150MB的文件
 */
static NSString *const DropboxUploadFilePath = @"2/files/upload";

/**
 *  上传单个大于150MB的文件
 */
static NSString *const DropboxUploadSessionStart = @"2/files/upload_session/start";
static NSString *const DropboxUploadSessionAppend = @"2/files/upload_session/append_v2";
static NSString *const DropboxUploadSessionFinish = @"2/files/upload_session/finish";
/**
 *  移动文件或者文件夹
 */
static NSString *const DropboxMove = @"2/files/move_v2";
/**
 *  移动多文件或者文件夹
 */
static NSString *const DropboxMoveMultiple = @"2/files/move_batch";
/**
 *  检查移动多文件或者文件夹
 */
static NSString *const DropboxMoveMultipleCheck = @"2/files/move_batch/check";
/**
 *  重命名文件或者文件夹
 */
static NSString *const DropboxRename = @"cmd/rename/%@";

/**
 *  搜索文件夹及文件
 */
static NSString *const DropboxSearchFolderOrFilePath = @"2/files/search";

/**
 *  Box相关常量配置
 */
/**
 *  api访问终结点
 */
static NSString *const BoxAPIBaseURL = @"https://api.box.com";
static NSString *const BoxAPIContentBaseURL = @"https://upload.box.com";
/**
 *  获取文件夹列表有关路径
 */
static NSString *const BoxGetRootListFolderAndFilePath = @"2.0/folders/0";  ///<默认根目录
static NSString *const BoxGetListFolderPath = @"2.0/folders/%@";            ///<当前目录信息及所有文件信息
static NSString *const BoxGetListFilePath = @"2.0/files/%@";                ///<当前文件信息
/**
 *  创建文件夹路径
 */
static NSString *const BoxCreateFolderPath = @"2.0/folders";
/**
 *  删除文件夹
 */
static NSString *const BoxDeleteFolderPath = @"2.0/folders/%@?recursive=true";
/**
 *  删除文件
 */
static NSString *const BoxDeleteFilePath = @"2.0/files/%@";
/**
 *  下载文件
 */
static NSString *const BoxDownloadFilePath = @"2.0/files/%@/content";
/**
 *  上传小于50MB的文件
 */
static NSString *const BoxUploadFilePath = @"api/2.0/files/content";
/**
 *  上传单个大于50MB的文件
 */
static NSString *const BoxUploadBigFileCreateSession = @"api/2.0/files/upload_sessions";
/**
 *  移动文件或者文件夹
 */
static NSString *const BoxFilesMove = @"2.0/files/%@";
static NSString *const BoxFoldersMove = @"2.0/folders/%@";
/**
 *  重命名文件或者文件夹
 */
static NSString *const BoxFilesRename = @"2.0/files/%@";
static NSString *const BoxFoldersRename = @"2.0/folders/%@";

/**
 *  GoogleDrive相关常量配置
 */
/**
 *  api访问终结点
 */
static NSString *const GoogleDriveAPIBaseURL = @"https://www.googleapis.com";
/**
 *  获取文件列表有关路径
 */
static NSString *const GoogleDriveGetListPath = @"drive/v3/files";
/**
 *  移动文件夹及文件
 */
static NSString *const GoogleDriveMoveFolderAndFilePath = @"drive/v3/files/%@?addParents=%@&removeParents=%@";
/**
 *  删除文件夹及文件
 */
static NSString *const GoogleDriveDeleteFolderAndFilePath = @"drive/v3/files/%@";
/**
 *  下载文件
 */
static NSString *const GoogleDriveDownloadFilePath = @"download/drive/v3/files/%@?alt=media";
/**
 *  上传文件
 */
static NSString *const GoogleDriveUploadFilePath = @"upload/drive/v3/files?uploadType=resumable";

/**
 *  iCloud Drive相关常量配置
 */

/**
 *  登录
 */
static NSString *const  iCloudDriveAuthSinginBaseURL= @"https://idmsa.apple.com";
/**
 *  登录第一步路径
 */
static NSString *const  iCloudDriveAuthSinginPath= @"appleauth/auth/signin";
/**
 *  得到和验证安全码路径
 */
static NSString *const  iCloudDriveGetAndVerifySecuritycodePath= @"appleauth/auth/verify/trusteddevice/securitycode";

static NSString *const  iCloudDriveAuthAcountLoginBaseURL= @"https://setup.icloud.com";
/**
 *  登录最后一步路径
 */
static NSString *const  iCloudDriveAuthAcountLoginPath= @"setup/ws/1/accountLogin?clientBuildNumber=%@&clientId=%@&clientMasteringNumber=%@";

/**
 *  注销
 */
static NSString *const iCloudDriveLogoutBaseURL = @"https://www.icloud.com";

/**
 *  上传
 */
static NSString *const iCloudDriveUploadOnePath = @"ws/com.apple.CloudDocs/upload/web";
static NSString *const iCloudDriveUploadThreePath = @"ws/com.apple.CloudDocs/update/documents";

/**
 *  validate 如果记住密码 第二次通过cookies直接登录
 */
static NSString *const iCloudDriveValidateBaseURL = @"https://setup.icloud.com";
static NSString *const iCloudDriveValidatePath = @"setup/ws/1/validate";

/**
 *  可用空间
 */
static NSString *const iCloudDriveUsedStorage = @"/setup/ws/1/storageUsageInfo?clientBuildNumber=17AHotfix1&clientMasteringNumber=17AHotfix1&dsid=%@";









