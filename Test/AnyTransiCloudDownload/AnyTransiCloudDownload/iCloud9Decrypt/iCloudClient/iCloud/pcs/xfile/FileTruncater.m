//
//  FileTruncater.m
//
//
//  Created by JGehry on 8/8/16.
//
//  Complete

#import "FileTruncater.h"
#import "AssetEx.h"
#import "CategoryExtend.h"

@implementation FileTruncater

+ (BOOL)truncate:(NSString*)file withAsset:(AssetEx*)asset {
    @try {
        NSNumber *num = [asset attributeSize];
        if (num) {
            if ([num intValue] != [asset size]) {
                [FileTruncater truncate:file to:[num longLongValue]];
            }
        }
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

+ (void)truncate:(NSString*)file to:(int64_t)to {
    @try {
        if (to == 0) {
            return;
        }
        long size = 0;
        if (size > to) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
                NSFileHandle *outFile = [[NSFileHandle alloc] initWithPath:file withAccess:OpenWrite];
                [outFile truncateFileAtOffset:to];
                [outFile closeFile];
#if !__has_feature(objc_arc)
                if (outFile) [outFile release]; outFile = nil;
#endif
            }
        }
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"%@", exception.description] userInfo:nil];
    }
}

@end
