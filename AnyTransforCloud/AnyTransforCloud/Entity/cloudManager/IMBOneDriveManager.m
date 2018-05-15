//
//  IMBOneDriveManager.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBOneDriveManager.h"

@implementation IMBOneDriveManager

- (void)loadData {
    [_baseDrive getList:@"0" success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *ary = [dic objectForKey:@"entries"];
        
        for (NSMutableDictionary *resDic in ary) {
            IMBBaseCloudManager *drviceEntity = [[IMBBaseCloudManager alloc]init];
            [self createDriveEntity:drviceEntity ResDic:resDic];
            [_driveDataAry addObject:drviceEntity];
            [drviceEntity release];
        }
//        [_deivceDelegate switchViewControllerDropBox:_dropbox];
    } fail:^(DriveAPIResponse *response) {
        //todo 错误
//        [IMBCommonTool showSingleBtnAlertInMainWindow:nil btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudLogin_Load_Error", nil) btnClickedBlock:^{
//            //            [self removeLoginLoadingAnimation];
//            [(IMBDeviceViewController *)_deivceDelegate loadDataFial];
//        }];
    }];
}

- (void)createDriveEntity:(IMBBaseCloudManager *)drviceEntity ResDic:(NSDictionary *)resDic {
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
//    if (downFileLoadURL) {
//        drviceEntity.fileLoadURL = downFileLoadURL;
//    }
//    if (createdString) {
//        drviceEntity.createdDateString = createdString;
//    }
//    if (lastModifiedString) {
//        drviceEntity.lastModifiedDateString = lastModifiedString;
//    }
//    if (fileName) {
//        drviceEntity.fileName = [fileName stringByDeletingPathExtension];
//    }
//    if (fileSystemCreatedDate) {
//        drviceEntity.fileSystemCreatedDate = fileSystemCreatedDate;
//    }
//    drviceEntity.fileSize = size;
//    if (fileSystemLastDate) {
//        drviceEntity.fileSystemLastDate = fileSystemLastDate;
//    }
//    drviceEntity.fileID = fileID;
//    drviceEntity.docwsid = fileID;
//    if (path) {
//        drviceEntity.filePath = path;
//    }
    
//    if ([isFolder isEqualToString:@"folder"]) {
//        drviceEntity.isFolder = YES;
//        drviceEntity.image = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
//        drviceEntity.extension = @"Folder";
//        if ([fileName containsString:@".app" options:0]) {
//            drviceEntity.image = [NSImage imageNamed:@"folder_icon_app"];
//            drviceEntity.isFolder = NO;
//            drviceEntity.extension = @"app";
//        }
//    }else{
//        drviceEntity.image = [TempHelper loadFileImage:extension];
//        drviceEntity.extension = extension;
//    }
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


@end
