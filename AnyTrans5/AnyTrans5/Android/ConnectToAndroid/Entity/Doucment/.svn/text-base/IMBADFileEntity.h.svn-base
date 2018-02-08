//
//  IMBADFileEntity.h
//  PhoneRescue_Android
//
//  Created by iMobie on 4/13/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"

@interface IMBADFileEntity : IMBBaseEntity {
@private
    NSString *_fileName; //有后缀的；
    NSString *_title;//没有后缀的；
    NSString *_parentName;
    NSString *_filePath;
    NSImage *_fileImage;
    NSString *_fileExtension;
    long long _fileSize;
    BOOL _isFile;
    NSMutableArray *_fileList;
    int _docSelectedCount;
    FileTypeEnum _fileType;
    int _imageFileCount;
    int _audioFileCount;
    int _videoFileCount;
    int _cummonFileCount;
    NSString *_localPath;//导出到本地的路径
    long long _createTime;
}
/**
 *      fileName、title      文件名字
 *      parentName          父节点名字
 *      filePath            文件路径
 *      fileSize            文件大小
 *      fileExtension       文件后缀
 *      isFile              是否是文件
 *      fileList            装file的数组
 *      fileType            文件类型
 *      imageFileCount      图片个数
 *      audioFileCount      音频个数
 *      videoFileCount      视频个数
 *      cummonFileCount     普通文件个数
 *      localPath;          导出到本地的路径
 *      createTime          文件创建时间

 */

@property (nonatomic, retain, readwrite) NSString *fileExtension;
@property (nonatomic, retain, readwrite) NSString *fileName;
@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSString *parentName;
@property (nonatomic, retain, readwrite) NSString *filePath;
@property (nonatomic, retain, readwrite) NSImage *fileImage;
@property (nonatomic, readwrite) long long fileSize;
@property (nonatomic, readwrite) BOOL isFile;
@property (nonatomic, retain, readwrite) NSMutableArray *fileList;
@property (nonatomic, readwrite) int docSelectedCount;
@property (nonatomic, readwrite) FileTypeEnum fileType;
@property (nonatomic, readwrite) int imageFileCount;
@property (nonatomic, readwrite) int audioFileCount;
@property (nonatomic, readwrite) int videoFileCount;
@property (nonatomic, readwrite) int cummonFileCount;
@property (nonatomic, readwrite, retain) NSString *localPath;
@property (nonatomic, readwrite) long long createTime;

@end
