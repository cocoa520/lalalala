//
//  BoxMoveToNewParentAPI.m
//  DriveSync
//
//  Created by JGehry on 1/15/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BoxMoveToNewParentAPI.h"

@implementation BoxMoveToNewParentAPI

- (NSString *)baseUrl {
    return BoxAPIBaseURL;
}

- (NSString *)requestUrl {
    if (_isFolder) {
        return [NSString stringWithFormat:BoxFoldersMove, _folderOrfileID];
    }else {
        return [NSString stringWithFormat:BoxFilesMove, _folderOrfileID];
    }
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPUT;
}

- (id)requestArgument {
    return @{@"name":_newName, @"parent": @{@"id": _newParentIDOrPath}};
}

@end
