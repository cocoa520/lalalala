//
//  PKCS12PBEParams.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKCS12PBEParams.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DEROctetString.h"

@implementation PKCS12PBEParams
@synthesize iterations = _iterations;
@synthesize iv = _iv;

+ (PKCS12PBEParams *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PKCS12PBEParams class]]) {
        return (PKCS12PBEParams *)paramObject;
    }
    if (paramObject) {
        return [[[PKCS12PBEParams alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.iv = (ASN1OctetString *)[paramASN1Sequence getObjectAt:0];
        self.iterations = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt
{
    if (self = [super init]) {
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
        self.iv = octetString;
        self.iterations = integer;
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
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

- (void)dealloc
{
    [self setIterations:nil];
    [self setIv:nil];
    [super dealloc];
}

- (BigInteger *)getIterations {
    return [self.iterations getValue];
}

- (NSMutableData *)getIV {
    return [self.iv getOctets];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.iv];
    [localASN1EncodableVector add:self.iterations];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
