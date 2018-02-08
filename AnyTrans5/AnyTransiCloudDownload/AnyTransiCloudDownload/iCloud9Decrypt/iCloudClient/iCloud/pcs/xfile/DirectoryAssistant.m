//
//  DirectoryAssistant.m
//  
//
//  Created by Pallas on 8/6/16.
//
//  Complete

#import "DirectoryAssistant.h"

@implementation DirectoryAssistant

+ (BOOL)createParent:(NSString*)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if (![fm fileExistsAtPath:path isDirectory:&isDir]) {
        return YES;
    }
    return [self create:path];
}

+ (BOOL)create:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:directory]) {
        if ([fm fileExistsAtPath:directory isDirectory:&isDir]) {
            return YES;
        }else {
            return NO;
        }
    }
    @try {
        if ([fm createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil]) {
            return YES;
        };
    }
    @catch (NSException *exception) {
        return NO;
    }
}

@end
