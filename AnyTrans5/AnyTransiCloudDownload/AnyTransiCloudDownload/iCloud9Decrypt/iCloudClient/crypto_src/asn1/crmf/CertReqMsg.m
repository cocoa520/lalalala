//
//  CertReqMsg.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertReqMsg.h"
#import "DERSequence.h"
#import "AttributeTypeAndValueCRMF.h"
#import "CategoryExtend.h"

@interface CertReqMsg ()

@property (nonatomic, readwrite, retain) CertRequest *certReq;
@property (nonatomic, readwrite, retain) ProofOfPossession *pop;
@property (nonatomic, readwrite, retain) ASN1Sequence *regInfo;

@end

@implementation CertReqMsg
@synthesize certReq = _certReq;
@synthesize pop = _pop;
@synthesize regInfo = _regInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certReq) {
        [_certReq release];
        _certReq = nil;
    }
    if (_pop) {
        [_pop release];
        _pop = nil;
    }
    if (_regInfo) {
        [_regInfo release];
        _regInfo = nil;
    }
    [super dealloc];
#endif
}

+ (CertReqMsg *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertReqMsg class]]) {
        return (CertReqMsg *)paramObject;
    }
    if (paramObject) {
        return [[[CertReqMsg alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.certReq = [CertRequest getInstance:[localEnumeration nextObject]];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            if ([localObject isKindOfClass:[ASN1TaggedObject class]] || [localObject isKindOfClass:[ProofOfPossession class]]) {
                self.pop = [ProofOfPossession getInstance:localObject];
            }else {
                self.regInfo = [ASN1Sequence getInstance:localObject];
            }
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCertRequest:(CertRequest *)paramCertRequest paramProofOfPossession:(ProofOfPossession *)paramProofOfPossession paramArrayOfAttributeTypeAndValue:(NSMutableArray *)paramArrayOfAttributeTypeAndValue
{
    if (self = [super init]) {
        if (!paramCertRequest) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"'certReq' cannot be null" userInfo:nil];
        }
        self.certReq = paramCertRequest;
        self.pop = paramProofOfPossession;
        if (paramArrayOfAttributeTypeAndValue) {
            ASN1Sequence *sequence = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:paramArrayOfAttributeTypeAndValue];
            self.regInfo = sequence;
#if !__has_feature(objc_arc)
            if (sequence) [sequence release]; sequence = nil;
#endif
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (CertRequest *)getCertReq {
    return self.certReq;
}

- (ProofOfPossession *)getPop {
    return self.pop;
}

- (ProofOfPossession *)getPopo {
    return self.pop;
}

- (NSMutableArray *)getReqInfo {
    if (!self.regInfo) {
        return nil;
    }
    NSMutableArray *arrayOfAttributeTypeAndValue = [[[NSMutableArray alloc] initWithSize:[self.regInfo size]] autorelease];
    for (int i = 0; i != arrayOfAttributeTypeAndValue.count; i++) {
        arrayOfAttributeTypeAndValue[i] = [AttributeTypeAndValueCRMF getInstance:[self.regInfo getObjectAt:i]];
    }
    return arrayOfAttributeTypeAndValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certReq];
    [self addOptional:localASN1EncodableVector paramASN1Encodable:self.pop];
    [self addOptional:localASN1EncodableVector paramASN1Encodable:self.regInfo];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (void)addOptional:(ASN1EncodableVector *)paramASN1EncodableVector paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    if (paramASN1Encodable) {
        [paramASN1EncodableVector add:paramASN1Encodable];
    }
}

@end
