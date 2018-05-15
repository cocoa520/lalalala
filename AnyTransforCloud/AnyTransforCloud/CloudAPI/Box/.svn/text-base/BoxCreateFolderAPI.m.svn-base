//
//  BoxCreateFolderAPI.m
//  DriveSync
//
//  Created by JGehry on 1/2/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BoxCreateFolderAPI.h"

@implementation BoxCreateFolderAPI

- (NSString *)baseUrl {
    return BoxAPIBaseURL;
}

- (NSString *)requestUrl {
    return BoxCreateFolderPath;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    if (![_parent isEqualToString:@""] && ![_parent isEqualToString:@"0"] && _parent) {
        return @{@"name":_folderName,@"parent":@{@"id":_parent}};
    }else {
        return @{@"name":_folderName, @"parent":@{@"id":@"0"}};
    }
}

@end
