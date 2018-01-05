//
//  BlockDecrypters.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "BlockDecrypters.h"
#import "Arrays.h"
#import "AesFastEngine.h"
#import "BlockDecrypter.h"
#import "BufferedBlockCipher.h"
#import "CategoryExtend.h"
#import "CbcBlockCipher.h"
#import "Digest.h"
#import "KeyParameter.h"
#import "Sha1Digest.h"
#import "ParametersWithIV.h"

@implementation BlockDecrypters

+ (BlockDecrypter*)create:(NSMutableData*)key {
    AesFastEngine *aesFast = [[AesFastEngine alloc] init];
    CbcBlockCipher *cbcCipher = [[CbcBlockCipher alloc] initWithCipher:aesFast];
    BufferedBlockCipher *cipher = [[BufferedBlockCipher alloc] initWithCipher:cbcCipher];
    Sha1Digest *digest = [[Sha1Digest alloc] init];
    BlockDecrypter *retDecrypter = [BlockDecrypters create:cipher withDigest:digest withKey:key];
#if !__has_feature(objc_arc)
    if (aesFast != nil) [aesFast release]; aesFast = nil;
    if (cbcCipher != nil) [cbcCipher release]; cbcCipher = nil;
    if (cipher != nil) [cipher release]; cipher = nil;
    if (digest != nil) [digest release]; digest = nil;
#endif
    return retDecrypter;
}

+ (BlockDecrypter*)create:(BufferedBlockCipher*)cipher withDigest:(Digest*)digest withKey:(NSMutableData*)key {
    ParametersWithIV *blockIVKey = [BlockDecrypters blockIVKey:digest withLength:[cipher getBlockSize] withKey:key];
    KeyParameter *keyParameter = [[KeyParameter alloc] initWithKey:key];
    BlockDecrypter *retDecrypter = [[[BlockDecrypter alloc] initWithBlockCipher:cipher withBlockIVKey:blockIVKey withKey:keyParameter] autorelease];
#if !__has_feature(objc_arc)
    if (keyParameter != nil) [keyParameter release]; keyParameter = nil;
#endif
    return retDecrypter;
}

+ (ParametersWithIV*)blockIVKey:(Digest*)digest withLength:(int)length withKey:(NSMutableData*)key {
    NSMutableData *hash = [[NSMutableData alloc] initWithSize:[digest getDigestSize]];
    
    [digest reset];
    [digest blockUpdate:key withInOff:0 withLength:(int)(key.length)];
    [digest doFinal:hash withOutOff:0];
    
    NSMutableData *mutData = [Arrays copyOfRangeWithByteArray:hash withFrom:0 withTo:length];
    KeyParameter *keyParameter = [[KeyParameter alloc] initWithKey:mutData];
    NSMutableData *iv = [[NSMutableData alloc] initWithSize:length];
    ParametersWithIV *retParameters = [[[ParametersWithIV alloc] initWithParameters:keyParameter withIv:iv] autorelease];
#if !__has_feature(objc_arc)
    if (mutData != nil) [mutData release]; mutData = nil;
    if (hash != nil) [hash release]; hash = nil;
    if (keyParameter != nil) [keyParameter release]; keyParameter = nil;
    if (iv != nil) [iv release]; iv = nil;
#endif
    return retParameters;
}

@end
