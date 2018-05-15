//
//  IMBiCloudDriveManager.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/25.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBiCloudDriveManager.h"

@implementation IMBiCloudDriveManager

- (id)initWithUserID:(NSString *) userID WithPassID:(NSString*) passID WithDelegate:(id)delegate isRememberPassCode:(BOOL)isRememberPassCode{
    if ([self init]) {
        _userID = [userID retain];
        _isRememberPassCode = isRememberPassCode;
       NSString *passWordID = [passID retain];
        _baseDrive  = [[iCloudDrive alloc]init];
        [_baseDrive setDelegate:self];
        _baseDrive.driveType = iCloudDriveCSEndPointURL;
        _baseDrive.driveName = CustomLocalizedString(@"AddCloud_iCloudDrive", nil);
        _delegete = delegate;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *cookie = [defaults objectForKey:@"iCloud"];
        if (cookie) {
            [(iCloudDrive *)_baseDrive loginWithCookie:cookie];
        }else{
            [(iCloudDrive *)_baseDrive loginAppleID:_userID password:passWordID rememberMe:YES];
        }
    }
    return self;
}

- (void)driveDidLogIn:(BaseDrive *)drive {
    if (_isRememberPassCode) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //保存访问令牌和刷新令牌到本地
        [defaults setObject:[(iCloudDrive *)_baseDrive cookie] forKey:@"iCloud"];
        [defaults synchronize];
    }
    [self recursiveDirectoryContentsDics:@"0"];
}

#pragma mark -- 获取数据
- (void)loadData {
    [self recursiveDirectoryContentsDics:@"0"];
}

- (void)getAccount {
//    [_baseDrive getUsedStorage:@"0" success:^(DriveAPIResponse *response) {
//        NSDictionary *storageDic = [response.content objectForKey:@"storageUsageInfo"];
//        iCloudDrive *icloudDrive = (iCloudDrive *)drive;
//        _iCloudDrive.userName = icloudDrive.userName;
//        if ([storageDic.allKeys containsObject:@"totalStorageInBytes"]) {
//            _iCloudDrive.totalStorageInBytes = [[storageDic objectForKey:@"totalStorageInBytes"] longLongValue];
//        }
//        if ([storageDic.allKeys containsObject:@"usedStorageInBytes"]) {
//            _iCloudDrive.usedStorageInBytes = [[storageDic objectForKey:@"usedStorageInBytes"] longLongValue];
//        }
//    } fail:^(DriveAPIResponse *response) {
//        //         [(IMBDeviceViewController *)_deivceDelegate loadDataFial];
//    }];
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID {
    [(iCloudDrive *)_baseDrive getList:folerID success:^(DriveAPIResponse *response) {
        NSMutableArray *ary = response.content;
        NSMutableDictionary *dic = [ary objectAtIndex:0];
        NSMutableArray *sonDic = [dic objectForKey:@"items"];
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        [self readSqlite];
        for (NSDictionary *itemDic in sonDic) {
            IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
            [self createDriveEntity:drviceEntity ItemDic:itemDic];
            [drviceEntity setDriveID:self.baseDrive.driveID];
            [self matchingSqlite:drviceEntity];
            [dataAry addObject:drviceEntity];
            [drviceEntity release];
        }
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:dataAry WithEvent:loadAction];
        }
        [dataAry release];
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:loadAction];
        }
    }];
}

- (void)createDriveEntity:(IMBDriveModel *)drviceEntity ItemDic:(NSDictionary *)itemDic {
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
    drviceEntity.displayName = [name stringByDeletingPathExtension];
    drviceEntity.fileSize = size;
    drviceEntity.zone = zone;
    drviceEntity.etag = etag;
    drviceEntity.fileID = drivewsid;
    drviceEntity.docwsID = docwsid ;
    drviceEntity.extension = extension;
    drviceEntity.itemIDOrPath = drivewsid;
    
    if ([file.lowercaseString isEqualToString:@"folder"]) {
        drviceEntity.isFolder = YES;
        drviceEntity.fileTypeEnum = Folder;
        drviceEntity.extension = @"Folder";
        if ([name containsString:@".app" options:0]) {
            drviceEntity.fileTypeEnum = AppFile;
            drviceEntity.isFolder = NO;
            drviceEntity.extension = @"app";
        }
    }else{
        drviceEntity.fileTypeEnum = [TempHelper getFileFormatWithExtension:extension];
        drviceEntity.extension = extension;
    }
    drviceEntity.iConimage = [TempHelper loadFileImage:drviceEntity.fileTypeEnum];
    drviceEntity.transferImage = [TempHelper loadFileTransferImage:drviceEntity.fileTypeEnum];
}

