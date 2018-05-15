//
//  IMBCloudManager.m
//  
//
//  Created by ding ming on 18/4/9.
//
//

#import "IMBCloudManager.h"
#import "IMBBoxManager.h"
#import "IMBGoogleManager.h"
#import "IMBDropBoxManager.h"
#import "IMBPCloudManager.h"
#import "IMBOneDriveManager.h"

@implementation IMBCloudManager
@synthesize driveManager = _driveManager;
@synthesize curEmail = _curEmail;
@synthesize curPassword = _curPassword;
@synthesize cloudManagerDic = _cloudManagerDic;
@synthesize categroyAryM = _categroyAryM;
@synthesize contentCloudDicM = _contentCloudDicM;
@synthesize iCloudDriveManager = _iCloudDriveManager;
@synthesize transferViewController = _transferViewController;
@synthesize userTable = _userTable;
@synthesize isLoadingHistory = _isLoadingHistory;
@synthesize starAry = _starAry;

- (id)init {
    if (self=[super init]) {
        _driveManager = [[LoginAuthorizationDrive alloc] init];
        _driveManager.delegate = self;
        _nc = [NSNotificationCenter defaultCenter];
        _cloudManagerDic = [[NSMutableDictionary alloc] init];
        _categroyAryM = [[NSMutableArray alloc] init];
        _contentCloudDicM = [[NSMutableDictionary alloc] init];
        _isLoadingHistory = NO;
        _starAry = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (IMBCloudManager*)singleton {
    static IMBCloudManager *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBCloudManager alloc] init];
        }
    }
    return _singleton;
}

#pragma mark - 创建账号、登录账号、退出账号、增加云盘、删除云盘、置顶云盘、获取绑定云盘、刷新所有绑定云盘等方法
- (void)createAccount:(NSString *)account Password:(NSString *)password ConfirmPassword:(NSString *)confirmPassword {
    [_driveManager userRegisterWithEmail:account withPassword:password withConfirmPassword:confirmPassword];
}

- (void)loginAccount:(NSString *)account Password:(NSString *)password G2FCode:(NSString *)g2fcode IsNeedCode:(BOOL)needCode {
    if (_curEmail) {
        [_curEmail release];
        _curEmail = nil;
    }
    if (_curPassword) {
        [_curPassword release];
        _curPassword = nil;
    }
    if (_userTable) {
        [_userTable release];
        _userTable = nil;
    }
    _userTable = [[IMBUserHistoryTable alloc] initWithPath:nil];
    _curEmail = [account retain];
    _curPassword = [password retain];
    [_driveManager userLoginWithEmail:account withPassword:password withG2FCode:g2fcode withIsNeedCode:needCode];
}

- (void)logoutAccount {
    if (_curEmail) {
        [_curEmail release];
        _curEmail = nil;
    }
    if (_curPassword) {
        [_curPassword release];
        _curPassword = nil;
    }
    if (_transferViewController) {
        [_transferViewController release];
        _transferViewController = nil;
    }
    if (_userTable) {
        [_userTable release];
        _userTable = nil;
    }
    [_starAry removeAllObjects];
    [_cloudManagerDic removeAllObjects];
    [_categroyAryM removeAllObjects];
    [_contentCloudDicM removeAllObjects];
    [_driveManager userLogout];
}

- (void)addCloud:(NSString *)cloudName {
    [_driveManager driveAuthorizedWithName:cloudName];
}

- (void)deleteCloud:(BaseDrive *)drive {
    [_driveManager driveCancelAuthorizedWithName:drive];
}

- (void)driveTopIndexWithDrive:(BaseDrive *)indexdrive {
    [_driveManager driveTopIndexWithDrive:indexdrive];
}

- (BaseDrive *)getBindDrive:(NSString *)driveID {
    return [_driveManager getSaveDrive:driveID];
}

- (void)getDriveCategoryList {
    [_driveManager getDriveCategoryList];
}

- (void)refresh {
    [_driveManager refreshCurrentUserDrive];
}

