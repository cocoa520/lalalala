//
//  IMBAddTrackToList.h
//  iMobieTrans
//
//  Created by Pallas on 2/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDelete.h"

@interface IMBAddTrackToList : IMBBaseDelete {
@private
    NSArray *_tracksArray;
    int64_t _playlistID;
}

- (id)initWithIPodKey:(NSString *)ipodKey tracksArray:(NSArray*)tracksArray playlistID:(int64_t)playlistID;
- (void)startAddTrackToList;

@end
