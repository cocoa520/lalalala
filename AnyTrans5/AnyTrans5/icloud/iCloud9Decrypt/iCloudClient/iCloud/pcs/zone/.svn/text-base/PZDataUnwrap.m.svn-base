//
//  PZDataUnwrap.m
//
//
//  Created by Pallas on 8/1/16.
//
//
//  Complete

#import "PZDataUnwrap.h"
#import "BigInteger.h"
#import "RFC6637Factory.h"
#import "Hex.h"

@interface PZDataUnwrap ()

@property (nonatomic, readwrite, retain) RFC6637 *rfc6637;
@property (nonatomic, readwrite, retain) NSMutableData *fingerprint;

@end

@implementation PZDataUnwrap
@synthesize rfc6637 = _rfc6637;
@synthesize fingerprint = _fingerprint;

+ (PZDataUnwrap*)instance {
    static PZDataUnwrap *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[PZDataUnwrap alloc] initWithRfc6637:[RFC6637Factory SECP256R1] withFingerprint:[Hex decodeWithString:@"66696E6765727072696E74000000000000000000"]];
        }
    }
    return _instance;
}

- (id)initWithRfc6637:(RFC6637*)rfc6637 withFingerprint:(NSMutableData*)fingerprint {
    if (self = [super init]) {
        if (rfc6637 == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"rfc6637" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (fingerprint == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"fingerprint" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setRfc6637:rfc6637];
        [self setFingerprint:fingerprint];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setRfc6637:nil];
    [self setFingerprint:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)apply:(NSMutableData*)wrappedData withD:(BigInteger*)d {
    return [[self rfc6637] unwrap:wrappedData withFingerprint:[self fingerprint] withD:d];
}

@end
