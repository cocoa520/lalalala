//
//  RC2CBCParameter.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RC2CBCParameter.h"
#import "DERSequence.h"
#import "DEROctetString.h"

@implementation RC2CBCParameter
@synthesize version = _version;
@synthesize iv = _iv;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_iv) {
        [_iv release];
        _iv = nil;
    }
    [super dealloc];
#endif
}

+ (RC2CBCParameter *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RC2CBCParameter class]]) {
        return (RC2CBCParameter *)paramObject;
    }
    if (paramObject) {
        return [[[RC2CBCParameter alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] == 1) {
            self.version = nil;
            self.iv = (ASN1OctetString *)[paramASN1Sequence getObjectAt:0];
        }else {
            self.version = (ASN1Integer *)[paramASN1Sequence getObjectAt:0];
            self.iv = (ASN1OctetString *)[paramASN1Sequence getObjectAt:1];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.version = nil;
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        self.iv = octetString;
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        self.version = integer;
        self.iv = octetString;
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
    if (octetString) [octetString release]; octetString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BigInteger *)getRC2ParameterVersion {
    if (!self.version) {
        return nil;
    }
    return [self.version getValue];
}

- (NSMutableData *)getIV {
    return [self.iv getOctets];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.version) {
        [localASN1EncodableVector add:self.version];
    }
    [localASN1EncodableVector add:self.iv];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
