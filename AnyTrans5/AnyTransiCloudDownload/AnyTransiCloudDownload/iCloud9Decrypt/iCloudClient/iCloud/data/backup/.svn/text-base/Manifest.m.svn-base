//
//  Manifest.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 8/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//
//  Complete

#import "Manifest.h"

@interface Manifest ()

@property (nonatomic, assign) int count;
@property (nonatomic, assign) int checksum;
@property (nonatomic, readwrite, retain) NSString *iD;

@end

@implementation Manifest
@synthesize count = _count;
@synthesize checksum = _checksum;
@synthesize iD = _iD;

- (id)initWithCount:(int)count withChecksum:(int)checksum withID:(NSString*)iD {
    if (self = [super init]) {
        if (iD == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"iD" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setCount:count];
        [self setChecksum:checksum];
        [self setID:iD];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setID:nil];
    [super dealloc];
#endif
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (object == nil) {
        return NO;
    }
    if ([self class] != [object class]) {
        return NO;
    }
    Manifest *other = (Manifest*)object;
    if (self.count != other.count) {
        return NO;
    }
    if (self.checksum != other.checksum) {
        return NO;
    }
    if (![[self iD] isEqual:[other iD]]) {
        return NO;
    }
    return YES;
}

@end
