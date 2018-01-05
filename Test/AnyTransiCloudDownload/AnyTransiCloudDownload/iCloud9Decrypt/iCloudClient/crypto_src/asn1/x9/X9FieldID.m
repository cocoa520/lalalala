//
//  X9FieldID.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X9FieldID.h"
#import "ASN1Integer.h"
#import "ASN1EncodableVector.h"
#import "ASN1ObjectIdentifier.h"
#import "DERSequence.h"

@interface X9FieldID ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *id;
@property (nonatomic, readwrite, retain) ASN1Primitive *parameters;

@end

@implementation X9FieldID
@synthesize id = _id;
@synthesize parameters = _parameters;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_id) {
        [_id release];
        _id = nil;
    }
    if (_parameters) {
        [_parameters release];
        _parameters = nil;
    }
    [super dealloc];
#endif
}

+ (X9FieldID *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[X9FieldID class]]) {
        return (X9FieldID *)paramObject;
    }
    if (paramObject) {
        return [[[X9FieldID alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence {
    if (self = [super init]) {
        self.id = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.parameters = [[paramASN1Sequence getObjectAt:1] toASN1Primitive];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}


- (instancetype)initParamBI:(BigInteger *)paramBigInteger {
    if (self = [super init]) {
        self.id = [X9ObjectIdentifiers prime_field];
        ASN1Primitive *primitive = [[ASN1Integer alloc] initBI:paramBigInteger];
        self.parameters = primitive;
#if !__has_feature(objc_arc)
    if (primitive) [primitive release]; primitive = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt1:(int)paramInt1 paramInt2:(int)paramInt2 {
    if (self = [super init]) {
        [self initParamInt1:paramInt1 paramInt2:paramInt2 paramInt3:0 paramInt4:0];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt1:(int)paramInt1 paramInt2:(int)paramInt2 paramInt3:(int)paramInt3 paramInt4:(int)paramInt4 {
    if (self = [super init]) {
        self.id = [X9ObjectIdentifiers characteristic_two_field];
        ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
        ASN1Encodable *integerEncodable = [[ASN1Integer alloc] initLong:paramInt1];
        [localASN1EncodableVector1 add:integerEncodable];
#if !__has_feature(objc_arc)
    if (integerEncodable) [integerEncodable release]; integerEncodable = nil;
#endif
        if (paramInt3 == 0) {
            if (paramInt4 != 0) {
                @throw [NSException exceptionWithName:NSRangeException reason:@"inconsistend k values" userInfo:nil];
            }
            [localASN1EncodableVector1 add:[X9ObjectIdentifiers tpBasis]];
            ASN1Encodable *encodable = [[ASN1Integer alloc] initLong:paramInt2];
            [localASN1EncodableVector1 add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }else {
            if ((paramInt3 <= paramInt2) || (paramInt4 <= paramInt3)) {
                @throw [NSException exceptionWithName:NSRangeException reason:@"inconsistent k values" userInfo:nil];
            }
            [localASN1EncodableVector1 add:[X9ObjectIdentifiers ppBasis]];
            ASN1EncodableVector *localASN1EncodableVetor2 = [[ASN1EncodableVector alloc] init];
            ASN1Encodable *encodable1 = [[ASN1Integer alloc] initLong:paramInt2];
            ASN1Encodable *encodable2 = [[ASN1Integer alloc] initLong:paramInt3];
            ASN1Encodable *encodable3 = [[ASN1Integer alloc] initLong:paramInt4];
            ASN1Encodable *derSequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVetor2];
            [localASN1EncodableVetor2 add:encodable1];
            [localASN1EncodableVetor2 add:encodable2];
            [localASN1EncodableVetor2 add:encodable3];
            [localASN1EncodableVector1 add:derSequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVetor2) [localASN1EncodableVetor2 release]; localASN1EncodableVetor2 = nil;
    if (encodable1) [encodable1 release]; encodable1 = nil;
    if (encodable2) [encodable2 release]; encodable2 = nil;
    if (encodable3) [encodable3 release]; encodable3 = nil;
    if (derSequence) [derSequence release]; derSequence = nil;
#endif
        }
        ASN1Primitive *primitive = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1];
        self.parameters = primitive;
#if !__has_feature(objc_arc)
    if (primitive) [primitive release]; primitive = nil;
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getIdentifier {
    return self.id;
}

- (ASN1Primitive *)getParameters {
    return self.parameters;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.id];
    [localASN1EncodableVector add:self.parameters];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
