//
//  IMBDropBoxManage.m
//  iOSFiles
//
//  Created by JGehry on 3/12/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBDropBoxManage.h"
#import "IMBDriveEntity.h"
#import "StringHelper.h"
#import "DateHelper.h"
#import "IMBDeviceViewController.h"
#import "IMBBaseViewController.h"
#import "TempHelper.h"
#import "DriveItem.h"
#import "IMBCommonTool.h"

@implementation IMBDropBoxManage
- (id)initWithUserID:(NSString *)userID withDelegate:(id)delegate {
    if ([super initWithUserID:userID withDelegate:delegate]) {
        _driveDataAry = [[NSMutableArray alloc]init];
        _userID = userID;
        _dropbox = [[Dropbox alloc]initWithFromLocalOAuth:YES];
        _dropbox.userID = [_userID retain];
        [_dropbox setDelegate:self];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sessionDic = [defaults objectForKey:@"kAppAuthDropboxStateKey"];
        if (sessionDic) {
            NSString *accessToken = [sessionDic objectForKey:@"accessToken"];
            NSString *refreshToken = [sessionDic objectForKey:@"refreshToken"];
            NSDate *expirationDate = [sessionDic objectForKey:@"expirationDate"];
            _dropbox.accessToken = accessToken;
            _dropbox.refreshToken = refreshToken;
            _dropbox.expirationDate = expirationDate;
            [self loadDriveData];
        }else{
            [_dropbox logIn];
        }
        _deivceDelegate = delegate;
    }
    return self;
}

#pragma mark -- OneDrive Login
- (void)driveDidLogIn:(BaseDrive *)drive {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:1 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:CDropbox action:ALogin label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [_dropbox driveSetAccessTokenKey];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sessionDic = [NSDictionary dictionaryWithObjectsAndKeys:drive.accessToken,@"accessToken",drive.refreshToken ,@"refreshToken",drive.expirationDate,@"expirationDate", nil];
    //保存访问令牌和刷新令牌到本地
    [defaults setObject:sessionDic forKey:@"oneDriveSessionKey"];
    [defaults synchronize];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadDriveData];
    });
}

- (void)loadDriveData {
    
    [_dropbox getSpaceUsage:@"" success:^(DriveAPIResponse *response) {
        NSLog(@"");
        NSMutableDictionary *dic = response.content;
        NSDictionary *allocationDic = [dic objectForKey:@"allocation"];
        long long usedSize = [[dic objectForKey:@"used"] longLongValue];
        long long allocatedSize = [[allocationDic objectForKey:@"allocated"] longLongValue];
        _dropbox.usedStorageInBytes = usedSize;
        _dropbox.totalStorageInBytes = allocatedSize;
    } fail:^(DriveAPIResponse *response) {
        NSLog(@"");
    }];
    [_dropbox getAccount:@"" success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        //        NSString *account_id = [dic objectForKey:@"account_id"];
        //        NSString *email = [dic objectForKey:@"email"];
        //        NSString *email_verified = [dic objectForKey:@"email_verified"];
        NSDictionary *nameDic = [dic objectForKey:@"name"];
        NSString *displayName = [nameDic objectForKey:@"display_name"];
        _dropbox.userID = displayName;
    } fail:^(DriveAPIResponse *response) {
        NSLog(@"");
    }];
    
    
    [_dropbox getList:@"0" success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *ary = [dic objectForKey:@"entries"];
        
        for (NSMutableDictionary *resDic in ary) {
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
            [self createDriveEntity:drviceEntity ResDic:resDic];
            [_driveDataAry addObject:drviceEntity];
            [drviceEntity release];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_deivceDelegate switchViewControllerDropBox:_dropbox];
        });
    } fail:^(DriveAPIResponse *response) {
        [IMBCommonTool showSingleBtnAlertInMainWindow:nil btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudLogin_Load_Error", nil) btnClickedBlock:^{
            //            [self removeLoginLoadingAnimation];
            [(IMBDeviceViewController *)_deivceDelegate loadDataFial];

        }];
    }];
    
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID {
    
    [_dropbox getList:folerID success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *ary = [dic objectForKey:@"entries"];
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        for (NSMutableDictionary *resDic in ary) {
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
            [self createDriveEntity:drviceEntity ResDic:resDic];
            [dataAry addObject:drviceEntity];
            [drviceEntity release];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_driveWindowDelegate loadTransferComplete:dataAry WithEvent:loadAction];
        });
    } fail:^(DriveAPIResponse *response) {
        [IMBCommonTool showSingleBtnAlertInMainWindow:@"DropBox" btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudLogin_Load_Error", nil) btnClickedBlock:^{
//            [self removeLoginLoadingAnimation];
        }];
        //todo 获取数据失败
