//
//  BoxCopyItemAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/3.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BoxCopyItemAPI.h"

@implementation BoxCopyItemAPI

- (NSString *)baseUrl {
    return BoxAPIBaseURL;
}

- (NSString *)requestUrl {
    if (_isFolder) {
        return [NSString stringWithFormat:BoxFoldersCopy, _folderOrfileID];
    }else {
        return [NSString stringWithFormat:BoxFilesCopy, _folderOrfileID];
    }
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{@"parent": @{@"id": _newParentIDOrPath}};
}

@end
