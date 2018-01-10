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

@end
