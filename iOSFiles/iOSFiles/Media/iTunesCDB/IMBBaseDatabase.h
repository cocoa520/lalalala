//
//  IMBBaseDatabase.h
//  MediaTrans
//
//  Created by Pallas on 12/16/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseDatabaseElement.h"
#import "IMBiPod.h"
#import "TempHelper.h"
#import "IMBSession.h"

@interface IMBBaseDatabase : NSObject{
    IMBiPod *iPod;
    NSData *reader;
    NSString *databaseFilePath;
    
    int _version;
}

@property (nonatomic,readonly) IMBiPod *IPod;
@property (nonatomic,readonly) int version;

#pragma mark - method
- (void)readDatabase:(IMBBaseDatabaseElement*)root;
- (void)writeDatabase:(IMBBaseDatabaseElement*)root;

- (NSString*)getParseFilePath;

#pragma mark - 子类需要实现的方法
- (void)parse;
- (void)save;
- (void)doActionOnWriteDatabase:(NSString*)filePath;

@end

// DB数据库被写的事件通知（其主要作用是通知去写Sqlite数据库）
@protocol DatabaseWritten
@optional
- (void)iTunesDB_DatabaseWritten:(IMBBaseDatabase*)sender parms:(NSMutableDictionary*)parms;

@end
