//
//  IMBLogManager.m
//  iMobieTrans
//
//  Created by Pallas on 7/31/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBLogManager.h"

@implementation IMBLogManager
@synthesize logFilePath = _logFilePath;
@synthesize logsFolderPath = _logsFolderPath;

static const int ddLogLevel = LOG_LEVEL_INFO;

- (id)init {
    self = [super init];
    if (self) {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        _logsFolderPath = [[IMBHelper getAppSupportPath] stringByAppendingPathComponent:@"LogsFolder"];
        DDLogFileManagerDefault *defaultLogFile = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:_logsFolderPath];
        DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:defaultLogFile];
        fileLogger.rollingFrequency = 60 * 60 * 24 * 7; // 24 hour rolling
        [fileLogger setMaximumFileSize:1024*1024*5];
        [DDLog addLogger:fileLogger];
        _logFilePath = [[[fileLogger currentLogFileInfo] filePath] retain];
    }
    return self;
}

+ (IMBLogManager *)singleton {
    static IMBLogManager *_singleton = nil;
    @synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBLogManager alloc] init];
		}
	}
	return _singleton;
}

- (void)writeErrorLog:(NSString *)logMessage {
    DDLogError(logMessage);
}

- (void)writeInfoLog:(NSString *)logMessage {
    DDLogInfo(logMessage);
}

- (void)writeWarnLog:(NSString *)logMessage {
    DDLogWarn(logMessage);
}

@end
