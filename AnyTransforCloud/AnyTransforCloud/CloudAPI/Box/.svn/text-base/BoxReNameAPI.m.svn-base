//
//  BoxReNameAPI.m
//  DriveSync
//
//  Created by JGehry on 1/15/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BoxReNameAPI.h"

@implementation BoxReNameAPI

- (NSString *)baseUrl {
    return BoxAPIBaseURL;
}

- (NSString *)requestUrl {
    if (_isFolder) {
        return [NSString stringWithFormat:BoxFoldersRename, _folderOrfileID];
    }else {
        return [NSString stringWithFormat:BoxFilesRename, _folderOrfileID];
    }
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPUT;
}

- (id)requestArgument {
    return @{@"name":_newName};
}

@end
