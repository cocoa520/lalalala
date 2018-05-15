//
//  DriveToDrive.h
//  DriveSync
//
//  Created by 罗磊 on 2017/12/12.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDrive.h"
@interface DriveToDrive : NSObject
{
    NSMutableDictionary *_taskDic;  ///<保存云到云的任务
}

/**
 *  Description 云到云传输
 *
 *  @param sourceDrive 原云
 *  @param targetDrive 目标云
 *  @param item        传入项
 */
- (void)transferFromDrive:(BaseDrive *)sourceDrive targetDrive:(BaseDrive *)targetDrive item:(id<DownloadAndUploadDelegate>)item;

/**
 *  Description 取消云到云传输任务
 *
 *  @param item 传入取消项
 */
- (void)cancelDriveToDriveItem:(id<DownloadAndUploadDelegate>)item;

@end
