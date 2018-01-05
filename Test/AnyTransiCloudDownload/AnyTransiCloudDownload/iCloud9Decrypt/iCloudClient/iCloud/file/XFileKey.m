//
//  XFileKey.m
//  
//
//  Created by Pallas on 8/29/16.
//
//  Complete

#import "XFileKey.h"
#import "Arrays.h"
#import "BlockCipher.h"

@interface XFileKey ()

@property (nonatomic, readwrite, retain) NSMutableData *key;
@property (nonatomic, readwrite, retain) BlockCipher *ciphers;
@property (nonatomic, readwrite, retain) NSMutableData *flags;

@end

@implementation XFileKey
@synthesize key = _key;
@synthesize ciphers = _ciphers;
@synthesize flags = _flags;

- (id)initWithKey:(NSMutableData*)key withCiphers:(BlockCipher*)ciphers withFlags:(NSMutableData*)flags {
    if (self = [super init]) {
        if (!ciphers) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"ciphers" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (!flags) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"flags" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        NSMutableData *tmpData = [Arrays copyOfWithData:key withNewLength:(int)(key.length)];
        [self setKey:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        [self setCiphers:ciphers];
        [self setFlags:flags];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithKey:(NSMutableData*)key withCiphers:(BlockCipher*)ciphers {
    NSMutableData *tmpData = [[NSMutableData alloc] init];
    if (self = [self initWithKey:key withCiphers:ciphers withFlags:tmpData]) {
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setKey:nil];
    [self setCiphers:nil];
    [self setFlags:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)getKey {
    NSMutableData *retData = nil;
    if ([self key]) {
        retData = [Arrays copyOfWithData:[self key] withNewLength:(int)([self key].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getFlags {
    NSMutableData *retData = nil;
    if ([self flags]) {
        retData = [Arrays copyOfWithData:[self flags] withNewLength:(int)([self flags].length)];
    }
    return (retData ? [retData autorelease] : nil);
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
    XFileKey *other = (XFileKey*)object;
    if (![Arrays areEqualWithByteArray:[self key] withB:[other key]]) {
        return NO;
    }
    if (![[self ciphers] isEqual:[other ciphers]]) {
        return NO;
    }
    return YES;
}

@end
