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
@implementation IMBiCloudDriveManager

- (id)initWithUserID:(NSString *) userID WithPassID:(NSString*) passID WithDelegate:(id)delegate {
    if ([self init]) {
        _userID = userID;
        _passWordID = passID;
        _driveDataAry = [[NSMutableArray alloc]init];
        _iCloudDrive = [[iCloudDrive alloc]init];
        [_iCloudDrive setDelegate:self];
        
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
            //            NSString *changeDate = [itemDic objectForKey:@"dateChanged"];
            //            NSString *dateModified = [itemDic objectForKey:@"dateModified"];
            NSString *createdString = [self dateForm2001DateSting:[itemDic objectForKey:@"dateChanged"]];
            NSString *lastModifiedString = [self dateForm2001DateSting:[itemDic objectForKey:@"dateModified"]];
            NSString *docwsid = [itemDic objectForKey:@"docwsid"];
            NSString *extension = [itemDic objectForKey:@"extension"];
            NSString *name = [itemDic objectForKey:@"name"];
            long long  size = [[itemDic objectForKey:@"size"] intValue];
            NSString *file = [itemDic objectForKey:@"file"];
            
            IMBDriveEntity *drviceEntity = [[IMBDriveEntity alloc]init];
            drviceEntity.createdDateString = createdString;
            drviceEntity.lastModifiedDateString = lastModifiedString;
            drviceEntity.fileName = name;
            drviceEntity.fileSize = size;
            //            drviceEntity.fileSystemCreatedDate = fileSystemCreatedDate;
            //            drviceEntity.fileSystemLastDate = fileSystemLastDate;
            drviceEntity.fileID = docwsid;
            if ([file isEqualToString:@"FOLDER"]) {
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
            //            [self loadSonAryComplete:dataAry];
        });
    } fail:^(DriveAPIResponse *response) {
        
    }];
    
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        [self loadDriveData];
    //    });
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
}

- (void)driveNeedSecurityCode:(iCloudDrive *)iCloudDrive {
    
}

- (void)setTwoCodeID:(NSString *)twoCodeID{
    [_iCloudDrive verifySecurityCode:twoCodeID rememberMe:YES];
}

- (IBAction)codeDown:(id)sender {
//
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
    [_driveDataAry release];
    _driveDataAry = nil;
}

@end
