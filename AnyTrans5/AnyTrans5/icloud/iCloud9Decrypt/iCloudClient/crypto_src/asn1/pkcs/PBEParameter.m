//
//  PBEParameter.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PBEParameter.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DEROctetString.h"

@implementation PBEParameter
@synthesize iterations = _iterations;
@synthesize salt = _salt;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_iterations) {
        [_iterations release];
        _iterations = nil;
    }
    if (_salt) {
        [_salt release];
        _salt = nil;
    }
    [super dealloc];
#endif
}

+ (PBEParameter *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PBEParameter class]]) {
        return (PBEParameter *)paramObject;
    }
    if (paramObject) {
        return [[[PBEParameter alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.salt = (ASN1OctetString *)[paramASN1Sequence getObjectAt:0];
        self.iterations = (ASN1Integer *)[paramASN1Sequence getObjectAt:1];
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
        if ([paramArrayOfByte length] != 8) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"salt length must be 8" userInfo:nil];
        }
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
        self.salt = octetString;
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

- (BigInteger *)getIterationCount {
    return [self.iterations getValue];
}

- (NSMutableData *)getSalt {
    return [self.salt getOctets];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.salt];
    [localASN1EncodableVector add:self.iterations];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
