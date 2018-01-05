//
//  CertRepMessage.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"

@interface CertRepMessage : ASN1Object {
@private
    ASN1Sequence *_caPubs;
    ASN1Sequence *_response;
}

+ (CertRepMessage *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfCMPCertificate:(NSMutableArray *)paramArrayOfCMPCertificate paramArrayOfCertResponse:(NSMutableArray *)paramArrayOfCertResponse;
- (NSMutableArray *)getCaPubs;
- (NSMutableArray *)getResponse;
- (ASN1Primitive *)toASN1Primitive;

@end
