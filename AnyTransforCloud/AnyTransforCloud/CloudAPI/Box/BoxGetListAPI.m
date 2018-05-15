//
//  BoxGetListAPI.m
//  DriveSync
//
//  Created by JGehry on 1/2/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BoxGetListAPI.h"

@implementation BoxGetListAPI

- (NSString *)baseUrl {
    return BoxAPIBaseURL;
}

- (NSString *)requestUrl {
    NSString *url = nil;
    if ([_folderOrfileID isEqualToString:@"0"]) {
        url = BoxGetRootListFolderAndFilePath;
    }else {
        url = [NSString stringWithFormat:BoxGetListFolderPath, _folderOrfileID];
    }
    return url;
}

- (id)requestArgument {
    return @{
             @"fields": @"size,id,name,type,parent,created_at,modified_at"
             };
}

@end
