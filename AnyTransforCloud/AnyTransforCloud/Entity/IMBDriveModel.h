//
//  IMBCloudDataModel.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDrive.h"
#import "IMBCommonEnum.h"
@class IMBBaseManager;
@class DownLoadAndUploadItem;
@interface IMBDriveModel : DownLoadAndUploadItem <DownloadAndUploadDelegate>
{
    NSString *_fileLoadURL;             ///下载文件的路径
    NSString *_thumbnailURL;            ///缩略图下载路径
    NSString *_createdDateString;       ///文件的创建时间
    NSString *_lastModifiedDateString;  ///文件的修改时间
//    NSString *_fileName;                ///文件名
//    long long _fileSize;                ///文件大小
    NSString *_fileSystemCreatedDate;   ///文件原始的创建时间
    NSString *_fileSystemLastDate;      ///文件原始的修改时间
    NSString *_fileID;                  ///文件唯一标记ID
//    BOOL _isFolder;                     ///是否是文件夹 yes 是
    FileTypeEnum _fileTypeEnum;
    NSImage *_iConimage;                ///图标
    NSImage *_transferImage;            ///传输图标
    NSImage *_image;                    ///云上的图片，下载好了的
    BOOL _isTrashed;                    ///是否是删除的，YES 是
    
//    NSString *_zone;
    NSString *_etag;
    NSString *_extension;
    NSString *_filePath;
    
    CheckStateEnum _checkState;     ///是否选中
    
    NSMutableArray *_children;
    showTypeEnum _showType;
    BOOL _hasLoadchid;
    BOOL _isDownLoad;
    NSString *_completeDate;
    long long _completeInterval;
    NSString *_driveID;
    BOOL _isForbiddden;
    NSString *_sreachSize;
    NSString *_displayName; //界面显示的名字
}
//文件名字
@property (nonatomic,retain,nullable)NSString *displayName;
@property (nonatomic, retain) NSString *_Nonnull sreachSize;
@property (nonatomic, assign) CheckStateEnum checkState;
@property (nonatomic, retain) NSString *_Nonnull extension;
@property (nonatomic, retain) NSString *_Nonnull etag;
@property (nonatomic, retain) NSString *_Nonnull fileLoadURL;
@property (nonatomic, retain) NSString *_Nonnull thumbnailURL;
@property (nonatomic, retain) NSString *_Nonnull createdDateString;
@property (nonatomic, retain) NSString *_Nonnull lastModifiedDateString;
//@property (nonatomic, retain) NSString *fileName;
//@property (nonatomic, assign) long long fileSize;
@property (nonatomic, retain)  NSString *_Nonnull fileSystemCreatedDate;
@property (nonatomic, retain)  NSString *_Nonnull fileSystemLastDate;
@property (nonatomic, retain)  NSString *_Nonnull fileID;
//@property (nonatomic, assign) BOOL isFolder;
//@property (nonatomic, retain) NSString *zone;
@property (nonatomic, retain) NSString *_Nonnull filePath;
@property (nonatomic, assign) FileTypeEnum fileTypeEnum;
@property (nonatomic, retain) NSImage *_Nonnull iConimage;
@property (nonatomic, retain) NSImage *_Nonnull transferImage;
@property (nonatomic, assign) BOOL isTrashed;
@property (nonatomic, retain) NSMutableArray *_Nonnull children;
@property (nonatomic, assign) showTypeEnum showType;
@property (nonatomic, assign) BOOL hasLoadchid;
@property (nonatomic, assign) BOOL isDownLoad;
@property (nonatomic, retain) NSImage *_Nonnull image;
@property (nonnull,nonatomic,retain) NSString * completeDate;
@property (nonatomic, retain) NSString *_Nonnull driveID;
@property (nonatomic, assign) BOOL isForbiddden;
@property (nonatomic, assign) long long completeInterval;
- (NSInteger)numberOfChildren;
- (IMBDriveModel *_Nonnull)childAtIndex:(NSInteger)n;
@end
