//
//  PKIMessages.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "PKIHeader.h"
#import "PKIBody.h"
#import "DERBitString.h"
#import "ASN1Sequence.h"

@interface PKIMessage : ASN1Object {
@private
    PKIHeader *_header;
    PKIBody *_body;
    DERBitString *_protection;
    ASN1Sequence *_extraCerts;
}

+ (PKIMessage *)getInstance:(id)paramObject;
- (instancetype)initParamPKIHeader:(PKIHeader *)paramPKIHeader paramPKIBody:(PKIBody *)paramPKIBody paramDERBitString:(DERBitString *)paramDERBitString paramArrayOfCMPCertificate:(NSMutableArray *)paramArrayOfCMPCertificate;
- (instancetype)initParamPKIHeader:(PKIHeader *)paramPKIHeader paramPKIBody:(PKIBody *)paramPKIBody paramDERBitString:(DERBitString *)paramDERBitString;
- (instancetype)initParamPKIHeader:(PKIHeader *)paramPKIHeader paramPKIBody:(PKIBody *)paramPKIBody;
- (PKIHeader *)getHeader;
- (PKIBody *)getBody;
- (DERBitString *)getProtection;
- (NSMutableArray *)getExtraCerts;
- (ASN1Primitive *)toASN1Primitive;

@end
