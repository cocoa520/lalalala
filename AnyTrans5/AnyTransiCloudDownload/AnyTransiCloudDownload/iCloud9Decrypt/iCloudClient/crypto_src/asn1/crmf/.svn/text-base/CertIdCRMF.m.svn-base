//
//  CertIdCRMF.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertIdCRMF.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface CertIdCRMF ()

@property (nonatomic, readwrite, retain) GeneralName *issuer;
@property (nonatomic, readwrite, retain) ASN1Integer *serialNumber;

@end

@implementation CertIdCRMF
@synthesize issuer = _issuer;
@synthesize serialNumber = _serialNumber;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_issuer) {
        [_issuer release];
        _issuer = nil;
    }
    if (_serialNumber) {
        [_serialNumber release];
        _serialNumber = nil;
    }
    [super dealloc];
#endif
}

+ (CertIdCRMF *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertIdCRMF class]]) {
        return (CertIdCRMF *)paramObject;
    }
    if (paramObject) {
        return [[[CertIdCRMF alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (CertIdCRMF *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [CertIdCRMF getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.issuer = [GeneralName getInstance:[paramASN1Sequence getObjectAt:0]];
        self.serialNumber = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        ASN1Integer *integer = [[ASN1Integer alloc] initBI:paramBigInteger];
        [self initParamGeneralName:paramGeneralName paramASN1Integer:integer];
#if !__has_feature(objc_arc)
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

- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramASN1Integer:(ASN1Integer *)paramASN1Integer
{
    if (self = [super init]) {
        self.issuer = paramGeneralName;
        self.serialNumber = paramASN1Integer;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (GeneralName *)getIssuer {
    return self.issuer;
}

- (ASN1Integer *)getSerialNumber {
    return self.serialNumber;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.issuer];
    [localASN1EncodableVector add:self.serialNumber];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
