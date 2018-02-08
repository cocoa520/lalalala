//
//  CAST5CBCParameters.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CAST5CBCParameters.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@implementation CAST5CBCParameters
@synthesize keyLength = _keyLength;
@synthesize iv = _iv;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_keyLength) {
        [_keyLength release];
        _keyLength = nil;
    }
    if (_iv) {
        [_iv release];
        _iv = nil;
    }
    [super dealloc];
#endif
}

+ (CAST5CBCParameters *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CAST5CBCParameters class]]) {
        return (CAST5CBCParameters *)paramObject;
    }
    if (paramObject) {
        return [[[CAST5CBCParameters alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt
{
    if (self = [super init]) {
        ASN1OctetString *ivOctetSting = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        ASN1Integer *keyInteger = [[ASN1Integer alloc] initLong:paramInt];
        self.iv = ivOctetSting;
        self.keyLength = keyInteger;
#if !__has_feature(objc_arc)
    if (ivOctetSting) [ivOctetSting release]; ivOctetSting = nil;
    if (keyInteger) [keyInteger release]; keyInteger = nil;
#endif
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
        self.iv = ((ASN1OctetString *)[paramASN1Sequence getObjectAt:0]);
        self.keyLength = ((ASN1Integer *)[paramASN1Sequence getObjectAt:1]);
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableData *)getIV {
    return [self.iv getOctets];
}

- (int)getKeyLength {
    return [[self.keyLength getValue] intValue];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.iv];
    [localASN1EncodableVector add:self.keyLength];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
