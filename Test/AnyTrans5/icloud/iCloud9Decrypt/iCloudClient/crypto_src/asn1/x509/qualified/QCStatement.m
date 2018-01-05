//
//  QCStatement.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "QCStatement.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@implementation QCStatement
@synthesize qcStatementId = _qcStatementId;
@synthesize qcStatementInfo = _qcStatementInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_qcStatementId) {
        [_qcStatementId release];
        _qcStatementId = nil;
    }
    if (_qcStatementInfo) {
        [_qcStatementInfo release];
        _qcStatementInfo = nil;
    }
    [super dealloc];
#endif
}

+ (QCStatement *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[QCStatement class]]) {
        return (QCStatement *)paramObject;
    }
    if (paramObject) {
        return [[[QCStatement alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.qcStatementId = [ASN1ObjectIdentifier getInstance:[localEnumeration nextObject]];
        ASN1Encodable *encodable = nil;
        if (encodable = [localEnumeration nextObject]) {
            self.qcStatementInfo = encodable;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier
{
    if (self = [super init]) {
        self.qcStatementId = paramASN1ObjectIdentifier;
        self.qcStatementInfo = nil;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        self.qcStatementId = paramASN1ObjectIdentifier;
        self.qcStatementInfo = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getStatementId {
    return self.qcStatementId;
}

- (ASN1Encodable *)getStatementInfo {
    return self.qcStatementInfo;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.qcStatementId];
    if (self.qcStatementInfo) {
        [localASN1EncodableVector add:self.qcStatementInfo];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
