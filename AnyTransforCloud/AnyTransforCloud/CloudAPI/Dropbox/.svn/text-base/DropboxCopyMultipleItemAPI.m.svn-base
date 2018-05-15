//
//  DropboxCopyMultipleItemAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/3.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "DropboxCopyMultipleItemAPI.h"

@implementation DropboxCopyMultipleItemAPI

- (NSString *)baseUrl {
    return DropboxAPIBaseURL;
}

- (NSString *)requestUrl {
    return DropboxCopyMultiple;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSString *sourceName = nil;
    NSString *targetName = nil;
    NSMutableArray *mutAry = [[NSMutableArray alloc] init];
    NSUInteger count = [_multipleFilesOrFolder count];
    for (int i = 0; i < count; i++) {
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
        NSString *oldPath = [_multipleFilesOrFolder objectAtIndex:i];
        NSString *newPath = [_multipleNewFilesOrFolder objectAtIndex:i];
        
        if ([oldPath rangeOfString:@"id:"].location != NSNotFound) {
            sourceName = [NSString stringWithFormat:@"%@", oldPath];
            [mutDict setObject:sourceName forKey:@"from_path"];
        }else {
            if ([oldPath isEqualToString:@"0"]) {
                sourceName = @"/";
            }else {
                sourceName = [NSString stringWithFormat:@"%@", oldPath];
            }
            [mutDict setObject:sourceName forKey:@"from_path"];
        }
        
        if ([newPath rangeOfString:@"id:"].location != NSNotFound) {
            targetName = [NSString stringWithFormat:@"%@", newPath];
            [mutDict setObject:targetName forKey:@"to_path"];
        }else {
            if ([_parent isEqualToString:@"0"]) {
                targetName = [NSString stringWithFormat:@"/%@", newPath];
            }else {
                targetName = [NSString stringWithFormat:@"%@", newPath];
            }
            [mutDict setObject:targetName forKey:@"to_path"];
        }
        [mutAry addObject:mutDict];
        [mutDict release];
        mutDict = nil;
    }
    
    return @{@"entries": mutAry,
             @"autorename": @YES
             };
}

@end
