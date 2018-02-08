//
//  IMBFileHelper.h
//  
//
//  Created by ding ming on 17/3/16.
//
//

#import <Foundation/Foundation.h>

@interface IMBFileHelper : NSObject

+ (id)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
+ (BOOL)stringIsNilOrEmpty:(NSString*)string;
//如果file已经存在，则生成别名
+(NSString*)getFilePathAlias:(NSString*)filePath;

+(NSString*)getAppSupportPath;
+(NSString*)getAppTempPath;

@end
