//
//  MacData.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "MacData.h"
#import "ASN1Sequence.h"
#import "ASN1OctetString.h"
#import "ASN1Integer.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@implementation MacData
@synthesize digInfo = _digInfo;
@synthesize salt = _salt;
@synthesize iterationCount = _iterationCount;

+ (BigInteger *)ONE {
    static BigInteger *_ONE = nil;
    @synchronized(self) {
        if (!_ONE) {
            _ONE = [BigInteger One];
        }
    }
    return _ONE;
}

+ (MacData *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[MacData class]]) {
        return (MacData *)paramObject;
    }
    if (paramObject) {
        return [[[MacData alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.digInfo = [DigestInfo getInstance:[paramASN1Sequence getObjectAt:0]];
        self.salt = [(ASN1OctetString *)[paramASN1Sequence getObjectAt:1] getOctets];
        if ([paramASN1Sequence size] == 3) {
            self.iterationCount = [(ASN1Integer *)[paramASN1Sequence getObjectAt:2] getValue];
        }else {
            self.iterationCount = [MacData ONE];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDigestInfo:(DigestInfo *)paramDigestInfo paramArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt
{
    if (self = [super init]) {
        self.digInfo = paramDigestInfo;
        self.salt = paramArrayOfByte;
        self.iterationCount = [BigInteger valueOf:paramInt];
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
    [self setDigInfo:nil];
    [self setSalt:nil];
    [self setIterationCount:nil];
    [super dealloc];
}

- (DigestInfo *)getMac {
    return self.digInfo;
}

- (NSMutableData *)getSalt {
    return self.salt;
}

- (BigInteger *)getIterationCount {
    return self.iterationCount;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.digInfo];
    ASN1Encodable *encodable = [[DEROctetString alloc] initDEROctetString:self.salt];
    [localASN1EncodableVector add:encodable];
    if (![self.iterationCount isEqual:[MacData ONE]]) {
        ASN1Encodable *encodable = [[ASN1Integer alloc] initBI:self.iterationCount];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

@end
