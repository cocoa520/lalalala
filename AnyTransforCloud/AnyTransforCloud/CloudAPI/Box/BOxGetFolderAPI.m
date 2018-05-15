//
//  BOxGetFolderAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/11.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BOxGetFolderAPI.h"

@implementation BOxGetFolderAPI

- (NSString *)baseUrl {
    return BoxAPIBaseURL;
}

- (NSString *)requestUrl {
    NSString *url = nil;
    if ([_folderOrfileID isEqualToString:@"0"]) {
        url = BoxGetRootListFolderAndFilePath;
    }else {
        url = [NSString stringWithFormat:BoxGetFolderPath, _folderOrfileID];
    }
    return url;
}

- (id)requestArgument {
    return @{
             @"fields": @"size,id,name,type,parent,created_at,modified_at"
             };
}

@end
