//
//  IMBooksHelperEntry.h
//  iMobieTrans
//
//  Created by apple on 9/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBTrack.h"

@interface IMBBooksInfoEntry : IMBTrack {
@private
    IMBTrack *_basicInfo;
    // ibook在设备中的文件路径
    NSString *_ibookFilePath;
    // ibook在本地的文件路径
    NSString *_ibookLocalPath;
    // ibook的文件名称
    NSString *_ibookFileName;
    // ibook的类别
    NSString *_ibookCategory;
    // ibook的trackID
    int _trackID;
    
}

@property (nonatomic, readwrite, retain) NSString *ibookFilePath;
@property (nonatomic, readwrite, retain) NSString *ibookLocalPath;
@property (nonatomic, readwrite, retain) NSString *ibookFileName;
@property (nonatomic, readwrite, retain) NSString *ibookCategory;
@property (nonatomic, readwrite, retain) IMBTrack *basicInfo;
@property (nonatomic, readwrite) int trackID;

@end

@interface IMBEpubBookInfo : IMBBooksInfoEntry {
@private
    // 解压到的目标文件路径
    NSString *_extractFolderPath;
    // 原始的文件路径
    NSString *_epubLocalPath;
    // Epub的文件名称
    NSString *_bookName;
    // Epub的uniqueID
    NSString *_uniqueId;
    // Epub的packageHash
}

@property (nonatomic, readwrite, retain) NSString *extractFolderPath;
@property (nonatomic, readwrite, retain) NSString *epubLocalPath;
@property (nonatomic, readwrite, retain) NSString *bookName;
@property (nonatomic, readwrite, retain) NSString *uniqueId;

@end
