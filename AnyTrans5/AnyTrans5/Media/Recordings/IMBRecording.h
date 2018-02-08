//
//  IMBRecording.h
//  iMobieTrans
//
//  Created by Pallas on 1/30/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMBiPod;

@interface IMBRecording : NSObject {
@private
    IMBiPod *iPod;
    NSString *_localPath;
    NSString *_recordingFolderPath;
    NSString *_remotingPath;
    NSMutableArray *_recordingArray;
    
    NSFileManager *fm;
}

@property (nonatomic, retain) NSMutableArray *recordingArray;


- (id)initWithIPod:(IMBiPod*)ipod;

- (BOOL)checkRecordingDB;

- (NSArray*)refreshRecordings;
//- (NSArray*)getRecordings;


- (BOOL)deleteRecording:(NSDictionary*)recordingsInfo;



@end
