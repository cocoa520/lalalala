//
//  DropboxCopyMultipleItemCheckAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/3.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "DropboxCopyMultipleItemCheckAPI.h"

@implementation DropboxCopyMultipleItemCheckAPI

- (NSString *)baseUrl {
    return DropboxAPIBaseURL;
}

- (NSString *)requestUrl {
    return DropboxCopyMultipleCheck;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"async_job_id": _multipleFilesOrFolderAsyncJobID
             };
}

@end
