//
//  IMBBaseManager.h
//  iMobieTrans
//
//  Created by iMobie on 14-2-20.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"
#import "IMBiPod.h"
//#import "IMBAbstractProgress.h"
//#import "IMBSoftWareInfo.h"
#import "IMBTransResult.h"
#import "IMBProgressCounter.h"
#import "TempHelper.h"

@interface IMBMobileSyncManager : NSObject
{
    AMDevice  *device;
    AMMobileSync *mobileSync;
    NSMutableDictionary *_allItemDic;
    IMBResultSingleton *_transResult;
    IMBProgressCounter *_progressCounter;

    NSNotificationCenter *nc;
    
    BOOL _threadBreak;
}
@property (nonatomic,retain)AMMobileSync *mobileSync;
@property (nonatomic,retain)NSMutableDictionary *allItemDic;
//检测icloud itemkey可以为@"Notes",@"Contacts",@"Calendars",@"Bookmarks"
+ (BOOL)checkItemsValidWithIPod:(IMBiPod *)ipod itemKey:(NSString *)itemKey;

- (id)initWithAMDevice:(AMDevice *)_device;

//开启mobilesync服务*******(在进行增删改查前需要调用此方法，操作完成需要关闭服务)*************
- (void)openMobileSync;

//关闭mobileSync服务******(操作完成后需要调用此方法)*******************
- (void)closeMobileSync;
//将NSDate转换为指定格式的formate 字符串形式
- (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate;

//创建一个不相同的文件名 (当我们拷贝文件时，如果文件已经存在但是我们又不想覆盖它 就需要自动重命名)
- (NSString *)createDifferentfileNameinfolder:(NSString *)folder  filePath:(NSString *)filePath fileManager:(NSFileManager *)fileMan;

//去掉&nbsp 和<div>
//-(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;
- (id)initWithAMDeviceByexport:(AMDevice *)dev;

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
@end
