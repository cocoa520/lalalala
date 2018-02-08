//
//  DSTU4145Params.m
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DSTU4145Params.h"
#import "ASN1Sequence.h"
#import "Arrays.h"
#import "DEROctetString.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface DSTU4145Params ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *namedCurve;
@property (nonatomic, readwrite, retain) DSTU4145ECBinary *ecbinary;
@property (nonatomic, readwrite, retain) NSMutableData *dke;

@end

@implementation DSTU4145Params
@synthesize namedCurve = _namedCurve;
@synthesize ecbinary = _ecbinary;
@synthesize dke = _dke;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_namedCurve) {
        [_namedCurve release];
        _namedCurve = nil;
    }
    if (_ecbinary) {
        [_ecbinary release];
        _ecbinary = nil;
    }
    [super dealloc];
#endif
}

+ (NSMutableData *)DEFAULT_DKE {
    static NSMutableData *_DEFAULT_DKE = nil;
    @synchronized(self) {
        if (!_DEFAULT_DKE) {
            _DEFAULT_DKE = [[@[@((Byte)'-87'), @((Byte)'-42'), @((Byte)'-21'), @((Byte)'69'), @((Byte)'-15'), @((Byte)'60'), @((Byte)'112'), @((Byte)'-126'), @((Byte)'-128'), @((Byte)'-60'), @((Byte)'-106'), @((Byte)'123'), @((Byte)'35'), @((Byte)'31'), @((Byte)'94'), @((Byte)'-83'), @((Byte)'-10'), @((Byte)'88'), @((Byte)'-21'), @((Byte)'-92'), @((Byte)'-64'), @((Byte)'55'), @((Byte)'41'), @((Byte)'29'), @((Byte)'56'), @((Byte)'-39'), @((Byte)'107'), @((Byte)'-16'), @((Byte)'37'), @((Byte)'-54'), @((Byte)'78'), @((Byte)'23'), @((Byte)'114'), @((Byte)'13'), @((Byte)'-58'), @((Byte)'21'), @((Byte)'-76'), @((Byte)'58'), @((Byte)'40'), @((Byte)'-105'), @((Byte)'95'), @((Byte)'11'), @((Byte)'-63'), @((Byte)'-34'), @((Byte)'-93'), @((Byte)'100'), @((Byte)'56'), @((Byte)'-75'), @((Byte)'100'), @((Byte)'-22'), @((Byte)'44'), @((Byte)'23'), @((Byte)'-97'), @((Byte)'-48'), @((Byte)'18'), @((Byte)'62'), @((Byte)'109'), @((Byte)'-72'), @((Byte)'-6'), @((Byte)'-59'), @((Byte)'121'), @((Byte)'4')] fillToNSMutableData] retain];
        }
    }
    return _DEFAULT_DKE;
}

- (void)setDke:(NSMutableData *)dke {
    if (_dke != dke) {
        _dke = [[DSTU4145Params DEFAULT_DKE] retain];
    }
}

+ (DSTU4145Params *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DSTU4145Params class]]) {
        return (DSTU4145Params *)paramObject;
    }
    if (paramObject) {
        ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:paramObject];
        DSTU4145Params *localDSTU4145Params;
        if ([[localASN1Sequence getObjectAt:0] isKindOfClass:[ASN1ObjectIdentifier class]]) {
            localDSTU4145Params = [[[DSTU4145Params alloc] initParamASN1ObjectIdentifier:[ASN1ObjectIdentifier getInstance:[localASN1Sequence getObjectAt:0]]] autorelease];
        }else {
            localDSTU4145Params = [[[DSTU4145Params alloc] initParamDSTU4145ECBinary:[DSTU4145ECBinary getInstance:[localASN1Sequence getObjectAt:0]]] autorelease];
        }
        if ([localASN1Sequence size] == 2) {
            localDSTU4145Params.dke = [[ASN1OctetString getInstance:[localASN1Sequence getObjectAt:1]] getOctets];
            if ([localDSTU4145Params dke].length != [self DEFAULT_DKE].length) {
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"object parse error" userInfo:nil];
            }
        }
        return localDSTU4145Params;
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"object parse error" userInfo:nil];
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier
{
    if (self = [super init]) {
        self.namedCurve = paramASN1ObjectIdentifier;
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
        self.namedCurve = paramASN1ObjectIdentifier;
        NSMutableData *tmpData = [Arrays cloneWithByteArray:paramArrayOfByte];
        self.dke = tmpData;
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDSTU4145ECBinary:(DSTU4145ECBinary *)paramDSTU4145ECBinary
{
    if (self = [super init]) {
        self.ecbinary = paramDSTU4145ECBinary;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)isNamedCurve {
    return self.namedCurve != nil;
}

- (DSTU4145ECBinary *)getECBinary {
    return self.ecbinary;
}

- (NSMutableData *)getDKE {
    return [self dke];
}

+ (NSMutableData *)getDefaultDKE {
    return [self DEFAULT_DKE];
}

- (ASN1ObjectIdentifier *)getNamedCurve {
    return self.namedCurve;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.namedCurve) {
        [localASN1EncodableVector add:self.namedCurve];
    }else {
        [localASN1EncodableVector add:self.ecbinary];
    }
    if (![Arrays areEqualWithByteArray:[self dke] withB:[DSTU4145Params DEFAULT_DKE]]) {
        ASN1Encodable *encodable = [[DEROctetString alloc] initDEROctetString:[self dke]];
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
