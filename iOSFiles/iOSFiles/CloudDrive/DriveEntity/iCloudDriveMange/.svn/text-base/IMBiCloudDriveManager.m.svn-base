//
//  IMBiCloudDriveManager.m
//  iOSFiles
//
//  Created by JGehry on 3/1/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBiCloudDriveManager.h"
#import "DateHelper.h"
#import "StringHelper.h"
#import "IMBiCloudDriverViewController.h"
#import "IMBDeviceViewController.h"
#import "IMBCommonTool.h"
#import "DriveItem.h"
@implementation IMBiCloudDriveManager

- (id)initWithUserID:(NSString *) userID WithPassID:(NSString*) passID WithDelegate:(id)delegate isRememberPassCode:(BOOL)isRememberPassCode{
    if ([super initWithUserID:userID WithPassID:passID WithDelegate:delegate]) {
        _userID = [userID retain];
        _isRememberPassCode = isRememberPassCode;
        _passWordID = [passID retain];
        _driveDataAry = [[NSMutableArray alloc]init];
        _iCloudDrive = [[iCloudDrive alloc]init];
        [_iCloudDrive setDelegate:self];
        
        _deivceDelegate = delegate;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *cookie = [defaults objectForKey:@"iCloud"];
        if (cookie) {
            [_iCloudDrive loginWithCookie:cookie];
        }else{
            [_iCloudDrive loginAppleID:_userID password:_passWordID rememberMe:YES];
        }
    }
    return self;
}

- (void)driveDidLogIn:(BaseDrive *)drive {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:0 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:CiCloud action:ALogin label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    if (_isRememberPassCode) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //保存访问令牌和刷新令牌到本地
        [defaults setObject:_iCloudDrive.cookie forKey:@"iCloud"];
        [defaults synchronize];
    }
    [_iCloudDrive getUsedStorage:@"0" success:^(DriveAPIResponse *response) {
        NSDictionary *storageDic = [response.content objectForKey:@"storageUsageInfo"];
        iCloudDrive *icloudDrive = (iCloudDrive *)drive;
        _iCloudDrive.userName = icloudDrive.userName;
        if ([storageDic.allKeys containsObject:@"totalStorageInBytes"]) {
            _iCloudDrive.totalStorageInBytes = [[storageDic objectForKey:@"totalStorageInBytes"] longLongValue];
        }
        if ([storageDic.allKeys containsObject:@"usedStorageInBytes"]) {
            _iCloudDrive.usedStorageInBytes = [[storageDic objectForKey:@"usedStorageInBytes"] longLongValue];
        }
    } fail:^(DriveAPIResponse *response) {
//         [(IMBDeviceViewController *)_deivceDelegate loadDataFial];
    }];
    [_iCloudDrive getList:@"0" success:^(DriveAPIResponse *response) {
        NSMutableArray *ary = response.content;
        NSMutableDictionary *dic = [ary objectAtIndex:0];
        NSMutableArray *sonDic = [dic objectForKey:@"items"];
        for (NSDictionary *itemDic in sonDic) {
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
            [self createDriveEntity:drviceEntity ItemDic:itemDic];
            [_driveDataAry addObject:drviceEntity];
            [drviceEntity release];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_deivceDelegate switchiCloudDriveViewControllerWithiCloudDrive:_iCloudDrive];
        });
    } fail:^(DriveAPIResponse *response) {
        [IMBCommonTool showSingleBtnAlertInMainWindow:@"iCloud" btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudLogin_Load_Error", nil) btnClickedBlock:^{
            //            [self removeLoginLoadingAnimation];
             [(IMBDeviceViewController *)_deivceDelegate loadDataFial];
        }];
    }];
}

