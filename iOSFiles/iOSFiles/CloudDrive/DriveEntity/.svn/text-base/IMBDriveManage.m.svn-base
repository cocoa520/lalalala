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
@implementation IMBDriveManage
@synthesize driveDataAry = _driveDataAry;
@synthesize userID = _userID;
- (id)initWithUserID:(NSString *)userID withDelegate:(id)delegate{
    if ([super init]) {
        _driveDataAry = [[NSMutableArray alloc]init];
        _userID = userID;
        _oneDrive = [[OneDrive alloc]init];
        _oneDrive.userID = [_userID retain];
        [_oneDrive setDelegate:self];
        [_oneDrive logIn];
        _deivceDelegate = delegate;
    }
    return self;
}

//BaseDriveDelegate
- (void)driveDidLogIn:(BaseDrive *)drive {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sessionDic = [NSDictionary dictionaryWithObjectsAndKeys:drive.accessToken,@"accessToken",drive.refreshToken ,@"refreshToken",drive.expirationDate,@"expirationDate", nil];
    //保存访问令牌和刷新令牌到本地
    [defaults setObject:sessionDic forKey:@"oneDriveSessionKey"];
    [defaults synchronize];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
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
                }
                [_driveDataAry addObject:drviceEntity];
                [drviceEntity release];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [(IMBDeviceViewController*)_deivceDelegate switchViewController];
            });
        } fail:^(DriveAPIResponse *response) {
            //todo 回去数据失败
        }];
   
    });
}

- (void)driveDidLogOut:(BaseDrive *)drive {
    if ([drive isKindOfClass:[OneDrive class]]) { //将记录在本地的登录信息删掉
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; [defaults removeObjectForKey:@"oneDriveSessionKey"];
        [defaults synchronize];
        drive.accessToken = nil;
        drive.refreshToken = nil;
        drive.expirationDate = nil; }
}

- (void)drive:(BaseDrive *)drive logInFailWithError:(NSError *)error {
    //登录授权发  错误 在此处进 处
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



-(void)dealloc {
    [super dealloc];
    [_oneDrive release];
    _oneDrive = nil;
    [_driveDataAry release];
    _driveDataAry = nil;
    [_userID release];
    _userID = nil;
}

@end
