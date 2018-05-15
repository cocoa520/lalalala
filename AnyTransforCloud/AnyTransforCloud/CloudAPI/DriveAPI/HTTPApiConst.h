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
 *  注册
 */
static NSString *const WebRegisterEndPointURL = @"auth/register";
/**
 *  二次验证登录
 */
static NSString *const WebLoginCodeEndPointURL = @"auth/login/code";
/**
 *  第三方登录访问终结点
 */
static NSString *const WebUserEndPointURL = @"https://user.fuhanwen.cn/auth";
/**
 *  第三方退出
 */
static NSString *const WebLogoutEndPointURL = @"logout";
/**
 *  获取驱动器ID
 */
static NSString *const WebDriveListIDEndPointURL = @"drive";
/**
 *  获取驱动器分类
 */
static NSString *const WebDriveListCategoryIDEndPointURL = @"drive/category";
/**
 *  搜索文件及文件夹
 */
static NSString *const WebDriveSearchListPath = @"drive/%@/search";
/**
 *  令牌刷新
 */
static NSString *const WebRefreshEndPointURL = @"drive/%@/refresh";
/**
 *  云服务终结点
 */
static NSString *const CloudStorageEndPointURL = @"https://drive.fuhanwen.cn/api/drive";
/**
 *  云服务绑定授权终结点
 */
static NSString *const CloudStorageBindEndPointURL = @"bind/%@";
/**
 *  云服务取消授权终结点
 */
static NSString *const CloudStorageRemoveEndPointURL = @"%@";
/**
 *  云服务重命名终结点
 */
static NSString *const CloudStorageRenameEndPointURL = @"%@/rename";
/**
 *  云盘置顶
 */
static NSString *const CloudStorageTopIndexEndPointURL = @"drive/%@/top";
/**
 *  iCloud Drive 授权
 */
static NSString *const iCloudDriveCSEndPointURL = @"iclouddrive";
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
 *  PCloud 授权
 */
static NSString *const PCloudCSEndPointURL = @"pcloud";
/**
 *  Facebook 授权
 */
static NSString *const FacebookCSEndPointURL = @"facebook";
/**
 *  Twitter 授权
 */
static NSString *const TwitterCSEndPointURL = @"twitter";
/**
 *  Instagram 授权
 */
static NSString *const InstagramCSEndPointURL = @"instagram";

/**
 *  收藏配置
 */
/**
 *  收藏列表
 */
static NSString *const CollectionListPath = @"favorite?limit=%d&page=%d";
/**
 *  添加收藏，传入驱动器ID
 *  删除收藏，传入收藏ID
 *  修改收藏，传入收藏ID
 */
static NSString *const CollectionPath = @"favorite/%@";

/**
 *  访问历史记录配置
 */
/**
 *  访问历史列表
 */
static NSString *const HistoryListPath = @"history?limit=%d&page=%d";
/**
 *  添加访问历史记录，传入驱动器ID
 *  删除访问历史记录，传入收藏ID
 *  修改访问历史记录，传入收藏ID
 */
static NSString *const HistoryPath = @"history/%@";

/**
 *  分享配置
 */
/**
 *  收藏列表
 */
static NSString *const ShareListPath = @"share_file/list?limit=%d&page=%d";
/**
 *  添加分享，传入驱动器ID
 *  删除分享，传入分享ID
 *  修改分享，待定
 */
static NSString *const SharePath = @"share_file/%@";

/**
 *  分享发送邮件
 */
static NSString *const SendEmailSharePath = @"share_file/email/%@";

/**
 *  收藏分享配置
 */
/**
 *  访问历史列表
 */
static NSString *const CollectionShareListPath = @"share_favorite/list?limit=%d&page=%d";
/**
 *  添加收藏分享，传入收藏分享ID
 *  删除收藏分享，传入收藏分享ID
 */
static NSString *const CollectionSharePath = @"share_favorite/%@";

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
static NSString *const OneDriveFolderPath = @"me/drive/items/%@";
/**
 *  获取用户信息
 */
static NSString *const OneDriveGetCurrentAccount = @"me/drive";
/**
 *  创建文件夹路径
 */
static NSString *const OneDriveCreateFolderPath = @"me/drive/items/%@/children";
/**
 *  复制
 */
static NSString *const OneDriveCopyPath = @"me/drive/items/%@/copy";
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
 *  复制文件或者文件夹
 */
static NSString *const DropboxCopy = @"2/files/copy_v2";
/**
 *  复制多文件或者文件夹
 */
static NSString *const DropboxCopyMultiple = @"2/files/copy_batch";
/**
 *  检查复制多文件或者文件夹
 */
static NSString *const DropboxCopyMultipleCheck = @"2/files/copy_batch/check";
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
static NSString *const BoxGetRootListFolderAndFilePath = @"2.0/folders/0/items";  ///<默认根目录
static NSString *const BoxGetListFolderPath = @"2.0/folders/%@/items";            ///<当前目录信息及所有文件信息
static NSString *const BoxGetFolderPath = @"2.0/folders/%@";                        ///<当前目录信息
static NSString *const BoxGetListFilePath = @"2.0/files/%@";                ///<当前文件信息
/**
 *  获取用户信息
 */
static NSString *const BoxGetCurrentAccount = @"2.0/users/me";
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
 *  复制文件或者文件夹
 */