#pragma mark - 历史记录、分享、收藏、垃圾箱的获取、添加、删除方法
- (void)getContentList:(NSString *)type {
    if ([type isEqualToString:@"history"]) {
        if (!_isLoadingHistory) {
            [_driveManager.accessHistory getListWithPageLimit:100 withPageIndex:0 success:^(DriveAPIResponse *response) {
                NSLog(@"response:%@",response);
                NSDictionary *dic = [response content];
                NSArray *dataAry = nil;
                if (dic && [dic.allKeys containsObject:@"data"]) {
                    dataAry = [dic objectForKey:@"data"];
                }
                [_userTable analysisHistoryRecords:dataAry];
                [_nc postNotificationName:HistoryDriveSuccessedNotification object:nil userInfo:nil];
                _isLoadingHistory = NO;
            } fail:^(DriveAPIResponse *response) {
                NSLog(@"response:%@",response);
                [_userTable analysisHistoryRecords:nil];
                [_nc postNotificationName:HistoryDriveErroredNotification object:nil userInfo:nil];
                _isLoadingHistory = NO;
            }];
        }else {
            NSLog(@"Loading History");
        }
    }else if ([type isEqualToString:@"share"]) {
        
    }else if ([type isEqualToString:@"star"]) {
        [_starAry removeAllObjects];
        [_driveManager.collectionFavorite getListWithPageLimit:100 withPageIndex:0 success:^(DriveAPIResponse *response) {
            NSLog(@"response:%@",response);
            NSDictionary *dic = [response content];
            NSArray *dataAry = nil;
            if (dic && [dic.allKeys containsObject:@"data"]) {
                dataAry = [dic objectForKey:@"data"];
            }
            [self getDetailContent:dataAry ContentArray:_starAry];
        } fail:^(DriveAPIResponse *response) {
            NSLog(@"response:%@",response);
            
            
        }];
    }else if ([type isEqualToString:@"trash"]) {
        
    }
}

- (void)addContent:(NSArray *)contentArray Type:(NSString *)type DriveID:(NSString *)driveID {
    if ([type isEqualToString:@"history"]) {
        BaseDrive *drive = [self getBindDrive:driveID];
        NSMutableArray *idArray = [NSMutableArray array];
        for (IMBFilesHistoryEntity *entity in contentArray) {
            NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:entity.pathID, @"itemIDOrPath", [NSNumber numberWithBool:entity.isFolder], @"isFolder", nil];
            if (entity.albumID) {
                [itemDict setObject:entity.albumID forKey:@"albumID"];
            }
            [idArray addObject:itemDict];
        }
        [_driveManager.accessHistory addCollectionOrHistory:drive idOrPathArray:idArray success:^(DriveAPIResponse *response) {
            NSLog(@"response seccuss:%@",response);
            IMBFilesHistoryEntity *entity = [[IMBFilesHistoryEntity alloc] init];
            if (response.content) {
                entity.cloudID = [response.content objectForKey:@"drive_id"];
                entity.pathID = [response.content objectForKey:@"path_id"];
                entity.itemName = [response.content objectForKey:@"name"];
                entity.isFolder = [[response.content objectForKey:@"is_folder"] boolValue];
                entity.serverName = drive.driveType;
                entity.path = [response.content objectForKey:@"path"];
                entity.size = [response.content objectForKey:@"size"];
                entity.createTime = [response.content objectForKey:@"updated_at"];
                entity.userID = [response.content objectForKey:@"user_id"];
                entity.albumID = [response.content objectForKey:@"album_id"];
                entity.isSync = YES;
            }
            [_userTable updateSqlite:entity];
            [entity release];
            entity = nil;
            
            
        } fail:^(DriveAPIResponse *response) {
            NSLog(@"response error:%@",response);
            
            
        }];
    }else if ([type isEqualToString:@"share"]) {
        
    }else if ([type isEqualToString:@"star"]) {
        BaseDrive *drive = [self getBindDrive:driveID];
        NSMutableArray *idArray = [NSMutableArray array];
        for (IMBDriveModel *entity in contentArray) {
            NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:entity.itemIDOrPath, @"itemIDOrPath", [NSNumber numberWithBool:entity.isFolder], @"isFolder", nil];
//            if (entity.albumID) {
//                [itemDict setObject:entity.albumID forKey:@"albumID"];
//            }
            [idArray addObject:itemDict];
        }
        [_driveManager.collectionFavorite addCollectionOrHistory:drive idOrPathArray:idArray success:^(DriveAPIResponse *response) {
            NSLog(@"response seccuss:%@",response);
            
        } fail:^(DriveAPIResponse *response) {
            NSLog(@"response error:%@",response);
            
        }];
    }else if ([type isEqualToString:@"trash"]) {
        
    }
}