- (void)userDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:_userID];
    [_iCloudDrive userDidLogout];
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID {
    [_iCloudDrive getList:folerID success:^(DriveAPIResponse *response) {
        NSMutableArray *ary = response.content;
        NSMutableDictionary *dic = [ary objectAtIndex:0];
        NSMutableArray *sonDic = [dic objectForKey:@"items"];
         NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        for (NSDictionary *itemDic in sonDic) {
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
            [self createDriveEntity:drviceEntity ItemDic:itemDic];
            [dataAry addObject:drviceEntity];
            [drviceEntity release];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [(IMBiCloudDriverViewController *)_driveWindowDelegate loadTransferComplete:dataAry WithEvent:loadAction];
            [dataAry release];
        });
    } fail:^(DriveAPIResponse *response) {
//        [(IMBDeviceViewController *)_deivceDelegate loadDataFial];
        [IMBCommonTool showSingleBtnAlertInMainWindow:@"iCloud" btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudLogin_Load_Error", nil) btnClickedBlock:^{
//            [self removeLoginLoadingAnimation];
        }];
    }];
}

- (void)createDriveEntity:(IMBDriveEntity *)drviceEntity ItemDic:(NSDictionary *)itemDic {
    NSString *createdString = [self dateForm2001DateSting:[itemDic objectForKey:@"dateChanged"]];
    NSString *lastModifiedString = [self dateForm2001DateSting:[itemDic objectForKey:@"dateModified"]];
    NSString *docwsid = [itemDic objectForKey:@"docwsid"];
    NSString *extension = [itemDic objectForKey:@"extension"];
    NSString *name = [itemDic objectForKey:@"name"];
    long long  size = [[itemDic objectForKey:@"size"] intValue];
    NSString *file = [itemDic objectForKey:@"type"];
    NSString *zone = [itemDic objectForKey:@"zone"];
    NSString *drivewsid = [itemDic objectForKey:@"drivewsid"];
    NSString *etag = [itemDic objectForKey:@"etag"];
    if (![StringHelper stringIsNilOrEmpty:extension]) {
        extension = [extension lowercaseString];
    }
    
    drviceEntity.createdDateString = createdString;
    drviceEntity.lastModifiedDateString = lastModifiedString;
    drviceEntity.fileName = name;
    drviceEntity.fileSize = size;
    drviceEntity.zone = zone;
    drviceEntity.etag = etag;
    drviceEntity.fileID = drivewsid;
    drviceEntity.docwsid = docwsid;
    drviceEntity.extension = extension;
    
    if ([file isEqualToString:@"FOLDER"]) {
        drviceEntity.isFolder = YES;
        drviceEntity.image = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
        drviceEntity.extension = file;
    }else {
        drviceEntity.image = [TempHelper loadFileImage:extension];
    }
}

- (void)driveDidLogOut:(BaseDrive *)drive {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:0 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:CiCloud action:ALogout label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [_iCloudDrive userDidLogout];
}

- (void)drive:(BaseDrive *)drive logInFailWithError:(NSError *)error {
    
}


//登录错误
- (void)drive:(iCloudDrive *)iCloudDrive logInFailWithResponseCode:(ResponseCode)responseCode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:_userID];
    [(IMBDeviceViewController *)_deivceDelegate driveLogInFial:responseCode];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:0 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:CiCloud action:ALogin label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

- (void)driveNeedSecurityCode:(iCloudDrive *)iCloudDrive {
    [_deivceDelegate driveNeedSecurityCode:iCloudDrive];
}

- (void)setTwoCodeID:(NSString *)twoCodeID {
    [_iCloudDrive verifySecurityCode:twoCodeID rememberMe:YES];
}

- (IBAction)codeDown:(id)sender {
//
}

#pragma mark -- OneDrive Action
//下载单个
- (void)oneDriveDownloadOneItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [[_iCloudDrive downLoader] setDownloadPath:_downloadPath];
    [_iCloudDrive downloadItem:item];
}

//下载多个
- (void)driveDownloadItemsToMac:(NSArray<id<DownloadAndUploadDelegate>> *)items {
    [[_iCloudDrive downLoader] setDownloadPath:_downloadPath];
    [_iCloudDrive downloadItems:items];
}

