//
//  IMBTracklist.h
//  MediaTrans
//
//  Created by Pallas on 12/11/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBTrack.h"

@interface IMBTracklist : IMBBaseDatabaseElement{
@private
    int _trackCount;
    //存放的是IMBTrack对象数组
    NSMutableArray *_trackArray;
    NSMutableDictionary *_artistOfTrackDic;
    BOOL _isDirty;
    int64_t _freespace;
}

@property (nonatomic,readonly) NSMutableArray *trackArray;
@property (nonatomic,readonly) BOOL isDirty;
@property (nonatomic,assign)int64_t freespace;

- (void)freshFreeSpace;
- (int)getTrackCount;
- (IMBTrack*)getTrackByIndex:(int)index;
- (IMBTrack*)findByID:(int)trackID;
- (IMBTrack*)findByDBID:(long long)dbID;
- (BOOL)contains:(IMBTrack*)item;
- (IMBTrack*)getExistingTrack:(IMBNewTrack*)newTrack;
- (IMBTrack*)addTrack:(IMBNewTrack*)newItem copyToDevice:(BOOL)copyToDevice cacuTotalSize:(long long)calcuTotalSize;
- (IMBTrack*)addTrack:(IMBNewTrack*)newItem copyToDevice:(BOOL)copyToDevice calcuTotalSize:(long long)calcuTotalSize WithSrciPod:(IMBiPod*)srciPod;
- (BOOL)removeTrack:(IMBTrack*)track;
//通过媒体分类得到tracklist
//- (NSArray*)getTrackArrayByMediaTypes:(NSArray*)mediaTypes;

@end