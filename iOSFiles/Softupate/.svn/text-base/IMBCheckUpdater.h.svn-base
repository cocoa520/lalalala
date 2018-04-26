//
//  IMBCheckUpdater.h
//  PhoneRescue
//
//  Created by zhang yang on 12-12-31.
//  Copyright (c) 2012年 zhang yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBUpdateInfo.h"

enum {
    UpdaterStatus_Skip_Version = 2,
    UpdaterStatus_HasUpdate = 1,
    UpdaterStatus_UpToDate = 0,
    UpdaterStatus_NetworkError = -1,
    UpdaterStatus_GetFileError = -2,
    UpdaterStatus_UnknownError = -9,
};
typedef NSInteger UpdaterStatus;

@protocol IMBCheckUpdaterListener
@optional
- (void) UpdaterStatus:(UpdaterStatus) status UpdateInfo: (IMBUpdateInfo*) info Manual:(bool)isManual;

@end

@class IMBSoftWareInfo;

@interface IMBCheckUpdater : NSObject <NSURLDownloadDelegate> {
    NSString *_updateFileName;
    NSString *_updateFileLocalPath;
    NSString *_updateFileUrlPath;
    id _listener;
    bool _isManual;
    bool _isMustUpdate;
    
    IMBSoftWareInfo *software;
    NSURLDownload *_urlDown;
}

- (void) setListener:(id)listener;

- (void) checkUpdate;

- (id)initWithManual:(bool)isManual;


@end
