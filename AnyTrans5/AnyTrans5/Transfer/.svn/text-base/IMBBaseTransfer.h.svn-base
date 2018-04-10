//
//  IMBBaseTransfer.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-28.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "TempHelper.h"
#import "IMBLogManager.h"
#import "IMBDeviceConnection.h"
#import "OperationLImitation.h"
#import "IMBExportSetting.h"
#import "ATTracker.h"
#import "IMBTransferError.h"
@protocol TransferDelegate <NSObject>

//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file;
//传输准备进度结束
- (void)transferPrepareFileEnd;
//传输进度
- (void)transferProgress:(float)progress;
//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file;
//分析进度
- (void)parseProgress:(float)progress;
//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file;
//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount;

@optional
//传输出现错误
- (BOOL)transferOccurError:(NSString *)error;
- (void)cloneOrMergeComplete:(BOOL)success;
- (void)transferCurrentSize:(long long)currenSize;
//待扩展

@end

@interface IMBBaseTransfer : NSObject
{
    BOOL _isPause;
    BOOL _isStop;
    
    //当前传输的size
    int64_t _curSize;
    //需要传输的总的个数
    int _totalItemCount;
    //当前传输的项目的索引
    int _currItemIndex;
    
    int _totalCount;//总的大项个数
    
    int _currCount;//当前传输的大项索引
    
    //失败的个数
    int _failedCount;
    //成功的个数
    int _successCount;
    //跳过个数
    int _skipCount;
    IMBiPod *_ipod;
    
    IMBLogManager *_loghandle;
    NSFileManager *_fileManager;
    //需要传输的总共的大小
//    long long _transTotalSize;
    
    
    NSString *_exportPath;
    NSString *_mode;
    
    //html 用到
    NSString *_exportName;
    NSString *_htmlImgFolderPath;
    BOOL _isAllExport;
    float _percent;
    int _totalItem;
    
    NSCondition *_condition;
    OperationLImitation  *_limitation;
    @public
    NSArray *_exportTracks;
    id <TransferDelegate> _transferDelegate;  //用于传输窗口反馈进度等信息
    //总共传输的size
    int64_t _totalSize;
    BOOL _isReminder;
}
@property (nonatomic, assign) BOOL isAllExport;
@property (nonatomic, assign) float percent;
@property (nonatomic, assign) int totalItem;
@property (assign,nonatomic) BOOL isStop;
@property (nonatomic, assign) int currItemIndex;
@property (assign,nonatomic) BOOL isPause;
@property (assign,nonatomic) NSCondition *condition;
@property (nonatomic, assign) BOOL isReminder;
@property (nonatomic, assign) int successCount;

- (id)initWithIPodkey:(NSString *)ipodKey withDelegate:(id)delegate;

- (id)initWithIPodkey:(NSString *)ipodKey exportTracks:(NSArray *)exportTracks exportFolder:(NSString *)exportFolder withDelegate:(id)delegate;

- (id)initWithPath:(NSString *)exportPath exportTracks:(NSArray *)exportTracks withMode:(NSString *)mode withDelegate:(id)delegate;

- (id)initWithIPodkey:(NSString *)ipodKey importTracks:(NSArray *)importTracks withCurrentPath:(NSString *)curPath withDelegate:(id)delegate;

//传输开始入口
- (void)startTransfer;
+ (BOOL)checkIosIsHighVersion:(IMBiPod *)ipod;

//html 用到
- (BOOL)writeToMsgFileWithPageTitle:(NSString*)pageTitle;

#pragma mark - copy device to local
- (BOOL)copyRemoteFile:(NSString*)path1 toLocalFile:(NSString*)path2;
- (BOOL)asyncCopyRemoteFile:(NSString *)path1 toLocalFile:(NSString *)path2;
- (BOOL)copyLocalFile:(NSString*)path1 toRemoteFile:(NSString*)path2;
- (int64_t)caculateTransferTotalSize:(NSArray *)array;
- (void)sendCopyProgress:(uint64_t)curSize;

#pragma mark - 暂停方法
- (void)pauseScan;
- (void)resumeScan;
- (void)stopScan;

@end