- (void)getDetailContent:(NSArray *)dataAry ContentArray:(NSMutableArray *)contentAry {
    if (dataAry) {
        for (NSDictionary *dic in dataAry) {
            if (dic) {
                IMBDriveModel *driveModel = [[IMBDriveModel alloc] init];
                if ([dic.allKeys containsObject:@"created_at"]) {
                    driveModel.createdDateString = [dic objectForKey:@"created_at"];
                }
                if ([dic.allKeys containsObject:@"drive_id"]) {
                    driveModel.driveID = [dic objectForKey:@"drive_id"];
                }
                if ([dic.allKeys containsObject:@"is_folder"]) {
                    driveModel.isFolder = [[dic objectForKey:@"is_folder"] boolValue];
                }
                if ([dic.allKeys containsObject:@"path"]) {
                    driveModel.filePath = [dic objectForKey:@"path"];
                }
                if ([dic.allKeys containsObject:@"path_id"]) {
                    driveModel.itemIDOrPath = [dic objectForKey:@"path_id"];
                }
                if ([dic.allKeys containsObject:@"size"]) {
//                driveModel.fileSize = [dic objectForKey:@"size"];
                }
                if ([dic.allKeys containsObject:@"user_id"]) {
//                driveModel.user = [dic objectForKey:@"user_id"];
                }
                if ([dic.allKeys containsObject:@"album_id"]) {
                    
                }
                if ([dic.allKeys containsObject:@"file_extension"]) {
                    driveModel.extension = [dic objectForKey:@"file_extension"];
                }
                if ([dic.allKeys containsObject:@"name"]) {
                    driveModel.fileName = [dic objectForKey:@"name"];
                    driveModel.displayName = [driveModel.fileName stringByDeletingPathExtension];
                    if ([StringHelper stringIsNilOrEmpty:driveModel.extension]) {
                        driveModel.extension = [driveModel.fileName pathExtension];
                    }
                }
                if (driveModel.isFolder) {
                    driveModel.fileTypeEnum = Folder;
                    driveModel.extension = @"Folder";
                    if ([driveModel.fileName containsString:@".app" options:0]) {
                        driveModel.fileTypeEnum = AppFile;
                        driveModel.isFolder = NO;
                        driveModel.extension = @"app";
                    }
                }else{
                    driveModel.fileTypeEnum = [TempHelper getFileFormatWithExtension:driveModel.extension];
                }
                driveModel.iConimage = [TempHelper loadFileImage:driveModel.fileTypeEnum];
                driveModel.transferImage = [TempHelper loadFileTransferImage:driveModel.fileTypeEnum];
                [contentAry addObject:driveModel];
                [driveModel release];
                driveModel = nil;
            }
        }
    }
}

#pragma mark - BaseDriveDelegate 各个cloud登录回调方法
- (void)driveDidLogIn:(BaseDrive *)drive {
    if ([drive isKindOfClass:[LoginAuthorizationDrive class]]) {
        //管理所有的云盘登录类 拥有我们自己的令牌
        [_nc postNotificationName:AccountLoginSuccessedNotification object:nil userInfo:nil];
    }else if ([drive isKindOfClass:[GoogleDrive class]]) {
        
    }else if ([drive isKindOfClass:[OneDrive class]]){
        
    }
    NSLog(@"成功登录回调此方法");
}

