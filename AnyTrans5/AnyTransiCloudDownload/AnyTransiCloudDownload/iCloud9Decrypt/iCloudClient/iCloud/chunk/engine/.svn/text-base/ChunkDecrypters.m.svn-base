//
//  ChunkDecrypters.m
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "ChunkDecrypters.h"
#import "AesFastEngine.h"
#import "CategoryExtend.h"
#import "CfbBlockCipherEx.h"
#import "StreamBlockCipher.h"
#import "KeyParameter.h"

@implementation ChunkDecrypters

+ (NSMutableData*)decrypt:(NSMutableData*)key withData:(NSMutableData*)data withOffset:(int)offset withLength:(int)length {
    AesFastEngine *aesFast = [[AesFastEngine alloc] init];
    StreamBlockCipher *cipher = [[CfbBlockCipherEx alloc] initWithCipher:aesFast withBitBlockSize:128];
    NSMutableData *retData = [ChunkDecrypters decrypt:key withCipher:cipher withData:data withOffset:offset withLength:length];
#if !__has_feature(objc_arc)
    if (aesFast != nil) [aesFast release]; aesFast = nil;
    if (cipher != nil) [cipher release]; cipher = nil;
#endif
    return retData;
}

+ (NSMutableData*)decrypt:(NSMutableData*)key withCipher:(StreamBlockCipher*)cipher withData:(NSMutableData*)data withOffset:(int)offset withLength:(int)length {
    @try {
        KeyParameter *keyParameter = [[KeyParameter alloc] initWithKey:key];
        [cipher init:NO withParameters:keyParameter];
        NSMutableData *decrypted = [[[NSMutableData alloc] initWithSize:length] autorelease];
        [cipher processBytes:data withInOff:offset withLen:length withOutBytes:decrypted withOutOff:0];
#if !__has_feature(objc_arc)
        if (keyParameter != nil) [keyParameter release]; keyParameter = nil;
#endif
        return decrypted;
    }
    @catch (NSException *exception) {
        NSLog(@"-- decrypt() - exception: %@", [exception reason]);
        return nil;
    }
}

@end
