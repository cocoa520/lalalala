//
//  RevAnnContent.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RevAnnContent.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface RevAnnContent ()

@property (nonatomic, readwrite, retain) PKIStatus *status;
@property (nonatomic, readwrite, retain) CertIdCRMF *certId;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *willBeRevokedAt;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *badSinceDate;
@property (nonatomic, readwrite, retain) Extensions *crlDetails;

@end

@implementation RevAnnContent
@synthesize status = _status;
@synthesize certId = _certId;
@synthesize willBeRevokedAt = _willBeRevokedAt;
@synthesize badSinceDate = _badSinceDate;
@synthesize crlDetails = _crlDetails;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_status) {
        [_status release];
        _status = nil;
    }
    if (_certId) {
        [_certId release];
        _certId = nil;
    }
    if (_willBeRevokedAt) {
        [_willBeRevokedAt release];
        _willBeRevokedAt = nil;
    }
    if (_badSinceDate) {
        [_badSinceDate release];
        _badSinceDate = nil;
    }
    if (_crlDetails) {
        [_crlDetails release];
        _crlDetails = nil;
    }
    [super dealloc];
#endif
}

+ (RevAnnContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RevAnnContent class]]) {
        return (RevAnnContent *)paramObject;
    }
    if (paramObject) {
        return [[[RevAnnContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.status = [PKIStatus getInstance:[paramASN1Sequence getObjectAt:0]];
        self.certId = [CertIdCRMF getInstance:[paramASN1Sequence getObjectAt:1]];
        self.willBeRevokedAt = [ASN1GeneralizedTime getInstance:[paramASN1Sequence getObjectAt:2]];
        self.badSinceDate = [ASN1GeneralizedTime getInstance:[paramASN1Sequence getObjectAt:3]];
        if ([paramASN1Sequence size] > 4) {
            self.crlDetails = [Extensions getInstance:[paramASN1Sequence getObjectAt:4]];
        }
    }
    return self;
}

- (PKIStatus *)getStatus {
    return self.status;
}

- (CertIdCRMF *)getCertId {
    return self.certId;
}

- (ASN1GeneralizedTime *)getWillBeRevodedAt {
    return self.willBeRevokedAt;
}

- (ASN1GeneralizedTime *)getBadSinceDate {
    return self.badSinceDate;
}

- (Extensions *)getCrlDetails {
    return self.crlDetails;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.status];
    [localASN1EncodableVector add:self.certId];
    [localASN1EncodableVector add:self.willBeRevokedAt];
    [localASN1EncodableVector add:self.badSinceDate];
    if (self.crlDetails) {
        [localASN1EncodableVector add:self.crlDetails];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
