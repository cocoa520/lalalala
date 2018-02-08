//
//  CertID.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"
#import "ASN1Integer.h"

@interface CertID : ASN1Object {
    AlgorithmIdentifier *_hashAlgorithm;
    ASN1OctetString *_issuerNameHash;
    ASN1OctetString *_issuerKeyHash;
    ASN1Integer *_serialNumber;
}

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *hashAlgorithm;
@property (nonatomic, readwrite, retain) ASN1OctetString *issuerNameHash;
@property (nonatomic, readwrite, retain) ASN1OctetString *issuerKeyHash;
@property (nonatomic, readwrite, retain) ASN1Integer *serialNumber;

+ (CertID *)getInstance:(id)paramObject;
+ (CertID *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString1:(ASN1OctetString *)paramASN1OctetString1 paramASN1OctetString2:(ASN1OctetString *)paramASN1OctetString2 paramASN1Integer:(ASN1Integer *)paramASN1Integer;
- (AlgorithmIdentifier *)getHashAlgorithm;
- (ASN1OctetString *)getIssuerNameHash;
- (ASN1OctetString *)getIssuerKeyHash;
- (ASN1Integer *)getSerialNumber;
- (ASN1Primitive *)toASN1Primitive;

@end