- (void)driveDidLogOut:(BaseDrive *)drive {
    if ([drive isKindOfClass:[LoginAuthorizationDrive class]]) {
        //管理所有的云盘登录类 拥有我们自己的令牌
        [_nc postNotificationName:AccountLogoutSuccessedNotification object:nil userInfo:nil];
    }else if ([drive isKindOfClass:[GoogleDrive class]]) {
        
    }else if ([drive isKindOfClass:[OneDrive class]]){
        
    }
    NSLog(@"注销登录回调此方法");
    
}

//请求成功
- (void)driveAPIRequest:(BaseDrive *)drive withSuccess:(NSDictionary *)successDict withType:(NSString *)type {
    if ([drive isKindOfClass:[LoginAuthorizationDrive class]]) {
        if ([type isEqualToString:@"register"]) {
            NSLog(@"Register ResponseDict: %@", successDict);
            [_nc postNotificationName:AccountCreateSuccessedNotification object:nil userInfo:nil];
        }else if ([type isEqualToString:@"login"]) {
            NSLog(@"Login ResponseDict: %@", successDict);
            
        }else if ([type isEqualToString:@"bindDrive"]) {
            NSLog(@"bindDrive ResponseDict: %@", successDict);
            [_nc postNotificationName:BindDriveSuccessedNotification object:successDict userInfo:nil];
        }else if ([type isEqualToString:@"setTopIndex"]) {
            NSLog(@"setTopIndex ResponseDict: %@", successDict);
            
        }else if ([type isEqualToString:@"driveCategory"]) {
            NSLog(@"driveCategory ResponseDict: %@", successDict);
            [self getDriveCategorySeccussed:successDict];
        }else if ([type isEqualToString:@"cancelAuth"]) {
            NSLog(@"driveCategory ResponseDict: %@", successDict);
            [_nc postNotificationName:DeleteDriveSuccessedNotification object:successDict userInfo:nil];
        }else if ([type isEqualToString:@"refreshCloud"]) {
            NSLog(@"refreshCloud ResponseDict: %@", successDict);
            [_nc postNotificationName:RefreshDriveSuccessedNotification object:successDict userInfo:nil];
        }
    }
}

//请求失败
- (void)driveAPIRequest:(BaseDrive *)drive withFailed:(NSDictionary *)errorDict withType:(NSString *)type {
    if ([drive isKindOfClass:[LoginAuthorizationDrive class]]) {
        if ([type isEqualToString:@"register"]) {
            NSLog(@"Register error ResponseDict: %@", errorDict);
            [_nc postNotificationName:AccountCreateErroredNotification object:nil userInfo:errorDict];
        }else if ([type isEqualToString:@"login"]) {
            NSLog(@"Login error ResponseDict: %@", errorDict);
            [_nc postNotificationName:AccountLoginErroredNotification object:nil userInfo:errorDict];
        }else if ([type isEqualToString:@"bindDrive"]) {
            NSLog(@"bindDrive error ResponseDict: %@", errorDict);
            [_nc postNotificationName:BindDriveErroredNotification object:nil userInfo:errorDict];
        }else if ([type isEqualToString:@"setTopIndex"]) {
            NSLog(@"setTopIndex error ResponseDict: %@", errorDict);
            
        }else if ([type isEqualToString:@"driveCategory"]) {
            NSLog(@"driveCategory error ResponseDict: %@", errorDict);
            [self getDriveCategoryErrored];
        }else if ([type isEqualToString:@"cancelAuth"]) {
            NSLog(@"driveCategory error ResponseDict: %@", errorDict);
            [_nc postNotificationName:DeleteDriveErroredNotification object:errorDict userInfo:nil];
        }else if ([type isEqualToString:@"refreshCloud"]) {
            NSLog(@"refreshCloud ResponseDict: %@", errorDict);
            [_nc postNotificationName:RefreshDriveErroredNotification object:errorDict userInfo:nil];
        }
    }
}

//令牌方式登录 错误回调
- (void)drive:(BaseDrive *)drive logInFailWithError:(NSError *)error {
    NSLog(@"登录出错回调此方法");
    
}

