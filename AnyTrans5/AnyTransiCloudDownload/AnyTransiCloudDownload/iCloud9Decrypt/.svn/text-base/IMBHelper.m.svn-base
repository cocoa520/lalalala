//
//  IMBHelper.m
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBHelper.h"
#import "IMBLogManager.h"
@implementation IMBHelper

+ (id)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err != nil) {
//        [[IMBLogManager singleton]writeInfoLog:[NSString stringw]];
        [[IMBLogManager singleton] writeErrorLog:[NSString stringWithFormat:@"json解析失败:%@  jsonString: %@",err,jsonString]];

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

@end

