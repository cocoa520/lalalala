//
//  IMBSyncPlistBuilder.h
//  iMobieTrans
//
//  Created by zhang yang on 13-4-8.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBSqliteTables_5.h"
#import "IMBiPod.h"
#import "IMBATHSync.h"
#import "IMBMusicDatabase.h"

@interface IMBSyncPlistBuilder : NSObject {
    IMBiPod *iPod;
    IMBSqliteTables_5 *sqliteTable_5;
    NSDictionary *_operationDic;
    IMBMusicDatabase *_database;
    NSArray *_delTrackList;
    NSArray *_tracks;
    NSArray *_applications;
    IMBSyncDataEntiy *_syncData;
    BOOL _isAdd;
    
}
-(id)initWithIpod:(IMBiPod*)aIPod;

-(id)initWithIpod:(IMBiPod *)aIPod operationDic:(NSMutableDictionary *)operationDic syncData:(IMBSyncDataEntiy *)syncData delPidList:(NSArray *)array;

- (id)initWithIpod:(IMBiPod *)aIPod opreationDic:(NSMutableDictionary *)operationDic syncData:(IMBSyncDataEntiy *)syncdata addTrackList:(NSArray *)addTrackList isAdd:(BOOL)isAdd;

- (id)initWithIpod:(IMBiPod *)aIPod opreationDic:(NSMutableDictionary *)operationDic syncData:(IMBSyncDataEntiy *)syncdata addTrackList:(NSArray *)addTrackList addAppList:(NSArray *)addAppList isAdd:(BOOL)isAdd;

-(void) createBinPlistWithPath:(NSString*) path WithRevision:(int)revision;
-(void) createBinRingToneHeadPlistWithPath:(NSString*) path WithRevision:(int)revision;
-(void) createBinOtherContentPlistWithPath:(NSString*) path WithRevision:(int)revision;
- (void)createVoiceMemoCigHeadPlistWithPath:(NSString *)path WithRevision:(int)revision;
- (void)createVoiceMemosContentPlist:(NSString*) path WithRevision:(int)revision;
- (BOOL)createDelVoiceMemosSyncPlist:(NSString *)path WithRevision:(int)revision pidList:(NSArray *)list;
- (BOOL)syncVoiceMemoAfterDelete:(IMBiPod *)ipod;
- (BOOL)InitSyncDataBaseInfo;
- (NSDictionary *)startCreateSyncDataPlist;
@end
