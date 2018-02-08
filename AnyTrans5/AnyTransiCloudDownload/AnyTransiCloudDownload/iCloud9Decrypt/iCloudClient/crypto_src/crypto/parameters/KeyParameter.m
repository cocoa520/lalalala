//
//  KeyParameter.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "KeyParameter.h"
#import "CategoryExtend.h"

@interface KeyParameter ()

@property (nonatomic, readwrite, retain) NSMutableData *key;

@end

@implementation KeyParameter
@synthesize key = _key;

- (id)initWithKey:(NSMutableData*)key {
    if (self = [super init]) {
        if (key == nil) {
            @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"key" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        @autoreleasepool {
            int dataLength = (int)(key.length);
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:dataLength];
            [tmpData copyFromIndex:0 withSource:key withSourceIndex:0 withLength:dataLength];
            [self setKey:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithKey:(NSMutableData*)key withKeyOff:(int)keyOff withKeyLen:(int)keyLen {
    if (self = [super init]) {
        if (key == nil) {
            @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"key" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (keyOff < 0 || keyOff > key.length) {
            @throw [NSException exceptionWithName:@"ArgumentOutOfRange" reason:@"keyOff" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (keyLen < 0 || (keyOff + keyLen) > key.length) {
            @throw [NSException exceptionWithName:@"ArgumentOutOfRange" reason:@"keyLen" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        @autoreleasepool {
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:keyLen];
            [self setKey:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
            [[self key] copyFromIndex:0 withSource:key withSourceIndex:keyOff withLength:keyLen];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setKey:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)getKey {
    int keyLength = (int)([self key].length);
    NSMutableData *retData = [[[NSMutableData alloc] initWithSize:keyLength] autorelease];
    [retData copyFromIndex:0 withSource:[self key] withSourceIndex:0 withLength:keyLength];
    return retData;
}

@end
