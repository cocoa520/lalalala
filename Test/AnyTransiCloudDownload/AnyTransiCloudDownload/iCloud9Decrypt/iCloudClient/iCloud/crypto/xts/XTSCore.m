//
//  XTSCore.m
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import "XTSCore.h"
#import "Arrays.h"
#import "AesFastEngine.h"
#import "CategoryExtend.h"
#import "KeyParameter.h"
#import "XTSTweak.h"

@interface XTSCore ()

@property (nonatomic, readwrite, retain) BlockCipher *cipher;
@property (nonatomic, readwrite, retain) XTSTweak *tweak;
@property (nonatomic, readwrite, assign) BOOL forEncryption;

@end

@implementation XTSCore
@synthesize cipher = _cipher;
@synthesize tweak = _tweak;
@synthesize forEncryption = _forEncryption;

+ (int)BLOCK_SIZE {
    return 16;
}

- (id)initWithCipher:(BlockCipher*)cipher withTweak:(XTSTweak*)tweak {
    if (self = [super init]) {
        if (!cipher) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"cipher" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (!tweak) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"tweak" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setCipher:cipher];
        [self setTweak:tweak];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithTweak:(XTSTweak*)tweak {
    AesFastEngine *aesFast = [[AesFastEngine alloc] init];
    if (self = [self initWithCipher:aesFast withTweak:tweak]) {
#if !__has_feature(objc_arc)
        if (aesFast) [aesFast release]; aesFast = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (aesFast) [aesFast release]; aesFast = nil;
        [self release];
#endif
        return nil;
    }
}

- (id)init {
    XTSTweak *tweak = [[XTSTweak alloc] init];
    if (self = [self initWithTweak:tweak]) {
#if !__has_feature(objc_arc)
        if (tweak) [tweak release]; tweak = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (tweak) [tweak release]; tweak = nil;
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setCipher:nil];
    [self setTweak:nil];
    [super dealloc];
#endif
}

- (XTSCore*)init:(BOOL)forEncryption withKey:(KeyParameter*)key {
    NSMutableData *k = [((KeyParameter*)key) getKey];
    if (k.length != 32 && k.length != 64) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"bad key length: %d", k.length] userInfo:nil];
    }
    NSMutableData *key1 = [Arrays copyOfRangeWithByteArray:k withFrom:0 withTo:((int)(k.length) / 2)];
    NSMutableData *key2 = [Arrays copyOfRangeWithByteArray:k withFrom:((int)(k.length) / 2) withTo:(int)(k.length)];
    
    KeyParameter *keyP1 = [[KeyParameter alloc] initWithKey:key1];
    KeyParameter *keyP2 = [[KeyParameter alloc] initWithKey:key2];
    
    XTSCore *retVal = [self init:forEncryption withKey1:keyP1 withKey2:keyP2];
#if !__has_feature(objc_arc)
    if (key1) [key1 release]; key1 = nil;
    if (key2) [key2 release]; key2 = nil;
    if (keyP1) [keyP1 release]; keyP1 = nil;
    if (keyP2) [keyP2 release]; keyP2 = nil;
#endif
    return retVal;
}

- (XTSCore*)init:(BOOL)forEncryption withKey1:(KeyParameter*)key1 withKey2:(KeyParameter*)key2 {
    [[self cipher] init:forEncryption withParameters:key1];
    [[self tweak] init:key2];
    [self setForEncryption:forEncryption];
    return self;
}

- (XTSCore*)reset:(int64_t)tweakValue {
    [[self tweak] reset:tweakValue];
    return self;
}

- (NSString*)getAlgorithmName {
    return [[self cipher] algorithmName];
}

- (int)getBlockSize {
    return [XTSCore BLOCK_SIZE];
}

- (int)processBlock:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff {
    NSMutableData *tweakValue = [[self tweak] value];
    [self doProcessBlock:inBuf withInOff:inOff withOutBuf:outBuf withOutOff:outOff withTweakValue:tweakValue];
    [[self tweak] next];
    return [XTSCore BLOCK_SIZE];
}

- (int)doProcessBlock:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff withTweakValue:(NSMutableData*)tweakValue {
    [self merge:inBuf withInOff:inOff withOutBuf:outBuf withOutOff:outOff withTweak:tweakValue];
    [[self cipher] processBlock:outBuf withInOff:outOff withOutBuf:outBuf withOutOff:outOff];
    [self merge:outBuf withInOff:outOff withOutBuf:outBuf withOutOff:outOff withTweak:tweakValue];
    return [XTSCore BLOCK_SIZE];
}

- (void)merge:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff withTweak:(NSMutableData*)tweak {
    for (int i = 0; i < [XTSCore BLOCK_SIZE]; i++) {
        ((Byte*)(outBuf.bytes))[i + outOff] = (Byte)(((Byte*)(inBuf.bytes))[i + inOff] ^ ((Byte*)(tweak.bytes))[i]);
    }
}

- (int)processPartial:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff withLength:(int)length {
    if (length <= [XTSCore BLOCK_SIZE]) {
        @throw [NSException exceptionWithName:@"DataLength" reason:[NSString stringWithFormat:@"input buffer too small/ missing last two blocks: %d", length] userInfo:nil];
    }
    if (length >= [XTSCore BLOCK_SIZE] * 2) {
        @throw [NSException exceptionWithName:@"DataLength" reason:[NSString stringWithFormat:@"input buffer too large/ non-partial final block: %d", length] userInfo:nil];
    }
    NSMutableData *tweakA = [[self tweak] value];
    NSMutableData *tweakB = [[[self tweak] next] value];
    return [self forEncryption] ? [self doProcessPartial:inBuf withInOff:inOff withOutBuf:outBuf withOutOff:outOff withLength:length withTweakA:tweakA withTweakB:tweakB] : [self doProcessPartial:inBuf withInOff:inOff withOutBuf:outBuf withOutOff:outOff withLength:length withTweakA:tweakB withTweakB:tweakA];
}

- (int)doProcessPartial:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff withLength:(int)length withTweakA:(NSMutableData*)tweakA withTweakB:(NSMutableData*)tweakB {
    // M-1 block
    [self doProcessBlock:inBuf withInOff:inOff withOutBuf:outBuf withOutOff:outOff withTweakValue:tweakA];
    // Cipher stealing
    NSMutableData *buffer = [Arrays copyOfRangeWithByteArray:outBuf withFrom:outOff withTo:(outOff + [XTSCore BLOCK_SIZE])];
    [buffer copyFromIndex:0 withSource:inBuf withSourceIndex:(inOff + [XTSCore BLOCK_SIZE]) withLength:(length - [XTSCore BLOCK_SIZE])];
    // M block
    [self doProcessBlock:buffer withInOff:0 withOutBuf:buffer withOutOff:0 withTweakValue:tweakB];
    // Copy blocks
    [outBuf copyFromIndex:(outOff + [XTSCore BLOCK_SIZE]) withSource:outBuf withSourceIndex:outOff withLength:(length - [XTSCore BLOCK_SIZE])];
    [outBuf copyFromIndex:outOff withSource:buffer withSourceIndex:0 withLength:[XTSCore BLOCK_SIZE]];
#if !__has_feature(objc_arc)
    if (buffer) [buffer release]; buffer = nil;
#endif
    return length;
}

@end
