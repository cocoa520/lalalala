//
//  CertStatusCMP.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"
#import "ASN1Integer.h"
#import "PKIStatusInfo.h"

@interface CertStatusCMP : ASN1Object {
@private
    ASN1OctetString *_certHash;
    ASN1Integer *_certReqId;
    PKIStatusInfo *_statusInfo;
}

+ (CertStatusCMP *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramBigInteger:(BigInteger *)paramBigInteger paramPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo;
- (ASN1OctetString *)getCertHash;
- (ASN1Integer *)getCertReqId;
- (PKIStatusInfo *)getStatusInfo;
- (ASN1Primitive *)toASN1Primitive;

@end
