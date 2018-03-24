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

@implementation IMBDropBoxManage
- (id)initWithUserID:(NSString *)userID withDelegate:(id)delegate {
    if ([super initWithUserID:userID withDelegate:delegate]) {
        _driveDataAry = [[NSMutableArray alloc]init];
        _userID = userID;
        _dropbox = [[Dropbox alloc]initWithFromLocalOAuth:YES];
        _dropbox.userID = [_userID retain];
        [_dropbox setDelegate:self];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sessionDic = [defaults objectForKey:@"DropBoxSessionKey"];
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
    [_dropbox getList:@"0" success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *ary = [dic objectForKey:@"entries"];
        
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
            NSString *isFolder = [resDic objectForKey:@".tag"];
            
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
            drviceEntity.fileLoadURL = downFileLoadURL;
            drviceEntity.createdDateString = createdString;
            drviceEntity.lastModifiedDateString = lastModifiedString;
            drviceEntity.fileName = fileName;
            drviceEntity.fileSize = size;
            drviceEntity.fileSystemCreatedDate = fileSystemCreatedDate;
            drviceEntity.fileSystemLastDate = fileSystemLastDate;
            drviceEntity.fileID = fileID;
            drviceEntity.docwsid = fileID;
            if ([isFolder isEqualToString:@"folder"]) {
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
            [_deivceDelegate switchViewController];
        });
    } fail:^(DriveAPIResponse *response) {
        //todo 获取数据失败
    }];
    
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID {
    [_dropbox getList:folerID success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *ary = [dic objectForKey:@"entries"];
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        for (NSMutableDictionary *resDic in ary) {
            //文件下载路径
//            NSString *downFileLoadURL = [resDic objectForKey:@"@microsoft.graph.downloadUrl"];
            NSString *createdString = [self dateForm2001DateSting:[resDic objectForKey:@"client_modified"]];
            NSString *lastModifiedString = [self dateForm2001DateSting:[resDic objectForKey:@"server_modified"]];
            
            NSString *fileName = [resDic objectForKey:@"name"];
            long long size = [[resDic objectForKey:@"size"] longLongValue];
            NSMutableDictionary *fileSystemInfo = [resDic objectForKey:@"fileSystemInfo"];
            NSString *fileSystemCreatedDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"client_modified"]];
            NSString *fileSystemLastDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"server_modified"]];
            NSString *fileID = [resDic objectForKey:@"id"];
            
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
//            drviceEntity.fileLoadURL = downFileLoadURL;
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
            [_driveWindowDelegate loadSonAryComplete:dataAry];
        });
    } fail:^(DriveAPIResponse *response) {
        //todo 获取数据失败
        
    }];
}

- (void)driveDidLogOut:(BaseDrive *)drive {
    if ([drive isKindOfClass:[Dropbox class]]) { //将记录在本地的登录信息删掉
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
- (void)oneDriveDownloadOneItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_dropbox downloadItem:item];
}

//上传
- (void)oneDriveUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_dropbox uploadItem:item];
}

- (void)deleteDriveItem:(NSMutableArray *)deleteItemAry {
    [_dropbox deleteFilesOrFolders:deleteItemAry success:^(DriveAPIResponse *response) {
        
    } fail:^(DriveAPIResponse *response) {
        
    }];
}

- (void)userDidLogout {
    [_dropbox userDidLogout];
}

//时间转换
- (NSString *)dateForm2001DateSting:(NSString *)dateSting {
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
    [_dropbox release];
    _dropbox = nil;
    
}

@end
