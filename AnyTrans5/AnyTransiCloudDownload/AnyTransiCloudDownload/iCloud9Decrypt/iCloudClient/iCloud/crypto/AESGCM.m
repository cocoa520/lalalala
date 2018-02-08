//
//  AESGCM.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "AESGCM.h"
#import "Arrays.h"
#import "AesFastEngine.h"
#import "AeadParameters.h"
#import "CategoryExtend.h"
#import "GcmBlockCipher.h"
#import "KeyParameter.h"

@implementation AESGCM

/**
 * Returns decrypted data.
 *
 * @param key
 * @param nonce nonce/ IV
 * @param header
 * @param encryptedData
 * @param tag
 * @param optional optional AADBytes (post header)
 * @return decrypted data
 * @throws IllegalArgumentException on decryption exceptions
 * @throws NullPointerException on null arguments
 */
+ (NSMutableData*)decrypt:(NSMutableData*)key withNonce:(NSMutableData*)nonce withHeader:(NSMutableData*)header withEncryptedData:(NSMutableData*)encryptedData withTag:(NSMutableData*)tag withOptional:(NSMutableData*)optional {
    @try {
        NSMutableData *retData;
        @autoreleasepool {
            AesFastEngine *aesFast = [[AesFastEngine alloc] init];
            GcmBlockCipher *cipher = [[GcmBlockCipher alloc] initWithCipher:aesFast];
            KeyParameter *keyParam = [[KeyParameter alloc] initWithKey:key];
            AeadParameters *parameters = [[AeadParameters alloc] initWithKey:keyParam withMacSize:((int)(tag.length) * 8) withNonce:nonce withAssociatedText:header];
            [cipher init:NO withParameters:parameters];
            
            if (optional != nil) {
                [cipher processAadBytes:optional withInOff:0 withLen:(int)(optional.length)];
            }
            
            int totalLen = (int)(encryptedData.length) + (int)(tag.length);
            NSMutableData *outBytes = [[NSMutableData alloc] initWithSize:[cipher getOutputSize:totalLen]];
            
            int pos = [cipher processBytes:encryptedData withInOff:0 withLen:(int)(encryptedData.length) withOutBytes:outBytes withOutOff:0];
            pos += [cipher processBytes:tag withInOff:0 withLen:(int)(tag.length) withOutBytes:outBytes withOutOff:pos];
            pos += [cipher doFinal:outBytes withOutOff:pos];
            
            retData = [Arrays copyOfWithData:outBytes withNewLength:pos];
#if !__has_feature(objc_arc)
            if (aesFast != nil) [aesFast release]; aesFast = nil;
            if (cipher != nil) [cipher release]; cipher = nil;
            if (keyParam != nil) [keyParam release]; keyParam = nil;
            if (parameters != nil) [parameters release]; parameters = nil;
            if (outBytes != nil) [outBytes release]; outBytes = nil;
#endif
        }
        
        return (retData ? [retData autorelease] : nil);
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"IllegalState" reason:@"GCM decrypt error" userInfo:[exception userInfo]];
    }
}

@end
