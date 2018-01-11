//
//  ZLFileTool.m
//  TestNew
//
//  Created by iMobie on 18/1/10.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "ZLFileTool.h"
#import "NSString+ZLExtension.h"


@implementation ZLFileTool

+ (BOOL)zl_writeDataPlsitWithDataDic:(NSDictionary *)dataDic fileName:(NSString *)fileName {
    if (dataDic) {
        NSString *path = [NSString zl_pathForWritingDataPlistWithFileName:fileName];
        if (path) {
            if ([dataDic writeToFile:path atomically:YES]) {
                NSLog(@"fileWroteSucceded----path:%@",path);
                return YES;
            }else {
                NSLog(@"fileWroteFailed");
                return NO;
            }
        }
    }
    return NO;
}

+ (NSString*)zl_getAppSupportPath {
    NSString *appTempPath;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *identifier = [bundle bundleIdentifier];
    NSString *appName = [[bundle infoDictionary] objectForKey:@"CFBundleName"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *homeDocumentsPath = [[[manager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path];
    appTempPath =[[homeDocumentsPath stringByAppendingPathComponent:identifier] stringByAppendingPathComponent:appName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:appTempPath]) {
        [fileManager createDirectoryAtPath:appTempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return appTempPath;
}

+ (NSString*)zl_getParseFilePath {
    NSString *parseFilePath =nil;
    srandom((unsigned int)time((time_t *)NULL));
    parseFilePath = [[self zl_getAppSupportPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%qi", (long long)random()]];
    return parseFilePath;
}

+ (NSString *)zl_getItunesPath {
    return @"/iTunes_Control/iTunes/iTunesCDB";
}
@end
