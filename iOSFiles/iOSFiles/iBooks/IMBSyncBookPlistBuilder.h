//
//  IMBSyncBookPlist.h
//  iMobieTrans
//
//  Created by iMobie on 5/8/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBookEntity.h"
#import "IMBiPod.h"
typedef enum {
    Add,
    Del,
} BuilderType;

#define _syncPlist @"/Books/Sync/Books.plist"
#define _booksPlist @"/Books/Books.plist"
#define _bookDB @"/Books/Sync/Database/OutstandingAsset_4.sqlite"
#define _bookshmDB @"/Books/Sync/Database/OutstandingAsset_4.sqlite-shm"
#define _bookwalDB @"/Books/Sync/Database/OutstandingAsset_4.sqlite-wal"


@interface IMBSyncBookPlistBuilder : NSObject{
    IMBiPod *iPod;
    BuilderType _builderType;
    NSMutableArray *_delPidPlist;
    NSString *_localTempFolder;
    IMBLogManager *logHandle;
}

- (id)initWithIpod:(IMBiPod *)ipod;

- (id)initWithIpod:(IMBiPod *)ipod delPidList:(NSArray *)delPidList;

+ (NSMutableDictionary*)parsePlist:(IMBiPod*)ipod;
+ (void)createTrack:(NSDictionary*)bookInfoDic witIpod:(IMBiPod *)ipod;
+ (void)createTrack:(id)entity withIpod:(IMBiPod *)ipod;
+ (NSDictionary *)getRemoteEpubInfoDic:(NSString *)remotePath withIpod:(IMBiPod *)ipod;
- (NSMutableDictionary *)loadBookDataToDictionary;
@end
