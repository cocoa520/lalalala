//
//  IMBSendLogFile.h
//  iMobieTrans
//
//  Created by Pallas on 7/30/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "IMBFileSystem.h"
#import "IMBDeviceInfo.h"
#import "IMBDBFileBackup.h"
#import "IMBZipHelper.h"
#import "IMBLogManager.h"

@class IMBDeviceConnection;
@interface IMBSendLogFile : NSObject {
@private
    NSString *_logFolderPath;
    NSMutableDictionary *_dbFileDictionary;
    NSString *_sendLogZipPath;
    
    NSFileManager *fm;
    IMBLogManager *logHandle;
    IMBDeviceConnection *_deviceConnection;
    NSOperationQueue *queue;
}

@property (nonatomic, readonly) NSString *sendLogZipPath;

- (void)sendLogFile;

@end
