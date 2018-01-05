//
//  AttributeCertificateInfo.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "Holder.h"
#import "AttCertIssuer.h"
#import "AlgorithmIdentifier.h"
#import "AttCertValidityPeriod.h"
#import "ASN1Sequence.h"
#import "DERBitString.h"
#import "Extensions.h"
#import "ASN1TaggedObject.h"

@interface AttributeCertificateInfo : ASN1Object {
@private
    ASN1Integer *_version;
    Holder *_holder;
    AttCertIssuer *_issuer;
    AlgorithmIdentifier *_signature;
    ASN1Integer *_serialNumber;
    AttCertValidityPeriod *_attrCertValidityPeriod;
    ASN1Sequence *_attributes;
    DERBitString *_issuerUniqueID;
    Extensions *_extensions;
}

+ (AttributeCertificateInfo *)getInstance:(id)paramObject;
+ (AttributeCertificateInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (ASN1Integer *)getVersion;
- (Holder *)getHolder;
- (AttCertIssuer *)getIssuer;
- (AlgorithmIdentifier *)getSignature;
- (ASN1Integer *)getSerialNumber;
- (AttCertValidityPeriod *)getAttrCertValidityPeriod;
- (ASN1Sequence *)getAttributes;
- (DERBitString *)getIssuerUniqueID;
- (Extensions *)getExtensions;
- (ASN1Primitive *)toASN1Primitive;

@end
