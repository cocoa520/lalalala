//
//  DVCSCertInfo.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "DVCSRequestInformation.h"
#import "DigestInfo.h"
#import "ASN1Integer.h"
#import "DVCSTime.h"
#import "PKIStatusInfo.h"
#import "PolicyInformation.h"
#import "ASN1Set.h"
#import "ASN1Sequence.h"
#import "Extensions.h"

@interface DVCSCertInfo : ASN1Object {
@private
    int _version;
    DVCSRequestInformation *_dvReqInfo;
    DigestInfo *_messageImprint;
    ASN1Integer *_serialNumber;
    DVCSTime *_responseTime;
    PKIStatusInfo *_dvStatus;
    PolicyInformation *_policy;
    ASN1Set *_reqSignature;
    ASN1Sequence *_certs;
    Extensions *_extensions;
}

+ (DVCSCertInfo *)getInstance:(id)paramObject;
+ (DVCSCertInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamDVCSRequestInformation:(DVCSRequestInformation *)paramDVCSRequestInformation paramDigestInfo:(DigestInfo *)paramDigestInfo paramASN1Integer:(ASN1Integer *)paramASN1Integer paramDVCSTime:(DVCSTime *)paramDVCSTime;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;
- (int)getVersion;
- (DVCSRequestInformation *)getDvReqInfo;
- (DigestInfo *)getMessageImprint;
- (ASN1Integer *)getSerialNumber;
- (DVCSTime *)getResponseTime;
- (PKIStatusInfo *)getDvStatus;
- (PolicyInformation *)getPolicy;
- (ASN1Set *)getReqSignature;
- (NSMutableArray *)getCerts;
- (Extensions *)getExtension;

@end
