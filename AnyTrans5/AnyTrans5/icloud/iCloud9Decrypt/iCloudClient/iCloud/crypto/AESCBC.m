//
//  AESCBC.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "AESCBC.h"
#import "Arrays.h"
#import "AesFastEngine.h"
#import "CategoryExtend.h"
#import "CipherParameters.h"
#import "CbcBlockCipher.h"
#import "ParametersWithIV.h"
#import "PaddedBufferedBlockCipher.h"
#import "Pkcs7Padding.h"
#import "KeyParameter.h"


@implementation AESCBC

+ (NSMutableData*)decryptAESCBC:(NSMutableData*)key withIv:(NSMutableData*)iv withData:(NSMutableData*)data {
    // AES CBC PKCS7 decrypt
    @try {
        NSMutableData *retData;
        @autoreleasepool {
            KeyParameter *keyParam = [[KeyParameter alloc] initWithKey:key];
            CipherParameters *cipherParameters = [[ParametersWithIV alloc] initWithParameters:keyParam withIv:iv];
            AesFastEngine *aesFast = [[AesFastEngine alloc] init];
            CbcBlockCipher *cbcCipher = [[CbcBlockCipher alloc] initWithCipher:aesFast];
            Pkcs7Padding *padding = [[Pkcs7Padding alloc] init];
            PaddedBufferedBlockCipher *cipher = [[PaddedBufferedBlockCipher alloc] initWithCipher:cbcCipher withPadding:padding];
            [cipher init:NO withParameters:cipherParameters];
            
            NSMutableData *buffer = [[NSMutableData alloc] initWithSize:[cipher getOutputSize:(int)(data.length)]];
            int pos = [cipher processBytes:data withInOff:0 withLength:(int)(data.length) withOutput:buffer withOutOff:0];
            pos += [cipher doFinal:buffer withOutOff:pos];
            retData = [Arrays copyOfWithData:buffer withNewLength:pos];
#if !__has_feature(objc_arc)
            if (keyParam != nil) [keyParam release]; keyParam = nil;
            if (cipherParameters != nil) [cipherParameters release]; cipherParameters = nil;
            if (aesFast != nil) [aesFast release]; aesFast = nil;
            if (cbcCipher != nil) [cbcCipher release]; cbcCipher = nil;
            if (padding != nil) [padding release]; padding = nil;
            if (cipher != nil) [cipher release]; cipher = nil;
            if (buffer != nil) [buffer release]; buffer = nil;
#endif
        }
        return (retData ? [retData autorelease] : nil);
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"decrypt failed" userInfo:[exception userInfo]];
    }
}

@end
