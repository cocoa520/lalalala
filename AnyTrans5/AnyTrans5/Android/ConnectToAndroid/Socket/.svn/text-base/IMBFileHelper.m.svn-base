//
//  IMBFileHelper.m
//  
//
//  Created by ding ming on 17/3/16.
//
//

#import "IMBFileHelper.h"

@implementation IMBFileHelper

+ (id)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err != nil) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSString *jsonStr = nil;
    if (dic != nil) {
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
            jsonStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
            NSLog(@"jsonStr:%@",jsonStr);
        }
    }
    return jsonStr;
}

+ (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if (string == nil || [string isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

//如果file已经存在，则生成别名
+(NSString*)getFilePathAlias:(NSString*)filePath {
    NSString *newPath = filePath;
    NSFileManager *fm = [NSFileManager defaultManager];
    int i = 1;
    NSString *filePathWithOutExt = [filePath stringByDeletingPathExtension];
    NSString *fileExtension = [filePath pathExtension];
    while ([fm fileExistsAtPath:newPath]) {
        newPath = [NSString stringWithFormat:@"%@(%d).%@",filePathWithOutExt,i++,fileExtension];
    }
    return newPath;
}

+(NSString*)getAppSupportPath{
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
+(NSString*)getAppTempPath {
    NSString *tmpPath = [[self getAppSupportPath] stringByAppendingPathComponent:@"tmp"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tmpPath]) {
        [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tmpPath;
}

@end
