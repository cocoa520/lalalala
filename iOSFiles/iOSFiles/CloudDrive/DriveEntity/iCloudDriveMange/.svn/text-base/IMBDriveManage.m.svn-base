//
//  IMBDriveManage.m
//  iOSFiles
//
//  Created by JGehry on 2/27/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBDriveManage.h"
#import "IMBDriveEntity.h"
#import "StringHelper.h"
#import "DateHelper.h"
@class IMBDeviceViewController;
#import "IMBDriveWindow.h"
@implementation IMBDriveManage
- (id)initWithUserID:(NSString *)userID withDelegate:(id)delegate{
    if ([super initWithUserID:userID withDelegate:delegate]) {
        _driveDataAry = [[NSMutableArray alloc]init];
        _userID = userID;
        _oneDrive = [[OneDrive alloc]initWithFromLocalOAuth:YES];
        _oneDrive.userID = [_userID retain];
        [_oneDrive setDelegate:self];
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sessionDic = [defaults objectForKey:@"oneDriveSessionKey"];
        if (sessionDic) {
            NSString *accessToken = [sessionDic objectForKey:@"accessToken"];
            NSString *refreshToken = [sessionDic objectForKey:@"refreshToken"];
            NSDate *expirationDate = [sessionDic objectForKey:@"expirationDate"];
            _oneDrive.accessToken = accessToken;
            _oneDrive.refreshToken = refreshToken;
            _oneDrive.expirationDate = expirationDate;
            [self loadDriveData];
        }else{
            [_oneDrive logIn];
        }
        _deivceDelegate = delegate;
    }
    return self;
}

#pragma mark -- OneDrive Login
- (void)driveDidLogIn:(BaseDrive *)drive {
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
    [_oneDrive getList:@"0" success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *ary = [dic objectForKey:@"value"];
        
        for (NSMutableDictionary *resDic in ary) {
            //文件下载路径
            NSString *downFileLoadURL = [resDic objectForKey:@"@microsoft.graph.downloadUrl"];
            NSString *createdString = [self dateForm2001DateSting:[resDic objectForKey:@"createdDateTime"]];
            NSString *lastModifiedString = [self dateForm2001DateSting:[resDic objectForKey:@"lastModifiedDateTime"]];
            
            NSString *fileName = [resDic objectForKey:@"name"];
            long long size = [[resDic objectForKey:@"size"] longLongValue];
            NSMutableDictionary *fileSystemInfo = [resDic objectForKey:@"fileSystemInfo"];
            NSString *fileSystemCreatedDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"createdDateTime"]];
            NSString *fileSystemLastDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"lastModifiedDateTime"]];
            NSString *fileID = [resDic objectForKey:@"id"];
            
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
            drviceEntity.fileLoadURL = downFileLoadURL;
            drviceEntity.createdDateString = createdString;
            drviceEntity.lastModifiedDateString = lastModifiedString;
            drviceEntity.fileName = fileName;
            drviceEntity.fileSize = size;
            drviceEntity.fileSystemCreatedDate = fileSystemCreatedDate;
            drviceEntity.fileSystemLastDate = fileSystemLastDate;
            drviceEntity.fileID = fileID;
            
            if ([resDic.allKeys containsObject:@"folder"]) {
                NSMutableDictionary *folderDic = [resDic objectForKey:@"folder"];
                int childCount = [[folderDic objectForKey:@"childCount"] intValue];
                drviceEntity.isFolder = YES;
                drviceEntity.childCount = childCount;
                OSType code = UTGetOSTypeFromString((CFStringRef)@"fldr");
                NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];
                drviceEntity.image = [picture retain];
            }else{
                NSString *extension = [drviceEntity.fileName pathExtension];
                NSWorkspace *workSpace = [[NSWorkspace alloc] init];
                NSImage *icon = [workSpace iconForFileType:extension];
                drviceEntity.image = [icon retain];
                [workSpace release];
            }
            [_driveDataAry addObject:drviceEntity];
            [drviceEntity release];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [(IMBDeviceViewController*)_deivceDelegate switchViewController];
        });
    } fail:^(DriveAPIResponse *response) {
        //todo 获取数据失败
    }];
    
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID{
        [_oneDrive getList:folerID success:^(DriveAPIResponse *response) {
            NSMutableDictionary *dic = response.content;
            NSMutableArray *ary = [dic objectForKey:@"value"];
            NSMutableArray *dataAry = [[NSMutableArray alloc]init];
            for (NSMutableDictionary *resDic in ary) {
                //文件下载路径
                NSString *downFileLoadURL = [resDic objectForKey:@"@microsoft.graph.downloadUrl"];
                NSString *createdString = [self dateForm2001DateSting:[resDic objectForKey:@"createdDateTime"]];
                NSString *lastModifiedString = [self dateForm2001DateSting:[resDic objectForKey:@"lastModifiedDateTime"]];
                
                NSString *fileName = [resDic objectForKey:@"name"];
                long long size = [[resDic objectForKey:@"size"] longLongValue];
                NSMutableDictionary *fileSystemInfo = [resDic objectForKey:@"fileSystemInfo"];
                NSString *fileSystemCreatedDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"createdDateTime"]];
                NSString *fileSystemLastDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"lastModifiedDateTime"]];
                NSString *fileID = [resDic objectForKey:@"id"];
                
                IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
                drviceEntity.fileLoadURL = downFileLoadURL;
                drviceEntity.createdDateString = createdString;
                drviceEntity.lastModifiedDateString = lastModifiedString;
                drviceEntity.fileName = fileName;
                drviceEntity.fileSize = size;
                drviceEntity.fileSystemCreatedDate = fileSystemCreatedDate;
                drviceEntity.fileSystemLastDate = fileSystemLastDate;
                drviceEntity.fileID = fileID;
                
                if ([resDic.allKeys containsObject:@"folder"]) {
                    NSMutableDictionary *folderDic = [resDic objectForKey:@"folder"];
                    int childCount = [[folderDic objectForKey:@"childCount"] intValue];
                    drviceEntity.isFolder = YES;
                    drviceEntity.childCount = childCount;
                    OSType code = UTGetOSTypeFromString((CFStringRef)@"fldr");
                    NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];
                    drviceEntity.image = [picture retain];
                }else{
                    NSString *extension = [drviceEntity.fileName pathExtension];
                    NSWorkspace *workSpace = [[NSWorkspace alloc] init];
                    NSImage *icon = [workSpace iconForFileType:extension];
                    drviceEntity.image = [icon retain];
                    [workSpace release];
                }
                [dataAry addObject:drviceEntity];
                [drviceEntity release];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [(IMBDriveWindow *)_driveWindowDelegate loadSonAryComplete:dataAry];
            });
        } fail:^(DriveAPIResponse *response) {
            //todo 获取数据失败
            
        }];
}

