//
//  IMBRfc2898DeriveBytes.m
//  BackupTool_Mac
//
//  Created by Pallas on 1/17/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBRfc2898DeriveBytes.h"
#import "NSData+EncryptDecrypt.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation IMBRfc2898DeriveBytes

+ (void)deriveBytes:(NSMutableData *)deriveBytes fromPassword:(NSString *)password withSalt:(NSData *)salt withIterations:(int)iterations {
    const char *passPhraseBytes = [password UTF8String];
    int passPhraseLength = strlen(passPhraseBytes);
    
    NSMutableData *mSalt = [[[NSMutableData alloc] initWithData:salt] autorelease];
    [mSalt increaseLengthBy:4];
    
    unsigned char mac[CC_SHA1_DIGEST_LENGTH];
    unsigned char outputBytes[CC_SHA1_DIGEST_LENGTH];
    unsigned char U[CC_SHA1_DIGEST_LENGTH];
    int i;
    int generatedBytes = 0;
    unsigned char blockCount = 0;
    
    while (generatedBytes < [deriveBytes length]) {
        bzero(mac, CC_SHA1_DIGEST_LENGTH);
        bzero(outputBytes, CC_SHA1_DIGEST_LENGTH);
        bzero(U, CC_SHA1_DIGEST_LENGTH);
        
        blockCount++;
        unsigned char *mSaltBytes = (unsigned char *)[mSalt mutableBytes];
        mSaltBytes[[mSalt length]-1] = blockCount;
        
        memcpy(U, [mSalt bytes], CC_SHA1_DIGEST_LENGTH);
        
        CCHmac(kCCHmacAlgSHA1, passPhraseBytes, passPhraseLength, [mSalt bytes], [mSalt length], mac);
        for (i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            outputBytes[i] ^= mac[i];
            U[i] = mac[i];
        }
        
        for (int iteration = 1; iteration < iterations; iteration++) {
            CCHmac(kCCHmacAlgSHA1, passPhraseBytes, passPhraseLength, U, CC_SHA1_DIGEST_LENGTH, mac);
            for (i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
                outputBytes[i] ^= mac[i];
                U[i] = mac[i];
            }
        }
        
        int bytesNeeded = [deriveBytes length] - generatedBytes;
        int bytesToCopy = MIN(bytesNeeded, CC_SHA1_DIGEST_LENGTH);
        [deriveBytes replaceBytesInRange:NSMakeRange(generatedBytes, bytesToCopy) withBytes:outputBytes];
        generatedBytes += bytesToCopy;
    }
}

+ (void)deriveBytes256:(NSMutableData *)deriveBytes fromPassword:(NSString *)password withSalt:(NSData *)salt withIterations:(int)iterations {
    const char *passPhraseBytes = [password UTF8String];
    int passPhraseLength = strlen(passPhraseBytes);
    
    NSMutableData *mSalt = [[[NSMutableData alloc] initWithData:salt] autorelease];
    [mSalt increaseLengthBy:4];
    
    unsigned char mac[CC_SHA256_DIGEST_LENGTH];
    unsigned char outputBytes[CC_SHA256_DIGEST_LENGTH];
    unsigned char U[CC_SHA256_DIGEST_LENGTH];
    int i;
    int generatedBytes = 0;
    unsigned char blockCount = 0;
    
    while (generatedBytes < [deriveBytes length]) {
        bzero(mac, CC_SHA256_DIGEST_LENGTH);
        bzero(outputBytes, CC_SHA256_DIGEST_LENGTH);
        bzero(U, CC_SHA256_DIGEST_LENGTH);
        
        blockCount++;
        unsigned char *mSaltBytes = (unsigned char *)[mSalt mutableBytes];
        mSaltBytes[[mSalt length]-1] = blockCount;
        
        memcpy(U, [mSalt bytes], CC_SHA256_DIGEST_LENGTH);
        
        CCHmac(kCCHmacAlgSHA256, passPhraseBytes, passPhraseLength, [mSalt bytes], [mSalt length], mac);
        for (i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
            outputBytes[i] ^= mac[i];
            U[i] = mac[i];
        }
        
        for (int iteration = 1; iteration < iterations; iteration++) {
            CCHmac(kCCHmacAlgSHA256, passPhraseBytes, passPhraseLength, U, CC_SHA256_DIGEST_LENGTH, mac);
            for (i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
                outputBytes[i] ^= mac[i];
                U[i] = mac[i];
            }
        }
        
        int bytesNeeded = [deriveBytes length] - generatedBytes;
        int bytesToCopy = MIN(bytesNeeded, CC_SHA256_DIGEST_LENGTH);
        [deriveBytes replaceBytesInRange:NSMakeRange(generatedBytes, bytesToCopy) withBytes:outputBytes];
        generatedBytes += bytesToCopy;
    }
}

