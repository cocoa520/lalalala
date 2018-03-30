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
            NSString *extension = [fileName pathExtension];
            if (![StringHelper stringIsNilOrEmpty:extension]) {
                extension = [extension lowercaseString];
            }
            
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
                drviceEntity.isFolder = YES;
                drviceEntity.image = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
                drviceEntity.extension = @"Folder";
            }else{
                FileTypeEnum type = [StringHelper getFileFormatWithExtension:extension];
                NSImage *image;
                if (type == ImageFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_img"];
                } else if (type == MusicFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_music"];
                } else if (type == MovieFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_video"];
                } else if (type == TxtFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_txt"];
                } else if (type == DocFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_doc"];
                } else if (type == BookFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_books"];
                } else if (type == PPtFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_ppt"];
                } else if (type == ZIPFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_zip"];
                } else if (type == dmgFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_dmg"];
                } else if (type == contactFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_contacts"];
                } else if (type == excelFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_excel"];
                } else {
                    image = [NSImage imageNamed:@"cnt_fileicon_common"];
                }
                drviceEntity.image = image;
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

            NSString *createdString = [self dateForm2001DateSting:[resDic objectForKey:@"client_modified"]];
            NSString *lastModifiedString = [self dateForm2001DateSting:[resDic objectForKey:@"server_modified"]];
            
            NSString *fileName = [resDic objectForKey:@"name"];
            long long size = [[resDic objectForKey:@"size"] longLongValue];
            NSMutableDictionary *fileSystemInfo = [resDic objectForKey:@"fileSystemInfo"];
            NSString *fileSystemCreatedDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"client_modified"]];
            NSString *fileSystemLastDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"server_modified"]];
            NSString *fileID = [resDic objectForKey:@"id"];
            NSString *extension = [fileName pathExtension];
            if (![StringHelper stringIsNilOrEmpty:extension]) {
                extension = [extension lowercaseString];
            }
            
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
            drviceEntity.createdDateString = createdString;
            drviceEntity.lastModifiedDateString = lastModifiedString;
            drviceEntity.fileName = fileName;
            drviceEntity.fileSize = size;
            drviceEntity.fileSystemCreatedDate = fileSystemCreatedDate;
            drviceEntity.fileSystemLastDate = fileSystemLastDate;
            drviceEntity.fileID = fileID;
            drviceEntity.extension = extension;
            
            if ([resDic.allKeys containsObject:@"folder"]) {
                NSMutableDictionary *folderDic = [resDic objectForKey:@"folder"];
                int childCount = [[folderDic objectForKey:@"childCount"] intValue];
                drviceEntity.isFolder = YES;
                drviceEntity.childCount = childCount;
                drviceEntity.image = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
                drviceEntity.extension = @"Folder";
            }else{
                FileTypeEnum type = [StringHelper getFileFormatWithExtension:extension];
                NSImage *image;
                if (type == ImageFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_img"];
                } else if (type == MusicFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_music"];
                } else if (type == MovieFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_video"];
                } else if (type == TxtFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_txt"];
                } else if (type == DocFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_doc"];
                } else if (type == BookFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_books"];
                } else if (type == PPtFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_ppt"];
                } else if (type == ZIPFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_zip"];
                } else if (type == dmgFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_dmg"];
                } else if (type == contactFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_contacts"];
                } else if (type == excelFile) {
                    image = [NSImage imageNamed:@"cnt_fileicon_excel"];
                } else {
                    image = [NSImage imageNamed:@"cnt_fileicon_common"];
                }
                drviceEntity.image = image;
            }
            [dataAry addObject:drviceEntity];
            [drviceEntity release];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_driveWindowDelegate loadTransferComplete:dataAry WithEvent:loadAction];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [_driveWindowDelegate loadTransferComplete:dataAry WithEvent:deleteAction];
            [dataAry release];
        });
    } fail:^(DriveAPIResponse *response) {
        
    }];
}

//重命名
- (void)reName:(NSString *)newName idOrPath:(NSString *)idOrPath {
    [_dropbox reName:newName idOrPath:idOrPath success:^(DriveAPIResponse *response) {
        
    } fail:^(DriveAPIResponse *response) {
        
    }];
}

- (void)cancelDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_dropbox cancelDownloadItem:item];
}

//新建文件夹
- (void)createFolder:(NSString *)folderName parent:(NSString *)parentID {
    [_dropbox createFolder:folderName parent:parentID success:^(DriveAPIResponse *response) {
        
    } fail:^(DriveAPIResponse *response) {
        
    }];
}

//移动文件
- (void)moveToNewParent:(NSString *)newParent sourceParent:(NSString *)parent idOrPaths:(NSArray *)idOrPaths {
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [_driveWindowDelegate loadTransferComplete:dataAry WithEvent:deleteAction];
            [dataAry release];
        });
    } fail:^(DriveAPIResponse *response) {
        
    }];
}

- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_dropbox cancelUploadItem:item];
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
