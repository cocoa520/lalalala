//
//  ValidationParams.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ValidationParams.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface ValidationParams ()

@property (nonatomic, readwrite, retain) DERBitString *seed;
@property (nonatomic, readwrite, retain) ASN1Integer *pgenCounter;

@end

@implementation ValidationParams
@synthesize seed = _seed;
@synthesize pgenCounter = _pgenCounter;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_seed) {
        [_seed release];
        _seed = nil;
    }
    if (_pgenCounter) {
        [_pgenCounter release];
        _pgenCounter = nil;
    }
    [super dealloc];
#endif
}

+ (ValidationParams *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [ValidationParams getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (ValidationParams *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ValidationParams class]]) {
        return (ValidationParams *)paramObject;
    }
    if (paramObject) {
        return [[[ValidationParams alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt
{
    if (self = [super init]) {
        if (!paramArrayOfByte) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'seed' cannot be null" userInfo:nil];
        }
        DERBitString *seedBit =  [[DERBitString alloc] initDERBitString:paramArrayOfByte];
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
        self.seed = seedBit;
        self.pgenCounter = integer;
#if !__has_feature(objc_arc)
    if (seedBit) [seedBit release]; seedBit = nil;
    if (integer) [integer release]; integer = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDERBitString:(DERBitString *)paramDERBitString paramASN1Integer:(ASN1Integer *)paramASN1Integer
{
    if (self = [super init]) {
        if (!paramDERBitString) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'seed' cannot be null" userInfo:nil];
        }
        if (!paramASN1Integer) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'pgenCounter' cannot be null" userInfo:nil];
        }
        self.seed = paramDERBitString;
        self.pgenCounter = paramASN1Integer;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Bad sequence size: %d", paramASN1Sequence.size] userInfo:nil];
        }
        self.seed = [DERBitString getInstance:[paramASN1Sequence getObjectAt:0]];
        self.pgenCounter = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableData *)getSeed {
    return self.seed.getBytes;
}

- (BigInteger *)getPgenCounter {
    return self.pgenCounter.getPositiveValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.seed];
    [localASN1EncodableVector add:self.pgenCounter];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
