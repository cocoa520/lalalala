//
//  IMBDriveEntity.h
//  iOSFiles
//
//  Created by JGehry on 2/27/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"
@interface IMBDriveEntity : NSObject
{
    NSString *_fileLoadURL;//下载文件的路径
    NSString *_createdDateString;//文件的创建时间
    NSString *_lastModifiedDateString;//文件的修改时间
    NSString *_fileName;
    long long _fileSize;
    NSString *_fileSystemCreatedDate;//文件原始的创建时间
    NSString *_fileSystemLastDate;//文件原始的修改时间
    NSString *_fileID;
    BOOL _isFolder; //是否是文件夹 yes 是
    int _childCount;
     CheckStateEnum _checkState;
}
@property (nonatomic, retain) NSString *fileLoadURL;
@property (nonatomic, retain) NSString *createdDateString;
@property (nonatomic, retain) NSString *lastModifiedDateString;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, assign) long long fileSize;
@property (nonatomic, retain)  NSString *fileSystemCreatedDate;
@property (nonatomic, retain)  NSString *fileSystemLastDate;
@property (nonatomic, retain)  NSString *fileID;
@property (nonatomic, assign) BOOL isFolder;
@property (nonatomic, assign) int childCount;
@property(nonatomic, assign)CheckStateEnum checkState;
@end
