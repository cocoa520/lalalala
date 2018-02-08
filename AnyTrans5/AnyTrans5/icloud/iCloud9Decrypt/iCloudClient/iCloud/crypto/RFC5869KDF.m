//
//  RFC5869KDF.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "RFC5869KDF.h"
#import "CategoryExtend.h"
#import "Digest.h"
#import "HKDFParameters.h"
#import "HKDFBytesGenerator.h"

@implementation RFC5869KDF

+ (NSMutableData*)apply:(NSMutableData*)ikm withSalt:(NSMutableData*)salt withInfo:(NSMutableData*)info withDigest:(Digest*)digestSupplier withKeyLengthBytes:(int)keyLengthBytes {
    Digest *hash = digestSupplier;
    NSMutableData *okm = [[[NSMutableData alloc] initWithSize:keyLengthBytes] autorelease];
    @autoreleasepool {
        @try {
            HKDFParameters *params = [[HKDFParameters alloc] initWithIkm:ikm withSalt:salt withInfo:info];
            HKDFBytesGenerator *hkdf = [[HKDFBytesGenerator alloc] initWithDigest:hash];
            [hkdf init:params];
            [hkdf generateBytes:okm withOutOff:0 withLen:keyLengthBytes];
#if !__has_feature(objc_arc)
            if (params != nil) [params release]; params = nil;
            if (hkdf != nil) [hkdf release]; hkdf = nil;
#endif
        }
        @catch (NSException *exception) {
        }
    }
    return okm;
}

@end
