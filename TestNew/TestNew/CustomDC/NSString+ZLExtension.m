//
//  NSString+ZLExtension.m
//  TestNew
//
//  Created by iMobie on 18/1/10.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "NSString+ZLExtension.h"

@implementation NSString (ZLExtension)

+ (NSString *)zl_pathForWritingDataPlistWithFileName:(NSString *)fileName {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES).lastObject;
    if (path) {
        if (fileName == nil) {
            fileName = @"ZLDefaultDataFile.plist";
        }
        if (![fileName hasSuffix:@".plist"]) {
            fileName = [fileName stringByAppendingString:@".plist"];
        }
        path = [path stringByAppendingPathComponent:fileName];
    }
    return path;
}

- (NSString *)zl_pathForWritingDataPlsit {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES).lastObject;
    if (path) {
        if (self == nil) {
            self = @"ZLDefaultDataFile.plist";
        }
        if (![self hasSuffix:@".plist"]) {
            self = [self stringByAppendingString:@".plist"];
        }
        path = [path stringByAppendingPathComponent:self];
    }
    return path;
}
@end
