//
//  SnapshotID.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/2/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import <Foundation/Foundation.h>

@interface SnapshotID : NSObject {
@private
    CFTimeInterval                          _timestamp;
    NSString *                              _iD;
}

- (CFTimeInterval)timestamp;
- (NSString*)iD;

- (id)initWithTimestamp:(CFTimeInterval)timestamp withID:(NSString*)iD;
- (instancetype)initWithID:(NSString *)iD;
+ (SnapshotID *)from:(NSString *)snapshotID;

@end
