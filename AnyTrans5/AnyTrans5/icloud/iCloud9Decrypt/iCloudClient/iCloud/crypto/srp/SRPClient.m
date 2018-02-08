//
//  SRPClient.m
//  
//
//  Created by Pallas on 4/27/16.
//
//  Complete

#import "SRPClient.h"
#import "Arrays.h"
#import "BigInteger.h"
#import "Digest.h"
#import "SecureRandom.h"
#import "SRP6Utilities.h"
#import "SRPCore.h"

@interface SRPClient ()

@property (nonatomic, readwrite, retain) SecureRandom *random;
@property (nonatomic, readwrite, retain) Digest *digest;
@property (nonatomic, readwrite, retain) BigInteger *n;
@property (nonatomic, readwrite, retain) BigInteger *g;
@property (nonatomic, readwrite, retain) BigInteger *a;
@property (nonatomic, readwrite, retain) NSMutableData *ephemeralKeyA;
@property (nonatomic, readwrite, retain) NSMutableData *key;
@property (nonatomic, readwrite, retain) NSMutableData *m1;

@end

@implementation SRPClient
@synthesize random = _random;
@synthesize digest = _digest;
@synthesize n = _n;
@synthesize g = _g;
@synthesize a = _a;
@synthesize ephemeralKeyA = _ephemeralKeyA;
@synthesize key = _key;
@synthesize m1 = _m1;

- (id)initWithRandom:(SecureRandom*)random withDigest:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g {
    if (self = [super init]) {
        [self setRandom:random];
        [self setDigest:digest];
        [self setN:n];
        [self setG:g];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_random != nil) [_random release]; _random = nil;
    if (_digest != nil) [_digest release]; _digest = nil;
    if (_n != nil) [_n release]; _n = nil;
    if (_g != nil) [_g release]; _g = nil;
    if (_a != nil) [_a release]; _a = nil;
    if (_ephemeralKeyA != nil) [_ephemeralKeyA release]; _ephemeralKeyA = nil;
    if (_key != nil) [_key release]; _key = nil;
    if (_m1 != nil) [_m1 release]; _m1 = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)generateClientCredentials  {
    return [self generateClientCredentials:[SRP6Utilities generatePrivateValue:[self digest] withN:[self n] withG:[self g] withRandom:[self random]]];
}

- (NSMutableData*)generateClientCredentials:(BigInteger*)a {
    // Package private test injection point.
    [self setA:a];
    
    [self setEphemeralKeyA:[SRPCore generateEphemeralKeyA:[self n] withG:[self g] withA:a]];
    
    NSMutableData *retData = nil;
    if ([self ephemeralKeyA]) {
        retData = [Arrays copyOfWithData:[self ephemeralKeyA] withNewLength:(int)([self ephemeralKeyA].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)calculateClientEvidenceMessage:(NSMutableData*)salt withIdentity:(NSMutableData*)identity withPassword:(NSMutableData*)password withServerB:(NSMutableData*)serverB {
    if ([self ephemeralKeyA] == nil) {
        @throw [NSException exceptionWithName:@"IllegalState" reason:@"Client credentials not yet generated" userInfo:nil];
    }
    
    BigInteger *B = [[BigInteger alloc] initWithSign:1 withBytes:serverB];
    
    if ([SRPCore isZero:[self n] withI:B]) {
        return nil;
    }
    
    BigInteger *u = [SRPCore generateu:[self digest] withA:[self ephemeralKeyA] withB:serverB];
    BigInteger *x = [SRPCore generatex:[self digest] withN:[self n] withSalt:salt withIdentity:identity withPassword:password];
    BigInteger *k = [SRPCore generatek:[self digest] withN:[self n] withG:[self g]];
    BigInteger *S = [SRPCore generateS:[self digest] withN:[self n] withG:[self g] withA:[self a] withK:k withU:u withX:x withB:B];
    
    [self setKey:[SRPCore generateKey:[self digest] withN:[self n] withS:S]];
    [self setM1:[SRPCore generateM1:[self digest] withN:[self n] withG:[self g] withEphemeralKeyA:[self ephemeralKeyA] withEphemeralKeyB:serverB withKey:[self key] withSalt:salt withIdentity:identity]];
    
    return [self m1];
}

- (NSMutableData*)verifyServerEvidenceMessage:(NSMutableData*)serverM2 {
    NSMutableData *computedM2 = [SRPCore generateM2:[self digest] withN:[self n] withA:[self ephemeralKeyA] withM1:[self m1] withK:[self key]];
    
    NSMutableData *retData = nil;
    if ([Arrays areEqualWithByteArray:computedM2 withB:serverM2]) {
        if ([self key]) {
            retData = [Arrays copyOfWithData:[self key] withNewLength:(int)([self key].length)];
        }
    }
    
    return (retData ? [retData autorelease] : nil);
}

@end
