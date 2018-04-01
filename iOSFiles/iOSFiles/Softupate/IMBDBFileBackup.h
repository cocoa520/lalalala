//
//  IMBDBFileBackup.h
//  iMobieTrans
//
//  Created by Pallas on 7/23/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "IMBDeviceInfo.h"
#import "IMBFileSystem.h"
#import "IMBCommonEnum.h"

@interface IMBDBFileBackup : NSObject {
@private
    NSNotificationCenter *nc;
    NSMutableDictionary *filePathDic;
}

+ (IMBDBFileBackup*)singleton;

- (NSMutableDictionary *)getBackupFileName;

- (void)backupDBFileWithIPod:(IMBiPod *)ipod;

- (NSMutableArray *)getAllBackupFolderNameWithIPod:(IMBiPod *)ipod;

- (BOOL)restoreBackupFileWithIPod:(IMBiPod *)ipod backupFolder:(NSString *)backupFolder;

@end