//用户名和密码方式登录 错误回调
- (void)drive:(BaseDrive *)drive logInFailWithResponseCode:(ResponseCode)responseCode {
    NSLog(@"登录出错回调此方法 主要是用户密码方式登录");
    if ([drive isKindOfClass:[LoginAuthorizationDrive class]]) {
        
    }
}

//表明需要二次验证 回调给给界面弹出安全码验证框
- (void)driveNeedSecurityCode:(BaseDrive *)drive {
    NSLog(@"主要是icloud 二次验证登录回调");
    
}

//账号被锁住了
- (void)driveAccountLocked:(BaseDrive *)drive {
    NSLog(@"主要是icloud 账号锁住回调");
}

- (void)getDriveCategorySeccussed:(NSDictionary *)obj {
    if (obj) {
        for (NSString *key in obj.allKeys) {
            NSArray *itemAry = [obj objectForKey:key];
            if (itemAry) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *itemDic in itemAry) {
                    IMBCloudEntity *cloudEntity = [[IMBCloudEntity alloc] init];
                    cloudEntity.name = [itemDic objectForKey:@"name"];
                    cloudEntity.usersNumber = [[itemDic objectForKey:@"users"] intValue];
                    cloudEntity.service = [itemDic objectForKey:@"service"];
                    cloudEntity.category = [itemDic objectForKey:@"category"];
                    cloudEntity.popular = [[itemDic objectForKey:@"popular"] intValue];
                    [self setNewCloudEntity:cloudEntity];
                    [array addObject:cloudEntity];
                    [cloudEntity release];
                }
                if (array.count > 0) {
                    [_contentCloudDicM setObject:array forKey:key];
                    [_categroyAryM addObject:key];
               }
            }
        }
        
    }
    if (_categroyAryM.count == 0) {
        //设置默认的云盘
        [self addDefultCloud];
    }else {
        [_categroyAryM addObject:@"mycloud"];
    }
}

- (void)getDriveCategoryErrored {
    //设置默认的云盘
    [self addDefultCloud];
}

