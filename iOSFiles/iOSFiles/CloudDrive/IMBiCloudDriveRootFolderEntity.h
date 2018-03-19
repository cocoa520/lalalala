//
//  IMBiCloudDriveRootFolderEntity.h
//  iCloudDriveDemo_2
//
//  Created by iMobie on 2/11/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"
/*----------iCloudDrive根目录下的文件夹下包括的文件及文件夹的实体----------------*/
@interface IMBiCloudDriveFileEntity : NSObject {
    
}

@end

/*--------------iCloudDrive目录下载失败的文件----------------*/
@interface IMBiCloudDriveDownloadFailFileEntity : NSObject {
    NSString *_fileName;
    NSString *_error;
}
@property (nonatomic, readwrite, retain) NSString *fileName;
@property (nonatomic, readwrite, retain) NSString *error;

@end

/*----------------iCloudDrive根目录下包括的文件和文件夹的实体----------------*/
@interface IMBiCloudDriveFolderEntity :  IMBBaseEntity{
    NSString *_drivewsid;
    NSString *_docwsid;
    NSString *_zone;
    NSString *_name;
    NSString *_etag;
    
    NSImage *_image;
    
    NSString *_parentId;            //父文件ID；
    NSString *_dateModified;        //是文件才有，文件创建日期；
    long long _size;                //是文件才有，文件大小；
    NSString *_extension;           //是文件才有，文件格式；
    NSString *_type;
    NSString *_maxDepth;            //（只有Keynote、numbers、pages才有），
    NSMutableArray *_supportedExtensions;   //（只有Keynote、numbers、pages才有），支持文件格式
    NSMutableArray*_fileItemsList;  //（只有文件夹有值，装的是IMBiCloudDriveFileEntity），
    int _numberOfItems;
    NSString *_downloadError;
    NSString *_parentFolder;
    
    long long _finishSize;          //传输完成大小;
    NSString *_downloadPath;        //下载路径;

}
@property (nonatomic, retain) NSImage *image;
@property (nonatomic, retain) NSString *downloadError;
@property (nonatomic, readwrite, retain) NSString *drivewsid;
@property (nonatomic, readwrite, retain) NSString *docwsid;
@property (nonatomic, readwrite, retain) NSString *zone;
@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) NSString *etag;

@property (nonatomic, readwrite, retain) NSString *parentId;
@property (nonatomic, readwrite, retain) NSString *dateModified;
@property (nonatomic, readwrite, retain) NSString *extension;
@property (nonatomic, readwrite, retain) NSString *type;
@property (nonatomic, readwrite, retain) NSString *maxDepth;

@property (nonatomic, readwrite) long long size;
@property (nonatomic, readwrite) int numberOfItems;

@property (nonatomic, readwrite, retain) NSMutableArray *supportedExtensions;
@property (nonatomic, readwrite, retain) NSMutableArray *fileItemsList;

@property (nonatomic, readwrite, retain) NSString *parentFolder;
@property (nonatomic, readwrite) long long finishSize;
@property (nonatomic, readwrite, retain) NSString *downloadPath;

@end

/*----------------iCloudDrive根目录实体----------------*/
@interface IMBiCloudDriveRootFolderEntity : NSObject {
    NSString *_drivewsid;
    NSString *_docwsid;
    NSString *_zone;
    NSString *_name;
    NSString *_etag;
    NSString *_type;
    int _numberOfItems;
    NSMutableArray *_folderItemsList;//（装的时IMBiCloudDriveFolderEntity）
}

@property (nonatomic, readwrite, retain) NSString *drivewsid;
@property (nonatomic, readwrite, retain) NSString *docwsid;
@property (nonatomic, readwrite, retain) NSString *zone;
@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) NSString *etag;
@property (nonatomic, readwrite, retain) NSString *type;
@property (nonatomic, readwrite) int numberOfItems;
@property (nonatomic, readwrite, retain) NSMutableArray *folderItemsList;//（装的时IMBiCloudDriveFolderEntity）

@end
