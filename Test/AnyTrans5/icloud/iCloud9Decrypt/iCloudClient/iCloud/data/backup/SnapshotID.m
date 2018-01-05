//
//  SnapshotID.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/2/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "SnapshotID.h"

@interface SnapshotID ()

@property (nonatomic, assign) CFTimeInterval timestamp;
@property (nonatomic, readwrite, retain) NSString *iD;

@end

@implementation SnapshotID
@synthesize timestamp = _timestamp;
@synthesize iD = _iD;

- (id)initWithTimestamp:(CFTimeInterval)timestamp withID:(NSString*)iD {
    if (self = [super init]) {
        if (iD == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"iD" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setTimestamp:timestamp];
        [self setID:iD];
        return self;
    } else {
        return nil;
    }
}

- (instancetype)initWithID:(NSString *)iD
{
    if (self = [super init]) {
        if (iD == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"iD" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setID:iD];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

+ (SnapshotID *)from:(NSString *)snapshotID {
    SnapshotID *iD = [self parse:snapshotID];
    return iD;
}

+ (SnapshotID *)parse:(NSString *)parseID {
    NSArray *parseIDAry = [parseID componentsSeparatedByString:@":"];
    if (([parseIDAry count] != 2) || !([[parseIDAry objectAtIndex:0] isEqualToString:@"S"])) {
        NSLog(@"-- parse() - unexpected format: %@", parseID);
    }
    return ([parseIDAry count] < 2 ? nil : [[SnapshotID alloc] initWithID:[parseIDAry objectAtIndex:1]]);
}

- (BOOL)equals:(id)object {
    if (self == object) {
        return YES;
    }
    if (object == nil) {
        return NO;
    }
    if ([self class] != [object class]) {
        return NO;
    }
    SnapshotID *other = (SnapshotID*)object;
    if (self.iD != other.iD) {
        return NO;
    }
    if (![[self iD] isEqual:[other iD]]) {
        return NO;
    }
    return YES;
}

//public boolean equals(Object obj) {
//    if (this == obj) {
//        return true;
//    }
//    if (obj == null) {
//        return false;
//    }
//    if (getClass() != obj.getClass()) {
//        return false;
//    }
//    final SnapshotID other = (SnapshotID) obj;
//    if (!Objects.equals(this.uuid, other.uuid)) {
//        return false;
//    }
//    return true;
//}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setTimestamp:0];
    [self setID:nil];
    [super dealloc];
#endif
}

@end