- (void)addDefultCloud {
    NSMutableArray *array = [NSMutableArray array];
    
    //个人云盘
    IMBCloudEntity *pcloud = [[IMBCloudEntity alloc] init];
    pcloud.name = CustomLocalizedString(@"AddCloud_pCloud", nil);
    pcloud.image = [NSImage imageNamed:@"add_pcloud"];
    pcloud.usersNumber = 0;
    pcloud.category = @"personal";
    pcloud.popular = 0;
    pcloud.service = @"pcloud";
    pcloud.categoryCloudEnum = PCloudEnum;
    [array addObject:pcloud];
    [pcloud release], pcloud = nil;
    
    IMBCloudEntity *box = [[IMBCloudEntity alloc] init];
    box.name = CustomLocalizedString(@"AddCloud_box", nil);
    box.image = [NSImage imageNamed:@"add_box"];
    box.usersNumber = 0;
    box.category = @"personal";
    box.popular = 0;
    box.service = @"box";
    box.categoryCloudEnum = BoxEnum;
    [array addObject:box];
    [box release], box = nil;
    
    IMBCloudEntity *dropBox = [[IMBCloudEntity alloc] init];
    dropBox.name = CustomLocalizedString(@"AddCloud_dropBox", nil);
    dropBox.image = [NSImage imageNamed:@"add_dropbox"];
    dropBox.usersNumber = 0;
    dropBox.category = @"personal";
    dropBox.popular = 1;
    dropBox.service = @"dropbox";
    dropBox.categoryCloudEnum = DropBoxEnum;
    [array addObject:dropBox];
    [dropBox release], dropBox = nil;
    
    IMBCloudEntity *google = [[IMBCloudEntity alloc] init];
    google.name = CustomLocalizedString(@"AddCloud_google", nil);
    google.image = [NSImage imageNamed:@"add_google"];
    google.usersNumber = 0;
    google.category = @"personal";
    google.popular = 1;
    google.service = @"google";
    google.categoryCloudEnum = GoogleEnum;
    [array addObject:google];
    [google release], google = nil;
    
    IMBCloudEntity *oneDrive = [[IMBCloudEntity alloc] init];
    oneDrive.name = CustomLocalizedString(@"AddCloud_oneDrive", nil);
    oneDrive.image = [NSImage imageNamed:@"add_onedrive"];
    oneDrive.usersNumber = 0;
    oneDrive.category = @"personal";
    oneDrive.popular = 1;
    oneDrive.service = @"onedrive";
    oneDrive.categoryCloudEnum = OneDriveEnum;
    [array addObject:oneDrive];
    [oneDrive release], oneDrive = nil;
    
    [_contentCloudDicM setObject:array forKey:@"personal"];
    [_categroyAryM addObject:@"personal"];
    
    //流行云盘
    NSMutableArray *popArray = [NSMutableArray array];
    dropBox = [[IMBCloudEntity alloc] init];
    dropBox.name = CustomLocalizedString(@"AddCloud_dropBox", nil);
    dropBox.image = [NSImage imageNamed:@"add_dropbox"];
    dropBox.usersNumber = 0;
    dropBox.category = @"popular";
    dropBox.popular = 1;
    dropBox.service = @"dropbox";
    dropBox.categoryCloudEnum = DropBoxEnum;
    [popArray addObject:dropBox];
    [dropBox release], dropBox = nil;
    
    google = [[IMBCloudEntity alloc] init];
    google.name = CustomLocalizedString(@"AddCloud_google", nil);
    google.image = [NSImage imageNamed:@"add_google"];
    google.usersNumber = 0;
    google.category = @"popular";
    google.popular = 1;
    google.service = @"google";
    google.categoryCloudEnum = GoogleEnum;
    [popArray addObject:google];
    [google release], google = nil;
    
    oneDrive = [[IMBCloudEntity alloc] init];
    oneDrive.name = CustomLocalizedString(@"AddCloud_oneDrive", nil);
    oneDrive.image = [NSImage imageNamed:@"add_onedrive"];
    oneDrive.usersNumber = 0;
    oneDrive.category = @"popular";
    oneDrive.popular = 1;
    oneDrive.service = @"onedrive";
    oneDrive.categoryCloudEnum = OneDriveEnum;
    [popArray addObject:oneDrive];
    [oneDrive release], oneDrive = nil;
    
    [_contentCloudDicM setObject:popArray forKey:@"popular"];
    [_categroyAryM addObject:@"popular"];
    
    [_categroyAryM addObject:@"mycloud"];
}

