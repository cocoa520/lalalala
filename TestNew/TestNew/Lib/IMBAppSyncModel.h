//
//  IMBAppSyncModel.h
//  iMobieTrans
//
//  Created by iMobie on 8/21/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBAppSyncModel : NSObject{
    NSString *_identifier;
    NSString *_appName;
    NSString *_appVersion;
    NSString *_appFilePath;
    NSString *_appCachePath;
}

@property (nonatomic,copy) NSString *identifier;
@property (nonatomic,copy) NSString *appName;
@property (nonatomic,copy) NSString *appVersion;
@property (nonatomic,copy) NSString *appFilePath;
@property (nonatomic,copy) NSString *appCachePath;

@end
