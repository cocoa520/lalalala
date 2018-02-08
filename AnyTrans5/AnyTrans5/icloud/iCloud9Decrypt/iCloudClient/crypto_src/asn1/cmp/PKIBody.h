//
//  PKIBody.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1Encodable.h"

@interface PKIBody : ASN1Choice {
@private
    int _tagNo;
    ASN1Encodable *_body;
}

+ (int)TYPE_INIT_REQ;
+ (int)TYPE_INIT_REP;
+ (int)TYPE_CERT_REQ;
+ (int)TYPE_CERT_REP;
+ (int)TYPE_P10_CERT_REQ;
+ (int)TYPE_POPO_CHALL;
+ (int)TYPE_POPO_REP;
+ (int)TYPE_KEY_UPDATE_REQ;
+ (int)TYPE_KEY_UPDATE_REP;
+ (int)TYPE_KEY_RECOVERY_REQ;
+ (int)TYPE_KEY_RECOVERY_REP;
+ (int)TYPE_REVOCATION_REQ;
+ (int)TYPE_REVOCATION_REP;
+ (int)TYPE_CROSS_CERT_REQ;
+ (int)TYPE_CROSS_CERT_REP;
+ (int)TYPE_CA_KEY_UPDATE_ANN;
+ (int)TYPE_CERT_ANN;
+ (int)TYPE_REVOCATION_ANN;
+ (int)TYPE_CRL_ANN;
+ (int)TYPE_CONFIRM;
+ (int)TYPE_NESTED;
+ (int)TYPE_GEN_MSG;
+ (int)TYPE_GEN_REP;
+ (int)TYPE_ERROR;
+ (int)TYPE_CERT_CONFIRM;
+ (int)TYPE_POLL_REQ;
+ (int)TYPE_POLL_REP;
+ (PKIBody *)getInstance:(id)paramObject;
- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (int)getType;
- (ASN1Encodable *)getContent;
- (ASN1Primitive *)toASN1Primitive;

@end
