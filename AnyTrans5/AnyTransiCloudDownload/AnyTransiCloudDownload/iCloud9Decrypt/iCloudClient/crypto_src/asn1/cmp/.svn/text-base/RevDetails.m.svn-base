//
//  RevDetails.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RevDetails.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface RevDetails ()

@property (nonatomic, readwrite, retain) CertTemplate *certDetails;
@property (nonatomic, readwrite, retain) Extensions *crlEntryDetails;

@end

@implementation RevDetails
@synthesize certDetails = _certDetails;
@synthesize crlEntryDetails = _crlEntryDetails;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certDetails) {
        [_certDetails release];
        _certDetails = nil;
    }
    if (_crlEntryDetails) {
        [_crlEntryDetails release];
        _crlEntryDetails = nil;
    }
    [super dealloc];
#endif
}

+ (RevDetails *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RevDetails class]]) {
        return (RevDetails *)paramObject;
    }
    if (paramObject) {
        return [[[RevDetails alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.certDetails = [CertTemplate getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] > 1) {
            self.crlEntryDetails = [Extensions getInstance:[paramASN1Sequence getObjectAt:1]];
        }
    }
    return self;
}

- (instancetype)initParamCertTemplate:(CertTemplate *)paramCertTemplate
{
    self = [super init];
    if (self) {
        self.certDetails = paramCertTemplate;
    }
    return self;
}

- (instancetype)initParamCertTemplate:(CertTemplate *)paramCertTemplate paramX509Extensions:(X509Extensions *)paramX509Extensions
{
    self = [super init];
    if (self) {
        self.certDetails = paramCertTemplate;
        self.crlEntryDetails = [Extensions getInstance:[paramX509Extensions toASN1Primitive]];
    }
    return self;
}

- (instancetype)initParamCertTemplate:(CertTemplate *)paramCertTemplate paramExtensions:(Extensions *)paramExtensions
{
    self = [super init];
    if (self) {
        self.certDetails = paramCertTemplate;
        self.crlEntryDetails = paramExtensions;
    }
    return self;
}

- (CertTemplate *)getCertDetails {
    return self.certDetails;
}

- (Extensions *)getCrlEntryDetails {
    return self.crlEntryDetails;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certDetails];
    if (self.crlEntryDetails) {
        [localASN1EncodableVector add:self.crlEntryDetails];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
