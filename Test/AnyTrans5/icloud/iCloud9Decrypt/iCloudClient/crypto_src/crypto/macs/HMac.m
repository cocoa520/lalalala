//
//  HMac.m
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import "HMac.h"
#import "Digest.h"
#import "Memoable.h"
#import "CipherParameters.h"
#import "KeyParameter.h"
#import "CategoryExtend.h"

@interface HMac ()

@property (nonatomic, readwrite, retain) Digest *digest;
@property (nonatomic, readwrite, assign) int digestSize;
@property (nonatomic, readwrite, assign) int blockLength;
@property (nonatomic, readwrite, retain) Memoable *ipadState;
@property (nonatomic, readwrite, retain) Memoable *opadState;
@property (nonatomic, readwrite, retain) NSMutableData *inputPad;
@property (nonatomic, readwrite, retain) NSMutableData *outputBuf;

@end

@implementation HMac
@synthesize digest = _digest;
@synthesize digestSize = _digestSize;
@synthesize blockLength = _blockLength;
@synthesize ipadState = _ipadState;
@synthesize opadState = _opadState;
@synthesize inputPad = _inputPad;
@synthesize outputBuf = _outputBuf;

static const Byte IPAD = (Byte)0x36;
static const Byte OPAD = (Byte)0x5C;

- (id)initWithDigest:(Digest*)digest {
    if (self = [super init]) {
        @autoreleasepool {
            [self setDigest:digest];
            [self setDigestSize:[digest getDigestSize]];
            [self setBlockLength:[digest getByteLength]];
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:self.blockLength];
            [self setInputPad:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
            tmpData = [[NSMutableData alloc] initWithSize:(self.blockLength + self.digestSize)];
            [self setOutputBuf:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setDigest:nil];
    [self setIpadState:nil];
    [self setOpadState:nil];
    [self setInputPad:nil];
    [self setOutputBuf:nil];
    [super dealloc];
#endif
}

- (NSString*)algorithmName {
    return [NSString stringWithFormat:@"%@/HMAC", [[self digest] algorithmName]];
}

- (Digest*)getUnderlyingDigest {
    return [self digest];
}

- (void)init:(CipherParameters*)parameters {
    @autoreleasepool {
        [[self digest] reset];
        
        NSMutableData *key = [((KeyParameter*)parameters) getKey];
        int keyLength = (int)(key.length);
        
        if (keyLength > self.blockLength) {
            [[self digest] blockUpdate:key withInOff:0 withLength:keyLength];
            [[self digest] doFinal:[self inputPad] withOutOff:0];
            
            keyLength = self.digestSize;
        } else {
            [[self inputPad] copyFromIndex:0 withSource:key withSourceIndex:0 withLength:keyLength];
        }
        
        [[self inputPad] clearFromIndex:keyLength withLength:(self.blockLength - keyLength)];
        [[self outputBuf] copyFromIndex:0 withSource:[self inputPad] withSourceIndex:0 withLength:self.blockLength];
        
        [HMac xorPad:[self inputPad] withLen:self.blockLength withN:IPAD];
        [HMac xorPad:[self outputBuf] withLen:self.blockLength withN:OPAD];
        
        if ([self digest] != nil && [[self digest] isKindOfClass:[Memoable class]]) {
            [self setOpadState:[((Memoable*)[self digest]) copy]];
            
            [((Digest*)[self opadState]) blockUpdate:[self outputBuf] withInOff:0 withLength:self.blockLength];
        }
        
        [[self digest] blockUpdate:[self inputPad] withInOff:0 withLength:(int)([self inputPad].length)];
        
        if ([self digest] != nil && [[self digest] isKindOfClass:[Memoable class]]) {
            [self setIpadState:[((Memoable*)[self digest]) copy]];
        }
    }
}

- (int)getMacSize {
    return self.digestSize;
}

- (void)update:(Byte)input {
    [[self digest] update:input];
}

- (void)blockUpdate:(NSMutableData*)input withInOff:(int)inOff withLen:(int)len {
    [[self digest] blockUpdate:input withInOff:inOff withLength:len];
}

- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff {
    int len = 0;
    @autoreleasepool {
        [[self digest] doFinal:[self outputBuf] withOutOff:self.blockLength];
        
        if ([self opadState] != nil) {
            [((Memoable*)[self digest]) reset:[self opadState]];
            [[self digest] blockUpdate:[self outputBuf] withInOff:self.blockLength withLength:[[self digest] getDigestSize]];
        } else {
            [[self digest] blockUpdate:[self outputBuf] withInOff:0 withLength:(int)([self outputBuf].length)];
        }
        
        len = [[self digest] doFinal:output withOutOff:outOff];
        
        [[self outputBuf] clearFromIndex:self.blockLength withLength:self.digestSize];
        
        if ([self ipadState] != nil) {
            [((Memoable*)[self digest]) reset:[self ipadState]];
        } else {
            [[self digest] blockUpdate:[self inputPad] withInOff:0 withLength:(int)([self inputPad].length)];
        }
    }
    
    return len;
}

/**
 * Reset the mac generator.
 */
- (void)reset {
    // Reset underlying digest
    [[self digest] reset];
    
    // Initialise the digest
    [[self digest] blockUpdate:[self inputPad] withInOff:0 withLength:(int)([self inputPad].length)];
}

+ (void)xorPad:(NSMutableData*)pad withLen:(int)len withN:(Byte)n {
    for (int i = 0; i < len; ++i) {
        ((Byte*)(pad.bytes))[i] = ((Byte*)(pad.bytes))[i] ^ n;
    }
}

@end
