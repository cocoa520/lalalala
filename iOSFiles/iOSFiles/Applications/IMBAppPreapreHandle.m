//
//  IMBAppPreapreHandle.m
//  iMobieTrans
//
//  Created by iMobie on 8/21/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBAppPreapreHandle.h"
#import "IMBNewTrack.h"
#import "IMBSyncAppBuilder.h"

@implementation IMBAppPreapreHandle

- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}

+(IMBAppPreapreHandle *)singleton{
    static IMBAppPreapreHandle *token;
    @synchronized(self){
        if (token == nil) {
            token = [[IMBAppPreapreHandle alloc] init];
        }
    }
    return token;
}

//TODO:未完待续

- (BOOL)checkDeviceSupportApp:(NSDictionary *)dictionary{
    return NO;
}

- (NSString *)getAppCachePath{
    NSString *sessionFolder = [_ipod.session sessionFolderPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *tmpPath = [sessionFolder stringByAppendingPathComponent:@"tmp"];
    if (![fm fileExistsAtPath:sessionFolder]) {
        [fm createDirectoryAtPath:sessionFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fm fileExistsAtPath:tmpPath]){
        [fm removeItemAtPath:tmpPath error:nil];
    }
    return tmpPath;
}

- (void)getAppSpringboardIconStatePlist{
    NSString *appTmpPath = [self getAppCachePath];
    NSString *splocalPath = [IMBSyncAppBuilder tempPathOfIconState:appTmpPath inIpod:_ipod];
    IMBSyncAppBuilder *builder = [IMBSyncAppBuilder singletone];
    builder.sbIconStatePath = splocalPath;
}

- (void)CheckAppAvailable:(NSArray *)array{
    
}

- (void)dealloc{
    [super dealloc];
}

@end
