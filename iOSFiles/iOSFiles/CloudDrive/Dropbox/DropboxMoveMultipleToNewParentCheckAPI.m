//
//  DropboxMoveMultipleToNewParentCheckAPI.m
//  AllFiles
//
//  Created by JGehry on 18/04/2018.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "DropboxMoveMultipleToNewParentCheckAPI.h"

@implementation DropboxMoveMultipleToNewParentCheckAPI

- (NSString *)baseUrl {
    return DropboxAPIBaseURL;
}

- (NSString *)requestUrl {
    return DropboxMoveMultipleCheck;
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