//
//  ModifyOfflineTaskAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/4/28.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "ModifyOfflineTaskAPI.h"

@implementation ModifyOfflineTaskAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return OfflineTaskCreateURL;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPATCH;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _userLogintoken];
    return @{
             @"Authorization": authorizationHeaderValue,
             @"Client": @"Cloud Drive/1.0.0",
             @"accept": @"application/json"
             };
}

- (id)requestArgument {
    return @{
             @"name": _offlineName,                         //任务名称
             @"type": _offlineType,                         //任务类型, type: one-way/two-way
             @"mode": _offlineMode,                         //传输模式, mode: move/copy/backup
             @"scope": _offlineScope,                       //传输范围, scope: file/folder/留空（双向同步）
             @"conflict": _offlineConflict,                 //冲突处理, conflict: skip/overwrite/rename/留空（双向同步）
             @"frequency": _offlineFrequency,               //执行频率, frequency: once/day/week/month
             @"execute_time": _offlineExecuteTime           //执行时间
             };
}

@end
