//
//  X9Curve.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X9Curve.h"
#import "ECAlgorithms.h"
#import "X9FieldID.h"
#import "ASN1Sequence.h"
#import "ASN1Integer.h"
#import "X9FieldElement.h"
#import "DERBitString.h"
#import "ASN1EncodableVector.h"
#import "DERSequence.h"

@interface X9Curve ()

@property (nonatomic, readwrite, retain) ECCurve *curve;
@property (nonatomic, readwrite, retain) NSMutableData *seed;
@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *fieldIdentifier;

@end

@implementation X9Curve
@synthesize curve = _curve;
@synthesize seed = _seed;
@synthesize fieldIdentifier = _fieldIdentifier;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_curve) {
        [_curve release];
        _curve = nil;
    }
    if (_seed) {
        [_seed release];
        _seed = nil;
    }
    if (_fieldIdentifier) {
        [_fieldIdentifier release];
        _fieldIdentifier = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamECCurve:(ECCurve *)paramECCurve
{
    if (self = [super init]) {
        self.curve = paramECCurve;
        self.seed = NULL;
        [self setFieldIdentifier];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamECCurve:(ECCurve *)paramECCurve paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    if (self = [super init]) {
        self.curve = paramECCurve;
        self.seed = paramArrayOfByte;
        [self setFieldIdentifier];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamECCurve:(X9FieldID *)paramX9FieldID paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence {
    if (self = [super init]) {
        self.fieldIdentifier = [paramX9FieldID getIdentifier];
        id localObject1;
        id localObject2;
        id localObject3;
        if ([self.fieldIdentifier isEqual:[X9ObjectIdentifiers prime_field]]) {
            localObject1 = [((ASN1Integer *)[paramX9FieldID getParameters]) getValue];
            X9FieldElement *localX9fieldElement1 = [[X9FieldElement alloc] initParamBigInteger:(BigInteger *)localObject1 paramASN1OctetString:(ASN1OctetString *)[paramASN1Sequence getObjectAt:0]];
            localObject2 = [[X9FieldElement alloc] initParamBigInteger:(BigInteger *)localObject1 paramASN1OctetString:(ASN1OctetString *)[paramASN1Sequence getObjectAt:1]];
            ECCurve *ecc = [[[FpCurve alloc] initWithQ:(BigInteger *)localObject1 withA:[[localX9fieldElement1 getValue] toBigInteger] withB:[[((X9FieldElement *)localObject2) getValue] toBigInteger]] autorelease];
            self.curve = ecc;
#if !__has_feature(objc_arc)
    if (localX9fieldElement1) [localX9fieldElement1 release]; localX9fieldElement1 = nil;
    if (localObject2) [localObject2 release]; localObject2 = nil;
    if (ecc) [ecc release]; ecc = nil;
#endif
        }else if ([self.fieldIdentifier isEqual:[X9ObjectIdentifiers characteristic_two_field]]) {
            localObject1 = [ASN1Sequence getInstance:[paramX9FieldID getParameters]];
            int i = [[((ASN1Integer *)[((ASN1Sequence *)localObject1) getObjectAt:0]) getValue] intValue];
            localObject2 = (ASN1ObjectIdentifier *)[((ASN1Sequence *)localObject1) getObjectAt:1];
            int j = 0;
            int k = 0;
            int m = 0;
            if ([((ASN1ObjectIdentifier *)localObject2) isEqual:[X9ObjectIdentifiers tpBasis]]) {
                j = [[[ASN1Integer getInstance:[((ASN1Sequence *)localObject1) getObjectAt:2]] getValue] intValue];
            }else if ([((ASN1ObjectIdentifier *)localObject2) isEqual:[X9ObjectIdentifiers ppBasis]]) {
                localObject3 = [ASN1Sequence getInstance:[((ASN1Sequence *)localObject1) getObjectAt:2]];
                j = [[[ASN1Integer getInstance:[((ASN1Sequence *)localObject3) getObjectAt:0]] getValue] intValue];
                k = [[[ASN1Integer getInstance:[((ASN1Sequence *)localObject3) getObjectAt:1]] getValue] intValue];
                m = [[[ASN1Integer getInstance:[((ASN1Sequence *)localObject3) getObjectAt:2]] getValue] intValue];
            }else {
                @throw [[NSException exceptionWithName:NSGenericException reason:@"This type of EC basis is not implemented" userInfo:nil] autorelease];
            }
            localObject3 = [[X9FieldElement alloc] initParamInt1:i paramInt2:j paramInt3:k paramInt4:m paramASN1OctetString:(ASN1OctetString *)[paramASN1Sequence getObjectAt:0]];
            X9FieldElement *localX9FieldElement2 = [[X9FieldElement alloc] initParamInt1:i paramInt2:j paramInt3:k paramInt4:m paramASN1OctetString:(ASN1OctetString *)[paramASN1Sequence getObjectAt:1]];
            ECCurve *ecc = [[F2mCurve alloc] initWithM:i withK1:j withK2:k withK3:m withA:[[((X9FieldElement *)localObject3) getValue] toBigInteger] withB:[[localX9FieldElement2 getValue] toBigInteger]];
            self.curve = ecc;
#if !__has_feature(objc_arc)
    if (localObject3) [localObject3 release]; localObject3 = nil;
    if (localX9FieldElement2) [localX9FieldElement2 release]; localX9FieldElement2 = nil;
    if (ecc) [ecc release]; ecc = nil;
#endif
        }else {
            @throw [[NSException exceptionWithName:NSGenericException reason:@"This type of ECCurve is not implemented" userInfo:nil] autorelease];
        }
        if (paramASN1Sequence.seq.count == 3) {
            self.seed = [(DERBitString *)[paramASN1Sequence getObjectAt:2] getBytes];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)setFieldIdentifier {
    if ([ECAlgorithms isFpCurve:self.curve]) {
        self.fieldIdentifier = [X9ObjectIdentifiers prime_field];
    }else if ([ECAlgorithms isF2mCurve:self.curve]) {
        self.fieldIdentifier = [X9ObjectIdentifiers characteristic_two_field];
    }else {
        @throw [[NSException exceptionWithName:NSGenericException reason:@"This type of ECCurve is not implemented" userInfo:nil] autorelease];
    }
}

- (ECCurve *)getCurve {
    return self.curve;
}

- (NSMutableData *)getSeed {
    return self.seed;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if ([self.fieldIdentifier isEqual:[X9ObjectIdentifiers prime_field]]) {
        X9FieldElement *x9FE1 = [[X9FieldElement alloc] initParamECFieldElement:[self.curve a]];
        X9FieldElement *x9FE2 = [[X9FieldElement alloc] initParamECFieldElement:[self.curve b]];
        [localASN1EncodableVector add:[x9FE1 toASN1Primitive]];
        [localASN1EncodableVector add:[x9FE2 toASN1Primitive]];
#if !__has_feature(objc_arc)
    if (x9FE1) [x9FE1 release]; x9FE1 = nil;
    if (x9FE2) [x9FE2 release]; x9FE2 = nil;
#endif
    }else if ([self.fieldIdentifier isEqual:[X9ObjectIdentifiers characteristic_two_field]]) {
        X9FieldElement *x9FE1 = [[X9FieldElement alloc] initParamECFieldElement:[self.curve a]];
        X9FieldElement *x9FE2 = [[X9FieldElement alloc] initParamECFieldElement:[self.curve b]];
        [localASN1EncodableVector add:[x9FE1 toASN1Primitive]];
        [localASN1EncodableVector add:[x9FE2 toASN1Primitive]];
#if !__has_feature(objc_arc)
        if (x9FE1) [x9FE1 release]; x9FE1 = nil;
        if (x9FE2) [x9FE2 release]; x9FE2 = nil;
#endif
    }
    if (self.seed) {
        ASN1Encodable *encodable = [[DERBitString alloc] initDERBitString:self.seed];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
