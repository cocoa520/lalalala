//
//  RFC6637Factory.m
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import "RFC6637Factory.h"
#import "RFC6637.h"
#import "Digest.h"
#import "Wrapper.h"
#import "ASN1ObjectIdentifier.h"
#import "ECNamedCurveTable.h"
#import "RFC6637KDF.h"
#import "Sha256Digest.h"
#import "Sha512Digest.h"
#import "Rfc3394WrapEngine.h"
#import "AesFastEngine.h"
#import "RFC6637Constants.h"

@implementation RFC6637Factory

+ (RFC6637*)SECP521R1 {
    static RFC6637 *_secp521r1 = nil;
    @synchronized(self) {
        if (_secp521r1 == nil) {
            Sha512Digest *sha512 = [[Sha512Digest alloc] init];
            AesFastEngine *aesFast = [[AesFastEngine alloc] init];
            Rfc3394WrapEngine *rfc3394Wrap = [[Rfc3394WrapEngine alloc] initWithEngine:aesFast];
            _secp521r1 = [[RFC6637Factory create:@"secp521r1" withDigest:sha512 withWrapper:rfc3394Wrap withPublicKeyAlgID:ECDH withSymAlgID:AES_256 withSymAlgIDLength:0x20 withKdfHashID:SHA512] retain];
#if !__has_feature(objc_arc)
            if (sha512 != nil) [sha512 release]; sha512 = nil;
            if (aesFast != nil) [aesFast release]; aesFast = nil;
            if (rfc3394Wrap != nil) [rfc3394Wrap release]; rfc3394Wrap = nil;
#endif
        }
    }
    return _secp521r1;
}

+ (RFC6637*)SECP256R1 {
    static RFC6637 *_secp256r1 = nil;
    @synchronized(self) {
        if (_secp256r1 == nil) {
            Sha256Digest *sha256 = [[Sha256Digest alloc] init];
            AesFastEngine *aesFast = [[AesFastEngine alloc] init];
            Rfc3394WrapEngine *rfc3394Wrap = [[Rfc3394WrapEngine alloc] initWithEngine:aesFast];
            _secp256r1 = [[RFC6637Factory create:@"secp256r1" withDigest:sha256 withWrapper:rfc3394Wrap withPublicKeyAlgID:ECDH withSymAlgID:AES_128 withSymAlgIDLength:0x10 withKdfHashID:SHA256] retain];
#if !__has_feature(objc_arc)
            if (sha256 != nil) [sha256 release]; sha256 = nil;
            if (aesFast != nil) [aesFast release]; aesFast = nil;
            if (rfc3394Wrap != nil) [rfc3394Wrap release]; rfc3394Wrap = nil;
#endif
        }
    }
    return _secp256r1;
}

+ (RFC6637*)create:(NSString*)curveName withDigest:(Digest*)digestFactory withWrapper:(Wrapper*)wrapperFactory withPublicKeyAlgID:(int)publicKeyAlgID withSymAlgID:(int)symAlgID withSymAlgIDLength:(int)symAlgIDLength withKdfHashID:(int)kdfHashID {
    @try {
        ASN1ObjectIdentifier *oid = [ECNamedCurveTable getOID:curveName];
        
        RFC6637KDF *kdf = [[RFC6637KDF alloc] initWithDigest:digestFactory withOid:oid withPublicKeyAlgID:(Byte)publicKeyAlgID withSymAlgID:(Byte)symAlgID withKdfHashID:(Byte)kdfHashID];
        
        RFC6637 *retVal = [[[RFC6637 alloc] initWithWrapper:wrapperFactory withCurveName:curveName withSymAlgIDKeyLength:symAlgIDLength withKdf:kdf] autorelease];
#if !__has_feature(objc_arc)
        if (kdf != nil) [kdf release]; kdf = nil;
#endif
        return retVal;
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"IllegalState" reason:[exception reason] userInfo:nil];
    }
}

@end
