//
//  IMBQueue.h
//  PhoneRescue
//
//  Created by 肖体华 on 14-9-25.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
#import "IMBiCloudClient.h"
#import "iCloudClient.h"
#import "IMBiCloudBackupBindingEntity.h"
@protocol downloadSucessProtocol
- (void)sucessDownloadWithOutputpath:(NSString *)outputPath;
- (void)downloadFailedWithOutputPath:(NSString *)outputPath;
@end

@interface IMBQueue : NSObject{
    id _delegate;
    NSMutableArray *_queueArray;
    int _queueNumber;
    NSString *_outputPath;
    IMBiCloudClient *_iCloudClient;
    iCloudClient *_iCloudClient9;
    NSMutableDictionary *_dataDic;
    NSMutableDictionary *_deviceSnapshotDict;
    __block BOOL _cancel;
    
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL cancel;
@property (nonatomic, retain) NSString *outputPath;
//@property (nonatomic, readwrite, retain) id delegate;
@property (nonatomic, retain) IMBiCloudClient *iCloudClient;
@property (nonatomic, retain) iCloudClient *iCloudClient9;
@property (nonatomic, readwrite, retain) NSMutableDictionary *dataDic;
@property (nonatomic, readwrite, retain) NSMutableDictionary *deviceSnapshotDict;

- (id)initWithQueueNumber:(int)number withDelegate:(id)delegate;
- (BOOL)addOject:(id)obj;
- (id)getQueueHeadObject;
- (void)removeObject:(id)object;
- (void)removeHeadObject;
- (void)removeAllObjects;
- (int)getQueueCount;
- (void)startDownload;
- (NSArray *)getAllObjects;

/**
 *  ios 9 以后的iCloud Backup登录
 *
 *  @param appleID  帐号
 *  @param password 密码
 *
 *  @return 是否成功
 */
- (BOOL)loginAuth:(NSString*)appleID withPassword:(NSString*)password;

/**
 *  ios 9 以后的iCloud Backup下载
 */
- (void)iOS9StartDownload;

@end
