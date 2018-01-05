//
//  Snapshot.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/2/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "SnapshotEx.h"
#import "CloudKit.pb.h"
#import "CategoryExtend.h"

@interface SnapshotEx ()

@property (nonatomic, readwrite, retain) SnapshotID *snapshotID;
@property (nonatomic, readwrite, retain) NSMutableData *backupProperties;
@property (nonatomic, readwrite, retain) NSMutableArray *manifests;
@property (nonatomic, readwrite, retain) NSString *relativePath;

@end

@implementation SnapshotEx
@synthesize snapshotID = _snapshotID;
@synthesize backupProperties = _backupProperties;
@synthesize manifests = _manifests;
@synthesize relativePath = _relativePath;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setSnapshotID:nil];
    [self setBackupProperties:nil];
    [self setManifests:nil];
    [super dealloc];
#endif
}

- (id)initWithBackupProperties:(NSMutableData *)backupProperties manifests:(NSMutableArray *)manifests record:(Record *)record withSnapshotID:(SnapshotID *)snapshotID {
    if (self = [super initWithRecord:record]) {
        if (!backupProperties) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"backupProperties" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (!manifests) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"manifests" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (!snapshotID) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"snapshotID" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setBackupProperties:backupProperties];
        [self setManifests:manifests];
        [self setSnapshotID:snapshotID];
        return self;
    }else {
        return nil;
    }
}

- (SnapshotID *)snapshotID {
    return _snapshotID;
}

- (NSMutableDictionary *)getBackupProperties {
    NSMutableDictionary *dic = [[self backupProperties] dataToMutableDictionary];
    return dic;
}

- (NSMutableArray*)getManifests {
    return [[[NSMutableArray alloc] initWithArray:[self manifests]] autorelease];
}

- (int64_t)quotaUsed {
    RecordFieldValue *fieldValue = [self recordFieldValue:@"quotaUsed"];
    if (fieldValue) {
        return (long)[fieldValue signedValue];
    }else {
        return -1L;
    }
}

- (NSString *)deviceName {
    RecordFieldValue *fieldValue = [self recordFieldValue:@"deviceName"];
    if (fieldValue) {
        return [fieldValue stringValue];
    }else {
        return @"";
    }
}

- (NSString *)deviceIOSVersion {
    NSString *iosVersion = @"";
    NSMutableDictionary *dic = [[self backupProperties] dataToMutableDictionary];
    NSArray *allKeyArray = [dic allKeys];
    if ([allKeyArray containsObject:@"Lockdown"]) {
        NSDictionary *lockdownDic = [dic objectForKey:@"Lockdown"];
        NSArray *lockdownArray = [lockdownDic allKeys];
        if ([lockdownArray containsObject:@"ProductVersion"]) {
            iosVersion = (NSString *)[lockdownDic objectForKey:@"ProductVersion"];
        }
    }
    return iosVersion;
}

- (NSString *)info {
    return [NSString stringWithFormat:@"%6lli MB %@", ([self quotaUsed] / 1048576), [self deviceName]];
}

@end