#pragma mark -- 功能方法
//删除
- (void)deleteDriveItem:(NSMutableArray *)deleteItemAry {
    [(iCloudDrive *)_baseDrive deleteFilesOrFolders:deleteItemAry success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *array = [dic objectForKey:@"items"];
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in array) {
            NSString *status = @"";
            if ([dic.allKeys containsObject:@"status"]) {
                status = [dic objectForKey:@"status"];
            }
            if ([dic.allKeys containsObject:@"drivewsid"] && [status isEqualToString:@"OK"]) {
                [dataAry addObject:@{@"itemIDOrPath":[dic objectForKey:@"drivewsid"]}];
            }
        }
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:dataAry WithEvent:deleteAction];
        }
        [dataAry release];
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:deleteAction];
        }
    }];
}

//重命名
- (void)reName:(NSString *_Nonnull)newName idOrPathArray:(NSArray *_Nonnull)idOrPathArray withEntity:(nullable IMBDriveModel *)drviceEntity{
    [_baseDrive reName:newName idOrPathArray:idOrPathArray success:^(DriveAPIResponse *response) {
       NSMutableArray *array = [response.content objectForKey:@"items"];
        NSMutableDictionary *dataDic = [array objectAtIndex:0];
        NSString *fileName = [dataDic objectForKey:@"name"];
        drviceEntity.fileName = fileName;
        drviceEntity.displayName = [fileName stringByDeletingPathExtension];
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:[NSMutableArray array] WithEvent:renameAction];
        }

    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:renameAction];
        }
    }];
}

//新建文件夹
- (void)createFolder:(NSString *)folderName parent:(NSString *)parentID withEntity:(nullable IMBDriveModel *)drviceEntity {
    
    [(iCloudDrive *)_baseDrive createFolder:folderName parent:parentID success:^(DriveAPIResponse *response) {
        NSDictionary *contentDic = response.content;
        if ([contentDic.allKeys containsObject:@"folders"]) {
            NSArray *itemArray = [contentDic objectForKey:@"folders"];
            if (itemArray.count > 0) {
                NSDictionary *itemDic = [itemArray objectAtIndex:0];
                [self createDriveEntity:drviceEntity ItemDic:itemDic];
            }
        }
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:[NSMutableArray arrayWithObject: drviceEntity] WithEvent:createFolder];
        }
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:createFolder];
        }
    }];
}

//移动文件
- (void)moveToNewParent:(NSString *_Nonnull)newParent idOrPaths:(NSArray *_Nonnull)idOrPaths {
    [(iCloudDrive *)_baseDrive moveToNewParentIDOrPath:newParent idOrPathArray:idOrPaths success:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:[NSMutableArray array] WithEvent:moveAction];
        }
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:moveAction];
        }
    }];
}

//- (void)copyToNewParentIDOrPath:(NSString * _Nonnull)newParentIdOrPath idOrPathArray:(NSArray * _Nonnull)idOrPathArray {
//    [_baseDrive copyToNewParentIDOrPath:newParentIdOrPath idOrPathArray:idOrPathArray success:^(DriveAPIResponse *response) {
//        NSMutableDictionary *dic = response.content;
//        NSMutableArray *ary = [dic objectForKey:@"metadata"];
//        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
//        for (NSMutableDictionary *resDic in ary) {
//            IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
//            [self createDriveEntity:drviceEntity ResDic:resDic];
//            [self matchingSqlite:drviceEntity];
//            [dataAry addObject:drviceEntity];
//        }
//        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
//            [_delegete loadDriveComplete:dataAry WithEvent:copyAction];
//        }
//        [dataAry release];
//        dataAry = nil;
//        
//        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
//            [_delegete loadDriveComplete:dataAry WithEvent:copyAction];
//        }
//    } fail:^(DriveAPIResponse *response) {
//        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
//            [_delegete loadDriveDataFail:copyAction];
//        }
//    }];
//}


- (void)userDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:_userID];
    [(iCloudDrive *)_baseDrive userDidLogout];
}

//时间转换  2018-04-09T05:23:19-07:00  T：他表示后面跟的时间   -07:00 ：时区
- (NSString *)dateForm2001DateSting:(NSString *)dateSting {
    if(dateSting.length >= 19) {
        //取到当前时区
        NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
        NSInteger seconds1 = [zone1 secondsFromGMT];
        //获取系统默认的时区
        NSString *differStr = [dateSting substringWithRange:NSMakeRange(20, 2)];
        int differTimeInt = [differStr intValue];
        
        NSString *str = [dateSting substringToIndex:19];
        str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        //转换
        NSDate *date = [DateHelper dateFromString:str Formate:@"yyyy-MM-dd HH:mm:ss" withTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
        NSTimeInterval interval1 = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
        //对时间
        NSTimeInterval endInterval1 = 0;
        if (seconds1 > 0) {
            endInterval1 = interval1 + (seconds1/60/60 +  differTimeInt) *60*60;
        }else {
            seconds1 = seconds1 *-1;
            NSInteger differ = (seconds1/60/60 - differTimeInt) *-1;
            endInterval1 = interval1 + differ*60*60;
        }
        NSString *str2 = [DateHelper dateFrom1970ToString:endInterval1 withMode:2];
        return str2;
    }else {
        return @"--";
    }
}

@end
