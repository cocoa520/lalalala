//
//  XTSAESCipher.m
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import "XTSAESCipher.h"
#import "KeyParameter.h"
#import "XTSCore.h"
#import "XTSTweak.h"

@interface XTSAESCipher ()

@property (nonatomic, readwrite, retain) XTSCore *core;
@property (nonatomic, readwrite, assign) int blockSize;

@end

@implementation XTSAESCipher
@synthesize core = _core;
@synthesize blockSize = _blockSize;

- (id)initWithCore:(XTSCore*)core {
    if (self = [super init]) {
        if (!core) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"core" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setCore:core];
        [self setBlockSize:[core getBlockSize]];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithClazz:(Class)clazz withSelector:(SEL)selector {
    XTSTweak *tweak = [[XTSTweak alloc] initWithClazz:clazz withSelector:selector];
    XTSCore *core = [[XTSCore alloc] initWithTweak:tweak];
    if (self = [self initWithCore:core]) {
#if !__has_feature(objc_arc)
        if (tweak) [tweak release]; tweak = nil;
        if (core) [core release]; core = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (tweak) [tweak release]; tweak = nil;
        if (core) [core release]; core = nil;
        [self release];
#endif
        return nil;
    }
}

- (id)init {
    XTSCore *core = [[XTSCore alloc] init];
    if (self = [self initWithCore:core]) {
#if !__has_feature(objc_arc)
        if (core) [core release]; core = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (core) [core release]; core = nil;
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setCore:nil];
    [super dealloc];
#endif
}

- (NSString*)getAlgorithmName {
    return [[self core] getAlgorithmName];
}

- (int)getBlockSize {
    return [self blockSize];
}

- (XTSAESCipher*)init:(BOOL)forEncryption withKey:(KeyParameter*)key {
    [[self core] init:forEncryption withKey:key];
    return self;
}

- (XTSAESCipher*)init:(BOOL)forEncryption withKey1:(KeyParameter*)key1 withKey2:(KeyParameter*)key2 {
    [[self core] init:forEncryption withKey1:key1 withKey2:key2];
    return self;
}

- (int)processDataUnit:(NSMutableData*)inBuf withInOff:(int)inOff withLength:(int)length withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff withSequenceNumber:(int64_t)sequenceNumber {
    [[self core] reset:sequenceNumber];
    return [self process:inBuf withInOff:inOff withLength:length withOutBuf:outBuf withOutOff:outOff];
}

- (int)process:(NSMutableData*)inBuf withInOff:(int)inOff withLength:(int)length withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff {
    if (length < [self blockSize]) {
        @throw [NSException exceptionWithName:@"DataLength" reason:[NSString stringWithFormat:@"data unit size too small: %d", length] userInfo:nil];
    }
    if (inOff + length > [inBuf length]) {
        @throw [NSException exceptionWithName:@"DataLength" reason:[NSString stringWithFormat:@"input buffer too small for data unit size: %d", length] userInfo:nil];
    }
    if (outOff + length > [outBuf length]) {
        @throw [NSException exceptionWithName:@"DataLength" reason:[NSString stringWithFormat:@"output buffer too small for data unit size: %d", length] userInfo:nil];
    }
    int to = length % [self blockSize] == 0 ? length : length - ([self blockSize] * 2);
    
    int i;
    for (i = 0; i < to; i += [self blockSize]) {
        [[self core] processBlock:inBuf withInOff:(inOff + i) withOutBuf:outBuf withOutOff:(outOff + i)];
    }
    if (length > i) {
        [[self core] processPartial:inBuf withInOff:(inOff + i) withOutBuf:outBuf withOutOff:(outOff + i) withLength:(length - i)];
    }
    return length;
}

@end
