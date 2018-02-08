//
//  DVCSCertInfoBuilder.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVCSRequestInformation.h"
#import "DigestInfo.h"
#import "ASN1Integer.h"
#import "DVCSTime.h"
#import "PKIStatusInfo.h"
#import "PolicyInformation.h"
#import "ASN1Set.h"
#import "ASN1Sequence.h"
#import "Extensions.h"
#import "DVCSCertInfo.h"

@interface DVCSCertInfoBuilder : NSObject {
@private
    int _version;
    DVCSRequestInformation *_dvReqInfo;
    DigestInfo *_messageImprint;
    ASN1Integer *_serialNumber;
    DVCSTime *_responsetTime;
    PKIStatusInfo *_dvStatus;
    PolicyInformation *_policy;
    ASN1Set *_reqSignature;
    ASN1Sequence *_certs;
    Extensions *_extensions;
}

- (instancetype)initParamDVCSRequestInformation:(DVCSRequestInformation *)paramDVCSRequestInformation paramDigestInfo:(DigestInfo *)paramDigestInfo paramASN1Integer:(ASN1Integer *)paramASN1Integer paramDVCSTime:(DVCSTime *)paramDVCSTime;
- (DVCSCertInfo *)build;
- (void)setVersion:(int)version;
- (void)setDvReqInfo:(DVCSRequestInformation *)dvReqInfo;
- (void)setMessageImprint:(DigestInfo *)messageImprint;
- (void)setSerialNumber:(ASN1Integer *)serialNumber;
- (void)setResponsetTime:(DVCSTime *)responsetTime;
- (void)setDvStatus:(PKIStatusInfo *)dvStatus;
- (void)setPolicy:(PolicyInformation *)policy;
- (void)setReqSignature:(ASN1Set *)reqSignature;
- (void)setIsCerts:(NSMutableArray *)certs;
- (void)setExtensions:(Extensions *)extensions;

@end