//        [(IMBDeviceViewController *)_deivceDelegate loadDataFial];
    }];
}

- (void)createDriveEntity:(IMBDriveEntity *)drviceEntity ResDic:(NSDictionary *)resDic {
    //文件下载路径
    NSString *downFileLoadURL = [resDic objectForKey:@"@microsoft.graph.downloadUrl"];
    NSString *createdString = [self dateForm2001DateSting:[resDic objectForKey:@"server_modified"]];
    NSString *lastModifiedString = [self dateForm2001DateSting:[resDic objectForKey:@"client_modified"]];
    
    NSString *fileName = [resDic objectForKey:@"name"];
    long long size = [[resDic objectForKey:@"size"] longLongValue];
    NSMutableDictionary *fileSystemInfo = [resDic objectForKey:@"fileSystemInfo"];
    NSString *fileSystemCreatedDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"createdDateTime"]];
    NSString *fileSystemLastDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"lastModifiedDateTime"]];
    NSString *fileID = [resDic objectForKey:@"id"];
    NSString *isFolder = [resDic objectForKey:@".tag"];
    NSString *extension = [fileName pathExtension];
    NSString *path = [resDic objectForKey:@"path_display"];
    if (![StringHelper stringIsNilOrEmpty:extension]) {
        extension = [extension lowercaseString];
    }
    
    drviceEntity.fileLoadURL = downFileLoadURL;
    drviceEntity.createdDateString = createdString;
    drviceEntity.lastModifiedDateString = lastModifiedString;
    drviceEntity.fileName = [fileName stringByDeletingPathExtension];
    drviceEntity.fileSize = size;
    drviceEntity.fileSystemCreatedDate = fileSystemCreatedDate;
    drviceEntity.fileSystemLastDate = fileSystemLastDate;
    drviceEntity.fileID = fileID;
    drviceEntity.docwsid = fileID;
    drviceEntity.filePath = path;
    if ([isFolder isEqualToString:@"folder"]) {
        drviceEntity.isFolder = YES;
        drviceEntity.image = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
        drviceEntity.extension = @"Folder";
    }else{
        drviceEntity.image = [TempHelper loadFileImage:extension];
        drviceEntity.extension = extension;
    }
}

- (void)driveDidLogOut:(BaseDrive *)drive {
    if ([drive isKindOfClass:[Dropbox class]]) { //将记录在本地的登录信息删掉
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; [defaults removeObjectForKey:@"oneDriveSessionKey"];
        [defaults synchronize];
        drive.accessToken = nil;
        drive.refreshToken = nil;
        drive.expirationDate = nil;
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            [TempHelper customViewType:1 withCategoryEnum:0];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:CDropbox action:ALogout label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }
}

- (void)drive:(BaseDrive *)drive logInFailWithError:(NSError *)error {
    //登录授权发  错误 在此处进 处
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:1 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:CDropbox action:ALogin label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

#pragma mark -- OneDrive Action
//下载单个
- (void)oneDriveDownloadOneItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [[_dropbox downLoader] setDownloadPath:_downloadPath];
    [_dropbox downloadItem:item];
}

//下载多个
- (void)driveDownloadItemsToMac:(NSArray<id<DownloadAndUploadDelegate>> *)items {
    [[_dropbox downLoader] setDownloadPath:_downloadPath];
    [_dropbox downloadItems:items];
}

//上传单个
- (void)oneDriveUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_dropbox uploadItem:item];
}

//上传多个
- (void)driveUploadItems:(NSArray<id<DownloadAndUploadDelegate>> *)items {
    [_dropbox uploadItems:items];
}

