//
//  DHValidationParms.m
//  crypto
//
//  Created by JGehry on 5/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DHValidationParms.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface DHValidationParms ()

@property (nonatomic, readwrite, retain) DERBitString *seed;
@property (nonatomic, readwrite, retain) ASN1Integer *pgenCounter;

@end

@implementation DHValidationParms
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

+ (DHValidationParms *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DHValidationParms getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (DHValidationParms *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DHValidationParms class]]) {
        return (DHValidationParms *)paramObject;
    }
    if (paramObject) {
        return [[[DHValidationParms alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamDERBitString:(DERBitString *)paramDERBitString paramASN1Integer:(ASN1Integer *)paramASN1Integer
{
    if (self = [super init]) {
        if (!paramDERBitString) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"seed' cannot be null" userInfo:nil];
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

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASn1Sequence
{
    if (self = [super init]) {
        if ([paramASn1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Bad sequence size: %d", paramASn1Sequence.size] userInfo:nil];
        }
        self.seed = [DERBitString getInstance:[paramASn1Sequence getObjectAt:0]];
        self.pgenCounter = [ASN1Integer getInstance:[paramASn1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (DERBitString *)getSeed {
    return self.seed;
}

- (ASN1Integer *)getPgenCounter {
    return self.pgenCounter;
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
