//
//  X9FieldElement.m
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X9FieldElement.h"
#import "DEROctetString.h"
#import "X9IntegerConverter.h"
#import "BigInteger.h"

@interface X9FieldElement ()

@property (nonatomic, readwrite, retain) ECFieldElement *f;

@end

@implementation X9FieldElement
@synthesize f = _f;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_f) {
        [_f release];
        _f = nil;
    }
    [super dealloc];
#endif
}

+ (X9IntegerConverter *)converter {
    static X9IntegerConverter *_converter = nil;
    @synchronized(self) {
        if (!_converter) {
            _converter = [[X9IntegerConverter alloc] init];
        }
    }
    return _converter;
}

- (instancetype)initParamECFieldElement:(ECFieldElement *)paramECFieldElement
{
    if (self = [super init]) {
        _f = paramECFieldElement;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        BigInteger *big = [[BigInteger alloc] initWithSign:1 withBytes:[paramASN1OctetString getOctets]];
        ECFieldElement *ecFieldElement = [[FpFieldElement alloc] initWithQ:paramBigInteger withX:big];
        [self initParamECFieldElement:ecFieldElement];
#if !__has_feature(objc_arc)
    if (big) [big release]; big = nil;
    if (ecFieldElement) [ecFieldElement release]; ecFieldElement = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt1:(int)paramInt1 paramInt2:(int)paramInt2 paramInt3:(int)paramInt3 paramInt4:(int)paramInt4 paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        BigInteger *big = [[BigInteger alloc] initWithSign:1 withBytes:[paramASN1OctetString getOctets]];
        ECFieldElement *ecFieldElement = [[F2mFieldElement alloc] initWithM:paramInt1 withK1:paramInt2 withK2:paramInt3 withK3:paramInt4 withX:big];
        [self initParamECFieldElement:ecFieldElement];
#if !__has_feature(objc_arc)
    if (big) [big release]; big = nil;
    if (ecFieldElement) [ecFieldElement release]; ecFieldElement = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ECFieldElement *)getValue {
    return _f;
}

- (ASN1Primitive *)toASN1Primitive {
    int i = [[X9FieldElement converter] getByteLengthParamECFieldElement:self.f];
    NSMutableData *arrayOfByte = [[X9FieldElement converter] integerToBytes:[self.f toBigInteger] paramInt:i];
    return [[[DEROctetString alloc] initDEROctetString:arrayOfByte] autorelease];
}

@end
