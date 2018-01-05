//
//  X9ECParameters.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X9ECParameters.h"
#import "ASN1Sequence.h"
#import "ASN1Primitive.h"
#import "ECAlgorithms.h"
#import "IFiniteField.h"
#import "IPolynomialExtensionField.h"
#import "IPolynomial.h"
#import "ASN1EncodableVector.h"
#import "ASN1Integer.h"
#import "DERSequence.h"

@interface X9ECParameters ()

@property (nonatomic, readwrite, retain) BigInteger *n;
@property (nonatomic, readwrite, retain) BigInteger *h;
@property (nonatomic, readwrite, retain) X9ECPoint *g;
@property (nonatomic, readwrite, retain) ECCurve *curve;
@property (nonatomic, readwrite, retain) NSMutableData *seed;
@property (nonatomic, readwrite, retain) X9FieldID *fieldID;

@end

@implementation X9ECParameters
@synthesize n = _n;
@synthesize h = _h;
@synthesize g = _g;
@synthesize curve = _curve;
@synthesize seed = _seed;
@synthesize fieldID = _fieldID;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_n) {
        [_n release];
        _n = nil;
    }
    if (_h) {
        [_h release];
        _h = nil;
    }
    if (_g) {
        [_g release];
        _g = nil;
    }
    if (_curve) {
        [_curve release];
        _curve = nil;
    }
    if (_seed) {
        [_seed release];
        _seed = nil;
    }
    if (_fieldID) {
        [_fieldID release];
        _fieldID = nil;
    }
    [super dealloc];
#endif
}

+ (BigInteger *)ONE {
    static BigInteger *_one = nil;
    @synchronized(self) {
        if (!_one) {
            _one = [BigInteger One];
        }
    }
    return _one;
}

- (instancetype)init:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (![[paramASN1Sequence getObjectAt:0] isKindOfClass:[ASN1Integer class]] || ![[(ASN1Integer *)[paramASN1Sequence getObjectAt:0] getValue] isEqual:[X9ECParameters ONE]]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"bad version in X9ECParameters" userInfo:nil];
        }
        X9Curve *localX9Curve = [[X9Curve alloc] initParamECCurve:[X9FieldID getInstance:[paramASN1Sequence getObjectAt:1]] paramASN1Sequence:[ASN1Sequence getInstance:[paramASN1Sequence getObjectAt:2]]];
        self.curve = [localX9Curve getCurve];
        ASN1Encodable *localASN1Encodable = [paramASN1Sequence getObjectAt:3];
        if ([localASN1Encodable isKindOfClass:[X9ECPoint class]]) {
            self.g = (X9ECPoint *)localASN1Encodable;
        }else {
            X9ECPoint *x9ECP = [[X9ECPoint alloc] initParamECCurve:self.curve paramASN1OctetString:(ASN1OctetString *)localASN1Encodable];
            self.g = x9ECP;
#if !__has_feature(objc_arc)
    if (x9ECP) [x9ECP release]; x9ECP = nil;
#endif
        }
        self.n = [((ASN1Integer *)[paramASN1Sequence getObjectAt:4]) getValue];
        self.seed = [localX9Curve getSeed];
        if (paramASN1Sequence.seq.count == 6) {
            self.h = [((ASN1Integer *)[paramASN1Sequence getObjectAt:5]) getValue];
        }
#if !__has_feature(objc_arc)
    if (localX9Curve) [localX9Curve release]; localX9Curve = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