- (void)driveDidLogOut:(BaseDrive *)drive {
    if ([drive isKindOfClass:[OneDrive class]]) { //将记录在本地的登录信息删掉
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; [defaults removeObjectForKey:@"oneDriveSessionKey"];
        [defaults synchronize];
        drive.accessToken = nil;
        drive.refreshToken = nil;
        drive.expirationDate = nil;
    }
}

- (void)drive:(BaseDrive *)drive logInFailWithError:(NSError *)error {
    //登录授权发  错误 在此处进 处
}

#pragma mark -- OneDrive Action
//下载
- (void)oneDriveDownloadOneItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_oneDrive downloadItem:item];
}
//上传
- (void)oneDriveUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_oneDrive uploadItem:item];
}

- (void)deleteDriveItem:(NSMutableArray *) deleteItemAry {
    [_oneDrive deleteFilesOrFolders:deleteItemAry success:^(DriveAPIResponse *response) {
        
    } fail:^(DriveAPIResponse *response) {
        
    }];
}
//时间转换
- (NSString *)dateForm2001DateSting:(NSString *) dateSting {
    if ([StringHelper stringIsNilOrEmpty:dateSting] ) {
        return @"";
    }
    NSString *replacString = [dateSting stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString * replacString1 = [replacString substringToIndex:19];
    NSDate *replacDate = [DateHelper dateFromString:replacString1 Formate:nil];
    NSString *replacDateString = [DateHelper dateFrom2001ToDate:replacDate withMode:2];
    return replacDateString;
}

#pragma mark -- iCloudDrive Action


-(void)dealloc {
    [super dealloc];
    [_oneDrive release];
    _oneDrive = nil;

}

@end
