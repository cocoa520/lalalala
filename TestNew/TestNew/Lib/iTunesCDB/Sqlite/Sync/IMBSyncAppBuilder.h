//
//  IMBSyncAppBuilder.h
//  iMobieTrans
//
//  Created by iMobie on 8/21/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
//#import "IMBLogManager.h"
#import "IMBSession.h"
#import "IMBFileSystem.h"

@class IMBSyncAppBuilder;

typedef enum {
    Install,
    Remove
}AppOperation;

@interface IMBSyncAppBuilder : NSObject{
    AppOperation _operation;
    NSString *_appSyncPath;
    NSString *_sbIconStatePath;
    IMBiPod *_ipod;
//    IMBLogManager *_logManager;
}

@property (nonatomic,retain) NSString *appSyncPath;
@property (nonatomic,retain) NSString *sbIconStatePath;
@property (nonatomic,assign) AppOperation operation;


+ (IMBSyncAppBuilder*)singletone;
- (BOOL)createAppSyncPlist:(IMBiPod *)ipod appSyncs:(NSArray *)appSyncs appSyncPath:(NSString *)appSyncPath appIconStatePath:(NSString *)appIconStatePath;
+ (NSString *)tempPathOfIconState:(NSString*)localFolderPath inIpod:(IMBiPod *)ipod;
@end
