//
//  GCMDataB.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "GCMDataB.h"
#import "Arrays.h"
#import "AesFastEngine.h"
#import "AeadParameters.h"
#import "CategoryExtend.h"
#import "GcmBlockCipher.h"
#import "KeyParameter.h"

@implementation GCMDataB

static int GCMDataB_NONCE_LENGTH = 0x10;
static int GCMDataB_TAG_LENGTH = 0x10;

+ (NSMutableData*)decrypt:(NSMutableData*)key withData:(NSMutableData*)data {
    // TODO utilize GCMAES#decrypt method
    @try {
        NSMutableData *retData = nil;
        @autoreleasepool {
            if (data.length < GCMDataB_NONCE_LENGTH + GCMDataB_TAG_LENGTH) {
                @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"data packet too short" userInfo:nil];
            }
            
            int cipherTextLength = (int)(data.length) - GCMDataB_NONCE_LENGTH - GCMDataB_TAG_LENGTH;
            
            NSMutableData *nonce = [Arrays copyOfWithData:data withNewLength:GCMDataB_NONCE_LENGTH];
            
            AesFastEngine *aesFast = [[AesFastEngine alloc] init];
            GcmBlockCipher *cipher = [[GcmBlockCipher alloc] initWithCipher:aesFast];
            KeyParameter *keyParam = [[KeyParameter alloc] initWithKey:key];
            AeadParameters *parameters = [[AeadParameters alloc] initWithKey:keyParam withMacSize:(GCMDataB_TAG_LENGTH * 8) withNonce:nonce];
            [cipher init:NO withParameters:parameters];
            
            NSMutableData *outBytes = [[NSMutableData alloc] initWithSize:[cipher getOutputSize:(cipherTextLength + GCMDataB_TAG_LENGTH)]];
            
            int pos = [cipher processBytes:data withInOff:GCMDataB_NONCE_LENGTH withLen:((int)(data.length) - GCMDataB_NONCE_LENGTH) withOutBytes:outBytes withOutOff:0];
            pos += [cipher doFinal:outBytes withOutOff:pos];
            
            if (outBytes) {
                retData = [Arrays copyOfWithData:outBytes withNewLength:pos];
            }
#if !__has_feature(objc_arc)
            if (aesFast != nil) [aesFast release]; aesFast = nil;
            if (cipher != nil) [cipher release]; cipher = nil;
            if (keyParam != nil) [keyParam release]; keyParam = nil;
            if (nonce != nil) [nonce release]; nonce = nil;
            if (parameters != nil) [parameters release]; parameters = nil;
            if (outBytes != nil) [outBytes release]; outBytes = nil;
#endif
        }
        return (retData ? [retData autorelease] : nil);
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:[exception reason] userInfo:[exception userInfo]];
    }
}

@end
