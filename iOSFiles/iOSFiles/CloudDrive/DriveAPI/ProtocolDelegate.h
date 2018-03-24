//
//  ProtocolDelegate.h
//  DriveSync
//
//  Created by 罗磊 on 2017/12/12.
//  Copyright © 2017年 imobie. All rights reserved.
//

#ifndef ProtocolDelegate_h
#define ProtocolDelegate_h


#endif /* ProtocolDelegate_h */

#if __has_include(<AFNetworking/AFURLRequestSerialization.h>)
#import <AFNetworking/AFURLRequestSerialization.h>
#else
#import "AFURLRequestSerialization.h"
#endif

typedef NS_ENUM(NSUInteger,TransferState){
    TransferStateNormal = 0,    //默认状态，不会下载 也不会上传
    DownloadStateWait,      //等待下载
    DownloadStateLoading,   //正在下载
    DownloadStatePaused,    //下载暂停
    DownloadStateComplete,  //下载完成
    DownloadStateError,     //下载失败
    UploadStateWait,      //等待上传
    UploadStateLoading,   //正在上传
    UploadStatePaused,    //上传暂停
    UploadStateComplete,  //上传完成
    UploadStateError,     //上传失败
};

@protocol DownloadAndUploadDelegate <NSObject>

@optional
//进度
@property (nonatomic,assign)double progress;
//云云之间的进度
@property (nonatomic,assign)double driveTodriveProgress;

//状态
@property (nonatomic,assign)TransferState state;
//速度
@property (nonatomic,assign)NSUInteger speed;
//错误
@property (nonatomic,retain)NSError *error;
//下载的完整路径
@property (nonatomic,retain)NSString *urlString;
//下载头部所需参数
@property (nonatomic,retain)NSDictionary *headerParam;
//下载请求方式
@property (nonatomic,retain)NSString *httpMethod;
//父目录路径，只有下载文件夹的时候 parentPath才会被赋值
@property (nonatomic,retain)NSString *parentPath;
//文件或目录大小
@property (nonatomic,assign)long long fileSize;
//当前的下载或者上传的大小
@property (nonatomic,assign)long long currentSize;

@required
//如果是文件 其父目录对象
@property (nonatomic,assign)id <DownloadAndUploadDelegate> parent;
//如果是目录 则childArray 为目录下所有的文件集合
@property (nonatomic,retain)NSMutableArray *childArray;
//下载项的id或者路径
@property (nonatomic,retain)NSString *itemIDOrPath;
//如果是icloud drive 需要传入docwsid 下载的时候需要用到
@property (nonatomic,retain)NSString *docwsID;

@property (nonatomic,retain)NSString *currentSizeStr;

//是否是目录
@property (nonatomic,assign)BOOL isFolder;
//是否需要传入大文件
@property (nonatomic,assign)BOOL isBigFile;
//是否需要构建数据（用于部分云文件上传）
@property (nonatomic,assign)BOOL isConstructingData;
//构建数据（用于部分云文件上传）
@property (nonatomic,retain)NSData *constructingData;
//构建数据云平台名称（用于部分云文件上传）
@property (nonatomic,retain)NSString *constructingDataDriveName;
//构建云平台数据长度（用于部分云文件上传）
@property (nonatomic,assign)long long constructingDataLength;
//请求api 上传的时候需要
@property (nonatomic,retain)id requestAPI;
//上传项本地路径
@property (nonatomic,retain)NSString *localPath;
//文件名字
@property (nonatomic,retain)NSString *fileName;
//要上传到的父目录id或者路径
@property (nonatomic,retain)NSString *uploadParent;
//目标云名字
@property (nonatomic,retain)NSString *toDriveName;
//iCloud Drive 下载所需要，表明文件所属的域
@property (nonnull,retain)NSString *zone;

@property (nonnull,nonatomic,retain)NSMutableArray *dataAry;

@property (nonatomic,assign) BOOL isStart;
//唯一标识符
- (NSString *)identifier;
@end
