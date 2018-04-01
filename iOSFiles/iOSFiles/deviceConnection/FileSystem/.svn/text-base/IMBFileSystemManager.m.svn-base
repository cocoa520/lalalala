//
//  IMBFileSystemManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-8-19.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBFileSystemManager.h"
#import "IMBFileSystem.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
#import "StringHelper.h"
@implementation IMBFileSystemManager
@synthesize delegate = _delegate;
@synthesize curItems =  _curItems;

static int fileCount = 0;
- (id)initWithiPod:(IMBiPod *)ipod
{
    self = [super init];
    if (self) {
        _ipod = [ipod retain];
        _fileIconSize = NSMakeSize(56, 52);
        _folderIconSize = NSMakeSize(66, 58);
    }
    return self;
}

- (void)setFileIconSize:(NSSize)size
{
    _fileIconSize = size;
}
- (void)setFolderIconSize:(NSSize)size
{
    _folderIconSize = size;
}

- (id)initWithiPodByExport:(IMBiPod *)ipod
{
    self = [super init];
    if (self) {
        _threadBreak = NO;
        _ipod = [ipod retain];
        _fileIconSize = NSMakeSize(56, 52);
        _folderIconSize = NSMakeSize(66, 58);
    }
    return self;
}
- (void)changeThreadBreak:(NSNotification *)notification
{
    _threadBreak = YES;
}

- (NSArray*)recursiveDirectoryContentsDics:(NSString*)path
{
    AFCMediaDirectory *afcmd = [_ipod.deviceHandle newAFCMediaDirectory];
    NSArray *nodeArray = [self getFirstContent:path afcMedia:afcmd];
    [afcmd close];
    return nodeArray;
}

- (NSArray *)getFirstContent:(NSString *)path afcMedia:(AFCMediaDirectory *)afcMedia
{
    NSMutableArray *nodeArray = [NSMutableArray array];
    NSArray *array = [afcMedia directoryContents:path];
    for (NSString *fileName in array) {
        NSString *filePath = nil;
        if ([path isEqualToString:@"/"]) {
            filePath = [NSString stringWithFormat:@"/%@",fileName];
        }else
        {
            filePath = [path stringByAppendingPathComponent:fileName];
        }
        SimpleNode *node = [[SimpleNode alloc] initWithName:fileName];
        node.path = filePath;
        node.parentPath = path;
        NSDictionary *fileDic = [afcMedia getFileInfo:filePath];
        NSString *fileType = [fileDic objectForKey:@"st_ifmt"];
        NSDate *createDate = [fileDic objectForKey:@"st_birthtime"];
        int64_t fileSize = (int)[fileDic objectForKey:@"st_size"];
        NSDate *lastDate = [fileDic objectForKey:@"st_mtime"];
        node.itemSize = fileSize;
        NSString *extension = [node.path pathExtension];
        if (![StringHelper stringIsNilOrEmpty:extension]) {
            extension = [extension lowercaseString];
        }
        node.extension = extension;
        node.creatDate = [DateHelper stringFromFomate:createDate formate:@"yyyy-MM-dd HH:mm"];
        node.lastDate = [DateHelper stringFromFomate:lastDate formate:@"yyyy-MM-dd HH:mm"];
        if ([fileType isEqualToString:@"S_IFDIR"]) {
            node.container = YES;
            NSImage *picture = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
            node.image = picture;
            node.extension = @"Folder";
        }else {
            node.container = NO;
            node.itemSize = [[fileDic objectForKey:@"st_size"] longLongValue];
            FileTypeEnum type = [StringHelper getFileFormatWithExtension:extension];
            NSImage *image;
            if (type == ImageFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_img"];
            } else if (type == MusicFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_music"];
            } else if (type == MovieFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_video"];
            } else if (type == TxtFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_txt"];
            } else if (type == DocFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_doc"];
            } else if (type == BookFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_books"];
            } else if (type == PPtFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_ppt"];
            } else if (type == ZIPFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_zip"];
            } else if (type == dmgFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_dmg"];
            } else if (type == contactFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_contacts"];
            } else if (type == excelFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_excel"];
            } else {
                image = [NSImage imageNamed:@"cnt_fileicon_common"];
            }
            node.image = image;
        }
        [nodeArray addObject:node];
        [node release];
    }
    
    return nodeArray;
}

