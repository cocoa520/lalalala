//
//  DVCSCertInfoBuilder.m
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DVCSCertInfoBuilder.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface DVCSCertInfoBuilder ()

@property (nonatomic, assign) int version;
@property (nonatomic, readwrite, retain) DVCSRequestInformation *dvReqInfo;
@property (nonatomic, readwrite, retain) DigestInfo *messageImprint;
@property (nonatomic, readwrite, retain) ASN1Integer *serialNumber;
@property (nonatomic, readwrite, retain) DVCSTime *responsetTime;
@property (nonatomic, readwrite, retain) PKIStatusInfo *dvStatus;
@property (nonatomic, readwrite, retain) PolicyInformation *policy;
@property (nonatomic, readwrite, retain) ASN1Set *reqSignature;
@property (nonatomic, readwrite, retain) ASN1Sequence *certs;
@property (nonatomic, readwrite, retain) Extensions *extensions;

@end

@implementation DVCSCertInfoBuilder
@synthesize version = _version;
@synthesize dvReqInfo = _dvReqInfo;
@synthesize messageImprint = _messageImprint;
@synthesize serialNumber = _serialNumber;
@synthesize responsetTime = _responsetTime;
@synthesize dvStatus = _dvStatus;
@synthesize policy = _policy;
@synthesize reqSignature = _reqSignature;
@synthesize certs = _certs;
@synthesize extensions = _extensions;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_dvReqInfo) {
        [_dvReqInfo release];
        _dvReqInfo = nil;
    }
    if (_messageImprint) {
        [_messageImprint release];
        _messageImprint = nil;
    }
    if (_serialNumber) {
        [_serialNumber release];
        _serialNumber = nil;
    }
    if (_responsetTime) {
        [_responsetTime release];
        _responsetTime = nil;
    }
    if (_dvStatus) {
        [_dvStatus release];
        _dvStatus = nil;
    }
    if (_policy) {
        [_policy release];
        _policy = nil;
    }
    if (_reqSignature) {
        [_reqSignature release];
        _reqSignature = nil;
    }
    if (_certs) {
        [_certs release];
        _certs = nil;
    }
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
    [super dealloc];
#endif
}

+ (int)DEFAULT_VERSION {
    static int _DEFAULT_VERSION = 0;
    @synchronized(self) {
        if (!_DEFAULT_VERSION) {
            _DEFAULT_VERSION = 1;
        }
    }
    return _DEFAULT_VERSION;
}

+ (int)TAG_DV_STATUS {
    static int _TAG_DV_STATUS = 0;
    @synchronized(self) {
        if (!_TAG_DV_STATUS) {
            _TAG_DV_STATUS = 0;
        }
    }
    return _TAG_DV_STATUS;
}

+ (int)TAG_POLICY {
    static int _TAG_POLICY = 0;
    @synchronized(self) {
        if (!_TAG_POLICY) {
            _TAG_POLICY = 1;
        }
    }
    return _TAG_POLICY;
}

+ (int)TAG_REQ_SIGNATURE {
    static int _TAG_REQ_SIGNATURE = 0;
    @synchronized(self) {
        if (!_TAG_REQ_SIGNATURE) {
            _TAG_REQ_SIGNATURE = 2;
        }
    }
    return _TAG_REQ_SIGNATURE;
}

+ (int)TAG_CERTS {
    static int _TAG_CERTS = 0;
    @synchronized(self) {
        if (!_TAG_CERTS) {
            _TAG_CERTS = 3;
        }
    }
    return _TAG_CERTS;
}

- (instancetype)initParamDVCSRequestInformation:(DVCSRequestInformation *)paramDVCSRequestInformation paramDigestInfo:(DigestInfo *)paramDigestInfo paramASN1Integer:(ASN1Integer *)paramASN1Integer paramDVCSTime:(DVCSTime *)paramDVCSTime
{
    self = [super init];
    if (self) {
        self.dvReqInfo = paramDVCSRequestInformation;
        self.messageImprint = paramDigestInfo;
        self.serialNumber = paramASN1Integer;
        self.responsetTime = paramDVCSTime;
    }
    return self;
}

- (DVCSCertInfo *)build {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.version != 1) {
        ASN1Encodable *versionEncodable = [[ASN1Integer alloc] initLong:self.version];
        [localASN1EncodableVector add:versionEncodable];
#if !__has_feature(objc_arc)
    if (versionEncodable) [versionEncodable release]; versionEncodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.dvReqInfo];
    [localASN1EncodableVector add:self.messageImprint];
    [localASN1EncodableVector add:self.serialNumber];
    [localASN1EncodableVector add:self.responsetTime];
    if (self.dvStatus) {
        ASN1Encodable *dvStatusEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:self.dvStatus];
        [localASN1EncodableVector add:dvStatusEncodable];
#if !__has_feature(objc_arc)
    if (dvStatusEncodable) [dvStatusEncodable release]; dvStatusEncodable = nil;
#endif
    }
    if (self.policy) {
        ASN1Encodable *policyEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:1 paramASN1Encodable:self.policy];
        [localASN1EncodableVector add:policyEncodable];
#if !__has_feature(objc_arc)
    if (policyEncodable) [policyEncodable release]; policyEncodable = nil;
#endif
    }
    if (self.reqSignature) {
        ASN1Encodable *reqSignatureEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:2 paramASN1Encodable:self.reqSignature];
        [localASN1EncodableVector add:reqSignatureEncodable];
#if !__has_feature(objc_arc)
    if (reqSignatureEncodable) [reqSignatureEncodable release]; reqSignatureEncodable = nil;
#endif
    }
    if (self.certs) {
        ASN1Encodable *certsEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:3 paramASN1Encodable:self.certs];
        [localASN1EncodableVector add:certsEncodable];
#if !__has_feature(objc_arc)
        if (certsEncodable) [certsEncodable release]; certsEncodable = nil;
#endif
    }
    if (self.extensions) {
        [localASN1EncodableVector add:self.extensions];
    }
    DERSequence *derSequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
    DVCSCertInfo *certInfo = [DVCSCertInfo getInstance:derSequence];
#if !__has_feature(objc_arc)
    if (derSequence) [derSequence release]; derSequence = nil;
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return certInfo;
}

- (void)setVersion:(int)version {
    self.version = version;
}

- (void)setDvReqInfo:(DVCSRequestInformation *)dvReqInfo {
    self.dvReqInfo = dvReqInfo;
}

- (void)setMessageImprint:(DigestInfo *)messageImprint {
    self.messageImprint = messageImprint;
}

- (void)setSerialNumber:(ASN1Integer *)serialNumber {
    self.serialNumber = serialNumber;
}

- (void)setResponsetTime:(DVCSTime *)responsetTime {
    self.responsetTime = responsetTime;
}

- (void)setDvStatus:(PKIStatusInfo *)dvStatus {
    self.dvStatus = dvStatus;
}

- (void)setPolicy:(PolicyInformation *)policy {
    self.policy = policy;
}

- (void)setReqSignature:(ASN1Set *)reqSignature {
    self.reqSignature = reqSignature;
}

- (void)setIsCerts:(NSMutableArray *)certs {
    ASN1Sequence *sequence = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:certs];
    self.certs = sequence;
#if !__has_feature(objc_arc)
    if (sequence) [sequence release]; sequence = nil;
#endif
}

- (void)setExtensions:(Extensions *)extensions {
    self.extensions = extensions;
}

@end
