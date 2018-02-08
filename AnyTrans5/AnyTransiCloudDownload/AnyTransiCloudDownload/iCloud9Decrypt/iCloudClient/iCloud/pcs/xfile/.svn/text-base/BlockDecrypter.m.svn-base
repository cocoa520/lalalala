//
//  BlockDecrypter.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "BlockDecrypter.h"
#import "BufferedBlockCipher.h"
#import "CategoryExtend.h"
#import "ParametersWithIV.h"
#import "KeyParameter.h"

@interface BlockDecrypter ()

@property (nonatomic, readwrite, retain) BufferedBlockCipher *blockCipher;
@property (nonatomic, readwrite, retain) ParametersWithIV *blockIVKey;
@property (nonatomic, readwrite, retain) KeyParameter *key;

@end

@implementation BlockDecrypter
@synthesize blockCipher = _blockCipher;
@synthesize blockIVKey = _blockIVKey;
@synthesize key = _key;

- (id)initWithBlockCipher:(BufferedBlockCipher*)blockCipher withBlockIVKey:(ParametersWithIV*)blockIVKey withKey:(KeyParameter*)key {
    if (self = [super init]) {
        if (blockCipher == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"blockCipher" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (blockIVKey == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"blockIVKey" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (key == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"key" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setBlockCipher:blockCipher];
        [self setBlockIVKey:blockIVKey];
        [self setKey:key];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setBlockCipher:nil];
    [self setBlockIVKey:nil];
    [self setKey:nil];
    [super dealloc];
#endif
}

- (int)decryptWithBlock:(int)block withInData:(NSMutableData*)inData withLength:(int)length withOutData:(NSMutableData*)outData {
    return [self decryptWithBlock:block withInData:inData withInDataOff:0 withLength:length withOutData:outData withOutDataOff:0];
}

- (int)decryptWithBlock:(int)block withInData:(NSMutableData*)inData withInDataOff:(int)inDataOff withLength:(int)length withOutData:(NSMutableData*)outData withOutDataOff:(int)outDataOff {
    NSMutableData *iv = [self blockIV:block];
    
    ParametersWithIV *parameters = [[ParametersWithIV alloc] initWithParameters:[self key] withIv:iv];
    [[self blockCipher] init:NO withParameters:parameters];
#if !__has_feature(objc_arc)
    if (parameters != nil) [parameters release]; parameters = nil;
#endif
    return [[self blockCipher] processBytes:inData withInOff:inDataOff withLength:length withOutput:outData withOutOff:outDataOff];
}

- (NSMutableData*)blockIV:(int)block {
    NSMutableData *blockHash = [self blockHash:block];
    NSMutableData *iv = [[[NSMutableData alloc] initWithSize:[[self blockCipher] getBlockSize]] autorelease];
    
    [[self blockCipher] init:YES withParameters:[self blockIVKey]];
    [[self blockCipher] processBytes:blockHash withInOff:0 withLength:(int)(blockHash.length) withOutput:iv withOutOff:0];
    
    return iv;
}

- (NSMutableData*)blockHash:(int)block {
    int offset = block << 12;
    NSMutableData *hash = [[[NSMutableData alloc] initWithSize:0x10] autorelease];
    DataStream *buffer = [DataStream wrapWithData:hash];
    [buffer setOrder:LITTLE_ENDIAN_EX];
    
    for (int i = 0; i < 4; i++) {
        offset = ((offset & 1) == 1) ? 0x80000061 ^ (((uint)offset) >> 1) : ((uint)offset) >> 1;
        [buffer putInt:offset];
    }
    
    return hash;
}

@end
