//
//  IMBUtilTool.h
//  BackupTool_Mac
//
//  Created by Pallas on 1/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/stat.h>
#include <sys/sysctl.h>
//#import "NSString+Compare.h"

@interface IMBUtilTool : NSObject

+ (long long)fileSizeAtPath:(NSString*)filePath;

+ (NSString *)replacePathSpecialChar:(NSString *)fileName;

@end
