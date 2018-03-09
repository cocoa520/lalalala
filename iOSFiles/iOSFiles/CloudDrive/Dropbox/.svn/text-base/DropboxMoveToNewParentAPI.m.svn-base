//
//  DropboxMoveToNewParentAPI.m
//  DriveSync
//
//  Created by JGehry on 1/15/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "DropboxMoveToNewParentAPI.h"

@implementation DropboxMoveToNewParentAPI

- (NSString *)baseUrl {
    return DropboxAPIBaseURL;
}

- (NSString *)requestUrl {
    return DropboxMove;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSString *sourceName = nil;
    NSString *targetName = nil;
    if ([_folderOrfileID rangeOfString:@"id:"].location != NSNotFound) {
        sourceName = [NSString stringWithFormat:@"%@", _folderOrfileID];
    }else {
        if ([_folderOrfileID isEqualToString:@"0"]) {
            sourceName = @"//";
        }else {
            sourceName = [NSString stringWithFormat:@"/%@", _folderOrfileID];;
        }
    }
    if ([_newParentIDOrPath rangeOfString:@"id:"].location != NSNotFound) {
        targetName = [NSString stringWithFormat:@"%@", _newParentIDOrPath];
    }else {
        if ([_newParentIDOrPath isEqualToString:@"0"]) {
            targetName = @"//";
        }else {
            targetName = [NSString stringWithFormat:@"/%@", _newParentIDOrPath];
        }
    }
    return @{@"from_path": sourceName,
             @"to_path": targetName};
}

@end