+ (void)deriveBytes:(NSMutableData *)deriveBytes fromPasscodeData:(NSData *)passcodeData withSalt:(NSData *)salt withIterations:(int)iterations {
    const char *passPhraseBytes = passcodeData.bytes;
    int passPhraseLength = passcodeData.length;
    
    NSMutableData *mSalt = [[[NSMutableData alloc] initWithData:salt] autorelease];
    [mSalt increaseLengthBy:4];
    
    unsigned char mac[CC_SHA1_DIGEST_LENGTH];
    unsigned char outputBytes[CC_SHA1_DIGEST_LENGTH];
    unsigned char U[CC_SHA1_DIGEST_LENGTH];
    int i;
    int generatedBytes = 0;
    unsigned char blockCount = 0;
    
    while (generatedBytes < [deriveBytes length]) {
        bzero(mac, CC_SHA1_DIGEST_LENGTH);
        bzero(outputBytes, CC_SHA1_DIGEST_LENGTH);
        bzero(U, CC_SHA1_DIGEST_LENGTH);
        
        blockCount++;
        unsigned char *mSaltBytes = (unsigned char *)[mSalt mutableBytes];
        mSaltBytes[[mSalt length]-1] = blockCount;
        
        memcpy(U, [mSalt bytes], CC_SHA1_DIGEST_LENGTH);
        
        CCHmac(kCCHmacAlgSHA1, passPhraseBytes, passPhraseLength, [mSalt bytes], [mSalt length], mac);
        for (i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            outputBytes[i] ^= mac[i];
            U[i] = mac[i];
        }
        
        for (int iteration = 1; iteration < iterations; iteration++) {
            CCHmac(kCCHmacAlgSHA1, passPhraseBytes, passPhraseLength, U, CC_SHA1_DIGEST_LENGTH, mac);
            for (i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
                outputBytes[i] ^= mac[i];
                U[i] = mac[i];
            }
        }
        
        int bytesNeeded = [deriveBytes length] - generatedBytes;
        int bytesToCopy = MIN(bytesNeeded, CC_SHA1_DIGEST_LENGTH);
        [deriveBytes replaceBytesInRange:NSMakeRange(generatedBytes, bytesToCopy) withBytes:outputBytes];
        generatedBytes += bytesToCopy;
    }
}

+ (void)deriveKey:(NSMutableData *)key andIV:(NSMutableData *)iv fromPassword:(NSString *)password withSalt:(NSData *)salt withIterations:(int)iterations {
    NSMutableData *buffer = [[[NSMutableData alloc] initWithLength:(kCCKeySizeAES128+kCCBlockSizeAES128)] autorelease];
    [IMBRfc2898DeriveBytes deriveBytes:buffer fromPassword:password withSalt:salt withIterations:iterations];
    
    [key setLength:kCCKeySizeAES128];
    [iv setLength:kCCBlockSizeAES128];
    [buffer getBytes:[key mutableBytes] range:NSMakeRange(0, kCCKeySizeAES128)];
    [buffer getBytes:[iv mutableBytes] range:NSMakeRange(kCCKeySizeAES128, kCCBlockSizeAES128)];
}

@end