static NSString *const BoxFilesCopy = @"2.0/files/%@/copy";
static NSString *const BoxFoldersCopy = @"2.0/folders/%@/copy";
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
 *  获取用户信息
 */
static NSString *const GoogleDriveGetCurrentAccount = @"drive/v2/about";
/**
 *  获取文件列表有关路径
 */
static NSString *const GoogleDriveGetListPath = @"drive/v3/files";
/**
 *  获取文件夹有关路径
 */
static NSString *const GoogleDriveGetFolderPath = @"drive/v3/files/%@";
/**
 *  移动文件夹及文件
 */
static NSString *const GoogleDriveMoveFolderAndFilePath = @"drive/v3/files/%@?addParents=%@&removeParents=%@";
/**
 *  复制文件夹及文件
 */
static NSString *const GoogleDriveCopyFolderAndFilePath = @"drive/v3/files/%@/copy";
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
 *  Google Photo相关常量配置
 */
/**
 *  api访问终结点
 */
static NSString *const GooglePhotoAPIBaseURL = @"https://picasaweb.google.com";

/**
 *  获取Google photo albums列表
 */
static NSString *const GooglePhotoGetAlbumsListPath = @"data/feed/api/user/%@";

/**
 *  获取Google photo albums photo
 */
static NSString *const GooglePhotoGetAlbumsPhotoListPath = @"data/feed/api/user/%@/albumid/%@";




/**
 *  Facebook相关常量配置
 */
/**
 *  api访问终结点
 */
static NSString *const FacebookAPIBaseURL = @"https://graph.facebook.com";
static NSString *const FacebookAPIBaseURLWithVideo = @"https://graph-video.facebook.com";//上传发布视频需要
/**
 *  获取用户信息
 */
static NSString *const FacebookGetCurrentAccount = @"me";
/**
 *  创建相册
 */
static NSString *const FacebookCreateAlbumsPath = @"%@/albums";
/**
 *  获取所有相册
 */
static NSString *const FacebookGetListAlbumsPath = @"me/albums";
/**
 *  获取所有视频
 */
static NSString *const FacebookGetListVideosPath = @"me/videos/uploaded";
/**
 *  获取某个视频
 */
static NSString *const FacebookGetVideoPath = @"%@";
/**
 *  获取某个视频
 */
static NSString *const FacebookGetTimeLinePath = @"me/posts";
/**
 *  下载文件
 */
static NSString *const FacebookDownloadFilePath = @"%@";
/**
 *  上传视频（待以后追加）
 */

/**
 *  Twitter相关常量配置
 */
/**
 *  api访问终结点
 */
static NSString *const TwitterAPIBaseURL = @"https://api.twitter.com";
/**
 *  请求Token
 */
static NSString *const TwitterRequestTokenAPIURL = @"oauth/request_token";
/**
 *  授权Token
 */
static NSString *const TwitterAccessTokenAPIURL = @"oauth/access_token";
/**
 *  获取用户信息
 */
static NSString *const TwitterGetCurrentAccount = @"1.1/users/show.json?screen_name=%@";
/**
 *  获取媒体数据
 */
static NSString *const TwitterUpdateProfile = @"1.1/account/update_profile.json";
/**
 *  搜索
 */
static NSString *const TwitterSearch = @"1.1/users/search.json?q=%@";

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

static NSString *const  iCloudDriveGetSMSAndVerifySecuritycodePath= @"appleauth/auth/verify/phone";


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

/**
 *  instagram相关常量配置
 */
static NSString *const  InstagramBaseURL= @"https://api.instagram.com/v1";
static NSString *const  InstagramGetRecentMediaPath= @"users/self/media/recent/?access_token=%@";
static NSString *const  InstagramGetUserInfoPath= @"users/self/?access_token=%@";

/**
 *  pCloud相关常量配置
 */
static NSString *const  pCloudBaseURL= @"https://api.pcloud.com";
static NSString *const  pCloudGetUserInfoPath= @"userinfo";
static NSString *const  pCloudGetListPath = @"listfolder";
static NSString *const  pCloudCreateFolderPath = @"createfolder";
static NSString *const  pCloudReNameFilePath = @"renamefile";
static NSString *const  pCloudReNameFolderPath = @"renamefolder";
static NSString *const  pCloudCopyFilePath = @"copyfile";
static NSString *const  pCloudDeleteFolderPath = @"deletefolderrecursive";
static NSString *const  pCloudDeleteFilePath = @"deletefile";
static NSString *const  pCloudgetFileLinkPath = @"getfilelink";
static NSString *const  pCloudUploadPath = @"uploadfile";

/**
 *  离线任务相关配置
 */
/**
 *  获取等待执行的任务记录
 */
static NSString *const OfflineTaskWaitingURL = @"task/waiting";
/**
 *  获取正在执行的任务列表
 */
static NSString *const OfflineTaskRunningListURL = @"task/running";
/**
 *  取消正在执行的任务
 */
static NSString *const OfflineTaskCancelRunningURL = @"task/%@/cancel";
/**
 *  获取已完成的任务列表、清除已完成的任务记录
 */
static NSString *const OfflineTaskCompletedListURL = @"task/completed";
/**
 *  创建离线任务、修改离线任务
 */
static NSString *const OfflineTaskCreateURL = @"task";
/**
 *  删除离线任务
 */
static NSString *const OfflineTaskRemoveURL = @"task/%@";
