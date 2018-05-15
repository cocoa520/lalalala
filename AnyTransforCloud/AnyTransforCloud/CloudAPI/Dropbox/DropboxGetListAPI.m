//
//  DropboxGetListAPI.m
//  DriveSync
//
//  Created by JGehry on 12/5/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "DropboxGetListAPI.h"
#import "HTTPApiConst.h"

@implementation DropboxGetListAPI

- (NSString *)baseUrl {
    return DropboxAPIBaseURL;
}

- (NSString *)requestUrl {
    return DropboxGetListPath;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSString *folderName = nil;
    if ([_folderOrfileID rangeOfString:@"id:"].location != NSNotFound) {
        folderName = [NSString stringWithFormat:@"%@", _folderOrfileID];
    }else {
        if ([_folderOrfileID isEqualToString:@"0"]) {
            folderName = @"//";
        }else {
            folderName = [NSString stringWithFormat:@"%@", _folderOrfileID];
        }
    }
    return @{
             @"path": folderName
             };
}

@end
