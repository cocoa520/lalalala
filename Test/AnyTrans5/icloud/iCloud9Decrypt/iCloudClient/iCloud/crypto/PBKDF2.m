//
//  PBKDF2.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "PBKDF2.h"
#import "Digest.h"
#import "Sha1Digest.h"
#import "Pkcs5S2ParametersGenerator.h"
#import "KeyParameter.h"

@implementation PBKDF2

+ (NSMutableData*)generate:(NSMutableData*)password withSalt:(NSMutableData*)salt withIterations:(int)iterations withLengthBits:(int)lengthBits {
    Sha1Digest *sha1 = [[Sha1Digest alloc] init];
    NSMutableData *retData  = [PBKDF2 generate:sha1 withPassword:password withSalt:salt withIterations:iterations withLengthBits:lengthBits];
#if !__has_feature(objc_arc)
    if (sha1 != nil) [sha1 release]; sha1 = nil;
#endif
    return retData;
}

+ (NSMutableData*)generate:(Digest*)digest withPassword:(NSMutableData*)password withSalt:(NSMutableData*)salt withIterations:(int)iterations withLengthBits:(int)lengthBits {
    NSMutableData *retData = nil;
    @autoreleasepool {
        @try {
            Pkcs5S2ParametersGenerator *generator = [[Pkcs5S2ParametersGenerator alloc] initWithDigest:digest];
            [generator init:password withSalt:salt withIterationCount:iterations];
            retData = [[(KeyParameter*)[generator generateDerivedParameters:lengthBits] getKey] retain];
#if !__has_feature(objc_arc)
            if (generator != nil) [generator release]; generator = nil;
#endif
        }
        @catch (NSException *exception) {
        }
    }
    return [retData autorelease];
}

@end