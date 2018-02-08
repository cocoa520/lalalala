    //
//  IMBAES_CFB.m
//  iCloudDemo
//
//  Created by Pallas on 7/18/14.
//  Copyright (c) 2014 com.imobie. All rights reserved.
//

#import "IMBAES_CFB.h"
//#import "NSString+HexToBytes.h"
#include "aes.h"

@implementation IMBAES_CFB

+ (NSMutableData *)decryptCFBWithKey:(Byte*)key withIV:(Byte*)iv withData:(NSData*)data {
    NSMutableData *retData = [[[NSMutableData alloc] init] autorelease];
    NSData *ks = nil;
    @autoreleasepool {
         ks = [[self aesEncryptWithKey:key withIV:iv withData:[NSData dataWithBytes:iv length:16]] retain];
    }
    int blockCount = (int)ceil(data.length / 16.0);
    Byte decryptedBlock[16];
    for (int i = 0; i < blockCount; i++) {
        @autoreleasepool {
            int blockSize = data.length - (i * 16) >= 16 ? 16 : data.length - (i * 16);
            NSData *block = [data subdataWithRange:NSMakeRange(i * 16, blockSize)];
            memset(decryptedBlock, 0x00, 16);
            for (int j = 0; j < blockSize; j++) {
                decryptedBlock[j] = ((Byte*)block.bytes)[j] ^ ((Byte*)ks.bytes)[j];
            }
            [retData appendBytes:decryptedBlock length:blockSize];
            if (blockSize  == 16) {
                @autoreleasepool {
                    if (ks != nil) {
                        [ks release];
                        ks = nil;
                    }
                    ks = [[self aesEncryptWithKey:key withIV:iv withData:block] retain];
                }
            }
        }
    }
    if (ks != nil) {
        [ks release];
        ks = nil;
    }
    return retData;
}

+ (NSData*)aesEncryptWithKey:(Byte*)key withIV:(Byte*)iv withData:(NSData*)data {
    size_t numBytesEncrypted = 0;
    
    long dataLength = data.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    Byte *buffer = calloc(bufferSize, sizeof(char));
    
    NSMutableData *output = nil;
    
//    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key, kCCKeySizeAES128, iv, (Byte*)(data.bytes), dataLength, buffer, bufferSize, &numBytesEncrypted);
//    if (numBytesEncrypted > 16) {
//        output = [NSMutableData dataWithBytes:buffer length:16];
//    } else {
//        output = [NSMutableData dataWithBytes:buffer length:numBytesEncrypted];
//    }
//    if(result == kCCSuccess) {
//        return output;
//    } else {
//        return nil;
//    }
    
    AES128_CBC_encrypt_buffer((uint8_t*)buffer, (uint8_t*)data.bytes, dataLength, key, iv);
    numBytesEncrypted = 16;
    if (numBytesEncrypted > 16) {
        output = [NSMutableData dataWithBytes:buffer length:16];
    } else {
        output = [NSMutableData dataWithBytes:buffer length:numBytesEncrypted];
    }

    free(buffer);
    buffer = nil;
    if (numBytesEncrypted > 0) {
        return output;
    } else {
        return nil;
    }
}

@end