- (void)setNewCloudEntity:(IMBCloudEntity *)cloudEntity {
    if ([cloudEntity.service isEqualToString:@"onedrive"]) {
        cloudEntity.image = [NSImage imageNamed:@"add_onedrive"];
        cloudEntity.categoryCloudEnum = OneDriveEnum;
        cloudEntity.name = CustomLocalizedString(@"AddCloud_oneDrive", nil);
    }else if ([cloudEntity.service isEqualToString:@"google"]) {
        cloudEntity.image = [NSImage imageNamed:@"add_google"];
        cloudEntity.categoryCloudEnum = GoogleEnum;
        cloudEntity.name = CustomLocalizedString(@"AddCloud_google", nil);
    }else if ([cloudEntity.service isEqualToString:@"dropbox"]) {
        cloudEntity.image = [NSImage imageNamed:@"add_dropbox"];
        cloudEntity.categoryCloudEnum = DropBoxEnum;
        cloudEntity.name = CustomLocalizedString(@"AddCloud_dropBox", nil);
    }else if ([cloudEntity.service isEqualToString:@"box"]) {
        cloudEntity.image = [NSImage imageNamed:@"add_box"];
        cloudEntity.categoryCloudEnum = BoxEnum;
        cloudEntity.name = CustomLocalizedString(@"AddCloud_box", nil);
    }else if ([cloudEntity.service isEqualToString:@"pcloud"]) {
        cloudEntity.image = [NSImage imageNamed:@"add_pcloud"];
        cloudEntity.categoryCloudEnum = PCloudEnum;
        cloudEntity.name = CustomLocalizedString(@"AddCloud_pCloud", nil);
    }else if ([cloudEntity.service isEqualToString:@"facebook"]) {
        cloudEntity.image = [NSImage imageNamed:@"add_facebook"];
        cloudEntity.categoryCloudEnum = FaceBookEnum;
        cloudEntity.name = CustomLocalizedString(@"AddCloud_faceBook", nil);
    }else if ([cloudEntity.service isEqualToString:@"twitter"]) {
        cloudEntity.image = [NSImage imageNamed:@"add_twitter"];
        cloudEntity.categoryCloudEnum = TwitterEnum;
        cloudEntity.name = CustomLocalizedString(@"AddCloud_twitter", nil);
    }else if ([cloudEntity.service isEqualToString:@"instagram"]) {
        cloudEntity.image = [NSImage imageNamed:@"add_ins"];
        cloudEntity.categoryCloudEnum = InsEnum;
        cloudEntity.name = CustomLocalizedString(@"AddCloud_ins", nil);
    }else if ([cloudEntity.service isEqualToString:@"googlephoto"]) {
        cloudEntity.image = [NSImage imageNamed:@"add_googlephoto"];
        cloudEntity.categoryCloudEnum = GooglePhotoEnum;
        cloudEntity.name = CustomLocalizedString(@"AddCloud_googlePhoto", nil);
    }else if ([cloudEntity.service isEqualToString:@"sumsung"]) {
        cloudEntity.image = [NSImage imageNamed:@"add_sumsung"];
        cloudEntity.categoryCloudEnum = SumsungEnum;
        cloudEntity.name = CustomLocalizedString(@"AddCloud_sumsung", nil);
    }
}

#pragma mark - 获取/保存云盘的管理类
- (void)saveCloudManager:(BaseDrive *)baseDrive {
    if (![_cloudManagerDic.allKeys containsObject:baseDrive.driveID]) {
        [self createCloudManager:baseDrive];
    }
}

- (IMBBaseManager *)getCloudManager:(BaseDrive *)baseDrive {
    if ([_cloudManagerDic.allKeys containsObject:baseDrive.driveID]) {
        return [_cloudManagerDic objectForKey:baseDrive.driveID];
    }else {
        [self createCloudManager:baseDrive];
        if ([_cloudManagerDic.allKeys containsObject:baseDrive.driveID]) {
            return [_cloudManagerDic objectForKey:baseDrive.driveID];
        }
    }
    return nil;
}

- (void)removeCloudManager:(BaseDrive *)baseDrive {
    if ([_cloudManagerDic.allKeys containsObject:baseDrive.driveID]) {
        [_cloudManagerDic removeObjectForKey:baseDrive.driveID];
    }
}

- (void)createCloudManager:(BaseDrive *)baseDrive {
    IMBBaseManager *baseManager = nil;
    if ([baseDrive.driveType isEqualToString:OneDriveCSEndPointURL]) {
        baseManager = [[IMBOneDriveManager alloc] initWithDrive:baseDrive];
    }else if ([baseDrive.driveType isEqualToString:DropboxCSEndPointURL]) {
        baseManager = [[IMBDropBoxManager alloc] initWithDrive:baseDrive];
    }else if ([baseDrive.driveType isEqualToString:BoxCSEndPointURL]) {
        baseManager = [[IMBBoxManager alloc] initWithDrive:baseDrive];
    }else if ([baseDrive.driveType isEqualToString:GoogleDriveCSEndPointURL]) {
        baseManager = [[IMBGoogleManager alloc] initWithDrive:baseDrive];
    }else if ([baseDrive.driveType isEqualToString:PCloudCSEndPointURL]) {
        baseManager = [[IMBPCloudManager alloc] initWithDrive:baseDrive];
    }
    if (baseManager) {
        [_cloudManagerDic setObject:baseManager forKey:baseDrive.driveID];
    }
    [baseManager release];
}

@end
