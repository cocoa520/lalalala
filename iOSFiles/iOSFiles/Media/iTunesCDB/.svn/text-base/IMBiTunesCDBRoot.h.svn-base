//
//  IMBiTunesCDBRoot.h
//  MediaTrans
//
//  Created by Pallas on 12/10/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBiTunesDBRoot.h"
//#import "IMBGZipUtility.h"
#import "IMBBaseDatabase.h"

@class IMBSqliteTables;

@interface IMBiTunesCDBRoot : IMBiTunesDBRoot<DatabaseWritten> {
@private
    NSMutableArray *dirtyTracksArray;
    NSMutableArray *dirtyPlaylistArray;
    
    NSData *decompressionData;
    NSData *CompressionData;
}
- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition;

@end
