//
//  IMBRecordingEntry.m
//  iMobieTrans
//
//  Created by Pallas on 1/30/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBRecordingEntry.h"

@implementation IMBRecordingEntry
@synthesize z_PK = _z_PK;
@synthesize name = _name;
@synthesize time = _time;
@synthesize timeLength = _timeLength;
@synthesize recorded = _recorded;
@synthesize path = _path;
@synthesize size = _size;
@synthesize sizeLength = _sizeLength;
@synthesize recordingKey = _recordingKey;
@synthesize exportPath = _exportPath;
@synthesize persistentID = _persistentID;
@synthesize fileIsExist = _fileIsExist;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
