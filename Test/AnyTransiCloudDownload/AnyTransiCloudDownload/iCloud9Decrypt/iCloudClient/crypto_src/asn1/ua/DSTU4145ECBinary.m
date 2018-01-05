//
//  DSTU4145ECBinary.m
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DSTU4145ECBinary.h"
#import "ASN1Sequence.h"
#import "ASN1TaggedObject.h"
#import "Arrays.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation DSTU4145ECBinary
@synthesize version = _version;
@synthesize f = _f;
@synthesize a = _a;
@synthesize b = _b;
@synthesize n = _n;
@synthesize bp = _bp;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_f) {
        [_f release];
        _f = nil;
    }
    if (_a) {
        [_a release];
        _a = nil;
    }
    if (_b) {
        [_b release];
        _b = nil;
    }
    if (_n) {
        [_n release];
        _n = nil;
    }
    if (_bp) {
        [_bp release];
        _bp = nil;
    }
    [super dealloc];
#endif
}

+ (DSTU4145ECBinary *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DSTU4145ECBinary class]]) {
        return (DSTU4145ECBinary *)paramObject;
    }
    if (paramObject) {
        return [[[DSTU4145ECBinary alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        if ([[paramASN1Sequence getObjectAt:i] isKindOfClass:[ASN1TaggedObject class]]) {
            ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i];
            if ([localASN1TaggedObject isExplicit] && (0 == [localASN1TaggedObject getTagNo])) {
                self.version = [[ASN1Integer getInstance:[localASN1TaggedObject getLoadedObject]] getValue];
                i++;
            }else {
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"object parse error" userInfo:nil];
            }
        }
        self.f = [DSTU4145BinaryField getInstance:[paramASN1Sequence getObjectAt:i]];
        i++;
        self.a = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:i]];
        i++;
        self.b = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:i]];
        i++;
        self.n = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:i]];
        i++;
        self.bp = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:i]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (DSTU4145BinaryField *)getField {
    return self.f;
}

- (BigInteger *)getA {
    return self.a.getValue;
}

- (NSMutableData *)getB {
    return [[Arrays cloneWithByteArray:[self.b getOctets]] autorelease];
}

- (BigInteger *)getN {
    return self.n.getValue;
}

- (NSMutableData *)getG {
    return [[Arrays cloneWithByteArray:[self.bp getOctets]] autorelease];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (0 != [[self version] compareTo:[BigInteger Zero]]) {
        ASN1Encodable *integerEncodable = [[ASN1Integer alloc] initBI:self.version];
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:0 paramASN1Encodable:integerEncodable];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
    if (integerEncodable) [integerEncodable release]; integerEncodable = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.f];
    [localASN1EncodableVector add:self.a];
    [localASN1EncodableVector add:self.b];
    [localASN1EncodableVector add:self.n];
    [localASN1EncodableVector add:self.bp];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
