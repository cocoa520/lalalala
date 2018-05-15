//
//  BoxCreateSessionAPI.m
//  DriveSync
//
//  Created by JGehry on 1/4/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BoxCreateSessionAPI.h"

@implementation BoxCreateSessionAPI

- (NSString *)baseUrl {
    return BoxAPIContentBaseURL;
}

- (NSString *)requestUrl {
    return BoxUploadBigFileCreateSession;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    if (![_parent isEqualToString:@""] && ![_parent isEqualToString:@"0"] && _parent) {
        return @{@"folder_id":_parent, @"file_size":[NSNumber numberWithLongLong:_uploadFileSize], @"file_name":[_fileName stringByDeletingPathExtension]};
    }else {
        return @{@"folder_id":@"0", @"file_size":[NSNumber numberWithLongLong:_uploadFileSize], @"file_name":[_fileName stringByDeletingPathExtension]};
    }
}

@end
