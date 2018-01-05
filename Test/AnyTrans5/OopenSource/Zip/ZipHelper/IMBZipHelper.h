//
//  IMBZipHelper.h
//  iMobieTrans
//
//  Created by Pallas on 1/27/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipFile.h"
#import "ZipException.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"
#import "FileInZipInfo.h"

@interface IMBZipHelper : NSObject

+ (void)zipByPath:(NSString*)zipPath localPath:(NSString*)localPath;
+ (void)recuZip:(ZipFile*)zipFile fileManager:(NSFileManager*)fm folderPath:(NSString*)folderPath baseFolder:(NSString*)baseFolder;
+ (void)unZipByAllF:(NSString*)zipPath decFolderPath:(NSString*)decFolderPath;
+ (void)unZipByAll:(NSString*)zipPath decFolderPath:(NSString*)decFolderPath;
+ (void)unZipByFolder:(NSString*)zipPath folderPath:(NSString*)folderPath decFolderPath:(NSString*)decFolderPath;
+ (void)unzipByFile:(NSString*)zipPath filePath:(NSString*)filePath decFolderPath:(NSString*)decFolderPath;
+(NSArray *)unZipAppSyncFile:(NSString *)filePath tmpPath:(NSString *)tmpPath passWord:(NSString *)password;
@end
