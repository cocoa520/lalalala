//
//  FileStreamWriter.m
//  
//
//  Created by Pallas on 8/30/16.
//
//  Complete

#import "FileStreamWriter.h"
#import "Arrays.h"
#import "BlockCipher.h"
#import "BufferedBlockCipher.h"
#import "CategoryExtend.h"
#import "CipherInputStream.h"
#import "DigestInputStream.h"
#import "FileSignatures.h"
#import "FileDigestA.h"
#import "KeyParameter.h"
#import "XFileKey.h"

@implementation FileStreamWriter

+ (int)BUFFER_SIZE {
    return 16384;
//    return 8192;
}

+ (BOOL)copy:(Stream*)inStream withOutStream:(NSFileHandle*)outStream withKeyCipher:(XFileKey*)keyCipher withSignature:(NSMutableData*)signature withCancel:(BOOL*)cancel {
    if (*cancel) {
        return NO;
    }
    Digest *digest = nil;
    BOOL result = NO;
    if (signature) {
        digest = [FileSignatures typeWithFileSignature:signature];
    } else {
        digest = [FileSignatures ONE];
    }
    
    DigestInputStream *digestInputStream = [[DigestInputStream alloc] initWithStream:inStream digest:digest];
    
    NSMutableData *buffer = [[NSMutableData alloc] initWithSize:[FileStreamWriter BUFFER_SIZE]];
    Stream *decStream = [self decryptStream:digestInputStream withKeyCipher:keyCipher withCancel:cancel];
    while (YES) {
        int length = [decStream read:buffer];
        if (length <= 0 || *cancel) {
            break;
        }
        [outStream write:buffer withOffset:0 withCount:length];
        [outStream flush];
    }
    result = [self testSignature:[digestInputStream getDigest] withSignature:signature];
    if (!result) {
        return YES;
    }
#if !__has_feature(objc_arc)
    if (digestInputStream) [digestInputStream release]; digestInputStream = nil;
    if (buffer) [buffer release]; buffer = nil;
#endif
    return result;
}

+ (Stream*)decryptStream:(Stream*)inStream withKeyCipher:(XFileKey*)keyCipher withCancel:(BOOL*)cancel {
    if (*cancel) {
        return nil;
    }
    if (keyCipher) {
        BlockCipher *cipher = [keyCipher ciphers];
        KeyParameter *kp = [[KeyParameter alloc] initWithKey:[keyCipher getKey]];
        [cipher init:NO withParameters:kp];
        BufferedBlockCipher *bufferedCipher = [[BufferedBlockCipher alloc] initWithCipher:cipher];
        Stream *retStream = [[[CipherInputStream alloc] initWithIs:inStream withCipher:bufferedCipher] autorelease];
#if !__has_feature(objc_arc)
    if (kp) [kp release]; kp = nil;
    if (bufferedCipher) [bufferedCipher release]; bufferedCipher = nil;
#endif
        return retStream;
        
    } else {
        return inStream;
    }
}

+ (BOOL)testSignature:(Digest*)digest withSignature:(NSMutableData*)signature {
    if (signature) {
        NSMutableData *outData = [FileStreamWriter signature:digest];
        BOOL match = [Arrays areEqualWithByteArray:outData withB:signature];
        if (match) {
//            NSLog(@"-- testSignature() - positive match out: 0x%@ target: 0x%@", [NSString dataToHex:outData], [NSString dataToHex:signature]);
        } else {
//            NSLog(@"-- testSignature() - negative match out: 0x%@ target: 0x%@", [NSString dataToHex:outData], [NSString dataToHex:signature]);
        }
        return match;
    } else {
//        NSMutableData *outData = [FileStreamWriter signature:digest];
//        NSLog(@"-- testSignature() - signature: 0x%@", [NSString dataToHex:outData]);
        return YES;
    }
}

+ (NSMutableData*)signature:(Digest*)digest {
    NSMutableData *outData = [[[NSMutableData alloc] initWithSize:[digest getDigestSize]] autorelease];
    [digest doFinal:outData withOutOff:0];
    return outData;
}

@end
