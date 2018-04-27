//
//  IMBPlayCountEntry.h
//  iMobieTrans
//
//  Created by Pallas on 1/15/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"

@interface IMBPlayCountEntry : IMBBaseDatabaseElement {
@private
    NSString *_persistentID;
    int _playCount;
    uint _lastPlayed;
    int _bookmarkPosition;
    int _rating;
    NSDate *_dateLastPlayed;
}

@property (nonatomic, readwrite, retain) NSString *persistentID;
@property (nonatomic, readwrite) int playCount;
@property (nonatomic, readwrite) uint lastPlayed;
@property (nonatomic, readwrite) int rating;
@property (nonatomic, getter = dateLastPlayed, readonly) NSDate *dateLastPlayed;

- (NSDate*)dateLastPlayed;

- (id)initWithSize:(int)entrySize;

@end
