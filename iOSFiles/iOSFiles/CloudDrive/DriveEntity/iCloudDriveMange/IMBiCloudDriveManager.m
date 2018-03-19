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

@class IMBDeviceViewController;
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

- (void)driveDidLogIn:(BaseDrive *)drive{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //保存访问令牌和刷新令牌到本地
    [defaults setObject:_iCloudDrive.cookie forKey:_userID];
    [defaults synchronize];
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
            
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
            drviceEntity.createdDateString = createdString;
            drviceEntity.lastModifiedDateString = lastModifiedString;
            drviceEntity.fileName = name;
            drviceEntity.fileSize = size;
            drviceEntity.zone = zone;
            drviceEntity.etag = etag;
            drviceEntity.fileID = docwsid;
            drviceEntity.docwsid = drivewsid;
            drviceEntity.extension = extension;
            
            if ([file isEqualToString:@"FOLDER"]) {
                OSType code = UTGetOSTypeFromString((CFStringRef)@"fldr");
                NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];
                drviceEntity.isFolder = YES;
                drviceEntity.image = [picture retain];
                drviceEntity.extension = @"Folder";
            }else{
                NSWorkspace *workSpace = [[NSWorkspace alloc] init];
                NSImage *icon = [workSpace iconForFileType:extension];
                drviceEntity.image = [icon retain];
                [workSpace release];
            }
            [_driveDataAry addObject:drviceEntity];
            [drviceEntity release];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_deivceDelegate switchiCloudDriveViewController];
        });
    } fail:^(DriveAPIResponse *response) {
        
    }];
    
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        [self loadDriveData];
    //    });
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID{
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
            
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
            drviceEntity.createdDateString = createdString;
            drviceEntity.lastModifiedDateString = lastModifiedString;
            drviceEntity.fileName = name;
            drviceEntity.fileSize = size;
            drviceEntity.etag = etag;
            drviceEntity.fileID = docwsid;
            drviceEntity.docwsid = drivewsid;
            drviceEntity.extension = extension;
            
            if ([file isEqualToString:@"FOLDER"]) {
                OSType code = UTGetOSTypeFromString((CFStringRef)@"fldr");
                NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];
                drviceEntity.isFolder = YES;
                drviceEntity.image = [picture retain];
                drviceEntity.extension = @"Folder";
            }else{
                NSWorkspace *workSpace = [[NSWorkspace alloc] init];
                NSImage *icon = [workSpace iconForFileType:extension];
                drviceEntity.image = [icon retain];
                [workSpace release];
            }
            [dataAry addObject:drviceEntity];
            [drviceEntity release];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [(IMBiCloudDriverViewController *)_driveWindowDelegate loadSonAryComplete:dataAry];
            [dataAry release];
        });
    } fail:^(DriveAPIResponse *response) {
        
    }];

}

- (void)driveDidLogOut:(BaseDrive *)drive{
    
}

- (void)drive:(BaseDrive *)drive logInFailWithError:(NSError *)error{
   
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

- (void)setTwoCodeID:(NSString *)twoCodeID{
    [_iCloudDrive verifySecurityCode:twoCodeID rememberMe:YES];
}

- (IBAction)codeDown:(id)sender {
//
}

#pragma mark -- OneDrive Action
//下载
- (void)oneDriveDownloadOneItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_iCloudDrive downloadItem:item];
}
//上传
- (void)oneDriveUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_iCloudDrive uploadItem:item];
}

- (void)deleteDriveItem:(NSMutableArray *) deleteItemAry {
    [_iCloudDrive deleteFilesOrFolders:deleteItemAry success:^(DriveAPIResponse *response) {
        
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

- (void)dealloc {
    [super dealloc];

    [_iCloudDrive release];
    _iCloudDrive = nil;
}

@end
