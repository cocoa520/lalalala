//
//  ChunkEncryptionKeys.m
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "ChunkEncryptionKeys.h"
#import "Arrays.h"
#import "CategoryExtend.h"
#import "RFC3394Wrap.h"

@implementation ChunkEncryptionKeys

- (id)init {
#if !__has_feature(objc_arc)
    [self release];
#endif
    return nil;
}

+ (NSMutableData*)unwrapKey:(NSMutableData*)kek withKeyData:(NSMutableData*)keyData {
    int keyType = [ChunkEncryptionKeys keyType:keyData];
    switch (keyType) {
        case 1: {
            // TODO. No idea if iOS 8 type 1 encryption is in use.
            //NSLog(@"-- unwrapKey() - chunk 1 decryption not yet implemented");
            return nil;
        }
        case 2: {
            return [ChunkEncryptionKeys unwrapType2:kek withKeyData:keyData];
        }
        default: {
            //NSLog(@"-- unwrapKey() - unsupported key type: %d", keyType);
            return nil;
        }
    }
}

+ (NSMutableData*)unwrapType2:(NSMutableData*)kek withKeyData:(NSMutableData*)keyData {
    if (kek == nil) {
        //NSLog(@"-- unwrapType2() - kek required, but not present");
        return nil;
    }
    
    if (keyData.length < 0x19) {
        //NSLog(@"-- unwrapType2() - key data too short: 0x%@", [NSString dataToHex:keyData]);
    }
    
    NSMutableData *wrappedKey = [Arrays copyOfRangeWithByteArray:keyData withFrom:0x01 withTo:0x19];
    //NSLog(@"-- key() - wrapped key: 0x%@ kek: 0x%@", [NSString dataToHex:wrappedKey], [NSString dataToHex:kek]);
    
    NSMutableData *unwrappedKey = [RFC3394Wrap unwrap:kek withWrappedKey:wrappedKey];
    //NSLog(@"-- key() - unwrapped key: 0x%@", unwrappedKey == nil ? @"nil" : [NSString dataToHex:unwrappedKey]);
#if !__has_feature(objc_arc)
    if (wrappedKey) [wrappedKey release]; wrappedKey = nil;
#endif
    
    return unwrappedKey;
}

+ (int)keyType:(NSMutableData*)keyData {
    if (keyData == nil || keyData.length == 0) {
        //NSLog(@"-- keyType() - empty key data");
        return -1;
    }
    return (int)(((Byte*)(keyData.bytes))[0]);
}

@end
