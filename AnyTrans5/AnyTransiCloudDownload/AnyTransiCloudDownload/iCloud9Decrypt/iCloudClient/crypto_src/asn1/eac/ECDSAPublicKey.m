//
//  ECDSAPublicKey.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ECDSAPublicKey.h"
#import "ASN1OctetString.h"
#import "UnsignedInteger.h"
#import "DERTaggedObject.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@interface ECDSAPublicKey ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *usage;
@property (nonatomic, readwrite, retain) BigInteger *primeModulusP;
@property (nonatomic, readwrite, retain) BigInteger *firstCoefA;
@property (nonatomic, readwrite, retain) BigInteger *secondCoefB;
@property (nonatomic, readwrite, retain) NSMutableData *basePointG;
@property (nonatomic, readwrite, retain) BigInteger *orderOfBasePointR;
@property (nonatomic, readwrite, retain) NSMutableData *publicPointY;
@property (nonatomic, readwrite, retain) BigInteger *cofactorF;
@property (nonatomic, assign) int options;

@end

@implementation ECDSAPublicKey
@synthesize usage = _usage;
@synthesize primeModulusP = _primeModulusP;
@synthesize firstCoefA = _firstCoefA;
@synthesize secondCoefB = _secondCoefB;
@synthesize basePointG = _basePointG;
@synthesize orderOfBasePointR = _orderOfBasePointR;
@synthesize publicPointY = _publicPointY;
@synthesize cofactorF = _cofactorF;
@synthesize options = _options;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_usage) {
        [_usage release];
        _usage = nil;
    }
    if (_primeModulusP) {
        [_primeModulusP release];
        _primeModulusP = nil;
    }
    if (_firstCoefA) {
        [_firstCoefA release];
        _firstCoefA = nil;
    }
    if (_secondCoefB) {
        [_secondCoefB release];
        _secondCoefB = nil;
    }
    if (_basePointG) {
        [_basePointG release];
        _basePointG = nil;
    }
    if (_orderOfBasePointR) {
        [_orderOfBasePointR release];
        _orderOfBasePointR = nil;
    }
    if (_publicPointY) {
        [_publicPointY release];
        _publicPointY = nil;
    }
    if (_cofactorF) {
        [_cofactorF release];
        _cofactorF = nil;
    }
    [super dealloc];
#endif
}

+ (int)P {
    static int _P = 0;
    @synchronized(self) {
        if (!_P) {
            _P = 1;
        }
    }
    return _P;
}

+ (int)A {
    static int _A = 0;
    @synchronized(self) {
        if (!_A) {
            _A = 2;
        }
    }
    return _A;
}

+ (int)B {
    static int _B = 0;
    @synchronized(self) {
        if (!_B) {
            _B = 4;
        }
    }
    return _B;
}

+ (int)G {
    static int _G = 0;
    @synchronized(self) {
        if (!_G) {
            _G = 8;
        }
    }
    return _G;
}

+ (int)R {
    static int _R = 0;
    @synchronized(self) {
        if (!_R) {
            _R = 16;
        }
    }
    return _R;
}

+ (int)Y {
    static int _Y = 0;
    @synchronized(self) {
        if (!_Y) {
            _Y = 32;
        }
    }
    return _Y;
}

