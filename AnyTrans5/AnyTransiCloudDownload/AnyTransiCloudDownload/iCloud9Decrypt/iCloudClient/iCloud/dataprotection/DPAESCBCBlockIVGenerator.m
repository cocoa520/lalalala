//
//  DPAESCBCBlockIVGenerator.m
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import "DPAESCBCBlockIVGenerator.h"
#import "AesFastEngine.h"
#import "Arrays.h"
#import "BlockCipher.h"
#import "CategoryExtend.h"
#import "Sha1Digest.h"
#import "KeyParameter.h"

@interface DPAESCBCBlockIVGenerator ()

@property (nonatomic, readwrite, retain) BlockCipher *cipher;

@end

@implementation DPAESCBCBlockIVGenerator
@synthesize cipher = _cipher;

// 'The initialization vector (IV) is the output of a linear feedback shift register (LFSR) calculated with the
// block offset into the file, encrypted with the SHA-1 hash of the per-file key.'
// Apple: iOS Security. February 2014.
// https://www.apple.com/br/ipad/business/docs/iOS_Security_EN_Feb14.pdf
+ (BlockCipher*)cipher:(NSMutableData*)fileKey {
    Digest *digest = [[Sha1Digest alloc] init];
    NSMutableData *hash = [[NSMutableData alloc] initWithSize:[digest getDigestSize]];
    [digest reset];
    [digest blockUpdate:fileKey withInOff:0 withLength:(int)(fileKey.length)];
    [digest doFinal:hash withOutOff:0];
    
    AesFastEngine *cipher = [[[AesFastEngine alloc] init] autorelease];
    int blockSize = [cipher getBlockSize];
    
    NSMutableData *tmpData = [Arrays copyOfRangeWithByteArray:hash withFrom:0 withTo:blockSize];
    KeyParameter *keyParameter = [[KeyParameter alloc] initWithKey:tmpData];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
    [cipher init:YES withParameters:keyParameter];
    
#if !__has_feature(objc_arc)
    if (digest) [digest release]; digest = nil;
    if (hash) [hash release]; hash = nil;
    if (keyParameter) [keyParameter release]; keyParameter = nil;
#endif
    return cipher;
}

- (id)initWithCipher:(BlockCipher*)cipher {
    if (self = [super init]) {
        if (!cipher) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"cipher" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setCipher:cipher];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithFileKey:(NSMutableData*)fileKey {
    if (self = [self initWithCipher:[DPAESCBCBlockIVGenerator cipher:fileKey]]) {
        return self;
    } else {
        return nil;
    }
}

- (NSMutableData*)apply:(int)blockOffset {
    NSMutableData *lfsr = [self lfsr:blockOffset];
    NSMutableData *outBuf = [[[NSMutableData alloc] initWithSize:[[self cipher] getBlockSize]] autorelease];
    
    [[self cipher] processBlock:lfsr withInOff:0 withOutBuf:outBuf withOutOff:0];
    
    return outBuf;
}

- (NSMutableData*)lfsr:(int)blockOffset {
    DataStream *buffer = [[DataStream alloc] initWithAllocateSize:[[self cipher] getBlockSize]];
    [buffer setOrder:LITTLE_ENDIAN_EX];
    
    int r = blockOffset << 12;
    while ([buffer hasRemaining]) {
        r = ((uint)(r)) >> 1;
        if ((r & 1) == 1) {
            r = r ^ 0x80000061;
        }
        [buffer putInt:r];
    }
    
    NSMutableData *retData = [[[buffer toMutableData] retain] autorelease];
#if !__has_feature(objc_arc)
    if (buffer) [buffer release]; buffer = nil;
#endif
    return retData;
}

@end
