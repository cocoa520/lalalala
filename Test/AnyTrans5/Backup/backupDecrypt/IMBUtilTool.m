//
//  IMBUtilTool.m
//  BackupTool_Mac
//
//  Created by Pallas on 1/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBUtilTool.h"
#import "TempHelper.h"
@implementation IMBUtilTool

+ (long long)fileSizeAtPath:(NSString*)filePath {
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

+ (NSString *)replacePathSpecialChar:(NSString *)fileName {
    if (![TempHelper stringIsNilOrEmpty:@""]) {
        fileName = [[[[[[[[[[[[[[[[fileName stringByReplacingOccurrencesOfString:@"\\" withString:@""]
                                  stringByReplacingOccurrencesOfString:@":" withString:@""]
                                 stringByReplacingOccurrencesOfString:@"*" withString:@""]
                                stringByReplacingOccurrencesOfString:@"?" withString:@""]
                               stringByReplacingOccurrencesOfString:@"\"" withString:@""]
                              stringByReplacingOccurrencesOfString:@"<" withString:@""]
                             stringByReplacingOccurrencesOfString:@">" withString:@""]
                            stringByReplacingOccurrencesOfString:@"|" withString:@""]
                           
                           stringByReplacingOccurrencesOfString:@"\a" withString:@""]
                          stringByReplacingOccurrencesOfString:@"\b" withString:@""]
                         stringByReplacingOccurrencesOfString:@"\f" withString:@""]
                        stringByReplacingOccurrencesOfString:@"\n" withString:@""]
                       stringByReplacingOccurrencesOfString:@"\r" withString:@""]
                      stringByReplacingOccurrencesOfString:@"\t" withString:@""]
                     stringByReplacingOccurrencesOfString:@"\v" withString:@""]
                    stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    }
    return fileName;
}

@end
