//
//  ZLFileTool.h
//  TestNew
//
//  Created by iMobie on 18/1/10.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLFileTool : NSObject

+ (BOOL)zl_writeDataPlsitWithDataDic:(NSDictionary *)dataDic fileName:(NSString *)fileName;
+ (NSString*)zl_getAppSupportPath;
+ (NSString*)zl_getParseFilePath;
+ (NSString *)zl_getItunesPath;

@end



/**
 
 /iTunes_Control/iTunes/iTunesCDB
 
 **/