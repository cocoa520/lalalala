//
//  CertReqMessages.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "CertReqMsg.h"

@interface CertReqMessages : ASN1Object {
@private
    ASN1Sequence *_content;
}

+ (CertReqMessages *)getInstance:(id)paramObject;
- (instancetype)initParamCertReqMsg:(CertReqMsg *)paramCertReqMsg;
- (instancetype)initParamArrayOfCertReqMsg:(NSMutableArray *)paramArrayOfCertReqMsg;
- (NSMutableArray *)toCertReqMsgArray;
- (ASN1Primitive *)toASN1Primitive;

@end
