//
//  ECPrivateKey.m
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ECPrivateKey.h"
#import "BigIntegers.h"
#import "ASN1Integer.h"
#import "DEROctetString.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@interface ECPrivateKey ()

@property (nonatomic, readwrite, retain) ASN1Sequence *seq;

@end

@implementation ECPrivateKey
@synthesize seq = _seq;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_seq) {
        [_seq release];
        _seq = nil;
    }
    [super dealloc];
#endif
}

+ (ECPrivateKey *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ECPrivateKey class]]) {
        return (ECPrivateKey *)paramObject;
    }
    if (paramObject) {
        return [[[ECPrivateKey alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.seq = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        [self initParamInt:[paramBigInteger bitLength] paramBigInteger:paramBigInteger];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        NSMutableData *arrayOfByte = [BigIntegers asUnsignedByteArray:(paramInt + 7) / 8 withN:paramBigInteger];
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        ASN1Encodable *integerEncodable = [[ASN1Integer alloc] initLong:1];
        ASN1Encodable *octetStringEncodable = [[DEROctetString alloc] initDEROctetString:arrayOfByte];
        [localASN1EncodableVector add:integerEncodable];
        [localASN1EncodableVector add:octetStringEncodable];
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.seq = sequence;
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (integerEncodable) [integerEncodable release]; integerEncodable = nil;
    if (octetStringEncodable) [octetStringEncodable release]; octetStringEncodable = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        [self initParamBigInteger:paramBigInteger paramDERBitString:nil paramASN1Encodable:paramASN1Encodable];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger paramDERBitString:(DERBitString *)paramDERBitString paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        [self initParamInt:[paramBigInteger bitLength] paramBigInteger:paramBigInteger paramDERBitString:paramDERBitString paramASN1Encodable:paramASN1Encodable];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramBigInteger:(BigInteger *)paramBigInteger paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        [self initParamInt:paramInt paramBigInteger:paramBigInteger paramDERBitString:nil paramASN1Encodable:paramASN1Encodable];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramBigInteger:(BigInteger *)paramBigInteger paramDERBitString:(DERBitString *)paramDERBitString paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        NSMutableData *arrayOfByte = [BigIntegers asUnsignedByteArray:(paramInt + 7) / 8 withN:paramBigInteger];
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        ASN1Encodable *integerEncodable = [[ASN1Integer alloc] initLong:1];
        ASN1Encodable *octetStringEncodable = [[DEROctetString alloc] initDEROctetString:arrayOfByte];
        [localASN1EncodableVector add:integerEncodable];
        [localASN1EncodableVector add:octetStringEncodable];
        if (paramASN1Encodable) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:paramASN1Encodable];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        if (paramDERBitString) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:paramDERBitString];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.seq = sequence;
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (integerEncodable) [integerEncodable release]; integerEncodable = nil;
    if (octetStringEncodable) [octetStringEncodable release]; octetStringEncodable = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BigInteger *)getKey {
    ASN1OctetString *localASN1OctetString = (ASN1OctetString *)[self.seq getObjectAt:1];
    return [[[BigInteger alloc] initWithSign:1 withBytes:[localASN1OctetString getOctets]] autorelease];
}

- (DERBitString *)getPublicKey {
    return (DERBitString *)[self getObjectInTag:1];
}

- (ASN1Primitive *)getParameters {
    return [self getObjectInTag:0];
}

- (ASN1Primitive *)getObjectInTag:(int)paramInt {
    NSEnumerator *localEnumeration = [self.seq getObjects];
    ASN1Encodable *localASN1Encodable = nil;
    while (localASN1Encodable = [localEnumeration nextObject]) {
        if ([localASN1Encodable isKindOfClass:[ASN1TaggedObject class]]) {
            ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)localASN1Encodable;
            if ([localASN1TaggedObject getTagNo] == paramInt) {
                return [[localASN1TaggedObject getObject] toASN1Primitive];
            }
        }
    }
    return nil;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.seq;
}

@end