+ (int)F {
    static int _F = 0;
    @synchronized(self) {
        if (!_F) {
            _F = 64;
        }
    }
    return _F;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.usage = [ASN1ObjectIdentifier getInstance:[localEnumeration nextObject]];
        self.options = 0;
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            if ([localObject isKindOfClass:[ASN1TaggedObject class]]) {
                ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)localObject;
                switch ([localASN1TaggedObject getTagNo]) {
                    case 1:
                        [self setPrimeModulusP:[[UnsignedInteger getInstance:localASN1TaggedObject] getValue]];
                        break;
                    case 2:
                        [self setFirstCoefA:[[UnsignedInteger getInstance:localASN1TaggedObject] getValue]];
                        break;
                    case 3:
                        [self setSecondCoefB:[[UnsignedInteger getInstance:localASN1TaggedObject] getValue]];
                        break;
                    case 4:
                        [self setIsBasePointG:[ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:NO]];
                        break;
                    case 5:
                        [self setOrderOfBasePointR:[[UnsignedInteger getInstance:localASN1TaggedObject] getValue]];
                        break;
                    case 6:
                        [self setIsPublicPointY:[ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:NO]];
                        break;
                    case 7:
                        [self setIsCofactorF:[[UnsignedInteger getInstance:localASN1TaggedObject] getValue]];
                        break;
                    default:
                        self.options = 0;
                        @throw [NSException exceptionWithName:NSGenericException reason:@"Unknown Object Identifier!" userInfo:nil];
                        break;
                }
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:@"Unknown Object Identifier!" userInfo:nil];
            }
        }
        if ((self.options != 32) && (self.options != 127)) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"All options must be either present or absent!" userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.usage = paramASN1ObjectIdentifier;
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        [self setIsPublicPointY:octetString];
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

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3 paramArrayOfByte1:(NSMutableData *)paramArrayOfByte1 paramBigInteger4:(BigInteger *)paramBigInteger4 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 paramInt:(int)paramInt
{
    if (self = [super init]) {
        self.usage = paramASN1ObjectIdentifier;
        [self setPrimeModulusP:paramBigInteger1];
        [self setFirstCoefA:paramBigInteger2];
        [self setSecondCoefB:paramBigInteger3];
        ASN1OctetString *baseOctetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte1];
        [self setIsBasePointG:baseOctetString];
        [self setOrderOfBasePointR:paramBigInteger4];
        ASN1OctetString *publicOctetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte2];
        [self setIsPublicPointY:publicOctetString];
        [self setIsCofactorF:[BigInteger valueOf:paramInt]];
#if !__has_feature(objc_arc)
    if (baseOctetString) [baseOctetString release]; baseOctetString = nil;
    if (publicOctetString) [publicOctetString release]; publicOctetString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getUsage {
    return self.usage;
}

- (NSMutableData *)getBasePointG {
    if ((self.options & 0x8)) {
        return self.basePointG;
    }
    return nil;
}

- (void)setIsBasePointG:(ASN1OctetString *)paramASN1OctetString {
    if ((self.options & 0x8) == 0) {
        self.options |= 0x8;
        self.basePointG = [paramASN1OctetString getOctets];
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Base Point G already set" userInfo:nil];
    }
}

- (BigInteger *)getCofactorF {
    if ((self.options & 0x40)) {
        return self.cofactorF;
    }
    return nil;
}

- (void)setIsCofactorF:(BigInteger *)paramBigInteger {
    if ((self.options & 0x40) == 0) {
        self.options |= 0x40;
        self.cofactorF = paramBigInteger;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Cofactor F already set" userInfo:nil];
    }
}

- (BigInteger *)getFirstCoefA {
    if ((self.options & 0x2)) {
        return self.firstCoefA;
    }
    return nil;
}

- (void)setFirstCoefA:(BigInteger *)paramBigInteger {
    if ((self.options & 0x2) == 0) {
        self.options |= 0x2;
        self.firstCoefA = paramBigInteger;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"First Coef A already set" userInfo:nil];
    }
}

- (BigInteger *)getOrderOfBasePointR {
    if ((self.options & 0x10)) {
        return self.orderOfBasePointR;
    }
    return nil;
}

- (void)setOrderOfBasePointR:(BigInteger *)paramBigInteger {
    if ((self.options & 0x10) == 0) {
        self.options |= 0x10;
        self.orderOfBasePointR = paramBigInteger;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Order of base point R already set" userInfo:nil];
    }
}

- (BigInteger *)getPrimeModulusP {
    if ((self.options & 0x1)) {
        return self.primeModulusP;
    }
    return nil;
}

- (void)setPrimeModulusP:(BigInteger *)paramBigInteger {
    if ((self.options & 0x1) == 0) {
        self.options |= 0x1;
        self.primeModulusP = paramBigInteger;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Prime Modulus P already set" userInfo:nil];
    }
}

