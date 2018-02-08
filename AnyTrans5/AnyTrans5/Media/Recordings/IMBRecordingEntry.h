//
//  IMBRecordingEntry.h
//  iMobieTrans
//
//  Created by Pallas on 1/30/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"
@interface IMBRecordingEntry : IMBBaseEntity {
@private
    int _z_PK;
    NSString *_name;
    NSString *_time;
    double _timeLength;
    NSString *_recorded;
    NSString *_path;
    NSString *_size;
    long _sizeLength;
    NSString *_recordingKey;
    NSString *_exportPath;
    long long _persistentID;
    BOOL _fileIsExist;
}

@property (nonatomic, readwrite) BOOL fileIsExist;
@property (nonatomic, readwrite) int z_PK;
@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) NSString *time;
@property (nonatomic, readwrite) double timeLength;
@property (nonatomic, readwrite, retain) NSString *recorded;
@property (nonatomic, readwrite, retain) NSString *path;
@property (nonatomic, readwrite, retain) NSString *size;
@property (nonatomic, readwrite) long sizeLength;
@property (nonatomic, readwrite, retain) NSString *recordingKey;
@property (nonatomic, readwrite, retain) NSString *exportPath;
@property (nonatomic, readwrite) long long persistentID;

@end