+ (X9ECParameters *)getInstance:(id)paramObject{
    if ([paramObject isKindOfClass:[X9ECParameters class]]) {
        return (X9ECParameters *)paramObject;
    }
    if (paramObject) {
        return [[[X9ECParameters alloc] init:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return NULL;
}

- (instancetype)initX9ECParametersECCurve:(ECCurve *)paramECCurve ECParamECPoint:(ECPoint *)paramECPoint ECParamBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        [self initX9ECParametersECCurve:paramECCurve ECParamECPoint:paramECPoint ECParamBigInteger1:paramBigInteger ECParamBigInteger2:nil ECParamArrayOfByte:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initX9ECParametersECCurve:(ECCurve *)paramECCurve ECParamX9ECPoint:(X9ECPoint *)paramX9ECPoint ECParamBigInteger1:(BigInteger *)paramBigInteger1 ECParamBigInteger2:(BigInteger *)paramBigInteger2
{
    if (self = [super init]) {
        [self initX9ECParametersECCurve:paramECCurve ECParamX9ECPoint:paramX9ECPoint ECParamBigInteger1:paramBigInteger1 ECParamBigInteger2:paramBigInteger2 ECParamArrayOfByte:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initX9ECParametersECCurve:(ECCurve *)paramECCurve ECParamECPoint:(ECPoint *)paramECPoint ECParamBigInteger1:(BigInteger *)paramBigInteger1 ECParamBigInteger2:(BigInteger *)paramBigInteger2
{
    if (self = [super init]) {
        [self initX9ECParametersECCurve:paramECCurve ECParamECPoint:paramECPoint ECParamBigInteger1:paramBigInteger1 ECParamBigInteger2:paramBigInteger2 ECParamArrayOfByte:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initX9ECParametersECCurve:(ECCurve *)paramECCurve ECParamECPoint:(ECPoint *)paramECPoint ECParamBigInteger1:(BigInteger *)paramBigInteger1 ECParamBigInteger2:(BigInteger *)paramBigInteger2 ECParamArrayOfByte:(NSMutableData *)arrayOfByte
{
    if (self = [super init]) {
        X9ECPoint *x9ECP = [[X9ECPoint alloc] initParamECPoint:paramECPoint];
        [self initX9ECParametersECCurve:paramECCurve ECParamX9ECPoint:x9ECP ECParamBigInteger1:paramBigInteger1 ECParamBigInteger2:paramBigInteger2 ECParamArrayOfByte:arrayOfByte];
#if !__has_feature(objc_arc)
    if (x9ECP) [x9ECP release]; x9ECP = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initX9ECParametersECCurve:(ECCurve *)paramECCurve ECParamX9ECPoint:(X9ECPoint *)paramX9ECPoint ECParamBigInteger1:(BigInteger *)paramBigInteger1 ECParamBigInteger2:(BigInteger *)paramBigInteger2 ECParamArrayOfByte:(NSMutableData *)arrayOfByte
{
    if (self = [super init]) {
        self.curve = paramECCurve;
        self.g = paramX9ECPoint;
        self.n = paramBigInteger1;
        self.h = paramBigInteger2;
        self.seed = arrayOfByte;
        if ([ECAlgorithms isFpCurve:paramECCurve]) {
            X9FieldID *x9FID = [[X9FieldID alloc] initParamBI:[[paramECCurve field] characteristic]];
            self.fieldID = x9FID;
#if !__has_feature(objc_arc)
    if (x9FID) [x9FID release]; x9FID = nil;
#endif
        }else if ([ECAlgorithms isF2mCurve:paramECCurve]) {
            IPolynomialExtensionField *localPolynomialExtensionField = (IPolynomialExtensionField *)paramECCurve.field;
            NSMutableArray *intArray = [[localPolynomialExtensionField minimalPolynomial] getExponentsPresent];
            if (intArray.count == 3) {
                X9FieldID *x9FID = [[X9FieldID alloc] initParamInt1:[[intArray objectAtIndex:2] intValue] paramInt2:[[intArray objectAtIndex:1] intValue]];
                self.fieldID = x9FID;
#if !__has_feature(objc_arc)
                if (x9FID) [x9FID release]; x9FID = nil;
#endif
            }else if (intArray.count == 5) {
                X9FieldID *x9FID = [[X9FieldID alloc] initParamInt1:[[intArray objectAtIndex:4] intValue] paramInt2:[[intArray objectAtIndex:1] intValue] paramInt3:[[intArray objectAtIndex:2] intValue] paramInt4:[[intArray objectAtIndex:3] intValue]];
                self.fieldID = x9FID;
#if !__has_feature(objc_arc)
                if (x9FID) [x9FID release]; x9FID = nil;
#endif
            }else {
                @throw [NSException exceptionWithName:NSRangeException reason:@"Only trinomial and pentomial curves are supported" userInfo:nil];
            }
        }else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"curve is of an unsupported type" userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ECPoint *)getG {
    return self.g.getPoint;
}

- (X9Curve *)getCurveEntry {
    return [[[X9Curve alloc] initParamECCurve:self.curve paramArrayOfByte:self.seed] autorelease];
}

- (BigInteger *)getN {
    return self.n;
}

- (BigInteger *)getH {
    return self.h;
}

- (NSMutableData *)getSeed {
    return self.seed;
}

- (X9FieldID *)getFieldIDEntry {
    return self.fieldID;
}

- (X9ECPoint *)getBaseEntry {
    return self.g;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    ASN1Encodable *integer = [[ASN1Integer alloc] initBI:[X9ECParameters ONE]];
    ASN1Encodable *x9C = [[X9Curve alloc] initParamECCurve:self.curve paramArrayOfByte:self.seed];
    ASN1Encodable *integer1 = [[ASN1Integer alloc] initBI:self.n];
    [localASN1EncodableVector add:integer];
    [localASN1EncodableVector add:self.fieldID];
    [localASN1EncodableVector add:x9C];
    [localASN1EncodableVector add:self.g];
    [localASN1EncodableVector add:integer1];
    if (self.h) {
        ASN1Encodable *integer = [[ASN1Integer alloc] initBI:self.h];
        [localASN1EncodableVector add:integer];
#if !__has_feature(objc_arc)
        if (integer) [integer release]; integer = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (integer) [integer release]; integer = nil;
    if (x9C) [x9C release]; x9C = nil;
    if (integer1) [integer1 release]; integer1 = nil;
#endif
    return primitive;
}

@end
