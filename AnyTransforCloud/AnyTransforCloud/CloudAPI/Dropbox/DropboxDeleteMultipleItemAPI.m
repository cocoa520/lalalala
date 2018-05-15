//
//  DropboxDeleteMultipleItemAPI.m
//  AllFiles
//
//  Created by JGehry on 18/04/2018.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "DropboxDeleteMultipleItemAPI.h"

@implementation DropboxDeleteMultipleItemAPI

- (NSString *)baseUrl {
    return DropboxAPIBaseURL;
}

- (NSString *)requestUrl {
    return DropboxDeleteMultipleFolderAndFilePath;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSMutableArray *mutAry = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDict in _multipleFilesOrFolder) {
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
        NSString *value = [itemDict objectForKey:@"itemIDOrPath"];
        [mutDict setObject:value forKey:@"path"];
        [mutAry addObject:mutDict];
        [mutDict release];
        mutDict = nil;
    }
    return @{
             @"entries": mutAry
             };
}

@end
