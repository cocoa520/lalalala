//
//  V2AttributeCertificateInfoGenerator.h
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1Integer.h"
#import "Holder.h"
#import "AttCertIssuer.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "Extensions.h"
#import "ASN1GeneralizedTime.h"
#import "AttributeCertificateInfo.h"
#import "AttributeX509.h"
#import "X509Extensions.h"

@interface V2AttributeCertificateInfoGenerator : NSObject {
@private
    ASN1Integer *_version;
    Holder *_holder;
    AttCertIssuer *_issuer;
    AlgorithmIdentifier *_signature;
    ASN1Integer *_serialNumber;
    ASN1EncodableVector *_attributes;
    DERBitString *_issuerUniqueID;
    Extensions *_extensions;
    ASN1GeneralizedTime *_startDate;
    ASN1GeneralizedTime *_endDate;
}

- (AttributeCertificateInfo *)generateAttributeCertificateInfo;
- (void)addAttribute:(NSString *)paramString paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (void)setExtensionsParamX509Extensions:(X509Extensions *)paramX509Extensions;

@end
