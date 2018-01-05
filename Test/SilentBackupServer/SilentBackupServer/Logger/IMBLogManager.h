//
//  IMBLogManager.h
//  iMobieTrans
//
//  Created by Pallas on 7/31/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"
#import "IMBHelper.h"

@interface IMBLogManager : NSObject {
@private
    NSString *_logFilePath;
    NSString *_logsFolderPath;
}

@property (nonatomic, readonly) NSString *logFilePath;
@property (nonatomic, readonly) NSString *logsFolderPath;

+ (IMBLogManager *)singleton;

- (void)writeErrorLog:(NSString *)logMessage;

- (void)writeInfoLog:(NSString *)logMessage;

- (void)writeWarnLog:(NSString *)logMessage;

@end
