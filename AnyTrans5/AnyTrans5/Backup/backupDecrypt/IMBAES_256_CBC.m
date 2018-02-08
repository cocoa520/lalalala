//
//  IMBAES_256_CBC.m
//  BackupTool_Mac
//
//  Created by Pallas on 1/17/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBAES_256_CBC.h"

@implementation IMBAES_256_CBC

- (id)initWithKey:(Byte *)key withIV:(Byte *)iv {
    if (self = [super init]) {
        _key = key;
        _iv = iv;
    }
    return self;
}

- (NSMutableData *)encryptCBCWithBytes:(Byte*)data withLength:(int)length {
    size_t numBytesEncrypted = 0;
    
    long dataLength = length;
    if (dataLength % 16 != 0) {
        dataLength = (dataLength / 16) * 16;
    }
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    Byte *buffer = malloc(bufferSize);
    
    NSMutableData *output = nil;
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, _key, kCCKeySizeAES256, _iv, data, dataLength, buffer, bufferSize, &numBytesEncrypted);
    
    output = [NSMutableData dataWithBytes:buffer length:numBytesEncrypted];
    
    free(buffer);
    
    if(result == kCCSuccess) {
        return output;
    } else {
        return nil;
    }
}

- (NSMutableData *)decryptCBCWithBytes:(Byte*)data withLength:(int)length {
    size_t numBytesDecrypted = 0;
    
    long dataLength = length;
    if (dataLength % 16 != 0) {
        dataLength = (dataLength / 16) * 16;
    }
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    Byte *buffer = malloc(bufferSize);
    
    NSMutableData *output = nil;
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, _key, kCCKeySizeAES256, _iv, data, dataLength, buffer, bufferSize, &numBytesDecrypted);
    
    output = [NSMutableData dataWithBytes:buffer length:numBytesDecrypted];
    
    free(buffer);
    
    if(result == kCCSuccess) {
        return output;
    } else {
        return nil;
    }
}

+ (NSMutableData *)removePadding:(Byte *)data withLength:(size_t)length withBlockSize:(int)blockSize {
    NSMutableData *retData = nil;
    if (data != nil && length > 0) {
        Byte c = data[length - 1];
        int i = (int)c;
        Byte verifyByte[i];
        memcpy(verifyByte, data + (length - i), i);
        Byte verify[i];
        memset(verify, c, i);
        if (i < blockSize && memcmp(verifyByte, verify, i) == 0 ) {
            Byte newdata[length - i];
            memcpy(newdata, data, length - i);
            retData = [NSMutableData dataWithBytes:newdata length:length - i];
        } else {
            retData = [NSMutableData dataWithBytes:data length:length];
        }
    }
    return retData;
}

+ (NSMutableData *)aesEncryptWithData:(NSData*)data withKey:(NSData*)key withIV:(NSData*)iv {
    size_t numBytesEncrypted = 0;
    
    long dataLength = data.length;
    if (dataLength % 16 != 0) {
        dataLength = (dataLength / 16) * 16;
    }
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    Byte *buffer = malloc(bufferSize);
    
    NSMutableData *output = nil;
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, (Byte*)(key.bytes), kCCKeySizeAES256, (Byte*)(iv.bytes), data, dataLength, buffer, bufferSize, &numBytesEncrypted);
    
    output = [NSMutableData dataWithBytes:buffer length:numBytesEncrypted];
    
    free(buffer);
    
    if(result == kCCSuccess) {
        return output;
    } else {
        return nil;
    }
}

+ (NSMutableData *)aesDecryptWithData:(NSData*)data withKey:(NSData*)key withIV:(NSData*)iv {
    size_t numBytesDecrypted = 0;
    
    long dataLength = data.length;
    if (dataLength % 16 != 0) {
        dataLength = (dataLength / 16) * 16;
    }
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    Byte *buffer = malloc(bufferSize);
    
    NSMutableData *output = nil;
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, (Byte*)(key.bytes), kCCKeySizeAES256, (Byte*)(iv.bytes), data, dataLength, buffer, bufferSize, &numBytesDecrypted);
    
    output = [NSMutableData dataWithBytes:buffer length:numBytesDecrypted];
    
    free(buffer);
    
    if(result == kCCSuccess) {
        return output;
    } else {
        return nil;
    }
}

@end
