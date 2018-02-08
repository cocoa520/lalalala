//
//  FileKeyAssistant.m
//
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "FileKeyAssistant.h"
#import "CategoryExtend.h"
#import "Arrays.h"
#import "Sha256Digest.h"
#import "Curve25519Ex.h"
#import "RFC3394Wrap.h"
#import "KeyBag.h"
#import "KeyBlob.h"

@implementation FileKeyAssistant

+ (NSMutableData*)uuid:(NSMutableData*)fileKey {
    @try {
        DataStream *buffer = [DataStream wrapWithData:fileKey];
        NSMutableData *uuid = [[[NSMutableData alloc] initWithSize:0x10] autorelease];
        [buffer getWithMutableData:uuid];
        return uuid;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

+ (NSMutableData*)unwrap:(id)target withSel:(SEL)sel withFunction:(IMP)function withBlob:(KeyBlob*)blob {
    NSMutableData *tmpData = [blob getUuid];
    typedef KeyBag* (*MethodName)(id, SEL, NSMutableData*);
    MethodName methodName = (MethodName)function;
    KeyBag *keyBag = methodName(target, sel, tmpData);
    return [self unwrap:keyBag withBlob:blob];
}

+ (NSMutableData*)unwrap:(KeyBag*)keyBag withBlob:(KeyBlob*)blob {
    NSMutableData *publicKey = [keyBag publicKey:[blob protectionClass]];
    NSMutableData *privateKey = [keyBag privateKey:[blob protectionClass]];
    return (publicKey && privateKey) ? [self curve25519Unwrap:publicKey myPrivateKey:privateKey otherPublicKey:[blob getPublicKey] wrappedKey:[blob getWrappedKey]] : nil;
    
}

+ (NSMutableData*)curve25519Unwrap:(NSMutableData*)myPublicKey myPrivateKey:(NSMutableData*)myPrivateKey otherPublicKey:(NSMutableData*)otherPublicKey wrappedKey:(NSMutableData*)wrappedKey {
    Sha256Digest *sha256 = [[Sha256Digest alloc] init];
    NSMutableData *shared = [Curve25519Ex agreement:otherPublicKey withPrivateKey:myPrivateKey];
    NSMutableData *pad = [[NSMutableData alloc] initWithSize:4];
    ((Byte*)(pad.bytes))[3] = (Byte)0x01;
    NSMutableData *hash = [[NSMutableData alloc] initWithSize:[sha256 getDigestSize]];
    
    [sha256 reset];
    [sha256 blockUpdate:pad withInOff:0 withLength:(int)(pad.length)];
    [sha256 blockUpdate:shared withInOff:0 withLength:(int)(shared.length)];
    [sha256 blockUpdate:otherPublicKey withInOff:0 withLength:(int)(otherPublicKey.length)];
    [sha256 blockUpdate:myPublicKey withInOff:0 withLength:(int)(myPublicKey.length)];
    [sha256 doFinal:hash withOutOff:0];
    NSMutableData *retData = [RFC3394Wrap unwrap:hash withWrappedKey:wrappedKey];
#if !__has_feature(objc_arc)
    if (sha256) [sha256 release]; sha256 = nil;
    if (pad) [pad release]; pad = nil;
    if (hash) [hash release]; hash = nil;
#endif
    return retData;
}

@end