- (void)removeFiles:(NSArray *)nodeArray afcMediaDir:(AFCMediaDirectory *)afcMediaDir
{
    for (SimpleNode *node in nodeArray) {
        if (node.container) {
            NSArray *arr = [self getFirstContent:node.path afcMedia:afcMediaDir];
            [self removeFiles:arr afcMediaDir:afcMediaDir];
            [afcMediaDir unlink:node.path];
        }else
        {
            if ([afcMediaDir fileExistsAtPath:node.path]) {
                [afcMediaDir unlink:node.path];
            }
            _curItems ++;
            if ([_delegate respondsToSelector:@selector(setDeleteCurItems:)]) {
                [_delegate setDeleteCurItems:_curItems];
            }
        }
    }
}

- (BOOL)rename:(SimpleNode *)node withfileName:(NSString *)fileName
{
    NSString *filePath = node.path;
    NSString *oldfileName = [filePath lastPathComponent];

    NSString *newfilePath = [filePath stringByReplacingOccurrencesOfString:oldfileName withString:fileName];
    BOOL success = [_ipod.fileSystem rename:filePath newPath:newfilePath];
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            node.fileName = fileName;
            node.path = newfilePath;
        });
    }
    return success;
}

- (void)cacuSize:(NSString *)path size:(long long *)size  afcMedia:(AFCMediaDirectory *)afcMedia
{
    NSArray *array = [afcMedia directoryContents:path];
    for (NSString *fileName in array) {
        NSString *filePath = nil;
        if ([path isEqualToString:@"/"]) {
            filePath = [NSString stringWithFormat:@"/%@",fileName];
        }else
        {
            filePath = [path stringByAppendingPathComponent:fileName];
        }
        NSDictionary *fileDic = [afcMedia getFileInfo:filePath];
        NSString *fileType = [fileDic objectForKey:@"st_ifmt"];
        if ([fileType isEqualToString:@"S_IFDIR"]) {
            [self cacuSize:filePath size:size afcMedia:afcMedia];
        }else
        {
             *size += [[fileDic objectForKey:@"st_size"] longLongValue];
        }
    }
}

- (int)caculateTotalFileCount:(NSArray *)nodeArray afcMedia:(AFCMediaDirectory *)afcMedia
{
    for (SimpleNode *node in nodeArray) {
        if (!node.container) {
            fileCount++;
        }else
        {
             NSArray *arr = [self getFirstContent:node.path afcMedia:afcMedia];
            [self caculateTotalFileCount:arr afcMedia:afcMedia];
        }
    }
    return fileCount;
}
    
- (int)caculateTotalFileCount:(NSArray *)nodeArray fileManager:(NSFileManager *)fileManager
{
    for (NSString *filePath in nodeArray) {
        BOOL isDir;
        if ([fileManager fileExistsAtPath:filePath isDirectory:&isDir]) {
            if (!isDir) {
                fileCount++;
            }else
            {
                NSArray *subArr = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
                NSMutableArray *subSoucePathArray = [NSMutableArray array];
                for (NSString *url in subArr) {
                    NSString *subfilePath = [filePath stringByAppendingPathComponent:url];
                    [subSoucePathArray addObject:subfilePath];
                }
                [self caculateTotalFileCount:subSoucePathArray fileManager:fileManager];
            }
        }
    }
    return fileCount;
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter]  removeObserver:self name:NOTIFY_PROGRESS_SHOULD_CLOSE object:nil];
    [_ipod release],_ipod = nil;
    [super dealloc];
}
@end