- (NSMutableData *)getPublicPointY {
    if ((self.options & 0x20)) {
        return self.publicPointY;
    }
    return nil;
}

- (void)setIsPublicPointY:(ASN1OctetString *)paramASN1OctetString {
    if ((self.options & 0x20) == 0) {
        self.options |= 0x20;
        self.publicPointY = [paramASN1OctetString getOctets];
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Public Point Y already set" userInfo:nil];
    }
}

- (BigInteger *)getSecondCoefB {
    if ((self.options & 0x4)) {
        return self.secondCoefB;
    }
    return nil;
}

- (void)setSecondCoefB:(BigInteger *)paramBigInteger {
    if ((self.options & 0x4) == 0) {
        self.options |= 0x4;
        self.secondCoefB = paramBigInteger;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Second Coef B already set" userInfo:nil];
    }
}

- (BOOL)hasParameters {
    return self.primeModulusP != nil;
}

- (ASN1EncodableVector *)getASN1EncodableVector:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBoolean:(BOOL)paramBoolean {
    ASN1EncodableVector *localASN1EncodableVector = [[[ASN1EncodableVector alloc] init] autorelease];
    [localASN1EncodableVector add:paramASN1ObjectIdentifier];
    if (!paramBoolean) {
        ASN1Encodable *encodable1 = [[UnsignedInteger alloc] initParamInt:1 paramBigInteger:[self getPrimeModulusP]];
        ASN1Encodable *encodable2 = [[UnsignedInteger alloc] initParamInt:2 paramBigInteger:[self getFirstCoefA]];
        ASN1Encodable *encodable3 = [[UnsignedInteger alloc] initParamInt:3 paramBigInteger:[self getSecondCoefB]];
        ASN1Encodable *encodable4 = [[DEROctetString alloc] initDEROctetString:[self getBasePointG]];
        ASN1Encodable *encodable5 = [[DERTaggedObject alloc] initParamBoolean:false paramInt:4 paramASN1Encodable:encodable4];
        ASN1Encodable *encodable6 = [[UnsignedInteger alloc] initParamInt:5 paramBigInteger:[self getOrderOfBasePointR]];
        [localASN1EncodableVector add:encodable1];
        [localASN1EncodableVector add:encodable2];
        [localASN1EncodableVector add:encodable3];
        [localASN1EncodableVector add:encodable5];
        [localASN1EncodableVector add:encodable6];
#if !__has_feature(objc_arc)
        if (encodable1) [encodable1 release]; encodable1 = nil;
        if (encodable2) [encodable2 release]; encodable2 = nil;
        if (encodable3) [encodable3 release]; encodable3 = nil;
        if (encodable4) [encodable4 release]; encodable4 = nil;
        if (encodable5) [encodable5 release]; encodable5 = nil;
        if (encodable6) [encodable6 release]; encodable6 = nil;
#endif
    }
    ASN1Encodable *encodable5 = [[DEROctetString alloc] initDEROctetString:[self getPublicPointY]];
    ASN1Encodable *encodable6 = [[DERTaggedObject alloc] initParamBoolean:false paramInt:6 paramASN1Encodable:encodable5];
    [localASN1EncodableVector add:encodable6];
    if (!paramBoolean) {
        ASN1Encodable *encodable7 = [[UnsignedInteger alloc] initParamInt:7 paramBigInteger:[self getCofactorF]];
        [localASN1EncodableVector add:encodable7];
#if !__has_feature(objc_arc)
        if (encodable7) [encodable7 release]; encodable7 = nil;
#endif
    }
#if !__has_feature(objc_arc)
    if (encodable5) [encodable5 release]; encodable5 = nil;
    if (encodable6) [encodable6 release]; encodable6 = nil;
#endif
    return localASN1EncodableVector;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DERSequence alloc] initDERParamASN1EncodableVector:[self getASN1EncodableVector:self.usage paramBoolean:NO]] autorelease];
}

@end
