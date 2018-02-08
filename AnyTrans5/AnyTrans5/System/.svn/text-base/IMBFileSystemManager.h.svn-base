//
//  IMBFileSystemManager.h
//  iMobieTrans
//
//  Created by iMobie on 14-8-19.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "SimpleNode.h"

@interface IMBFileSystemManager : NSObject
{

    IMBiPod *_ipod;
    BOOL _threadBreak;
    NSSize _folderIconSize;
    NSSize _fileIconSize;
    id _delegate;
    int _curItems;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) int curItems;

- (id)initWithiPod:(IMBiPod *)ipod;
- (id)initWithiPodByExport:(IMBiPod *)ipod;
//获取该路径下的第一级目录
- (NSArray*)recursiveDirectoryContentsDics:(NSString*)path;
//导出
- (void)exploreFileToMac:(NSString *)FolderPath withNodeArray:(NSArray *)nodeArray fileManger:(NSFileManager *)fileManger afcMedia:(AFCMediaDirectory *)afcMedia;
//删除
- (void)removeFiles:(NSArray *)nodeArray afcMediaDir:(AFCMediaDirectory *)afcMediaDir;
//导入
- (void)importFileToDevice:(NSString *)destinationFolder withsourcePathArray:(NSArray *)sourcePathArray fileManger:(NSFileManager *)fileManger afcMedia:(AFCMediaDirectory *)afcMedia;
//重命名
- (BOOL)rename:(SimpleNode *)node withfileName:(NSString *)fileName;
//backup
//- (BOOL)copyBackupItemToMac:(NSString *)desPath node:(NSArray *)nodeArr backupPath:(NSString *)backupPath iCloudBackup:(IMBiCloudBackup *)iCloudBackup ipod:(IMBiPod *)ipod isDrag:(BOOL)isDrag;
//拷贝文件从头一个设备到另一个设备
- (void)copyfileArray:(NSArray *)sourceNodeArray sourceafcDir:(AFCMediaDirectory *)sourceafcDir desafcDir:(AFCMediaDirectory *)desafcDir;
- (void)setFileIconSize:(NSSize)size;
- (void)setFolderIconSize:(NSSize)size;

- (int)caculateTotalFileCount:(NSArray *)nodeArray afcMedia:(AFCMediaDirectory *)afcMedia;
@end
