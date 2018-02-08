//
//  NSData+EncryptDecrypt.m
//  BackupTool_Mac
//
//  Created by Pallas on 1/14/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "NSData+EncryptDecrypt.h"
#import "IMBRfc2898DeriveBytes.h"

@implementation NSData (EncryptDecrypt)

- (NSString *)hexString {
    NSMutableString *outputString = [[[NSMutableString alloc] init] autorelease];
    unsigned char *p = (unsigned char *)[self bytes];
    for (int i = 0; i < [self length]; i++) {
        [outputString appendFormat:@"%02X", *p];
        p++;
    }
    return outputString;
}

+ (NSData *)dataWithHexString:(NSString *)hexString {
    if (([hexString length] % 2) == 1) {
        return nil;
    }
    NSMutableData *buffer = [[[NSMutableData alloc] init] autorelease];
    for (int byteOffset = 0; byteOffset < [hexString length]; byteOffset += 2) {
        NSRange range = NSMakeRange(byteOffset, 2);
        NSString *byteString = [hexString substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:byteString];
        unsigned int value;
        [scanner scanHexInt:&value];
        [buffer appendBytes:&value length:1];
    }
    return buffer;
}

- (NSMutableData *)AES256EncryptWithKey:(Byte *)key withIV:(Byte *)iv {
    size_t numBytesEncrypted = 0;
    
    Byte *data = nil;
    long dataLength = self.length;
    if (dataLength % 16 != 0) {
        dataLength = (dataLength / 16) * 16;
    }
    data = malloc(dataLength);
    memcpy(data, self.bytes, dataLength);
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    Byte *buffer = malloc(bufferSize);
    
    NSMutableData *output = nil;
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key, kCCKeySizeAES256, iv, data, dataLength, buffer, bufferSize, &numBytesEncrypted);
    free(data);
    
    output = [NSMutableData dataWithBytes:buffer length:numBytesEncrypted];
    
    free(buffer);
    
    if(result == kCCSuccess) {
        return output;
    } else {
        return nil;
    }
}

- (NSMutableData *)AES256DecryptWithKey:(Byte *)key withIV:(Byte *)iv withPadding:(BOOL)padding {
    size_t numBytesDecrypted = 0;
    
    Byte *data = nil;
    long dataLength = self.length;
    if (dataLength % 16 != 0) {
        dataLength = (dataLength / 16) * 16;
    }
    data = malloc(dataLength);
    memcpy(data, self.bytes, dataLength);
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    Byte *buffer = malloc(bufferSize);
    
    NSMutableData *output = nil;
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key, kCCKeySizeAES256, iv, data, dataLength, buffer, bufferSize, &numBytesDecrypted);
    free(data);
    
    if (padding) {
        output = [self removePadding:buffer withLength:numBytesDecrypted withBlockSize:16];
    } else {
        output = [NSMutableData dataWithBytes:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    
    if(result == kCCSuccess) {
        return output;
    } else {
        return nil;
    }
}

- (NSMutableData *)removePadding:(Byte *)data withLength:(size_t)length withBlockSize:(int)blockSize {
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

- (NSMutableData *)sha1 {
    Byte *buffer;
    if (!(buffer = malloc(CC_SHA1_DIGEST_LENGTH))) {
        return nil;
    }
    
    CC_SHA1(self.bytes, (CC_LONG)self.length, buffer);
    
    NSMutableData *output = nil;
    output = [NSMutableData dataWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
    free(buffer);
    
    return output;
}

- (NSMutableData *)sha256 {
    Byte *buffer;
    if (!(buffer = malloc(CC_SHA256_DIGEST_LENGTH))) {
        return nil;
    }
    
    CC_SHA256(self.bytes, (CC_LONG)self.length, buffer);
    
    NSMutableData *output = nil;
    output = [NSMutableData dataWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
    free(buffer);
    
    return output;
}

- (NSMutableData *)aes_wrap_key:(Byte *)kek withKekLength:(int)kekLength {
    uint8_t wrapped[(256 + 64) / 8];
    size_t wrapped_size = sizeof(wrapped);
    
    const uint8_t *iv= CCrfc3394_iv;
    const size_t ivLen = CCrfc3394_ivLen;
    CCSymmetricKeyWrap(kCCWRAPAES, iv, ivLen, kek, kekLength, self.bytes, self.length, wrapped, &wrapped_size);
    
    NSMutableData *output = nil;
    if (wrapped_size > 0) {
        output = [NSMutableData dataWithBytes:wrapped length:wrapped_size];
    }
    
    return output;
}

- (NSMutableData *)aes_unwrap_key:(Byte *)kek withKekLength:(int)kekLength {
    uint8_t unwrapped[256 / 8];
    size_t unwrapped_size = sizeof(unwrapped); 
    
    const uint8_t *iv= CCrfc3394_iv;
    const size_t ivLen = CCrfc3394_ivLen;
    CCSymmetricKeyUnwrap(kCCWRAPAES, iv, ivLen, kek, kekLength, self.bytes, self.length, unwrapped, &unwrapped_size);
    
    NSMutableData *output = nil;
    if (unwrapped_size > 0) {
        output = [NSMutableData dataWithBytes:unwrapped length:unwrapped_size];
    }
    
    return output;
}

+ (NSMutableData *)Rfc2898DeriveBytes:(NSString *)passcode withSalt:(NSData *)salt withIterations:(int)iterations {
    uint8_t key[32];
    memset(key, 0x00, 32);
    
    NSMutableData *rfc1898Data = [[NSMutableData alloc] initWithLength:(kCCKeySizeAES128 + kCCBlockSizeAES128)];
    [IMBRfc2898DeriveBytes deriveBytes:rfc1898Data fromPassword:passcode withSalt:salt withIterations:iterations];
    if (rfc1898Data != nil && rfc1898Data.length >= 32) {
        memcpy(key, rfc1898Data.bytes, 32);
    } else {
        return nil;
    }
    [rfc1898Data release];
    rfc1898Data = nil;
    
    NSMutableData *output = [NSMutableData dataWithBytes:key length:32];
    
    return output;
}

+ (NSMutableData *)Rfc2898DeriveBytesWithPasscodeData:(NSData *)passcode withSalt:(NSData *)salt withIterations:(int)iterations {
    uint8_t key[32];
    memset(key, 0x00, 32);
    
    NSMutableData *rfc1898Data = [[NSMutableData alloc] initWithLength:(kCCKeySizeAES128 + kCCBlockSizeAES128)];
    [IMBRfc2898DeriveBytes deriveBytes:rfc1898Data fromPasscodeData:passcode withSalt:salt withIterations:iterations];
    if (rfc1898Data != nil && rfc1898Data.length >= 32) {
        memcpy(key, rfc1898Data.bytes, 32);
    } else {
        return nil;
    }
    [rfc1898Data release];
    rfc1898Data = nil;
    
    NSMutableData *output = [NSMutableData dataWithBytes:key length:32];
    
    return output;
}

+ (NSMutableData *)curve25519:(NSData *)privateKey withPeerPublicKey:(NSData *)peerPublicKey {
    const unsigned char basepoint[32] = {9};
    curve25519((Byte*)peerPublicKey.bytes, privateKey.bytes, basepoint);
    NSMutableData *output = [NSMutableData dataWithBytes:basepoint length:32];
    return output;
}

@end