//上传单个
- (void)oneDriveUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_iCloudDrive uploadItem:item];
}

//上传多个
- (void)driveUploadItems:(NSArray<id<DownloadAndUploadDelegate>> *)items {
    [_iCloudDrive uploadItems:items];
}

//删除
- (void)deleteDriveItem:(NSMutableArray *)deleteItemAry {
    __block NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:0 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [_iCloudDrive deleteFilesOrFolders:deleteItemAry success:^(DriveAPIResponse *response) {
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [(IMBiCloudDriverViewController *)_driveWindowDelegate loadTransferComplete:dataAry WithEvent:deleteAction];
            [dataAry release];
        });
        [ATTracker event:CiCloud action:ADelete label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    } fail:^(DriveAPIResponse *response) {
        [ATTracker event:CiCloud action:ADelete label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }];
}

//重命名
- (void)reNameWithDic:(NSDictionary *)dic {
    __block NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:0 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [_iCloudDrive reName:dic success:^(DriveAPIResponse *response) {
        [ATTracker event:CiCloud action:ARename label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    } fail:^(DriveAPIResponse *response) {
        [ATTracker event:CiCloud action:ARename label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }];
}

- (void)cancelDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_iCloudDrive cancelDownloadItem:item];
}

//新建文件夹
- (void)createFolder:(NSString *)folderName parent:(NSString *)parentID withEntity:(nullable IMBDriveEntity*)drviceEntity {
    __block NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:0 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [_iCloudDrive createFolder:folderName parent:parentID success:^(DriveAPIResponse *response) {
        NSDictionary *contentDic = response.content;
        BOOL ret = NO;
        if (contentDic) {
            if ([contentDic.allKeys containsObject:@"folders"]) {
                NSArray *itemArray = [contentDic objectForKey:@"folders"];
                if (itemArray.count > 0) {
                    NSDictionary *itemDic = [itemArray objectAtIndex:0];
                    ret = YES;
                    [self createDriveEntity:drviceEntity ItemDic:itemDic];
                }
            }
        }
        [ATTracker event:CiCloud action:ACreateFolder label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [(IMBiCloudDriverViewController *)_driveWindowDelegate loadTransferComplete:[NSMutableArray arrayWithObjects:[NSNumber numberWithBool:ret], drviceEntity, nil] WithEvent:createFolder];
        });
    } fail:^(DriveAPIResponse *response) {
        [ATTracker event:CiCloud action:ACreateFolder label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [(IMBiCloudDriverViewController *)_driveWindowDelegate loadTransferComplete:[NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO], drviceEntity, nil] WithEvent:createFolder];
        });
    }];
}

//移动文件
- (void)moveToNewParent:(NSString *)newParent itemDics:(NSArray *)items {
    __block NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:0 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [_iCloudDrive moveToNewParent:newParent itemDics:items success:^(DriveAPIResponse *response) {
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
        [ATTracker event:CiCloud action:AMove label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [(IMBiCloudDriverViewController *)_driveWindowDelegate loadTransferComplete:dataAry WithEvent:deleteAction];
            [dataAry release];
        });
        
    } fail:^(DriveAPIResponse *response) {
        [ATTracker event:CiCloud action:AMove label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [IMBCommonTool showSingleBtnAlertInMainWindow:@"iCloud" btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudLogin_Load_Error", nil) btnClickedBlock:^{
        }];
    }];
}

- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_iCloudDrive cancelUploadItem:item];
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

- (void)toDrive:(BaseDrive * _Nonnull)targetDrive item:(NSMutableArray *)item{
    for (DriveItem *drive in item) {
        [_iCloudDrive toDrive:targetDrive item:drive];
    }
}

- (void)dealloc {
    [super dealloc];

    [_iCloudDrive release];
    _iCloudDrive = nil;
}

@end
