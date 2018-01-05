//
//  RFC3394Wrap.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "RFC3394Wrap.h"
#import "AesFastEngine.h"
#import "KeyParameter.h"
#import "Rfc3394WrapEngine.h"

@implementation RFC3394Wrap

+ (NSMutableData*)unwrap:(NSMutableData*)keyEncryptionKey withWrappedKey:(NSMutableData*)wrappedKey {
    NSMutableData *retData = nil;
    @autoreleasepool {
        @try {
            AesFastEngine *aesFast = [[AesFastEngine alloc] init];
            Rfc3394WrapEngine *engine = [[Rfc3394WrapEngine alloc] initWithEngine:aesFast];
            KeyParameter *keyParam = [[KeyParameter alloc] initWithKey:keyEncryptionKey];
            [engine init:NO withParameters:keyParam];
            retData = [[engine unwrap:wrappedKey withInOff:0 withLength:(int)(wrappedKey.length)] retain];
#if !__has_feature(objc_arc)
            if (aesFast != nil) [aesFast release]; aesFast = nil;
            if (engine != nil) [engine release]; engine = nil;
            if (keyParam != nil) [keyParam release]; keyParam = nil;
#endif
        }
        @catch (NSException *exception) {
//            NSLog(@"-- unwrap() - InvalidCipherTextException: %@", [exception reason]);
        }
    }
    return (retData ? [retData autorelease] : nil);
}

+ (NSMutableData*)wrap:(NSMutableData*)keyEncryptionKey withUnwrappedKey:(NSMutableData*)unwrappedKey {
    NSMutableData *retData;
    @autoreleasepool {
        @try {
            AesFastEngine *aesFast = [[AesFastEngine alloc] init];
            Rfc3394WrapEngine *engine = [[Rfc3394WrapEngine alloc] initWithEngine:aesFast];
            KeyParameter *keyParam = [[KeyParameter alloc] initWithKey:keyEncryptionKey];
            [engine init:YES withParameters:keyParam];
            retData = [[engine wrap:unwrappedKey withInOff:0 withLength:(int)(unwrappedKey.length)] retain];
#if !__has_feature(objc_arc)
            if (aesFast != nil) [aesFast release]; aesFast = nil;
            if (engine != nil) [engine release]; engine = nil;
            if (keyParam != nil) [keyParam release]; keyParam = nil;
#endif
        }
        @catch (NSException *exception) {
        }
    }
    return [retData autorelease];
}

@end
