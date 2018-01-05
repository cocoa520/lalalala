//
//  BackupAccount.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "BackupAccount.h"
#import "Arrays.h"

@interface BackupAccount ()

@property (nonatomic, readwrite, retain) NSMutableData *hmacKey;
@property (nonatomic, readwrite, retain) NSMutableArray *devices;

@end

@implementation BackupAccount
@synthesize hmacKey  = _hmacKey;
@synthesize devices = _devices;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setHmacKey:nil];
    [self setDevices:nil];
    [super dealloc];
#endif
}

- (instancetype)initWithHmacKey:(NSMutableData *)hmacKey devices:(NSMutableArray *)devices
{
    if (self = [super init]) {
        NSMutableData *tmpData = [Arrays copyOfWithData:hmacKey withNewLength:(int)[hmacKey length]];
        [self setHmacKey:tmpData];
        NSMutableArray *tmpAry = [[NSMutableArray alloc] initWithArray:devices];
        [self setDevices:tmpAry];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
        if (tmpAry) [tmpAry release]; tmpAry = nil;
#endif
        return self;
    }else {
        return nil;
    }
}

- (NSMutableData *)getHmacKey {
    NSMutableData *retData = nil;
    if ([self hmacKey]) {
        retData = [Arrays copyOfWithData:[self hmacKey] withNewLength:(int)[self.hmacKey length]];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableArray *)devices {
    return [[[NSMutableArray alloc] initWithArray:_devices] autorelease];
}

@end
