//
//  GCMDataA.m
//  
//
//  Created by Pallas on 8/1/16.
//
//  Complete

#import "GCMDataA.h"
#import "AESGCM.h"
#import "CategoryExtend.h"

@implementation GCMDataA

+ (NSMutableData*)decrypt:(NSMutableData*)key withData:(NSMutableData*)data {
    return [GCMDataA decrypt:key withData:data withOptional:nil];
}

/**
 * Returns the decrypted data.
 *
 * @param key key
 * @param data encrypted data
 * @param optional optional AADBytes (post header)
 * @return decrypted data
 * @throws IllegalArgumentException on decryption exceptions
 * @throws NullPointerException on null arguments
 */
+ (NSMutableData*)decrypt:(NSMutableData*)key withData:(NSMutableData*)data withOptional:(NSMutableData*)optional {
    @try {
        // Network byte orderered data.
        DataStream *buffer = [DataStream wrapWithData:data];
        [buffer setOrder:BIG_ENDIAN_EX];
        
        int version = (uint)[buffer get];
        [buffer rewind];
        
        switch (version) {
            case 0: {
                // Not verified
                return [GCMDataA doDecrypt:buffer withKey:key withHeaderLength:1 withNonceLength:8 withTagLength:8 withOptional:optional];
            }
            case 1: {
                // Not verified
                return [GCMDataA doDecrypt:buffer withKey:key withHeaderLength:1 withNonceLength:12 withTagLength:12 withOptional:optional];
            }
            case 2: {
                // Not verified
                return [GCMDataA doDecrypt:buffer withKey:key withHeaderLength:3 withNonceLength:12 withTagLength:12 withOptional:optional];
            }
            case 3: {
                if ([buffer limit] < 4) {
                    @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"cipher text too short for header" userInfo:nil];
                }
                
                int headerLength = 4 + (uint)[buffer getFromIndex:3];
                return [GCMDataA doDecrypt:buffer withKey:key withHeaderLength:headerLength withNonceLength:12 withTagLength:12 withOptional:optional];
            }
            default: {
                @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"unsupported version: %d", version] userInfo:nil];
            }
        }
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"decryption exception" userInfo:[exception userInfo]];
    }
}

+ (NSMutableData*)doDecrypt:(DataStream*)buffer withKey:(NSMutableData*)key withHeaderLength:(int)headerLength withNonceLength:(int)nonceLength withTagLength:(int)tagLength withOptional:(NSMutableData*)optional {
    NSMutableData *decrypted;
    @autoreleasepool {
        int cipherTextLength = [buffer limit] - headerLength - nonceLength - tagLength;
        if (cipherTextLength < 0) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"cipher text too short" userInfo:nil];
        }
        
        NSMutableData *header = [[NSMutableData alloc] initWithSize:headerLength];
        [buffer getWithMutableData:header];
        
        NSMutableData *nonce = [[NSMutableData alloc] initWithSize:nonceLength];
        [buffer getWithMutableData:nonce];
        
        NSMutableData *tag = [[NSMutableData alloc] initWithSize:tagLength];
        [buffer getWithMutableData:tag];
        
        NSMutableData *encrypted = [[NSMutableData alloc] initWithSize:cipherTextLength];
        [buffer getWithMutableData:encrypted];
        
        decrypted = [[AESGCM decrypt:key withNonce:nonce withHeader:header withEncryptedData:encrypted withTag:tag withOptional:optional] retain];
        
#if !__has_feature(objc_arc)
        if (header != nil) [header release]; header = nil;
        if (nonce != nil) [nonce release]; nonce = nil;
        if (tag != nil) [tag release]; tag = nil;
        if (encrypted != nil) [encrypted release]; encrypted = nil;
#endif
    }
    
    return [decrypted autorelease];
}

@end
