//
//  DVCSCertInfo.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DVCSCertInfo.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"
#import "TargetEtcChain.h"

@interface DVCSCertInfo ()

@property (nonatomic, assign) int version;
@property (nonatomic, readwrite, retain) DVCSRequestInformation *dvReqInfo;
@property (nonatomic, readwrite, retain) DigestInfo *messageImprint;
@property (nonatomic, readwrite, retain) ASN1Integer *serialNumber;
@property (nonatomic, readwrite, retain) DVCSTime *responseTime;
@property (nonatomic, readwrite, retain) PKIStatusInfo *dvStatus;
@property (nonatomic, readwrite, retain) PolicyInformation *policy;
@property (nonatomic, readwrite, retain) ASN1Set *reqSignature;
@property (nonatomic, readwrite, retain) ASN1Sequence *certs;
@property (nonatomic, readwrite, retain) Extensions *extensions;

@end

@implementation DVCSCertInfo
@synthesize version = _version;
@synthesize dvReqInfo = _dvReqInfo;
@synthesize messageImprint = _messageImprint;
@synthesize serialNumber = _serialNumber;
@synthesize responseTime = _responseTime;
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
    if (_responseTime) {
        [_responseTime release];
        _responseTime = nil;
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

- (void)setVersion:(int)version {
    if (_version != version) {
        _version = 1;
    }
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

+ (DVCSCertInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DVCSCertInfo class]]) {
        return (DVCSCertInfo *)paramObject;
    }
    if (paramObject) {
        return [[[DVCSCertInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (DVCSCertInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DVCSCertInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamDVCSRequestInformation:(DVCSRequestInformation *)paramDVCSRequestInformation paramDigestInfo:(DigestInfo *)paramDigestInfo paramASN1Integer:(ASN1Integer *)paramASN1Integer paramDVCSTime:(DVCSTime *)paramDVCSTime
{
    if (self = [super init]) {
        self.dvReqInfo = paramDVCSRequestInformation;
        self.messageImprint = paramDigestInfo;
        self.serialNumber = paramASN1Integer;
        self.responseTime = paramDVCSTime;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        ASN1Encodable *localASN1Encodable = [paramASN1Sequence getObjectAt:i++];
        id localObject;
        if ([localASN1Encodable isKindOfClass:[ASN1Integer class]]) {
            localObject = [ASN1Integer getInstance:localObject];
            self.version = [[((ASN1Integer *)localObject) getValue] intValue];
            localASN1Encodable = [paramASN1Sequence getObjectAt:i++];
        }
        self.dvReqInfo = [DVCSRequestInformation getInstance:localASN1Encodable];
        localASN1Encodable = [paramASN1Sequence getObjectAt:i++];
        self.messageImprint = [DigestInfo getInstance:localASN1Encodable];
        localASN1Encodable = [paramASN1Sequence getObjectAt:i++];
        self.serialNumber = [ASN1Integer getInstance:localASN1Encodable];
        localASN1Encodable = [paramASN1Sequence getObjectAt:i++];
        self.responseTime = [DVCSTime getInstance:localASN1Encodable];
        while (i < [paramASN1Sequence size]) {
            localASN1Encodable = [paramASN1Sequence getObjectAt:i++];
            @try {
                localObject = [ASN1TaggedObject getInstance:localASN1Encodable];
                int j = [((ASN1TaggedObject *)localObject) getTagNo];
                switch (j) {
                    case 0:
                        self.dvStatus = [PKIStatusInfo getInstance:(ASN1TaggedObject *)localObject paramBoolean:false];
                        break;
                    case 1:
                        self.policy = [PolicyInformation getInstance:[ASN1Sequence getInstance:(ASN1TaggedObject *)localObject paramBoolean:false]];
                        break;
                    case 2:
                        self.reqSignature = [ASN1Set getInstance:(ASN1TaggedObject *)localObject paramBoolean:false];
                        break;
                    case 3:
                        self.certs = [ASN1Sequence getInstance:(ASN1TaggedObject *)localObject paramBoolean:false];
                        break;
                    default:
                        break;
                }
            }
            @catch (NSException *exception) {
                @try {
                    self.extensions = [Extensions getInstance:localASN1Encodable];
                }
                @catch (NSException *exception) {
                }
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

- (ASN1Primitive *)toASN1Primitive {
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
    [localASN1EncodableVector add:self.responseTime];
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
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    NSMutableString *localStringBuffer = [[NSMutableString alloc] init];
    [localStringBuffer appendString:@"DVCSCertInfo {\n"];
    if (self.version != 1) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"version: %d\n", self.version]];
    }
    [localStringBuffer appendString:[NSString stringWithFormat:@"dvReqInfo: %@\n", self.dvReqInfo]];
    [localStringBuffer appendString:[NSString stringWithFormat:@"messageImprint: %@\n", self.messageImprint]];
    [localStringBuffer appendString:[NSString stringWithFormat:@"serialNumber %@\n", self.serialNumber]];
    [localStringBuffer appendString:[NSString stringWithFormat:@"responseTime %@\n", self.responseTime]];
    if (self.dvStatus) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"dvStatus: %@\n", self.dvStatus]];
    }
    if (self.policy) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"policy: %@\n", self.policy]];
    }
    if (self.reqSignature) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"reqSignature: %@\n", self.reqSignature]];
    }
    if (self.certs) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"certs: %@\n", self.certs]];
    }
    if (self.extensions) {
        [localStringBuffer appendString:[NSString stringWithFormat:@"extensions: %@\n", self.extensions]];
    }
    [localStringBuffer appendString:@"}\n"];
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

- (int)getVersion {
    return self.version;
}

- (DVCSRequestInformation *)getDvReqInfo {
    return self.dvReqInfo;
}

- (void)setDvReqInfo:(DVCSRequestInformation *)dvReqInfo {
    self.dvReqInfo = dvReqInfo;
}

- (DigestInfo *)getMessageImprint {
    return self.messageImprint;
}

- (void)setMessageImprint:(DigestInfo *)messageImprint {
    self.messageImprint = messageImprint;
}

- (ASN1Integer *)getSerialNumber {
    return self.serialNumber;
}

- (DVCSTime *)getResponseTime {
    return self.responseTime;
}

- (PKIStatusInfo *)getDvStatus {
    return self.dvStatus;
}

- (PolicyInformation *)getPolicy {
    return self.policy;
}

- (ASN1Set *)getReqSignature {
    return self.reqSignature;
}

- (NSMutableArray *)getCerts {
    if (self.certs) {
        return [TargetEtcChain arrayFromSequence:self.certs];
    }
    return nil;
}

- (Extensions *)getExtension {
    return self.extensions;
}

@end
