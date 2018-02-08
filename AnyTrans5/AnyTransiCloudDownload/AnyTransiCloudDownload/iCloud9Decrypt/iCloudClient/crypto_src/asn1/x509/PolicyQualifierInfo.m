//
//  PolicyQualifierInfo.m
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PolicyQualifierInfo.h"
#import "DERSequence.h"
#import "PolicyQualifierId.h"
#import "DERIA5String.h"

@interface PolicyQualifierInfo ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *policyQualifierId;
@property (nonatomic, readwrite, retain) ASN1Encodable *qualifier;

@end

@implementation PolicyQualifierInfo
@synthesize policyQualifierId = _policyQualifierId;
@synthesize qualifier = _qualifier;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_policyQualifierId) {
        [_policyQualifierId release];
        _policyQualifierId = nil;
    }
    if (_qualifier) {
        [_qualifier release];
        _qualifier = nil;
    }
    [super dealloc];
#endif
}

+ (PolicyQualifierInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PolicyQualifierInfo class]]) {
        return (PolicyQualifierInfo *)paramObject;
    }
    if (paramObject) {
        return [[[PolicyQualifierInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.policyQualifierId = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.qualifier = [paramASN1Sequence getObjectAt:1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        self.policyQualifierId = [PolicyQualifierId id_qt_cps];
        ASN1Encodable *encodable = [[DERIA5String alloc] initParamString:paramString];
        self.qualifier = encodable;
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
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
        self.policyQualifierId = paramASN1ObjectIdentifier;
        self.qualifier = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getPolicyQualifierId {
    return self.policyQualifierId;
}

- (ASN1Encodable *)getQualifier {
    return self.qualifier;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.policyQualifierId];
    [localASN1EncodableVector add:self.qualifier];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