//删除
- (void)deleteDriveItem:(NSMutableArray *)deleteItemAry {
    __block NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:1 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [_dropbox deleteFilesOrFolders:deleteItemAry success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *array = [dic objectForKey:@"items"];
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in array) {
            NSString *status = @"";
            if ([dic.allKeys containsObject:@"status"]) {
                status = [dic objectForKey:@"status"];
            }
            if ([dic.allKeys containsObject:@"drivewsid"] && [status isEqualToString:@"OK"]) {
                [dataAry addObject:[dic objectForKey:@"drivewsid"]];
            }
        }
        [ATTracker event:CDropbox action:ADelete label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_driveWindowDelegate loadTransferComplete:dataAry WithEvent:deleteAction];
            [dataAry release];
        });
    } fail:^(DriveAPIResponse *response) {
        [ATTracker event:CDropbox action:ADelete label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }];
}

//重命名
- (void)reName:(NSString *)newName idOrPath:(NSString *)idOrPath {
    __block NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:1 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [_dropbox reName:newName idOrPath:idOrPath success:^(DriveAPIResponse *response) {
        [ATTracker event:CDropbox action:ARename label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    } fail:^(DriveAPIResponse *response) {
        [ATTracker event:CDropbox action:ARename label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }];
}

- (void)cancelDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_dropbox cancelDownloadItem:item];
}

//新建文件夹
- (void)createFolder:(NSString *)folderName parent:(NSString *)parentID withEntity:(nullable IMBDriveEntity *)drviceEntity {
    __block NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:1 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [_dropbox createFolder:folderName parent:parentID success:^(DriveAPIResponse *response) {
        [ATTracker event:CDropbox action:ACreateFolder label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        NSDictionary *resDic = response.content;
        BOOL ret = NO;
        if (resDic) {
            ret = YES;
            [self createDriveEntity:drviceEntity ResDic:resDic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_driveWindowDelegate loadTransferComplete:[NSMutableArray arrayWithObjects:[NSNumber numberWithBool:ret], drviceEntity, nil] WithEvent:createFolder];
        });
    } fail:^(DriveAPIResponse *response) {
        [ATTracker event:CDropbox action:ACreateFolder label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_driveWindowDelegate loadTransferComplete:[NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO], drviceEntity, nil] WithEvent:createFolder];
        });
    }];
}

//移动文件
- (void)moveToNewParent:(NSString *)newParent sourceParent:(NSString *)parent idOrPaths:(NSArray *)idOrPaths {
    __block NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:1 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [_dropbox moveToNewParent:newParent sourceParent:parent idOrPaths:idOrPaths success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *array = [dic objectForKey:@"items"];
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in array) {
            NSString *status = @"";
            if ([dic.allKeys containsObject:@"status"]) {
                status = [dic objectForKey:@"status"];
            }
            if ([dic.allKeys containsObject:@"drivewsid"] && [status isEqualToString:@"OK"]) {
                [dataAry addObject:[dic objectForKey:@"drivewsid"]];
            }
        }
        [ATTracker event:CDropbox action:AMove label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_driveWindowDelegate loadTransferComplete:dataAry WithEvent:deleteAction];
            [dataAry release];
        });
    } fail:^(DriveAPIResponse *response) {
        [ATTracker event:CDropbox action:AMove label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }];
}

- (void)toDrive:(BaseDrive * _Nonnull)targetDrive item:(NSMutableArray *)item{
    for (DriveItem *driveItem in item) {
         [_dropbox toDrive:targetDrive item:driveItem];
    }
   
}

- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_dropbox cancelUploadItem:item];
}

- (void)userDidLogout {
    [_dropbox userDidLogout];
}

//时间转换
- (NSString *)dateForm2001DateSting:(NSString *)dateSting {
    if(dateSting.length >= 19) {
        NSString *str = [dateSting substringToIndex:19];
        str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSDate *date = [DateHelper dateFromString:str Formate:@"yyyy-MM-dd HH:mm:ss" withTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
        NSTimeInterval interval1 = [DateHelper getTimeStampFrom1970Date:date withTimezone:[NSTimeZone localTimeZone]];
        NSString *str2 = [DateHelper dateFrom1970ToString:interval1 withMode:2];
        return str2;
    }else {
        return @"--";
    }
}

#pragma mark -- iCloudDrive Action
-(void)dealloc {
    [super dealloc];
    [_dropbox release];
    _dropbox = nil;
    
}

@end
