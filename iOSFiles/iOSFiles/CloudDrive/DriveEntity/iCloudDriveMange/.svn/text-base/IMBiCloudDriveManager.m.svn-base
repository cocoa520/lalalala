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

@implementation IMBiCloudDriveManager

- (id)initWithUserID:(NSString *) userID WithPassID:(NSString*) passID WithDelegate:(id)delegate {
    if ([super initWithUserID:userID WithPassID:passID WithDelegate:delegate]) {
        _userID = [userID retain];
        _passWordID = [passID retain];
        _driveDataAry = [[NSMutableArray alloc]init];
        _iCloudDrive = [[iCloudDrive alloc]init];
        [_iCloudDrive setDelegate:self];
        
        _deivceDelegate = delegate;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *cookie = [defaults objectForKey:_userID];
        if (cookie) {
            [_iCloudDrive loginWithCookie:cookie];
        }else{
            [_iCloudDrive loginAppleID:_userID password:_passWordID rememberMe:YES];
        }
    }
    return self;
}

- (void)driveDidLogIn:(BaseDrive *)drive {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //保存访问令牌和刷新令牌到本地
    [defaults setObject:_iCloudDrive.cookie forKey:_userID];
    [defaults synchronize];
    [_iCloudDrive getUsedStorage:@"0" success:^(DriveAPIResponse *response) {
        NSDictionary *storageDic = [response.content objectForKey:@"storageUsageInfo"];
        if ([storageDic.allKeys containsObject:@"totalStorageInBytes"]) {
            _iCloudDrive.totalStorageInBytes = [[storageDic objectForKey:@"totalStorageInBytes"] longLongValue];
        }
        if ([storageDic.allKeys containsObject:@"usedStorageInBytes"]) {
            _iCloudDrive.usedStorageInBytes = [[storageDic objectForKey:@"usedStorageInBytes"] longLongValue];
        }
    } fail:^(DriveAPIResponse *response) {
        NSLog(@"");
    }];
    [_iCloudDrive getList:@"0" success:^(DriveAPIResponse *response) {
        NSMutableArray *ary = response.content;
        NSMutableDictionary *dic = [ary objectAtIndex:0];
        NSMutableArray *sonDic = [dic objectForKey:@"items"];
        for (NSDictionary *itemDic in sonDic) {
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
            
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
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
                drviceEntity.extension = @"Folder";
            }else {
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
            [_deivceDelegate switchiCloudDriveViewControllerWithiCloudDrive:_iCloudDrive];
        });
    } fail:^(DriveAPIResponse *response) {
        
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
            NSString *createdString = [self dateForm2001DateSting:[itemDic objectForKey:@"dateChanged"]];
            NSString *lastModifiedString = [self dateForm2001DateSting:[itemDic objectForKey:@"dateModified"]];
            NSString *docwsid = [itemDic objectForKey:@"docwsid"];
            NSString *extension = [itemDic objectForKey:@"extension"];
            NSString *name = [itemDic objectForKey:@"name"];
            long long  size = [[itemDic objectForKey:@"size"] intValue];
            NSString *file = [itemDic objectForKey:@"type"];
            NSString *drivewsid = [itemDic objectForKey:@"drivewsid"];
            NSString *etag = [itemDic objectForKey:@"etag"];
            if (![StringHelper stringIsNilOrEmpty:extension]) {
                extension = [extension lowercaseString];
            }
            
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
            drviceEntity.createdDateString = createdString;
            drviceEntity.lastModifiedDateString = lastModifiedString;
            drviceEntity.fileName = name;
            drviceEntity.fileSize = size;
            drviceEntity.etag = etag;
            drviceEntity.docwsid = docwsid;
            drviceEntity.fileID = drivewsid;
            drviceEntity.extension = extension;
            
            if ([file isEqualToString:@"FOLDER"]) {
                drviceEntity.isFolder = YES;
                drviceEntity.image = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
                drviceEntity.extension = @"Folder";
            }else {
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
            [(IMBiCloudDriverViewController *)_driveWindowDelegate loadTransferComplete:dataAry WithEvent:loadAction];
            [dataAry release];
        });
    } fail:^(DriveAPIResponse *response) {
        
    }];

}

- (void)driveDidLogOut:(BaseDrive *)drive {
    [_iCloudDrive userDidLogout];
}

- (void)drive:(BaseDrive *)drive logInFailWithError:(NSError *)error {
   
}
//登录错误
- (void)drive:(iCloudDrive *)iCloudDrive logInFailWithResponseCode:(ResponseCode)responseCode {
    if (responseCode == ResponseUserNameOrPasswordError) {//密码或者账号错误
        
    }else if (responseCode == ResonseSecurityCodeError) {//<沿验证码错误
        
    }else if (responseCode == ResponseUnknown) {//未知错误
        
    }else if (responseCode == ResponseInvalid) {///<响应无效 一般参数错误
        
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *cookie = [defaults objectForKey:_userID];
    [defaults removeObjectForKey:_userID];
    [(IMBDeviceViewController *)_deivceDelegate driveLogInFial:responseCode];
}

- (void)driveNeedSecurityCode:(iCloudDrive *)iCloudDrive {
    
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
    } fail:^(DriveAPIResponse *response) {
        
    }];
}

//重命名
- (void)reNameWithDic:(NSDictionary *)dic {
    [_iCloudDrive reName:dic success:^(DriveAPIResponse *response) {
        
    } fail:^(DriveAPIResponse *response) {
        
    }];
}

- (void)cancelDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_iCloudDrive cancelDownloadItem:item];
}

//新建文件夹
- (void)createFolder:(NSString *)folderName parent:(NSString *)parentID {
    [_iCloudDrive createFolder:folderName parent:parentID success:^(DriveAPIResponse *response) {
        
    } fail:^(DriveAPIResponse *response) {
        
    }];
}

//移动文件
- (void)moveToNewParent:(NSString *)newParent itemDics:(NSArray *)items {
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [(IMBiCloudDriverViewController *)_driveWindowDelegate loadTransferComplete:dataAry WithEvent:deleteAction];
            [dataAry release];
        });
        
    } fail:^(DriveAPIResponse *response) {
        
    }];
}

- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_iCloudDrive cancelUploadItem:item];
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

- (void)dealloc {
    [super dealloc];

    [_iCloudDrive release];
    _iCloudDrive = nil;
}

@end
